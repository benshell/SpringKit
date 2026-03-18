import SwiftUI
import SpringKit

struct BrochureTab: View {
    @Environment(\.horizontalSizeClass) private var sizeClass

    private var galleryColumns: Int {
        sizeClass == .regular ? 3 : 2
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: SpringSpacing.Vertical.lg) {

                    InfoBanner(
                        style: .seasonal,
                        icon: Image(systemName: "sparkles"),
                        message: "Spring tasting menu now available — reserve your table for an evening to remember.",
                        actionLabel: "Reserve Now",
                        action: {}
                    )

                    HeroView(
                        image: DemoContent.heroImage,
                        headline: "Vineyard Estate",
                        subheadline: "An unforgettable dining experience among the vines",
                        ctaLabel: "Book a Table",
                        ctaAction: {}
                    )

                    SectionHeader(
                        title: "Our Offerings",
                        subtitle: "Curated experiences for every occasion",
                        useAccentFont: true
                    )

                    ScrollView(.horizontal) {
                        HStack(spacing: SpringSpacing.Horizontal.md) {
                            ForEach(DemoContent.features) { feature in
                                FeatureCard(
                                    icon: feature.icon,
                                    title: feature.title,
                                    description: feature.description
                                )
                                .frame(width: 240)
                            }
                        }
                        .padding(.horizontal, SpringSpacing.Horizontal.md)
                    }
                    .scrollIndicators(.hidden)

                    SectionHeader(
                        title: "Guest Experiences",
                        subtitle: "What our guests are saying"
                    )

                    testimonials
                        .readableContentWidth()

                    SectionHeader(
                        title: "Gallery",
                        subtitle: "A glimpse of our estate"
                    )

                    GalleryGrid(
                        images: DemoContent.galleryImages,
                        columns: galleryColumns,
                        layout: .uniform(imageHeight: 160)
                    )

                    InfoBanner(
                        style: .info,
                        icon: Image(systemName: "calendar"),
                        message: "Private dining rooms available for groups of 8–24 guests.",
                        actionLabel: "Enquire",
                        action: {}
                    )

                    InfoBanner(
                        style: .warning,
                        icon: Image(systemName: "clock"),
                        message: "Last orders for the kitchen are at 9:30 pm on weeknights."
                    )
                }
                .padding(.bottom, SpringSpacing.Vertical.xl)
            }
            .navigationTitle("Brochure Components")
        }
    }

    private var testimonials: some View {
        VStack(spacing: SpringSpacing.Vertical.md) {
            ForEach(DemoContent.testimonials) { testimonial in
                TestimonialCard(
                    quote: testimonial.quote,
                    attribution: testimonial.name,
                    subtitle: testimonial.subtitle,
                    rating: testimonial.rating
                )
            }
        }
        .padding(.horizontal, SpringSpacing.Horizontal.md)
    }
}

#Preview {
    BrochureTab()
}
