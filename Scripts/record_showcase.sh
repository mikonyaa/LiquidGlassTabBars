#!/bin/zsh

set -euo pipefail

ROOT="${0:A:h:h}"
PROJECT="$ROOT/Examples/LiquidGlassDemo/LiquidGlassDemo.xcodeproj"
DERIVED_DATA="$ROOT/DerivedData"
APP="$DERIVED_DATA/Build/Products/Debug-iphonesimulator/LiquidGlassDemo.app"
BUNDLE_ID="dev.liquidglasstemplates.demo"
DEVICE_ID="${LIQUID_DEMO_DEVICE_ID:-58A90F38-36E7-4A46-93ED-E2E7714CD0A4}"
RECORDING="$ROOT/Assets/GIFs/showcase-source.mov"
GIF="$ROOT/Assets/GIFs/liquid-tab-bars.gif"
BUILD_LOG="$DERIVED_DATA/showcase-build.log"

mkdir -p "$DERIVED_DATA" "$ROOT/Assets/GIFs" "$ROOT/Assets/Screenshots"

xcodebuild \
  -project "$PROJECT" \
  -scheme LiquidGlassDemo \
  -configuration Debug \
  -destination "platform=iOS Simulator,id=$DEVICE_ID" \
  -derivedDataPath "$DERIVED_DATA" \
  CODE_SIGNING_ALLOWED=NO \
  build > "$BUILD_LOG"

xcrun simctl boot "$DEVICE_ID" >/dev/null 2>&1 || true
xcrun simctl bootstatus "$DEVICE_ID" -b
xcrun simctl uninstall "$DEVICE_ID" "$BUNDLE_ID" >/dev/null 2>&1 || true
xcrun simctl install "$DEVICE_ID" "$APP"
xcrun simctl terminate "$DEVICE_ID" "$BUNDLE_ID" >/dev/null 2>&1 || true
xcrun simctl launch "$DEVICE_ID" "$BUNDLE_ID" >/dev/null
sleep 2
xcrun simctl terminate "$DEVICE_ID" "$BUNDLE_ID" >/dev/null 2>&1 || true
xcrun simctl launch "$DEVICE_ID" "$BUNDLE_ID" --showcase

sleep 1.8
xcrun simctl io "$DEVICE_ID" recordVideo --codec=h264 --force "$RECORDING" &
RECORDING_PID=$!

sleep 13.4
kill -INT "$RECORDING_PID" || true
wait "$RECORDING_PID" || true

ffmpeg -y -i "$RECORDING" \
  -filter_complex "fps=20,scale=400:-1:flags=lanczos,split[frames][palette_input];[palette_input]palettegen=max_colors=192:stats_mode=diff[palette];[frames][palette]paletteuse=dither=sierra2_4a:diff_mode=rectangle" \
  -loop 0 "$GIF" >/dev/null 2>&1

capture_screenshot() {
  local output="$1"
  shift
  xcrun simctl terminate "$DEVICE_ID" "$BUNDLE_ID" >/dev/null 2>&1 || true
  xcrun simctl launch "$DEVICE_ID" "$BUNDLE_ID" "$@" >/dev/null
  sleep 1.8
  xcrun simctl io "$DEVICE_ID" screenshot "$output" >/dev/null
}

capture_screenshot "$ROOT/Assets/Screenshots/system-classic.png"
capture_screenshot "$ROOT/Assets/Screenshots/floating-graphite.png" --floating --graphite
capture_screenshot "$ROOT/Assets/Screenshots/morphing-classic.png" --morphing --activity

echo "GIF: $GIF"
echo "Screenshots: $ROOT/Assets/Screenshots"
echo "Build log: $BUILD_LOG"
