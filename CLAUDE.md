# SpringKit — Design System Library

## Project Overview

SpringKit is a standalone SwiftUI design system library for iOS, distributed via Swift Package Manager. It provides a complete design foundation — colors, typography, spacing, Liquid Glass materials, and pre-built SwiftUI components — for use across multiple iOS applications.

The aesthetic is **"elegant spring"**: think vineyard estates, wedding venues, and upscale restaurants. Deep greens are the dominant brand color, harvest orange and champagne gold serve as accents, and warm off-white parchment provides the foundational background. The overall impression is refined, natural, and celebratory without being ostentatious.

---

## Target Platform

- **iOS 26+** — strict minimum; no backward-compatibility shims or availability guards for anything iOS 26 provides natively
- **Swift 6** with strict concurrency
- **SwiftUI** as the exclusive UI framework
- **Swift Package Manager** — zero CocoaPods or Carthage; zero external dependencies
- **Liquid Glass** (iOS 26) — used for materials, overlays, and navigation surfaces

---

## Design Philosophy

- Follow **Apple Human Interface Guidelines** at all times
- **Accessibility first**: all color pairs must meet WCAG AA contrast ratios minimum (AAA where achievable); High Contrast Mode is not optional
- **Semantic naming**: every token name reflects its purpose, never its color (no `green`, `orange`, `white`)
- **Composition over inheritance** in all SwiftUI component design
- **Single source of truth**: all token values live in their respective definition files; never hardcode values in component files

---

## Package Structure

```
SpringKit/
├── Package.swift
├── CLAUDE.md
├── Sources/
│   └── SpringKit/
│       ├── SpringKit.swift                  # Public API re-exports (top-level)
│       ├── Colors/
│       │   ├── SpringColor.swift            # Color token definitions
│       │   └── Resources/
│       │       └── SpringColorAssets.xcassets/
│       ├── Typography/
│       │   ├── SpringFont.swift             # Font type definitions & loading
│       │   ├── SpringFontSize.swift         # Text size tokens
│       │   └── Resources/
│       │       └── Fonts/
│       │           └── GreatVibes-Regular.ttf
│       ├── Spacing/
│       │   └── SpringSpacing.swift          # Spacing, sizing, and fixed-unit utility
│       ├── Materials/
│       │   └── SpringMaterial.swift         # Liquid Glass material helpers & modifiers
│       └── Components/
│           ├── Brochure/                    # Display/marketing components
│           │   ├── HeroView.swift
│           │   ├── FeatureCard.swift
│           │   ├── TestimonialCard.swift
│           │   ├── GalleryGrid.swift
│           │   ├── SectionHeader.swift
│           │   └── InfoBanner.swift
│           └── Portal/                      # Interactive/functional components
│               ├── Buttons/
│               │   ├── PrimaryButton.swift
│               │   ├── SecondaryButton.swift
│               │   ├── GhostButton.swift
│               │   └── AccentButton.swift
│               ├── Forms/
│               │   ├── SpringTextField.swift
│               │   ├── SpringTextArea.swift
│               │   ├── SpringDatePicker.swift
│               │   └── SpringStepperField.swift
│               ├── Cards/
│               │   ├── BookingCard.swift
│               │   ├── OrderCard.swift
│               │   └── InquiryCard.swift
│               ├── Navigation/
│               │   ├── SpringNavigationBar.swift
│               │   └── SpringTabBar.swift
│               └── Feedback/
│                   ├── SpringToast.swift
│                   ├── SpringBadge.swift
│                   └── SpringLoadingView.swift
└── Tests/
    └── SpringKitTests/
        └── SpringKitTests.swift
```

---

## Color System

### Principles

- All colors are defined in an **Asset Catalog** (`.xcassets`) with separate Light, Dark, and High Contrast slots — this is the only permitted way to define colors in SpringKit
- Tokens are exposed as `static` properties on a `SpringColor` enum used as a namespace
- Colors are organized into three independent categories: **Text**, **Object** (UI elements), and **Background**
- Text, Object, and Background tokens are fully independent — `SpringColor.Text.primary` and `SpringColor.Background.primary` are different colors
- Never reference raw hex values in component files; always use token properties

### Raw Palette Reference

These are the underlying color values that feed into the semantic tokens. They are not exposed as public API — they exist only to document what values are used.

| Palette Name | Light Mode   | Dark Mode    | Notes                          |
|--------------|-------------|-------------|-------------------------------|
| Forest       | `#1A2E20`   | `#0D1A12`   | Deep vineyard green            |
| Verdant      | `#2D6A4F`   | `#3A8A65`   | Mid-tone green                 |
| Sage         | `#4A7C59`   | `#5A9E72`   | Lighter, livelier green        |
| Harvest      | `#D4682E`   | `#E07A3A`   | Warm burnt orange              |
| Champagne    | `#C4A35A`   | `#D4B468`   | Gold luxury accent             |
| Parchment    | `#F7F3EC`   | —           | Warm off-white                 |
| Stone        | `#8B7A62`   | `#A89278`   | Warm neutral brown             |
| Bark         | `#5C3D2E`   | `#7A5642`   | Deep warm brown                |

### Text Color Tokens (`SpringColor.Text`)

| Token          | Light              | Dark               | HC Light           | HC Dark            |
|----------------|-------------------|-------------------|-------------------|-------------------|
| `primary`      | Forest `#1A2E20`  | Parchment `#F7F3EC` | `#000000`        | `#FFFFFF`          |
| `secondary`    | Stone `#8B7A62`   | Sage `#5A9E72`    | Forest `#1A2E20`  | Parchment `#F7F3EC` |
| `accent`       | Harvest `#D4682E` | Harvest `#E07A3A` | `#A83D10`         | `#FF8C4A`          |
| `muted`        | Stone 60% opacity | Stone `#A89278`   | Stone `#8B7A62`   | Stone `#C4AE94`    |
| `inverted`     | Parchment `#F7F3EC` | Forest `#1A2E20` | `#FFFFFF`         | `#000000`          |
| `link`         | Verdant `#2D6A4F` | Sage `#5A9E72`    | `#1A4A34`         | `#7ABF94`          |

### Object Color Tokens (`SpringColor.Object`)

| Token          | Light              | Dark               | HC Light           | HC Dark            |
|----------------|-------------------|-------------------|-------------------|-------------------|
| `primary`      | Forest `#1A2E20`  | Verdant `#3A8A65` | `#000000`          | `#FFFFFF`          |
| `secondary`    | Verdant `#2D6A4F` | Sage `#5A9E72`    | Forest `#1A2E20`   | Parchment `#F7F3EC` |
| `accent`       | Harvest `#D4682E` | Harvest `#E07A3A` | `#A83D10`          | `#FF8C4A`          |
| `champagne`    | Champagne `#C4A35A` | Champagne `#D4B468` | `#8A6E2A`       | `#F0D080`          |
| `border`       | Stone 40% opacity | Sage 30% opacity  | Forest `#1A2E20`   | Parchment `#F7F3EC` |
| `destructive`  | `#C0392B`         | `#E05545`         | `#8B0000`          | `#FF6B5B`          |

### Background Color Tokens (`SpringColor.Background`)

| Token          | Light              | Dark               | HC Light           | HC Dark            |
|----------------|-------------------|-------------------|-------------------|-------------------|
| `primary`      | Parchment `#F7F3EC` | Forest `#0D1A12` | `#FFFFFF`          | `#000000`          |
| `secondary`    | `#EDE8DF`         | Forest `#1A2E20`  | `#F0EBE0`          | `#0A1209`          |
| `surface`      | `#FFFFFF`         | `#1E3428`         | `#FFFFFF`          | `#0F1F16`          |
| `elevated`     | `#FAF7F2`         | `#243C2E`         | `#FFFFFF`          | `#162414`          |
| `accent`       | Harvest 15% tint  | Harvest 20% tint  | Harvest 25% tint   | Harvest 30% tint   |
| `overlay`      | Black 40% opacity | Black 60% opacity | Black 60% opacity  | Black 80% opacity  |

---

## Typography System

### Font Types

SpringKit defines two font types, exposed via the `SpringFont` namespace.

#### Type 1: `SpringFont.prose` — SF Pro (System Font)

- Uses `Font.system(size:weight:design:)` — no bundled assets required
- `.default` design for body/UI text (SF Pro Text at smaller sizes, SF Pro Display at larger sizes — Apple handles this automatically via the system font)
- Supports the full range of `Font.Weight` values
- Scales with Dynamic Type when used via the `SpringTextStyle` modifiers

#### Type 2: `SpringFont.accent` — Great Vibes (Custom Cursive)

- **Font:** Great Vibes by TypeSETit
- **License:** SIL Open Font License (free, redistribution permitted)
- **Source:** Google Fonts — `GreatVibes-Regular.ttf`
- **Usage:** Sparingly — decorative headings, hero displays, section headers only. Never for body text, labels, or UI controls.
- **Character:** Flowing calligraphic script; evokes handwritten wedding invitations and fine restaurant menus
- **Available weight:** Regular only (script fonts have a single weight by nature)
- Must be declared as a resource in `Package.swift` and registered via `CTFontManagerRegisterFontsForURL` or Info.plist `UIAppFonts` equivalent for SPM packages

### Font API Design

```swift
// System prose font
SpringFont.prose(size: .heading1, weight: .semibold)
SpringFont.prose(size: .body, weight: .regular)
SpringFont.prose(size: SpringSpacing.fixed(2.5), weight: .medium)  // fixed-unit size

// Custom accent/cursive font
SpringFont.accent(size: .display)
SpringFont.accent(size: .heading2)

// View modifier equivalents (preferred in component code)
Text("Vineyard Estate").springAccentFont(size: .display)
Text("Welcome").springProseFont(size: .body, weight: .regular)
```

### Font Weight Support

`SpringFont.prose` supports all standard weights:
`.ultraLight` · `.thin` · `.light` · `.regular` · `.medium` · `.semibold` · `.bold` · `.heavy` · `.black`

`SpringFont.accent` supports: `.regular` only.

---

## Font Size & Spacing Tokens

All values live in `SpringFontSize.swift` and `SpringSpacing.swift`. These files are the **single point of update** when new sizes are needed — never define sizes inline in component files.

### Text Size Tokens (`SpringFontSize`)

| Token        | Size  | Typical Usage                              |
|-------------|------|--------------------------------------------|
| `.caption`   | 11pt | Fine print, legal text, metadata labels    |
| `.footnote`  | 13pt | Supporting info, timestamps, photo credits |
| `.body`      | 16pt | Primary reading text                       |
| `.callout`   | 18pt | Featured callout or lead paragraph         |
| `.subheading`| 20pt | Section subheadings                        |
| `.heading3`  | 24pt | H3                                         |
| `.heading2`  | 28pt | H2                                         |
| `.heading1`  | 34pt | H1 — prose font recommended                |
| `.display`   | 44pt | Hero text — accent font primary use case   |
| `.hero`      | 56pt | Full-bleed hero — accent font only         |

### Vertical Spacing Tokens (`SpringSpacing.Vertical`)

| Token        | Size  | Typical Usage                    |
|-------------|------|----------------------------------|
| `.xs`        | 4pt  | Tight inline gaps                |
| `.sm`        | 8pt  | Small internal padding           |
| `.md`        | 16pt | Standard component padding       |
| `.lg`        | 24pt | Between related components       |
| `.xl`        | 40pt | Section breaks                   |
| `.xxl`       | 64pt | Major section separators         |

### Horizontal Spacing Tokens (`SpringSpacing.Horizontal`)

| Token        | Size  | Typical Usage                    |
|-------------|------|----------------------------------|
| `.xs`        | 4pt  | Tight inline gaps                |
| `.sm`        | 8pt  | Small internal padding           |
| `.md`        | 16pt | Standard screen edge margins     |
| `.lg`        | 24pt | Content padding                  |
| `.xl`        | 40pt | Wide layout insets               |
| `.xxl`       | 64pt | Full-width section padding       |

### Fixed-Multiplier Utility

`SpringSpacing.fixed(_ multiplier: CGFloat) -> CGFloat`

Base unit: **8pt** (defined as `SpringSpacing.baseUnit: CGFloat = 8`; change it in one place to rebase the entire scale).

```swift
SpringSpacing.fixed(0.5)   // →  4pt
SpringSpacing.fixed(1)     // →  8pt
SpringSpacing.fixed(2)     // → 16pt
SpringSpacing.fixed(3)     // → 24pt
SpringSpacing.fixed(5)     // → 40pt
SpringSpacing.fixed(20)    // → 160pt
```

---

## Liquid Glass Materials (iOS 26)

Liquid Glass is iOS 26's dynamic material system. SpringKit wraps it in `SpringMaterial` to apply consistent brand coloring and ensure appropriate usage across the design system.

### Material Definitions

| Material               | Description                                              |
|------------------------|----------------------------------------------------------|
| `SpringMaterial.glass`       | Default Liquid Glass — general surfaces and cards  |
| `SpringMaterial.thinGlass`   | Lightweight glass — overlays and secondary panels  |
| `SpringMaterial.thickGlass`  | Prominent glass — modal sheets, prominent cards    |
| `SpringMaterial.forestGlass` | Glass with Forest green tint — navigation surfaces |
| `SpringMaterial.harvestGlass`| Glass with Harvest orange tint — accent highlights |

### View Modifiers

```swift
// Background material
.springGlass()                            // default glass
.springGlass(.thin)
.springGlass(.forest)

// Card container with glass background + corner radius + shadow
.springGlassCard(cornerRadius: 20)
.springGlassCard(cornerRadius: 16, material: .thick)

// Frosted overlay (modal backdrops, image overlays)
.springFrostedOverlay(opacity: 0.4)

// Navigation bar material
.springNavigationMaterial()
```

---

## Component Inventory

### Brochure Components

Display-focused; typically non-interactive or lightly interactive. Used to present the venue, menu, or brand.

| Component         | Description                                                                 |
|------------------|-----------------------------------------------------------------------------|
| `HeroView`        | Full-bleed background image with overlay gradient, headline (accent font), subheadline, and optional CTA button |
| `FeatureCard`     | Image + optional icon + title (prose) + body description; for showcasing amenities or services |
| `TestimonialCard` | Pull quote with attribution name, optional avatar, and star rating          |
| `GalleryGrid`     | Adaptive photo grid (uniform or masonry layout, configurable columns)       |
| `SectionHeader`   | Title (accent font optional) + optional subtitle + decorative botanical divider |
| `InfoBanner`      | Full-width banner for seasonal messaging, announcements, or promotional copy |

### Portal / Functional Components

Interactive customer-facing components for ordering, booking, planning, and inquiry flows.

#### Buttons

| Component         | Style                                      | Usage                            |
|------------------|--------------------------------------------|----------------------------------|
| `PrimaryButton`   | Filled Forest green, white label           | Primary confirmation actions     |
| `SecondaryButton` | Outlined Forest green, green label         | Secondary / alternative actions  |
| `GhostButton`     | No fill, muted label                       | Tertiary or destructive actions  |
| `AccentButton`    | Filled Harvest orange, white label         | High-priority CTA (Book Now, Order) |

All buttons: minimum 44×44pt tap target, supports disabled state, loading state (spinner replaces label), and full-width layout option.

#### Forms

| Component           | Description                                                      |
|--------------------|------------------------------------------------------------------|
| `SpringTextField`   | Single-line styled text input with label, placeholder, error state |
| `SpringTextArea`    | Multi-line input for inquiry messages and special requests        |
| `SpringDatePicker`  | Styled date/time picker for reservation and booking flows         |
| `SpringStepperField`| Numeric stepper with label; for guest count, quantity selection  |

#### Cards

| Component      | Description                                                          |
|---------------|----------------------------------------------------------------------|
| `BookingCard`  | Reservation summary: date, time, party size, venue/table, status badge |
| `OrderCard`    | Menu item display: image, name, description, price, add-to-order action |
| `InquiryCard`  | Submitted inquiry with reference number, status badge, timestamp     |

#### Navigation

| Component              | Description                                                    |
|-----------------------|----------------------------------------------------------------|
| `SpringTabBar`         | Custom tab bar using Liquid Glass material; Spring-branded icons and labels |
| `SpringNavigationBar`  | Custom nav bar with optional accent-font title, back button, and trailing actions |

#### Feedback & Status

| Component          | Description                                                       |
|-------------------|-------------------------------------------------------------------|
| `SpringToast`      | Transient overlay message (success, info, warning, error variants) |
| `SpringBadge`      | Status pill or dot indicator (e.g., Confirmed, Pending, New)      |
| `SpringLoadingView`| Branded loading animation for async operations                    |

---

## Code Conventions

- **Swift 6 strict concurrency** throughout — use `Sendable`, `@MainActor`, and structured concurrency appropriately
- All public types, properties, and methods require `///` documentation comments
- Use `@frozen` on enums where the case list is intentionally fixed
- Token namespacing via `enum` with no cases (used as a pure namespace), e.g., `enum SpringColor { enum Text { ... } }`
- No hardcoded color, size, or font values in component files — always reference tokens
- All component files must include a `#Preview` block demonstrating key states
- Asset Catalog colors only — never use `Color(hex:)` initializers in production code; hex values belong in the xcassets JSON only
- Components use `@Environment` and `ViewBuilder` for composability and theming hooks
- Prefer value types (`struct`) over reference types; use `class` only when reference semantics are genuinely required

---

## Accessibility Requirements

- All text/background color pairs must achieve **WCAG AA** (4.5:1 normal text, 3:1 large text) at minimum; target AAA (7:1) where practical
- **High Contrast Mode** variants are required for every color token — this is not optional
- All user-facing text components must support **Dynamic Type** (`scaledFont` or `.font(.body)` system equivalents)
- Every interactive element must have a minimum tap target of **44×44pt**
- All interactive components must declare `accessibilityLabel`, `accessibilityHint`, and `accessibilityRole` as appropriate
- `SpringLoadingView` and animated elements must respect `AccessibilityReduceMotion`

---

## Non-Goals (V1)

- macOS, watchOS, tvOS, or visionOS support
- Multi-brand / multi-theme support (SpringKit ships one brand)
- Animation library beyond component-internal transitions
- Icon library
- Localization infrastructure (components accept already-localized strings)
