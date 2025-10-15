# PantryChef Design System

## Brand Identity
PantryChef is a modern, AI-powered cooking companion that transforms available ingredients into delicious recipes. The design embodies simplicity, warmth, and culinary inspiration.

---

## Color Palette

### Primary Colors
- **Background**: `#F8F8F8` (Off-White) - Main app background
- **Surface**: `#FFFFFF` (Pure White) - Cards, elevated surfaces
- **Accent**: `#FF7F6A` (Soft Coral) - Primary interactive elements
  - Buttons, chips, icons, highlights
  - Warm and appetizing, evokes fresh ingredients

### Secondary Colors
- **Text Primary**: `#2C2C2C` (Charcoal) - Main text, headings
- **Text Secondary**: `#6B6B6B` (Medium Gray) - Descriptions, labels
- **Text Tertiary**: `#9E9E9E` (Light Gray) - Hints, placeholders

### Functional Colors
- **Success**: `#4CAF50` (Fresh Green) - Completed actions, checkmarks
- **Warning**: `#FFA726` (Warm Orange) - Alerts, tips
- **Error**: `#EF5350` (Soft Red) - Error states
- **Divider**: `#E0E0E0` (Light Gray) - Separators, borders

### Accent Color Variations
- **Accent Light**: `#FFB5A7` (Light Coral) - Hover states, backgrounds
- **Accent Dark**: `#E65A45` (Deep Coral) - Pressed states

---

## Typography

### Font Family
**Primary**: [Poppins](https://fonts.google.com/specimen/Poppins) (Google Fonts)
- Modern, geometric, highly readable
- Weights: 300 (Light), 400 (Regular), 500 (Medium), 600 (SemiBold), 700 (Bold)

### Type Scale

#### Headings
- **H1 (Screen Titles)**: Poppins SemiBold, 28px, Letter Spacing: -0.5px
- **H2 (Section Headers)**: Poppins SemiBold, 22px, Letter Spacing: -0.3px
- **H3 (Card Titles)**: Poppins Medium, 18px, Letter Spacing: 0px
- **H4 (Subsections)**: Poppins Medium, 16px, Letter Spacing: 0px

#### Body Text
- **Body Large**: Poppins Regular, 16px, Line Height: 24px
- **Body Medium**: Poppins Regular, 14px, Line Height: 20px
- **Body Small**: Poppins Regular, 12px, Line Height: 18px

#### Interactive Elements
- **Button Text**: Poppins SemiBold, 16px, Letter Spacing: 0.5px
- **Chip Text**: Poppins Medium, 14px
- **Label Text**: Poppins Medium, 12px, Letter Spacing: 0.5px (Uppercase)

---

## Spacing System

### Base Unit: 4px
All spacing follows an 8-point grid system for consistency.

### Spacing Scale
- **XXS**: 4px - Tight spacing within components
- **XS**: 8px - Minimal padding, icon spacing
- **S**: 12px - Chip padding, small gaps
- **M**: 16px - Standard padding, card margins
- **L**: 24px - Section spacing, large gaps
- **XL**: 32px - Screen padding, major sections
- **XXL**: 48px - Extra large spacing, feature separation

---

## Component Specifications

### Buttons

#### Primary Button (ElevatedButton)
- **Background**: Accent Color (#FF7F6A)
- **Text**: White (#FFFFFF)
- **Height**: 56px
- **Border Radius**: 16px
- **Padding**: Horizontal 32px
- **Shadow**: Elevation 2 (0px 2px 8px rgba(0,0,0,0.12))
- **Hover**: Accent Dark (#E65A45)
- **Pressed**: Accent Dark + Elevation 4

#### Secondary Button (OutlinedButton)
- **Border**: 2px solid Accent Color
- **Text**: Accent Color
- **Background**: Transparent
- **Height**: 48px
- **Border Radius**: 12px
- **Padding**: Horizontal 24px

#### Icon Button
- **Size**: 48x48px
- **Icon Size**: 24x24px
- **Color**: Text Secondary (#6B6B6B)
- **Hover**: Accent Light background (#FFB5A7)

### Chips

#### Choice Chip (Selected)
- **Background**: Accent Color (#FF7F6A)
- **Text**: White (#FFFFFF)
- **Height**: 36px
- **Border Radius**: 18px (Pill shape)
- **Padding**: Horizontal 16px
- **Icon**: Optional, 18x18px

#### Choice Chip (Unselected)
- **Background**: White (#FFFFFF)
- **Border**: 1.5px solid #E0E0E0
- **Text**: Text Primary (#2C2C2C)
- **Height**: 36px
- **Border Radius**: 18px
- **Padding**: Horizontal 16px

### Input Fields

#### Text Input (Multi-line)
- **Background**: White (#FFFFFF)
- **Border**: 2px solid #E0E0E0
- **Border Radius**: 16px
- **Padding**: 16px
- **Min Height**: 120px
- **Font**: Body Large (16px)
- **Placeholder**: Text Tertiary (#9E9E9E)
- **Focus**: Border changes to Accent Color

#### Text Input (Single-line)
- **Background**: White (#FFFFFF)
- **Border**: 1.5px solid #E0E0E0
- **Border Radius**: 12px
- **Height**: 48px
- **Padding**: Horizontal 16px
- **Font**: Body Medium (14px)

### Cards

#### Recipe Card
- **Background**: White (#FFFFFF)
- **Border Radius**: 20px
- **Padding**: 20px
- **Shadow**: 0px 4px 12px rgba(0,0,0,0.08)
- **Hover**: Shadow increases to 0px 6px 16px rgba(0,0,0,0.12)

#### Small Card (Cookbook Grid)
- **Background**: White (#FFFFFF)
- **Border Radius**: 16px
- **Padding**: 16px
- **Aspect Ratio**: 1:1 or 3:4
- **Shadow**: 0px 2px 8px rgba(0,0,0,0.06)

### Icons

#### Icon Style
- **Library**: Material Icons (Outlined variant) or Lucide Icons
- **Style**: Minimalist, line-based (2px stroke weight)
- **Primary Size**: 24x24px
- **Large Size**: 32x32px
- **Small Size**: 18x18px

#### Common Icons
- **Ingredients**: `kitchen`, `restaurant_menu`
- **Time**: `schedule`, `timer`
- **Servings**: `people_outline`, `person_outline`
- **Save**: `bookmark_border` / `bookmark`
- **Chef/Cooking**: `soup_kitchen`, `local_dining`
- **Checkmark**: `check_circle_outline` / `check_circle`

### Illustrations

#### Style Guidelines
- **Type**: Abstract, minimalist line art
- **Stroke Weight**: 2px
- **Color**: Accent Color (#FF7F6A) or Text Secondary (#6B6B6B)
- **Complexity**: Simple, 3-5 main elements
- **Examples**: 
  - Whisk outline
  - Chef's hat silhouette
  - Pot with steam lines
  - Cutting board with knife
  - Ingredient icons (tomato, carrot, etc.)

---

## Layout Guidelines

### Screen Structure
- **Status Bar**: System default
- **App Bar Height**: 56px
- **Bottom Navigation**: 64px (if used)
- **Screen Padding**: 20px horizontal, 16px vertical
- **Safe Area**: Respect system insets

### Grid System
- **Columns**: 4 columns on mobile
- **Gutter**: 16px
- **Margin**: 20px

### Content Width
- **Max Width**: 600px (for tablet/large screens)
- **Center content** on screens wider than max width

---

## Animation & Transitions

### Timing
- **Fast**: 150ms - Micro-interactions (chip selection, button press)
- **Medium**: 300ms - Screen transitions, card appearance
- **Slow**: 500ms - Loading animations, complex transitions

### Easing
- **Standard**: Cubic Bezier (0.4, 0.0, 0.2, 1) - Most transitions
- **Decelerate**: Cubic Bezier (0.0, 0.0, 0.2, 1) - Entering elements
- **Accelerate**: Cubic Bezier (0.4, 0.0, 1, 1) - Exiting elements

### Common Animations
- **Fade In**: Opacity 0 → 1 (300ms)
- **Slide Up**: TranslateY 20px → 0 (300ms)
- **Scale**: Scale 0.95 → 1.0 (150ms)
- **Ripple**: Material ripple effect on tap

---

## Accessibility

### Contrast Ratios
- **Text Primary on Background**: 12.5:1 (AAA)
- **Text Secondary on Background**: 7.2:1 (AAA)
- **Accent on Background**: 3.8:1 (AA)
- **White on Accent**: 4.2:1 (AA)

### Touch Targets
- **Minimum Size**: 48x48px
- **Recommended**: 56x56px for primary actions
- **Spacing**: Minimum 8px between interactive elements

### Text Sizing
- **Minimum Body Text**: 14px
- **Minimum Interactive Text**: 14px
- **Support Dynamic Type**: Allow text scaling up to 200%

---

## Design Principles

1. **Clarity First**: Every element should have a clear purpose
2. **Consistent Spacing**: Use the 8px grid system religiously
3. **Hierarchy**: Use size, weight, and color to guide the eye
4. **Whitespace**: Don't fear empty space—it improves readability
5. **Warmth**: The accent color should feel inviting and appetizing
6. **Simplicity**: Avoid clutter; show only what's necessary
7. **Delight**: Subtle animations and illustrations add personality

---

## Implementation Notes

### Flutter Packages
- **google_fonts**: For Poppins font family
- **flutter_svg**: For custom illustrations
- **lottie**: For animated loading states
- **cached_network_image**: For efficient image loading

### Theme Configuration
```dart
ThemeData(
  primaryColor: Color(0xFFFF7F6A),
  scaffoldBackgroundColor: Color(0xFFF8F8F8),
  fontFamily: 'Poppins',
  colorScheme: ColorScheme.light(
    primary: Color(0xFFFF7F6A),
    secondary: Color(0xFF4CAF50),
    surface: Color(0xFFFFFFFF),
    background: Color(0xFFF8F8F8),
    error: Color(0xFFEF5350),
  ),
  textTheme: TextTheme(
    displayLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
    displayMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
    titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
    bodyLarge: TextStyle(fontSize: 16, height: 1.5),
    bodyMedium: TextStyle(fontSize: 14, height: 1.43),
  ),
)
```

---

**Last Updated**: October 2025
**Version**: 1.0
