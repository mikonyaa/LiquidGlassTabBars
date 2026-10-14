# GIFs

`liquid-tab-bars.gif` is an actual Simulator runtime recording of the scripted RC showcase: iPhone 16 Pro Max, iOS 26.5, Xcode 27.0, source `0ea39e444a32dce38dc2b92b1d2a1bd77cba56f2`. It is 400 × 869 px, 223 frames at 20 fps (11.15 seconds), 2,498,240 bytes (approximately 2.4 MiB). The recording includes System / Classic, Floating / Graphite and Morphing / Classic with changing destinations.

The [manifest](../capture-manifest.json) records its exact hash, source and capture metadata; [commands](../capture-commands.txt) show the actual steps. This is runtime evidence for the recorded source, not a tagged release or physical-device validation.

Recording checklist:

1. Use an iPhone Simulator with iOS 26.
2. Hide debug overlays and pointer visualization.
3. Record System / Classic → Floating / Graphite → Morphing / Classic.
4. Tap at least two tabs in each variant.
5. Show one palette change.
6. Keep the final loop under 12 seconds and optimize its file size.
7. Confirm the GIF matches its recorded source SHA and update the manifest with any new capture.

Run `Scripts/record_showcase.sh` to rebuild all screenshots and the optimized GIF. Source `.mov` recordings are ignored by Git.
