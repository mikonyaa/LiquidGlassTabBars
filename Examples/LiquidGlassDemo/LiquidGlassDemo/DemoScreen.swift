import SwiftUI

struct DemoScreen: View {
    let tab: DemoTab
    let palette: DemoPalette
    @Binding var fixture: DemoFixture
    var controlPanelHeight: CGFloat = 50
    @State private var isCreatePresented = false

    var body: some View {
        ZStack {
            DemoBackdrop(palette: palette)

            ScrollView {
                LazyVStack(alignment: .leading, spacing: 18) {
                    Color.clear.frame(height: controlPanelHeight + 12)

                    header
                    progressCard
                    quickActions
                    recentSection
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
            .scrollIndicators(.hidden)
        }
        .sheet(isPresented: $isCreatePresented) {
            CreateSampleSheet { fixture.sampleTitle = $0 }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(tab.title.uppercased(), systemImage: tab.systemImage)
                .font(.caption.weight(.bold))
                .foregroundStyle(.secondary)
                .tracking(1.2)

            Text(tab.headline)
                .font(.largeTitle.bold())
                .fontDesign(.rounded)

            Text(tab.message)
                .font(.body)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
                .frame(minHeight: 44, alignment: .topLeading)
        }
        .padding(.top, 20)
    }

    private var progressCard: some View {
        HStack(spacing: 18) {
            ZStack {
                Circle()
                    .stroke(.white.opacity(0.10), lineWidth: 8)

                Circle()
                    .trim(from: 0, to: fixture.fraction)
                    .stroke(
                        palette.theme.tint,
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))

                Text("\(fixture.percentage)%")
                    .font(.headline.monospacedDigit())
            }
            .frame(width: 82, height: 82)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Sample progress")
            .accessibilityValue("\(fixture.percentage)%")

            VStack(alignment: .leading, spacing: 6) {
                Text("Today")
                    .font(.title3.bold())

                Text(fixture.progressDescription)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Label("On track", systemImage: "checkmark.circle.fill")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(palette.theme.tint)
            }

            Spacer(minLength: 0)
        }
        .padding(20)
        .background(.white.opacity(0.075), in: RoundedRectangle(cornerRadius: 28))
        .overlay {
            RoundedRectangle(cornerRadius: 28)
                .stroke(.white.opacity(0.10), lineWidth: 0.75)
        }
    }

    private var quickActions: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Local sample controls — changes last until you close the app.")
                .font(.caption)
                .foregroundStyle(.secondary)
            HStack(spacing: 12) {
                DemoAction(title: "Create", systemImage: "plus") { isCreatePresented = true }
                DemoAction(title: fixture.isFocusActive ? "End focus" : "Focus", systemImage: "timer") {
                    fixture.isFocusActive.toggle()
                }
                ShareLink(item: fixture.shareText) {
                    DemoActionLabel(title: "Share", systemImage: "square.and.arrow.up")
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Share")
            }
            Text(fixture.isFocusActive ? "Focus preview is on" : "Focus preview is off")
                .font(.caption)
                .foregroundStyle(fixture.isFocusActive ? palette.theme.tint : .secondary)
            if let sampleTitle = fixture.sampleTitle {
                Label(sampleTitle, systemImage: "checkmark.circle")
                    .font(.subheadline)
            }
        }
    }

    private var recentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent · sample content")
                .font(.headline)

            VStack(spacing: 0) {
                DemoRow(
                    title: "Review the visual hierarchy",
                    detail: "10:30",
                    systemImage: "rectangle.3.group.fill"
                )

                Divider().overlay(.white.opacity(0.08))

                DemoRow(
                    title: "Tune spacing and motion",
                    detail: "14:00",
                    systemImage: "slider.horizontal.3"
                )
            }
            .padding(.horizontal, 16)
            .background(.white.opacity(0.055), in: RoundedRectangle(cornerRadius: 24))
        }
    }
}

private struct DemoAction: View {
    let title: String
    let systemImage: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            DemoActionLabel(title: title, systemImage: systemImage)
        }
        .buttonStyle(.plain)
    }
}

private struct DemoActionLabel: View {
    let title: String
    let systemImage: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: systemImage).font(.headline)
            Text(title).font(.caption.weight(.semibold))
        }
        .frame(maxWidth: .infinity)
        .frame(minHeight: 76)
        .background(.white.opacity(0.065), in: RoundedRectangle(cornerRadius: 22))
        .overlay {
            RoundedRectangle(cornerRadius: 22).stroke(.white.opacity(0.09), lineWidth: 0.75)
        }
    }
}

private struct CreateSampleSheet: View {
    let save: (String) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""

    var body: some View {
        NavigationStack {
            Form {
                Text("Create a local preview sample. Nothing is sent or saved permanently.")
                TextField("Sample title", text: $title)
            }
            .navigationTitle("Create sample")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save sample") {
                        save(title.trimmingCharacters(in: .whitespacesAndNewlines))
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

private struct DemoRow: View {
    let title: String
    let detail: String
    let systemImage: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: systemImage)
                .frame(width: 28, height: 28)
                .foregroundStyle(.secondary)

            Text(title)
                .font(.subheadline.weight(.medium))

            Spacer(minLength: 8)

            Text(detail)
                .font(.caption.monospacedDigit())
                .foregroundStyle(.tertiary)
        }
        .frame(minHeight: 58)
    }
}

private struct DemoBackdrop: View {
    let palette: DemoPalette

    @ViewBuilder
    var body: some View {
        ZStack {
            Color(red: 0.065, green: 0.07, blue: 0.08)
                .opacity(palette == .classic ? 1 : 0)

            LinearGradient(
                colors: [
                    Color(red: 0.055, green: 0.055, blue: 0.06),
                    Color(red: 0.13, green: 0.13, blue: 0.145),
                    Color(red: 0.025, green: 0.025, blue: 0.03)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .opacity(palette == .graphite ? 1 : 0)
        }
        .animation(.easeInOut(duration: 0.60), value: palette)
        .ignoresSafeArea()
    }
}
