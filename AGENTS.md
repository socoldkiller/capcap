# CapcapKit library adaptation branch

This branch publishes embeddable SwiftPM library products from Sources/. The upstream standalone application and its guidance are retained as provenance; see UPSTREAM-APP-AGENTS.md and Package.upstream-app.swift. Do not run the upstream rebuild/install scripts for SDK work: this branch is consumed by a host application.

- Build with `swift build -c release`, verify changes through `swift test -c release` and `python3 scripts/check-library-targets.py`.
- Do not install or launch the upstream app, capture the screen, start recording, upload data or grant OS permissions as part of a library build/test. UI verification requires a user request and the actual host.
- Preserve the MIT license and upstream revision provenance.
- Keep capture and optional products separate. Capture, Text and Recording may depend only on CapcapSupport, not on each other or advanced optional implementations.
- Internal upstream collaboration uses package visibility; expose only the small public host facades.
- AppKit owns capture/editing UI. SwiftUI is limited to the existing Apple Translation bridge required by the system API.
- The host owns permissions, global shortcuts, windows and resource embedding. A packaged host missing CapcapKit_CapcapSupport.bundle must fail explicitly, never fall back to developer build resources.
- Keep native Apple OCR as the default. Self-hosted endpoints and credentials must be explicitly configured; never commit developer addresses or credentials.
- New user-facing copy must not end with punctuation. Preserve existing localization keys and preference compatibility.
