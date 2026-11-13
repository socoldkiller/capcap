import CapcapSupport
import AppKit
import QuickLookThumbnailing
import UniformTypeIdentifiers

/// The history entry URL always points to this small manifest, never to a source file.
/// Consequently history deletion and favorite xattrs cannot affect the originals.
package final class HistoryFileReferences {
    package struct Reference: Codable {
        package let path: String
        package let bookmark: Data?
        package let name: String
        package let typeIdentifier: String?
        package let isDirectory: Bool

        package init(url: URL) {
            path = url.path
            name = url.lastPathComponent
            let values = try? url.resourceValues(forKeys: [.contentTypeKey, .isDirectoryKey])
            typeIdentifier = values?.contentType?.identifier
            isDirectory = values?.isDirectory == true
            bookmark = try? url.bookmarkData(options: [], includingResourceValuesForKeys: nil, relativeTo: nil)
        }

        package func resolve() -> URL? {
            // Do not display permission dialogs or mount an offline volume while browsing history.
            var stale = false
            let bookmarkedURL = bookmark.flatMap {
                try? URL(resolvingBookmarkData: $0, options: [.withoutUI, .withoutMounting],
                         relativeTo: nil, bookmarkDataIsStale: &stale)
            }
            guard bookmark == nil || bookmarkedURL != nil else { return nil }
            let url = bookmarkedURL ?? URL(fileURLWithPath: path)
            let trashPath = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent(".Trash").path + "/"
            guard !url.path.hasPrefix(trashPath), !url.pathComponents.contains(".Trashes") else { return nil }
            guard url.isFileURL,
                  (try? url.checkResourceIsReachable()) == true,
                  let values = try? url.resourceValues(forKeys: [.isReadableKey, .isUbiquitousItemKey,
                                                               .ubiquitousItemDownloadingStatusKey]),
                  values.isReadable != false else { return nil }
            // Avoid making thumbnail generation download an iCloud placeholder.
            if values.isUbiquitousItem == true,
               values.ubiquitousItemDownloadingStatus == .notDownloaded { return nil }
            return url
        }
    }

    package struct Resolution {
        package let urls: [URL]
        package let totalCount: Int
        package var isAvailable: Bool { !urls.isEmpty && urls.count == totalCount }
    }

    package let references: [Reference]
    private let lock = NSLock()
    private var resolution: Resolution?

    package init(references: [Reference]) { self.references = references }

    package static func load(from url: URL) -> HistoryFileReferences? {
        guard let data = try? Data(contentsOf: url),
              let references = try? JSONDecoder().decode([Reference].self, from: data),
              !references.isEmpty else { return nil }
        return HistoryFileReferences(references: references)
    }

    package var lastResolution: Resolution? {
        lock.lock()
        defer { lock.unlock() }
        return resolution
    }

    package var displayName: String {
        guard let first = references.first else { return L10n.historyPanelFilterFiles }
        let current = lastResolution
        let name = current?.isAvailable == true ? (current?.urls.first?.lastPathComponent ?? first.name) : first.name
        return references.count == 1 ? name : "\(name) +\(references.count - 1)"
    }

    package var typeLabel: String {
        let labels = Set(references.map { reference -> String in
            if reference.isDirectory { return L10n.historyPanelFolder }
            let ext = URL(fileURLWithPath: reference.path).pathExtension
            if !ext.isEmpty { return String(ext.prefix(10)).uppercased() }
            return reference.typeIdentifier.flatMap { UTType($0)?.localizedDescription }
                ?? L10n.historyPanelFilterFiles
        })
        let label = labels.count == 1 ? (labels.first ?? L10n.historyPanelFilterFiles) : L10n.historyPanelFilterFiles
        return references.count == 1 ? label : "\(label) ×\(references.count)"
    }

    package var searchText: String { references.map { "\($0.name) \($0.path)" }.joined(separator: "\n") }

    /// Called only from the bounded background queue, including immediately before transfer.
    package func resolve() -> Resolution {
        let result = Resolution(urls: references.compactMap { $0.resolve() }, totalCount: references.count)
        lock.lock()
        resolution = result
        lock.unlock()
        return result
    }

    package static let transferQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "capcap.historyFileReferences"
        queue.qualityOfService = .userInitiated
        queue.maxConcurrentOperationCount = 2
        return queue
    }()

    package static let captureQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "capcap.historyFileCapture"
        queue.qualityOfService = .utility
        queue.maxConcurrentOperationCount = 1
        return queue
    }()

    package static func resolveTransfer(_ entries: [HistoryEntry], completion: @escaping ([URL]?) -> Void) {
        transferQueue.addOperation {
            var urls: [URL] = []
            var seen = Set<String>()
            var available = true
            for entry in entries {
                let candidates: [URL]
                if case .files(let files) = entry.kind {
                    let result = files.resolve()
                    available = available && result.isAvailable
                    candidates = result.urls
                } else {
                    candidates = [entry.fileURL]
                }
                for url in candidates where seen.insert(url.standardizedFileURL.path).inserted {
                    urls.append(url)
                }
            }
            let result = available && !urls.isEmpty ? urls : nil
            DispatchQueue.main.async { completion(result) }
        }
    }
}

package struct HistoryFilePreview {
    package let resolution: HistoryFileReferences.Resolution
    package let image: CGImage?
}

/// Source checks and Quick Look never run on the main thread. Only small rendered
/// thumbnails are cached in memory; source bytes are never copied into history.
package final class HistoryFilePreviewLoader {
    package static let shared = HistoryFilePreviewLoader()
    private final class CachedImage: NSObject {
        package let image: CGImage
        package init(_ image: CGImage) { self.image = image }
    }
    private let cache: NSCache<NSString, CachedImage> = {
        let cache = NSCache<NSString, CachedImage>()
        cache.countLimit = 100
        cache.totalCostLimit = 24 * 1024 * 1024
        return cache
    }()
    private let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "capcap.historyFilePreviews"
        queue.qualityOfService = .utility
        queue.maxConcurrentOperationCount = 2
        return queue
    }()

    @discardableResult
    package func load(files: HistoryFileReferences, pixelSize: Int,
              completion: @escaping (HistoryFilePreview) -> Void) -> HistoryImagePreviewRequest {
        let token = HistoryImagePreviewRequest()
        let operation = BlockOperation()
        operation.addExecutionBlock { [weak self] in
            guard let self, !token.isCancelled else { return }
            let resolution = files.resolve()
            guard !token.isCancelled else { return }
            let image = resolution.isAvailable
                ? resolution.urls.first.flatMap { self.thumbnail(url: $0, pixelSize: pixelSize, token: token) }
                : nil
            guard !token.isCancelled else { return }
            DispatchQueue.main.async {
                guard !token.isCancelled else { return }
                completion(HistoryFilePreview(resolution: resolution, image: image))
            }
        }
        token.onCancel { [weak operation] in operation?.cancel() }
        queue.addOperation(operation)
        return token
    }

    private func thumbnail(url: URL, pixelSize: Int, token: HistoryImagePreviewRequest) -> CGImage? {
        let values = try? url.resourceValues(forKeys: [.contentModificationDateKey, .fileSizeKey])
        let key = "\(url.path)#\(values?.contentModificationDate?.timeIntervalSince1970 ?? 0)#\(values?.fileSize ?? 0)#\(pixelSize)" as NSString
        if let cached = cache.object(forKey: key) { return cached.image }
        let request = QLThumbnailGenerator.Request(fileAt: url,
            size: CGSize(width: pixelSize, height: pixelSize), scale: 1,
            representationTypes: [.thumbnail, .icon])
        let result = ThumbnailResult()
        token.onCancel {
            QLThumbnailGenerator.shared.cancel(request)
            result.ready.signal()
        }
        guard !token.isCancelled else { return nil }
        QLThumbnailGenerator.shared.generateBestRepresentation(for: request) { representation, _ in
            result.finish(representation?.cgImage)
        }
        // A slow or broken provider must not monopolize the preview queue.
        guard result.ready.wait(timeout: .now() + 3) == .success else {
            QLThumbnailGenerator.shared.cancel(request)
            return nil
        }
        guard !token.isCancelled, let image = result.image else { return nil }
        cache.setObject(CachedImage(image), forKey: key, cost: image.bytesPerRow * image.height)
        return image
    }

    private final class ThumbnailResult {
        package let ready = DispatchSemaphore(value: 0)
        private let lock = NSLock()
        private var value: CGImage?
        package var image: CGImage? {
            lock.lock()
            defer { lock.unlock() }
            return value
        }
        package func finish(_ image: CGImage?) {
            lock.lock()
            value = image
            lock.unlock()
            ready.signal()
        }
    }
}
