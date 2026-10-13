#!/bin/bash
set -euo pipefail
repo_root="$(cd "$(dirname "$0")/.." && pwd)"
test_output="${LIQUID_TEST_OUTPUT:-$(mktemp -d "${TMPDIR:-/tmp}/liquid-ui-tests.XXXXXX")}"
mkdir -p "$test_output"
device_id=""
cleanup() {
  if [ -n "$device_id" ]; then
    xcrun simctl shutdown "$device_id" >/dev/null 2>&1 || true
    xcrun simctl delete "$device_id" >/dev/null 2>&1 || true
  fi
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
runtime_id="${LIQUID_TEST_RUNTIME:-$(xcrun simctl list runtimes -j | python3 -c '
import json,sys
r=[r for r in json.load(sys.stdin)["runtimes"] if r["isAvailable"] and r["identifier"].split(".")[-1].startswith("iOS-")]
if not r: sys.exit("No available iOS Simulator runtime")
print(max(r,key=lambda r: tuple(map(int,r["version"].split("."))))["identifier"])
')}"
# A Pro Max is wide enough to host the 420pt fixture without cropping it.
device_type="${LIQUID_TEST_DEVICE_TYPE:-com.apple.CoreSimulator.SimDeviceType.iPhone-16-Pro-Max}"
device_id="$(xcrun simctl create "LiquidUI integration $$" "$device_type" "$runtime_id")"
printf 'SHA: %s\nSimulator: %s\nRuntime: %s\n' "$(git -C "$repo_root" rev-parse HEAD)" "$device_id" "$runtime_id"
swift --version
xcodebuild -version
xcrun simctl boot "$device_id"
xcrun simctl bootstatus "$device_id" -b
test_project="$repo_root/Examples/LiquidGlassDemo/LiquidGlassDemo.xcodeproj"
# Environment accessibility values are read-only. Set actual Simulator preferences using Settings UI first.
xcodebuild -project "$test_project" -scheme LiquidGlassDemo \
  -destination "platform=iOS Simulator,id=$device_id" -derivedDataPath "$test_output/DerivedData" \
  -resultBundlePath "$test_output/settings.xcresult" -parallel-testing-enabled NO -collect-test-diagnostics never \
  -only-testing:IntegrationUITests/InteractionTests/testConfigureReducedEffects CODE_SIGNING_ALLOWED=NO test
xcodebuild -project "$test_project" -scheme LiquidGlassDemo \
  -destination "platform=iOS Simulator,id=$device_id" -derivedDataPath "$test_output/DerivedData" \
  -resultBundlePath "$test_output/integration.xcresult" -parallel-testing-enabled NO -collect-test-diagnostics never \
  CODE_SIGNING_ALLOWED=NO test
echo "UI results: $test_output"
