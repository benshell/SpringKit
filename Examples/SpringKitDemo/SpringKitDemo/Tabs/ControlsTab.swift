import SwiftUI
import SpringKit

struct ControlsTab: View {
    // Button state
    @State private var isLoading = false

    // Form state
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var emailError: String? = nil
    @State private var notes = ""
    @State private var reservationDate = Date()
    @State private var guestCount = 2

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: SpringSpacing.Vertical.lg) {

                    // MARK: Buttons

                    SectionHeader(title: "Buttons", alignment: .leading)
                        .padding(.horizontal, SpringSpacing.Horizontal.md)

                    VStack(spacing: SpringSpacing.Vertical.md) {
                        HStack(spacing: SpringSpacing.Horizontal.md) {
                            PrimaryButton("Confirm", isLoading: isLoading) {}
                            SecondaryButton("Learn More", isLoading: isLoading) {}
                        }
                        HStack(spacing: SpringSpacing.Horizontal.md) {
                            AccentButton("Book Now", icon: Image(systemName: "calendar.badge.plus"), isLoading: isLoading) {}
                            GhostButton("Cancel", style: .destructive) {}
                        }
                        PrimaryButton("Full Width Primary", isLoading: isLoading, isFullWidth: true) {}
                        AccentButton("Full Width Accent", isLoading: isLoading, isFullWidth: true) {}
                        SecondaryButton("Full Width Secondary", isLoading: isLoading, isFullWidth: true) {}
                        GhostButton("Full Width Ghost", isFullWidth: true) {}
                    }
                    .padding(.horizontal, SpringSpacing.Horizontal.md)

                    Toggle("Simulate loading state", isOn: $isLoading)
                        .padding(.horizontal, SpringSpacing.Horizontal.md)
                        .tint(SpringColor.Object.secondary)

                    Divider()
                        .padding(.horizontal, SpringSpacing.Horizontal.md)

                    // MARK: Forms

                    SectionHeader(title: "Form Controls", alignment: .leading)
                        .padding(.horizontal, SpringSpacing.Horizontal.md)

                    VStack(spacing: SpringSpacing.Vertical.md) {
                        SpringTextField(
                            label: "Full Name",
                            placeholder: "e.g. Alexandra Williams",
                            text: $name
                        )

                        SpringTextField(
                            label: "Email Address",
                            placeholder: "you@example.com",
                            text: $email,
                            error: emailError,
                            keyboardType: .emailAddress,
                            submitLabel: .next
                        ) {
                            emailError = email.contains("@") ? nil : "Please enter a valid email address."
                        }

                        SpringTextField(
                            label: "Password",
                            placeholder: "Minimum 8 characters",
                            text: $password,
                            isSecure: true
                        )

                        SpringTextArea(
                            label: "Special Requests",
                            placeholder: "Dietary requirements, celebrations, seating preferences…",
                            text: $notes
                        )

                        SpringDatePicker(
                            label: "Reservation Date & Time",
                            selection: $reservationDate,
                            minimumDate: Date()
                        )

                        SpringStepperField(
                            label: "Number of Guests",
                            value: $guestCount,
                            range: 1...24,
                            unit: "guests"
                        )
                    }
                    .padding(.horizontal, SpringSpacing.Horizontal.md)
                }
                .padding(.vertical, SpringSpacing.Vertical.md)
                .readableContentWidth()
            }
            .navigationTitle("Controls")
        }
    }
}

#Preview {
    ControlsTab()
}
