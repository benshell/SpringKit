import Testing
@testable import SpringKit

// MARK: - Spacing Token Tests

@Suite("SpringSpacing")
struct SpringSpacingTests {

    @Test("baseUnit is 8")
    func baseUnit() {
        #expect(SpringSpacing.baseUnit == 8)
    }

    @Test("fixed(_:) returns baseUnit × multiplier")
    func fixedMultiplier() {
        #expect(SpringSpacing.fixed(0.5) == 4)
        #expect(SpringSpacing.fixed(1) == 8)
        #expect(SpringSpacing.fixed(2) == 16)
        #expect(SpringSpacing.fixed(3) == 24)
        #expect(SpringSpacing.fixed(5) == 40)
        #expect(SpringSpacing.fixed(20) == 160)
    }

    @Test("Vertical tokens match expected values")
    func verticalTokens() {
        #expect(SpringSpacing.Vertical.xs  == 4)
        #expect(SpringSpacing.Vertical.sm  == 8)
        #expect(SpringSpacing.Vertical.md  == 16)
        #expect(SpringSpacing.Vertical.lg  == 24)
        #expect(SpringSpacing.Vertical.xl  == 40)
        #expect(SpringSpacing.Vertical.xxl == 64)
    }

    @Test("Horizontal tokens match expected values")
    func horizontalTokens() {
        #expect(SpringSpacing.Horizontal.xs  == 4)
        #expect(SpringSpacing.Horizontal.sm  == 8)
        #expect(SpringSpacing.Horizontal.md  == 16)
        #expect(SpringSpacing.Horizontal.lg  == 24)
        #expect(SpringSpacing.Horizontal.xl  == 40)
        #expect(SpringSpacing.Horizontal.xxl == 64)
    }

    @Test("Minimum tap target is 44pt")
    func minimumTapTarget() {
        #expect(SpringSpacing.minimumTapTarget == 44)
    }
}

// MARK: - Font Size Token Tests

@Suite("SpringFontSize")
struct SpringFontSizeTests {

    @Test("Text size tokens have expected values")
    func textSizeTokens() {
        #expect(SpringFontSize.caption    == 11)
        #expect(SpringFontSize.footnote   == 13)
        #expect(SpringFontSize.body       == 16)
        #expect(SpringFontSize.callout    == 18)
        #expect(SpringFontSize.subheading == 20)
        #expect(SpringFontSize.heading3   == 24)
        #expect(SpringFontSize.heading2   == 28)
        #expect(SpringFontSize.heading1   == 34)
        #expect(SpringFontSize.display    == 44)
        #expect(SpringFontSize.hero       == 56)
    }

    @Test("Sizes are in ascending order")
    func ascendingOrder() {
        let sizes: [CGFloat] = [
            SpringFontSize.caption,
            SpringFontSize.footnote,
            SpringFontSize.body,
            SpringFontSize.callout,
            SpringFontSize.subheading,
            SpringFontSize.heading3,
            SpringFontSize.heading2,
            SpringFontSize.heading1,
            SpringFontSize.display,
            SpringFontSize.hero
        ]
        #expect(sizes == sizes.sorted())
    }
}
