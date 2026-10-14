#!/bin/bash
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
consumer_root="${LIQUID_CONSUMER_OUTPUT:-$(mktemp -d "${TMPDIR:-/tmp}/liquid-consumers.XXXXXX")}"
mkdir -p "$consumer_root"
consumer_root="$(cd "$consumer_root" && pwd)"
case "$consumer_root/" in
  "$repo_root/"*) echo "Consumer output must be outside the source repository" >&2; exit 2 ;;
esac
swift --version
xcodebuild -version

for consumer_kind in released candidate; do
  consumer_dir="$consumer_root/$consumer_kind"
  mkdir -p "$consumer_dir/Sources/Consumer"
  if [ "$consumer_kind" = released ]; then
    dependency='.package(url: "https://github.com/mikonyaa/LiquidGlassTabBars.git", exact: "1.0.3")'
  else
    # JSON string escaping is also valid in the Swift path string.
    quoted_path="$(python3 -c 'import json,sys; print(json.dumps(sys.argv[1], ensure_ascii=False))' "$repo_root")"
    dependency=".package(path: $quoted_path)"
  fi
  cat > "$consumer_dir/Package.swift" <<EOF
// swift-tools-version: 6.0
import PackageDescription
let package = Package(
    name: "LiquidConsumer",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [.library(name: "Consumer", targets: ["Consumer"])],
    dependencies: [$dependency],
    targets: [.target(name: "Consumer", dependencies: [.product(name: "LiquidUI", package: "LiquidGlassTabBars")])]
)
EOF
  cat > "$consumer_dir/Sources/Consumer/Consumer.swift" <<'EOF'
import SwiftUI
import LiquidUI

public struct Consumer: View {
    @State private var selected = 101
    @State private var reselections = 0
    public init() {}
    public var body: some View {
        VStack {
            LiquidTabBar(
                selection: $selected,
                items: [
                    LiquidTabItem(id: 101, title: "Inbox", systemImage: "tray"),
                    LiquidTabItem(id: 907, title: "Saved", systemImage: "bookmark")
                ],
                variant: .morphing,
                theme: LiquidTabBarTheme(fallbackFill: .blue.opacity(0.1)),
                onReselect: { _ in reselections += 1 }
            )
            SystemGlassTabView(selection: $selected) {
                Text("Inbox").tabItem { Label("Inbox", systemImage: "tray") }.tag(101)
                Text("Saved").tabItem { Label("Saved", systemImage: "bookmark") }.tag(907)
            }
        }
    }
}
EOF
  (
    cd "$consumer_dir"
    swift package resolve
    swift build
  )
done
echo "Public-API consumers passed: $consumer_root"
