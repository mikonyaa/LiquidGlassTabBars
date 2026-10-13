#!/bin/bash
set -euo pipefail
repo_root="$(cd "$(dirname "$0")/.." && pwd)"
for tool in xcodebuild xcrun ffmpeg python3 git; do
  command -v "$tool" >/dev/null || { echo "Required tool missing: $tool" >&2; exit 2; }
done
duration="${LIQUID_DEMO_DURATION:-13.4}"
python3 -c 'import sys; d=float(sys.argv[1]); sys.exit(0 if 0 < d <= 120 else 2)' "$duration" || {
  echo "LIQUID_DEMO_DURATION must be between 0 and 120 seconds" >&2; exit 2;
}
device_id="${LIQUID_DEMO_DEVICE_ID:-}"
owned_device=false
installed_app=false
recording_pid=""
scratch_dir=""
sleep_pid=""
source_sha="$(git -C "$repo_root" rev-parse HEAD)"
source_dirty="$(git -C "$repo_root" status --porcelain)"
bundle_id=dev.liquidglasstemplates.demo
cleanup() {
  if [ -n "$sleep_pid" ]; then
    kill "$sleep_pid" 2>/dev/null || true
    wait "$sleep_pid" 2>/dev/null || true
  fi
  if [ -n "$recording_pid" ]; then
    kill -INT "$recording_pid" 2>/dev/null || true
    wait "$recording_pid" 2>/dev/null || true
  fi
  if $installed_app; then
    xcrun simctl terminate "$device_id" "$bundle_id" >/dev/null 2>&1 || true
    xcrun simctl uninstall "$device_id" "$bundle_id" >/dev/null 2>&1 || true
  fi
  if $owned_device; then
    xcrun simctl shutdown "$device_id" >/dev/null 2>&1 || true
    xcrun simctl delete "$device_id" >/dev/null 2>&1 || true
  fi
  if [ -n "$scratch_dir" ]; then rm -rf "$scratch_dir"; fi
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
if [ -n "$device_id" ]; then
  xcrun simctl list devices available -j | python3 -c '
import json,sys
devices=[d for group in json.load(sys.stdin)["devices"].values() for d in group]
if not any(d["udid"]==sys.argv[1] and d["isAvailable"] for d in devices):
 sys.exit("Selected simulator is unavailable: " + sys.argv[1])
' "$device_id"
else
  runtime_id="${LIQUID_DEMO_RUNTIME:-$(xcrun simctl list runtimes -j | python3 -c '
import json,sys
r=[r for r in json.load(sys.stdin)["runtimes"] if r["isAvailable"] and r["identifier"].split(".")[-1].startswith("iOS-")]
if not r: sys.exit("No iOS Simulator runtime available; install one in Xcode")
print(max(r,key=lambda r: tuple(map(int,r["version"].split("."))))["identifier"])
')}"
  device_type="${LIQUID_DEMO_DEVICE_TYPE:-com.apple.CoreSimulator.SimDeviceType.iPhone-16-Pro-Max}"
  device_id="$(xcrun simctl create "Liquid Glass capture $$" "$device_type" "$runtime_id")"
  owned_device=true
fi
scratch_dir="$(mktemp -d "${TMPDIR:-/tmp}/liquid-capture.XXXXXX")"
output_dir="${LIQUID_DEMO_OUTPUT:-$repo_root/Assets}"
mkdir -p "$output_dir/GIFs" "$output_dir/Screenshots"
command_log="$output_dir/capture-commands.txt"
: > "$command_log"
run() {
  python3 -c 'import shlex,sys; print(shlex.join(sys.argv[3:]).replace(sys.argv[1], ".").replace(sys.argv[2], "<scratch>"))' \
    "$repo_root" "$scratch_dir" "$@" >> "$command_log"
  "$@"
}
run xcrun simctl boot "$device_id" >/dev/null 2>&1 || {
  xcrun simctl list devices available -j | python3 -c '
import json,sys
devices=[d for g in json.load(sys.stdin)["devices"].values() for d in g]
sys.exit(0 if any(d["udid"]==sys.argv[1] and d["state"]=="Booted" for d in devices) else 1)
' "$device_id"
}
run xcrun simctl bootstatus "$device_id" -b
if xcrun simctl get_app_container "$device_id" "$bundle_id" app >/dev/null 2>&1; then
  echo "Demo already installed on selected simulator; use default isolated capture or a fresh simulator" >&2
  exit 2
fi
run xcodebuild -project "$repo_root/Examples/LiquidGlassDemo/LiquidGlassDemo.xcodeproj" \
  -scheme LiquidGlassDemo -configuration Debug -destination "platform=iOS Simulator,id=$device_id" \
  -derivedDataPath "$scratch_dir/DerivedData" CODE_SIGNING_ALLOWED=NO build > "$scratch_dir/build.log" 2>&1 || {
  tail -50 "$scratch_dir/build.log" >&2; exit 1;
}
run xcrun simctl install "$device_id" "$scratch_dir/DerivedData/Build/Products/Debug-iphonesimulator/LiquidGlassDemo.app"
installed_app=true
capture_screenshot() {
  local filename="$1"
  shift
  xcrun simctl terminate "$device_id" "$bundle_id" >/dev/null 2>&1 || true
  run xcrun simctl launch "$device_id" "$bundle_id" "$@"
  sleep 2
  run xcrun simctl io "$device_id" screenshot "$output_dir/Screenshots/$filename"
}
# Runtime screens are captured before assembling the showcase GIF.
capture_screenshot system-classic.png
capture_screenshot floating-graphite.png --floating --graphite
capture_screenshot morphing-classic.png --morphing --activity
xcrun simctl terminate "$device_id" "$bundle_id" >/dev/null 2>&1 || true
run xcrun simctl launch "$device_id" "$bundle_id" --showcase
sleep 1.8
recording="$scratch_dir/showcase-source.mov"
# Launch simctl directly so this PID is the recording process, not a shell wrapper.
printf 'xcrun simctl io %s recordVideo --codec=h264 --force <scratch>/showcase-source.mov\n' "$device_id" >> "$command_log"
xcrun simctl io "$device_id" recordVideo --codec=h264 --force "$recording" &
recording_pid=$!
sleep "$duration" &
sleep_pid=$!
wait "$sleep_pid"
sleep_pid=""
kill -INT "$recording_pid"
wait "$recording_pid" || true
recording_pid=""
run ffmpeg -y -i "$recording" \
  -filter_complex 'fps=20,scale=400:-1:flags=lanczos,split[frames][palette_input];[palette_input]palettegen=max_colors=192:stats_mode=diff[palette];[frames][palette]paletteuse=dither=sierra2_4a:diff_mode=rectangle' \
  -loop 0 "$output_dir/GIFs/liquid-tab-bars.gif" > "$scratch_dir/ffmpeg.log" 2>&1
xcrun simctl list devices available -j > "$scratch_dir/devices.json"
xcrun simctl list runtimes -j > "$scratch_dir/runtimes.json"
python3 - "$repo_root" "$device_id" "$scratch_dir" "$output_dir" "$source_sha" "$source_dirty" <<'PY'
import datetime,hashlib,json,pathlib,subprocess,sys
root,device_id,scratch,output=map(pathlib.Path,sys.argv[1:5])
devices=json.loads((scratch/'devices.json').read_text())['devices']
runtime_id,device=next((r,d) for r,group in devices.items() for d in group if d['udid']==str(device_id))
runtime=next(r for r in json.loads((scratch/'runtimes.json').read_text())['runtimes'] if r['identifier']==runtime_id)
files={str(p.relative_to(output)):hashlib.sha256(p.read_bytes()).hexdigest() for p in sorted(output.rglob('*')) if p.suffix in {'.png','.gif'}}
manifest={'capture_type':'iOS Simulator runtime screenshots and recording; not physical-device validation',
 'sha':sys.argv[5], 'dirty':bool(sys.argv[6]),
 'captured_at_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
 'device':device['name'],'device_type':device['deviceTypeIdentifier'],'os':runtime['version'],
 'xcode':subprocess.check_output(['xcodebuild','-version'],text=True).strip(),
 'commands':'capture-commands.txt','sha256':files}
(output/'capture-manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
PY
test -s "$output_dir/GIFs/liquid-tab-bars.gif"
echo "Runtime screenshots, GIF and manifest: $output_dir"
