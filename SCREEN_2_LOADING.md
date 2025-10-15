# Screen 2: Loading Screen

## Purpose
A delightful full-screen overlay that appears while the AI generates a recipe, featuring engaging animation and rotating cooking tips.

## Visual Mockup

```
┌─────────────────────────────────────┐
│                                     │
│                                     │
│                                     │
│         ┌─────────────┐             │
│         │             │             │
│         │  Animated   │             │
│         │   Chef's    │             │
│         │    Hat      │             │
│         │   (Bouncing)│             │
│         │             │             │
│         └─────────────┘             │
│                                     │
│      Creating your recipe...        │
│                                     │
│  ┌───────────────────────────────┐ │
│  │ 💡 Tip: Season your pasta     │ │
│  │    water generously—it        │ │
│  │    should taste like the sea! │ │
│  └───────────────────────────────┘ │
│                                     │
│         ●●●○○                       │
│                                     │
│                                     │
└─────────────────────────────────────┘
```

## Specifications

### Overlay
- **Background**: #F8F8F8 at 98% opacity
- **Backdrop Blur**: 10px (if supported)
- **Coverage**: Full screen including status bar

### Animation Container
- **Position**: Centered vertically and horizontally
- **Size**: 200x200px
- **Margin Bottom**: 40px

### Animation Options

**Option 1: Animated Chef's Hat**
- Lottie or SVG animation
- Color: #FF7F6A (Accent)
- Bounces up/down (2s loop)
- Subtle rotation ±5° (3s loop)
- Steam lines rise from top (1.5s loop)

**Option 2: Stirring Pot**
- Pot with spoon stirring
- Spoon circles (2s loop)
- Steam bubbles rise (1s loop)
- Pot wobbles (3s loop)

**Option 3: Cooking Ingredients**
- Ingredients float in from sides
- Combine in center with sparkle
- Continuous loop

### Status Text
- **Text**: "Creating your recipe..."
- **Font**: Poppins Medium, 18px, #2C2C2C
- **Position**: Below animation, centered
- **Animation**: Subtle fade in/out (2s loop)

### Tip Card
- **Width**: 90% of screen (max 400px)
- **Background**: #FFFFFF
- **Border Radius**: 16px
- **Padding**: 20px
- **Shadow**: 0px 4px 16px rgba(0,0,0,0.08)
- **Icon**: 💡 (24x24px) on left
- **Text**: Poppins Regular, 14px, #2C2C2C, line height 20px
- **Transition**: Fade out/in (500ms) every 4 seconds

### Progress Dots
- **Count**: 5 dots
- **Size**: 8px diameter
- **Spacing**: 12px between centers
- **Inactive**: #E0E0E0
- **Active**: #FF7F6A
- **Animation**: Fill sequentially left to right (500ms each), loop

## Cooking Tips (Rotate Every 4s)

1. "💡 Season your pasta water generously—it should taste like the sea!"
2. "💡 Let meat rest after cooking to keep it juicy and tender."
3. "💡 Add a pinch of salt to bring out the sweetness in desserts."
4. "💡 Room temperature ingredients mix better in baking recipes."
5. "💡 Taste as you cook! Adjust seasoning throughout the process."
6. "💡 A sharp knife is safer than a dull one—and makes prep easier."
7. "💡 Don't overcrowd the pan—give ingredients space to brown properly."
8. "💡 Fresh herbs at the end, dried herbs at the beginning."
9. "💡 Save pasta water—it's liquid gold for finishing sauces!"
10. "💡 Preheat your pan before adding oil for better results."
11. "💡 Acid (lemon, vinegar) brightens flavors—add a splash at the end!"
12. "💡 Let baked goods cool completely before cutting for clean slices."

## Timing
- **Minimum Display**: 2 seconds
- **Maximum Display**: 30 seconds (then show error)
- **Tip Rotation**: Every 4 seconds
- **Animation**: Continuous loop

## Transitions
- **Entry**: Fade in (300ms) + scale 0.95→1.0
- **Exit**: Fade out (300ms) + scale 1.0→1.05
- **Next Screen**: Slide up to Recipe Display

## Error State (After 30s)
- Animation pauses
- Status: "This is taking longer than expected..."
- Button: "Try Again" (secondary style)
