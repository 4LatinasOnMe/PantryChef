# PantryChef Assets Guide

## Overview
This guide details all visual assets needed for the PantryChef app, including icons, illustrations, animations, and implementation instructions.

---

## Asset Directory Structure

```
assets/
├── icons/
│   ├── app_icon.png (1024x1024)
│   ├── chef_hat.svg
│   ├── food/
│   │   ├── pasta.svg
│   │   ├── salad.svg
│   │   ├── soup.svg
│   │   ├── pan.svg
│   │   ├── dessert.svg
│   │   ├── wrap.svg
│   │   ├── pizza.svg
│   │   └── bowl.svg
│   └── ui/
│       ├── bookmark.svg
│       ├── bookmark_filled.svg
│       ├── clock.svg
│       ├── person.svg
│       └── fire.svg
├── animations/
│   ├── chef_hat_bounce.json
│   ├── stirring_pot.json
│   └── ingredients_combine.json
├── illustrations/
│   ├── empty_cookbook.svg
│   ├── cooking_utensils.svg
│   └── welcome_pattern.svg
└── splash/
    ├── splash_icon.png (1024x1024)
    └── splash_background.png
```

---

## Icon Specifications

### Style Guidelines
- **Type**: Line-based, minimalist
- **Stroke Weight**: 2px
- **Corner Radius**: Rounded (2px)
- **Color**: Single color (will be tinted in app)
- **Format**: SVG (vector)
- **Canvas Size**: 24x24px (UI icons), 64x64px (food icons)
- **Padding**: 2px internal padding

### UI Icons (24x24px)

#### Navigation & Actions
1. **Back Arrow**
   - Left-pointing chevron
   - 2px stroke
   - Color: #2C2C2C

2. **Bookmark (Outline)**
   - Classic bookmark shape
   - 2px stroke outline
   - Color: #6B6B6B

3. **Bookmark (Filled)**
   - Same shape, filled
   - Color: #FF7F6A

4. **Search**
   - Magnifying glass
   - 2px stroke
   - Color: #6B6B6B

5. **Share**
   - Connected nodes or arrow
   - 2px stroke
   - Color: #6B6B6B

6. **Profile/User**
   - Simple person silhouette
   - 2px stroke
   - Color: #6B6B6B

7. **Settings**
   - Gear icon
   - 2px stroke
   - Color: #6B6B6B

#### Info Icons (20x20px)
1. **Clock/Timer**
   - Simple clock face
   - Color: #FF7F6A

2. **Cooking Pot**
   - Pot with steam
   - Color: #FF7F6A

3. **Person/Servings**
   - Person silhouette
   - Color: #FF7F6A

4. **Fire/Flame**
   - Stylized flame
   - Color: #FF7F6A

5. **Checkmark**
   - Simple check
   - Color: #4CAF50

#### Decorative Icons (18x18px)
1. **Lightbulb** (for tips)
   - Simple bulb outline
   - Color: #FFA726

2. **Chef Hat** (small)
   - Minimalist hat
   - Color: #FF7F6A

---

### Food Icons (64x64px)

All food icons should be abstract, minimalist line art with 2px stroke weight.

#### Required Food Icons

1. **Pasta**
   - Curved noodles or spaghetti strands
   - Simple, flowing lines
   - Color: #FF7F6A

2. **Salad Bowl**
   - Bowl with leafy elements
   - Minimal detail
   - Color: #FF7F6A

3. **Soup Pot**
   - Pot with steam lines
   - Simple curves
   - Color: #FF7F6A

4. **Frying Pan**
   - Pan with handle
   - Optional steam or food outline
   - Color: #FF7F6A

5. **Dessert/Cake**
   - Slice of cake or cupcake
   - Simple geometric shapes
   - Color: #FF7F6A

6. **Wrap/Burrito**
   - Rolled wrap shape
   - Minimal lines
   - Color: #FF7F6A

7. **Pizza**
   - Pizza slice with toppings
   - Simple circles and lines
   - Color: #FF7F6A

8. **Rice Bowl**
   - Bowl with rice texture
   - Chopsticks optional
   - Color: #FF7F6A

9. **Sandwich**
   - Layered sandwich
   - Simple rectangles
   - Color: #FF7F6A

10. **Smoothie/Drink**
    - Glass with straw
    - Simple outline
    - Color: #FF7F6A

#### Icon Usage
- Recipe cards in Cookbook
- Empty states
- Category indicators
- Recipe type badges

---

## Illustrations

### Empty Cookbook Illustration (120x120px)

**Design**:
- Open cookbook with blank pages
- Minimalist line art style
- 2px stroke weight
- Color: #E0E0E0(light gray)

**Elements**:
- Book cover (slightly open)
- Two visible pages
- Optional: Small bookmark ribbon
- Optional: Subtle chef hat on cover

**Usage**: Empty state on Cookbook screen

---

### Cooking Utensils Pattern (200x200px)

**Design**:
- Collection of kitchen utensils
- Whisk, spatula, spoon, fork
- Arranged in decorative pattern
- Very light color (#F0F0F0)
- 1px stroke weight

**Elements**:
- 4-5 utensils
- Overlapping arrangement
- Subtle and non-distracting

**Usage**: Background pattern on Home screen header

---

### Welcome Cooking Scene (150x150px)

**Design**:
- Abstract cooking scene
- Pot, ingredients, steam
- Warm and inviting
- Color: #FF7F6A with #6B6B6B accents

**Elements**:
- Central pot or pan
- Floating ingredient icons
- Steam or sparkle effects
- Minimalist composition

**Usage**: Onboarding or welcome screen (optional)

---

## Animations

### 1. Chef Hat Bounce (chef_hat_bounce.json)

**Type**: Lottie animation
**Duration**: 2 seconds (loop)
**Size**: 200x200px canvas

**Animation Sequence**:
1. **Bounce** (0-2s, continuous):
   - Hat moves up 10px
   - Ease out (0.5s)
   - Hat moves down 10px
   - Ease in (0.5s)
   - Repeat

2. **Rotation** (0-3s, continuous):
   - Rotate -5° to +5°
   - Smooth sine wave motion
   - Slower than bounce

3. **Steam Lines** (staggered):
   - 3 wavy lines rise from top
   - Fade in at bottom (0.2s)
   - Rise upward (1.5s)
   - Fade out at top (0.2s)
   - Stagger start times (0.3s apart)

**Colors**:
- Hat: #FF7F6A
- Steam: #9E9E9E (50% opacity)

**Export**: JSON (Lottie), optimized

---

### 2. Stirring Pot (stirring_pot.json)

**Type**: Lottie animation
**Duration**: 2 seconds (loop)
**Size**: 200x200px canvas

**Animation Sequence**:
1. **Pot** (static):
   - Simple pot outline
   - Color: #FF7F6A

2. **Spoon** (0-2s, continuous):
   - Circular stirring motion
   - 360° rotation in 2s
   - Pivot point at handle top
   - Color: #6B6B6B

3. **Bubbles** (random):
   - Small circles rise from pot
   - Random start positions
   - Rise 30px in 1s
   - Fade out at top
   - 3-4 bubbles at a time
   - Color: #9E9E9E (30% opacity)

4. **Pot Wobble** (0-3s, continuous):
   - Subtle scale: 1.0 to 1.02
   - Slow sine wave
   - Very gentle

**Export**: JSON (Lottie), optimized

---

### 3. Ingredients Combine (ingredients_combine.json)

**Type**: Lottie animation
**Duration**: 4 seconds (loop)
**Size**: 200x200px canvas

**Animation Sequence**:
1. **Ingredients Enter** (0-1s):
   - 3 ingredient icons (tomato, carrot, herb)
   - Slide in from left, right, top
   - Ease out motion
   - Color: #FF7F6A

2. **Rotate & Combine** (1-2.5s):
   - Icons move to center
   - Rotate 360° while moving
   - Converge to single point

3. **Sparkle Effect** (2.5-3s):
   - Star burst from center
   - 6-8 small sparkles
   - Radiate outward
   - Fade out
   - Color: #FFA726

4. **Recipe Icon Appears** (3-3.5s):
   - Chef hat or recipe book icon
   - Scale from 0 to 1
   - Bounce effect
   - Color: #FF7F6A

5. **Hold & Loop** (3.5-4s):
   - Brief pause
   - Fade out
   - Loop back to start

**Export**: JSON (Lottie), optimized

---

## App Icon & Splash

### App Icon (1024x1024px)

**Design Concept**:
- Chef's hat as primary element
- Minimalist and modern
- Coral color (#FF7F6A) on white or gradient background
- Optional: Subtle cooking utensil silhouettes

**Variations Needed**:
- iOS: 1024x1024px (PNG, no alpha)
- Android: 512x512px (PNG, with alpha)
- Adaptive Icon: 108x108dp foreground + background

**Style**:
- Flat design
- No gradients (or subtle gradient)
- High contrast
- Recognizable at small sizes

**Color Options**:
1. White chef hat on coral background
2. Coral chef hat on white background
3. Coral chef hat on gradient (light coral to white)

---

### Splash Screen

**Design**:
- Centered app icon (256x256px)
- Background: #F8F8F8 (matches app background)
- Optional: App name below icon
  - "PantryChef"
  - Poppins SemiBold, 24px, #2C2C2C

**Duration**: 1-2 seconds (minimal)

**Animation** (optional):
- Icon fades in (300ms)
- Slight scale up (0.9 to 1.0)

---

## Implementation Guide

### pubspec.yaml Configuration

```yaml
flutter:
  assets:
    - assets/icons/
    - assets/icons/food/
    - assets/icons/ui/
    - assets/animations/
    - assets/illustrations/
    - assets/splash/

  fonts:
    - family: Poppins
      fonts:
        - asset: fonts/Poppins-Light.ttf
          weight: 300
        - asset: fonts/Poppins-Regular.ttf
          weight: 400
        - asset: fonts/Poppins-Medium.ttf
          weight: 500
        - asset: fonts/Poppins-SemiBold.ttf
          weight: 600
        - asset: fonts/Poppins-Bold.ttf
          weight: 700
```

### Using SVG Icons

```dart
import 'package:flutter_svg/flutter_svg.dart';

// Display SVG icon
SvgPicture.asset(
  'assets/icons/food/pasta.svg',
  width: 64,
  height: 64,
  color: Color(0xFFFF7F6A), // Tint color
)
```

### Using Lottie Animations

```dart
import 'package:lottie/lottie.dart';

// Display Lottie animation
Lottie.asset(
  'assets/animations/chef_hat_bounce.json',
  width: 200,
  height: 200,
  repeat: true,
  animate: true,
)
```

### Icon Color Mapping

```dart
// Define icon colors in theme
class AppIcons {
  static const Color primary = Color(0xFFFF7F6A);
  static const Color secondary = Color(0xFF6B6B6B);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFA726);
}

// Usage
Icon(
  Icons.bookmark,
  color: AppIcons.primary,
  size: 24,
)
```

---

## Asset Creation Tools

### Recommended Tools

**Vector Graphics (SVG)**:
- **Figma** (free, web-based)
- **Adobe Illustrator** (professional)
- **Inkscape** (free, open-source)
- **Affinity Designer** (one-time purchase)

**Animations (Lottie)**:
- **Adobe After Effects** + Bodymovin plugin
- **LottieFiles Creator** (web-based)
- **Haiku Animator**

**Icon Libraries** (for inspiration):
- **Material Icons** (Google)
- **Lucide Icons** (open-source)
- **Feather Icons** (minimalist)
- **Heroicons** (Tailwind)

### Export Settings

**SVG Icons**:
- Remove unnecessary groups
- Flatten transforms
- Decimal precision: 2
- Minify: Yes
- Remove metadata: Yes

**Lottie JSON**:
- Compress: Yes
- Remove hidden layers: Yes
- Optimize keyframes: Yes
- Target file size: < 50KB per animation

**PNG (App Icon)**:
- Format: PNG-24
- Compression: Medium
- Color profile: sRGB
- No transparency (iOS)

---

## Asset Checklist

### Phase 1: Essential Assets
- [ ] App icon (all sizes)
- [ ] Splash screen
- [ ] Chef hat icon (SVG)
- [ ] Bookmark icons (outline + filled)
- [ ] 8 food icons (pasta, salad, soup, pan, dessert, wrap, pizza, bowl)
- [ ] 1 loading animation (chef hat bounce)
- [ ] Empty cookbook illustration

### Phase 2: Enhanced Assets
- [ ] Additional food icons (10+ more)
- [ ] All UI icons (search, share, profile, settings)
- [ ] 2 more loading animations (stirring pot, ingredients combine)
- [ ] Cooking utensils pattern
- [ ] Welcome illustration

### Phase 3: Polish Assets
- [ ] Onboarding illustrations
- [ ] Achievement badges
- [ ] Category icons
- [ ] Seasonal variations
- [ ] Animated transitions

---

## Asset Optimization

### Performance Tips
1. **SVG Optimization**:
   - Use SVGO tool to minify
   - Remove unused elements
   - Simplify paths
   - Target: < 5KB per icon

2. **Lottie Optimization**:
   - Limit layers and effects
   - Use simple shapes
   - Reduce keyframes
   - Target: < 50KB per animation

3. **Caching**:
   - Preload frequently used assets
   - Cache SVGs in memory
   - Use `precacheImage()` for PNGs

4. **Lazy Loading**:
   - Load animations only when needed
   - Dispose when not visible
   - Use `AutomaticKeepAliveClientMixin` wisely

---

## Accessibility Considerations

### Icon Semantics
- All icons must have text labels or semantic descriptions
- Don't rely on color alone to convey meaning
- Provide alternative text for screen readers

### Animation Controls
- Allow users to disable animations (respect `reduce_motion`)
- Provide static fallbacks for animations
- Don't use flashing or strobing effects

### Size & Contrast
- Ensure icons are visible at minimum size (24x24px)
- Maintain 3:1 contrast ratio for UI icons
- Test with color blindness simulators

---

## Version Control

### Asset Versioning
- Use semantic versioning (v1.0, v1.1, v2.0)
- Document changes in CHANGELOG
- Keep previous versions for rollback

### File Naming Convention
```
{category}_{name}_{variant}_{version}.{ext}

Examples:
- icon_chef_hat_outline_v1.svg
- anim_loading_chef_bounce_v2.json
- illust_empty_cookbook_v1.svg
```

---

## Resources & References

### Free Icon Resources
- [Material Icons](https://fonts.google.com/icons)
- [Lucide Icons](https://lucide.dev/)
- [Feather Icons](https://feathericons.com/)
- [Heroicons](https://heroicons.com/)

### Lottie Resources
- [LottieFiles](https://lottiefiles.com/) - Free animations
- [Lottie Documentation](https://airbnb.io/lottie/)
- [Bodymovin Plugin](https://aescripts.com/bodymovin/)

### Design Inspiration
- [Dribbble](https://dribbble.com/) - Food app designs
- [Behance](https://www.behance.net/) - UI/UX projects
- [Mobbin](https://mobbin.com/) - Mobile app patterns

---

**Last Updated**: October 2025
**Version**: 1.0
