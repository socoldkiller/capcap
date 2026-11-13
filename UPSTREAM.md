# Upstream and downstream scope

Upstream: https://github.com/realskyrin/capcap
Base revision: 7dd035225eaa41e6da8a5156556a8c4dd7bd028b
License: MIT; original LICENSE is retained.

This fork's codex/swiftpm-library branch is an embeddable-library adaptation. It does not publish the upstream executable products. The original package manifest and app guidance are retained in Package.upstream-app.swift and UPSTREAM-APP-AGENTS.md. The unchanged upstream main branch remains available for the standalone app.

Adaptations:

- SwiftPM library products with a shared resource/configuration target and optional text, recording, upload, pinning, history and image-merge targets.
- Small main-actor host facades for capture, editing and optional capabilities. App lifecycle and global shortcuts remain with the host.
- Host-bundle-namespaced preferences, embedded SwiftPM resource lookup and session-only OCR/translation secrets.
- Compact native screenshot toolbar (32pt buttons), optional OCR/translation actions and explicit capability installation.
- GLM-OCR support retained, with Apple OCR as the default and no built-in private endpoint.
- Existing async timeout/translation tests and optional capability tests. None perform screen capture, recording, network upload or permission changes.

Most files are moved from capcap/ into Sources/ without algorithm changes. The package access modifier preserves collaboration inside this package without exposing all upstream types to hosts.
