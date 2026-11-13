# CapcapKit — embeddable SwiftPM libraries

基于 [realskyrin/capcap](https://github.com/realskyrin/capcap)，基础版本为
`7dd035225eaa41e6da8a5156556a8c4dd7bd028b`，MIT，许可证见 LICENSE。
第三方实现没有因本次拆分删除；是否编译、链接由产品依赖决定。

## Products / targets

| Product / target | 职责 | 依赖 |
| --- | --- | --- |
| `CapcapSupport`（内部 target） | 本地化资源、偏好、共享模型、基础窗口样式、选装接口 | Apple frameworks |
| `CapcapKit` | 截图选区、窗口贴合、标注、输出、`CapcapCaptureSession` | Support |
| `CapcapText` | Apple/网络 OCR、翻译、结果面板和设置、`CapcapTextService` | Support |
| `CapcapRecording` | 屏幕录制、音轨、GIF 输出、`CapcapRecordingSession` | Support |
| `CapcapUpload` | 云上传 providers 和上传界面、`CapcapCloudUpload` | Capture + Support |
| `CapcapPinning` | 贴图、图中文字交互、`CapcapPinnedImages` | Capture + Text + Support |
| `CapcapHistory` | 历史浏览窗口、快速预览、`CapcapHistoryBrowser` | Capture + Text + Support |
| `CapcapImageMerge` | 拼图工作区、`CapcapImageMergeWorkspace` | Capture + Support |

截图不能反向依赖选装模块。OCR/翻译和录屏都可以在没有截图编辑器、历史、上传模块时编译。
历史的数据模型与缓存读取仍在截图 target 中，供原编辑器的历史图片切换使用；大型历史窗口独立选装。

## 使用

此适配分支用于嵌入宿主 App。上游 `main` 仍提供完整 capcap 应用；此分支的 package 只发布 libraries。
按需选择截图、文本处理或其他产品，不安装应用、不注册全局快捷键，也不在导入时申请权限。

```swift
.product(name: "CapcapKit", package: "capcap"),
.product(name: "CapcapText", package: "capcap"),
```

```swift
import CapcapKit
import CapcapText

// 在主 actor、开始截图前创建。显式安装文本能力，保留截图的 OCR/翻译菜单。
let text = CapcapTextService()
let capture = CapcapCaptureSession()
```

仅使用截图时无需依赖/导入 Text，文本菜单不出现。选择上传、贴图时分别显式调用
`CapcapCloudUpload.install()`、`CapcapPinnedImages.install()`；导入模块不启动功能或申请权限。
录屏、历史窗口、拼图通过各自 facade 创建与使用，不向宿主公开整套上游实现。

## 运行与资源

- 宿主负责应用、窗口、权限和会话生命周期，不包含上游 AppDelegate、菜单栏或应用入口。
- target 之间使用 `package` 访问级别保留包内实现协作；主 App 只使用小范围 `public` facade。
- 可选功能通过 Support 中的接口安装，截图不使用 `canImport` 或条件链接来猜测是否启用。
- 选装接口的可变注册状态归 main actor；旧 AppKit 同步事件在主线程调用接口，异步 OCR 保持主 actor 入口。
- 本地化资源只由 `CapcapSupport` 持有，打包名为 `CapcapKit_CapcapSupport.bundle`，没有每个 target 各复制一份资源。
- 偏好仍隔离在 `<host bundle-id>.capcap`。OCR/翻译密钥仍仅在会话内保留，拆分不改变配置键和识别/翻译实现。
- 上游模块保持 Swift 5 语言模式；公开宿主 facade 隔离在 main actor，新接口测试使用 Swift Testing。

## 构建与验证

```sh
swift build -c release
swift test -c release
python3 scripts/check-library-targets.py
```

OCR 默认使用 Apple Vision。GLM-OCR 等自托管服务需要使用者在设置中显式填写 endpoint；不内置开发机地址。
本地化资源包 `CapcapKit_CapcapSupport.bundle` 必须由宿主打包，缺失时不会回退读取开发目录。

修改基线与适配说明见 [UPSTREAM.md](UPSTREAM.md)，MIT 许可证见 [LICENSE](LICENSE)。
