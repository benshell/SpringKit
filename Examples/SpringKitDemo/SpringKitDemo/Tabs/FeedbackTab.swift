import SwiftUI
import SpringKit

struct FeedbackTab: View {
    @State private var toastMessage: SpringToast.Message? = nil
    @State private var showOverlayLoader = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: SpringSpacing.Vertical.lg) {

                    // MARK: Toast

                    SectionHeader(title: "Toast Notifications", subtitle: "Tap to trigger each style")

                    VStack(spacing: SpringSpacing.Vertical.sm) {
                        HStack(spacing: SpringSpacing.Horizontal.sm) {
                            AccentButton("Success", isFullWidth: true) {
                                toastMessage = SpringToast.Message("Reservation confirmed for 4 guests.", style: .success)
                            }
                            PrimaryButton("Info", isFullWidth: true) {
                                toastMessage = SpringToast.Message("Your table will be held for 15 minutes.", style: .info)
                            }
                        }
                        HStack(spacing: SpringSpacing.Horizontal.sm) {
                            SecondaryButton("Warning", isFullWidth: true) {
                                toastMessage = SpringToast.Message("Kitchen closes in 30 minutes.", style: .warning)
                            }
                            GhostButton("Error", style: .destructive, isFullWidth: true) {
                                toastMessage = SpringToast.Message("Unable to process your booking. Please try again.", style: .error)
                            }
                        }
                    }
                    .padding(.horizontal, SpringSpacing.Horizontal.md)

                    Divider()
                        .padding(.horizontal, SpringSpacing.Horizontal.md)

                    // MARK: Badges — Pill

                    SectionHeader(title: "Status Badges", subtitle: "Pill and dot variants")

                    VStack(alignment: .leading, spacing: SpringSpacing.Vertical.sm) {
                        Text("Pill badges")
                            .springProseFont(size: SpringFontSize.footnote, weight: .semibold)
                            .foregroundStyle(SpringColor.Text.secondary)
                            .padding(.horizontal, SpringSpacing.Horizontal.md)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: SpringSpacing.Horizontal.sm) {
                                SpringBadge("Confirmed", style: .success)
                                SpringBadge("Pending", style: .warning)
                                SpringBadge("Cancelled", style: .destructive)
                                SpringBadge("Completed", style: .neutral)
                                SpringBadge("Premium", style: .accent)
                            }
                            .padding(.horizontal, SpringSpacing.Horizontal.md)
                        }

                        Text("Dot badges")
                            .springProseFont(size: SpringFontSize.footnote, weight: .semibold)
                            .foregroundStyle(SpringColor.Text.secondary)
                            .padding(.horizontal, SpringSpacing.Horizontal.md)

                        HStack(spacing: SpringSpacing.Horizontal.lg) {
                            VStack(spacing: SpringSpacing.Vertical.xs) {
                                SpringBadge(style: .success)
                                Text("success").springProseFont(size: SpringFontSize.caption, weight: .regular)
                                    .foregroundStyle(SpringColor.Text.muted)
                            }
                            VStack(spacing: SpringSpacing.Vertical.xs) {
                                SpringBadge(style: .warning)
                                Text("warning").springProseFont(size: SpringFontSize.caption, weight: .regular)
                                    .foregroundStyle(SpringColor.Text.muted)
                            }
                            VStack(spacing: SpringSpacing.Vertical.xs) {
                                SpringBadge(style: .destructive)
                                Text("destructive").springProseFont(size: SpringFontSize.caption, weight: .regular)
                                    .foregroundStyle(SpringColor.Text.muted)
                            }
                            VStack(spacing: SpringSpacing.Vertical.xs) {
                                SpringBadge(style: .neutral)
                                Text("neutral").springProseFont(size: SpringFontSize.caption, weight: .regular)
                                    .foregroundStyle(SpringColor.Text.muted)
                            }
                            VStack(spacing: SpringSpacing.Vertical.xs) {
                                SpringBadge(style: .accent)
                                Text("accent").springProseFont(size: SpringFontSize.caption, weight: .regular)
                                    .foregroundStyle(SpringColor.Text.muted)
                            }
                        }
                        .padding(.horizontal, SpringSpacing.Horizontal.md)
                    }

                    Divider()
                        .padding(.horizontal, SpringSpacing.Horizontal.md)

                    // MARK: Loading Views

                    SectionHeader(title: "Loading States", subtitle: "Inline and overlay variants")

                    VStack(spacing: SpringSpacing.Vertical.md) {
                        SpringLoadingView(message: "Loading your reservations…", style: .inline)
                            .padding(SpringSpacing.Vertical.md)
                            .frame(maxWidth: .infinity)
                            .springGlassCard()

                        SpringLoadingView(style: .inline)
                            .padding(SpringSpacing.Vertical.md)
                            .frame(maxWidth: .infinity)
                            .springGlassCard()

                        SecondaryButton("Show Overlay Loader (3 s)", isFullWidth: true) {
                            showOverlayLoader = true
                            Task {
                                try? await Task.sleep(for: .seconds(3))
                                showOverlayLoader = false
                            }
                        }
                    }
                    .padding(.horizontal, SpringSpacing.Horizontal.md)
                }
                .padding(.vertical, SpringSpacing.Vertical.md)
                .readableContentWidth()
            }
            .background(SpringColor.Background.primary)
            .navigationTitle("Feedback & Status")
            .navigationBarTitleDisplayMode(.inline)
            .springToast($toastMessage)
            .springLoadingOverlay(isLoading: showOverlayLoader, message: "Please wait…")
        }
    }
}

#Preview {
    FeedbackTab()
}
