# Screen 4: My Cookbook Screen

## Purpose
Display the user's saved recipe collection in an organized, visually appealing format with an encouraging empty state.

## Visual Mockup (With Recipes)

```
┌─────────────────────────────────────┐
│  My Cookbook                  [🔍]  │
├─────────────────────────────────────┤
│                                     │
│  ┌──────────┐  ┌──────────┐        │
│  │          │  │          │        │
│  │    🍝    │  │    🥗    │        │
│  │          │  │          │        │
│  │ Creamy   │  │ Caesar   │        │
│  │ Chicken  │  │ Salad    │        │
│  │ Pasta    │  │          │        │
│  │          │  │          │        │
│  │ 30 min   │  │ 15 min   │        │
│  │ 4 servs  │  │ 2 servs  │        │
│  └──────────┘  └──────────┘        │
│                                     │
│  ┌──────────┐  ┌──────────┐        │
│  │          │  │          │        │
│  │    🍲    │  │    🥘    │        │
│  │          │  │          │        │
│  │ Tomato   │  │ Stir Fry │        │
│  │ Soup     │  │ Veggies  │        │
│  │          │  │          │        │
│  │          │  │          │        │
│  │ 45 min   │  │ 20 min   │        │
│  │ 6 servs  │  │ 3 servs  │        │
│  └──────────┘  └──────────┘        │
│                                     │
└─────────────────────────────────────┘
```

## Visual Mockup (Empty State)

```
┌─────────────────────────────────────┐
│  My Cookbook                        │
├─────────────────────────────────────┤
│                                     │
│                                     │
│                                     │
│         ┌─────────────┐             │
│         │             │             │
│         │  📖         │             │
│         │  Cookbook   │             │
│         │  Icon       │             │
│         │             │             │
│         └─────────────┘             │
│                                     │
│    Your cookbook is empty           │
│                                     │
│    Start by generating a recipe     │
│    and saving your favorites!       │
│                                     │
│    ┌───────────────────────┐       │
│    │  Generate Recipe  🔥  │       │
│    └───────────────────────┘       │
│                                     │
│                                     │
└─────────────────────────────────────┘
```

## Specifications

### App Bar
- **Height**: 56px
- **Background**: #FFFFFF
- **Border Bottom**: 1px solid #E0E0E0
- **Left**: "My Cookbook" (Poppins SemiBold, 20px, #2C2C2C)
- **Right**: Search icon (24x24px, #6B6B6B)
- **Padding**: 20px horizontal

### Recipe Grid (With Content)

**Layout**:
- **Columns**: 2
- **Gap**: 16px (horizontal and vertical)
- **Padding**: 20px horizontal, 16px vertical
- **Scroll**: Vertical

**Recipe Card**:
- **Aspect Ratio**: 3:4 (portrait)
- **Background**: #FFFFFF
- **Border Radius**: 20px
- **Shadow**: 0px 4px 12px rgba(0,0,0,0.08)
- **Padding**: 16px
- **Tap**: Navigate to Recipe Display
- **Long Press**: Context menu (Delete, Share)
- **Hover**: Shadow increases to 0px 6px 16px rgba(0,0,0,0.12)

**Card Content**:

1. **Icon/Illustration**:
   - Position: Top center
   - Size: 64x64px
   - Margin: 16px top, 16px bottom
   - Color: #FF7F6A or #6B6B6B
   - Style: Abstract line art
   - Examples: 🍝 🥗 🍲 🥘 🍰 🥙

2. **Recipe Title**:
   - Poppins SemiBold, 16px, #2C2C2C
   - Line height: 22px
   - Max lines: 2 (ellipsis)
   - Alignment: Center
   - Margin bottom: 8px

3. **Meta Info**:
   - Poppins Regular, 12px, #9E9E9E
   - Alignment: Center
   - Format: "30 min • 4 servings"
   - Icons: Clock and person (14x14px)

4. **Bookmark Badge**:
   - Position: Top right corner (absolute)
   - Icon: Filled bookmark (16x16px, #FF7F6A)
   - Background: White circle (28x28px)
   - Shadow: 0px 2px 4px rgba(0,0,0,0.1)

**Card States**:
- **Press**: Scale 0.98, shadow increases
- **Transition**: 200ms

### Empty State

**Container**:
- **Position**: Centered vertically and horizontally
- **Padding**: 40px horizontal
- **Max Width**: 400px

**Illustration**:
- **Size**: 120x120px
- **Style**: Minimalist cookbook icon or chef's hat
- **Color**: #E0E0E0 (light gray)
- **Margin Bottom**: 32px

**Heading**:
- **Text**: "Your cookbook is empty"
- **Font**: Poppins SemiBold, 22px, #2C2C2C
- **Alignment**: Center
- **Margin Bottom**: 16px

**Description**:
- **Text**: "Start by generating a recipe and saving your favorites!"
- **Font**: Poppins Regular, 16px, #6B6B6B
- **Line Height**: 24px
- **Alignment**: Center
- **Margin Bottom**: 32px

**CTA Button**:
- **Width**: 100% (max 300px)
- **Height**: 56px
- **Background**: #FF7F6A
- **Border Radius**: 16px
- **Text**: "Generate Recipe" (Poppins SemiBold, 16px, White)
- **Icon**: Fire emoji 🔥 (20x20px)
- **Shadow**: 0px 4px 12px rgba(255, 127, 106, 0.3)
- **Action**: Navigate to Home screen

## Search Functionality (Optional)

### Search Bar (When Search Icon Tapped)
- **Expands**: App bar transforms to search input
- **Background**: #F8F8F8
- **Border Radius**: 12px
- **Height**: 40px
- **Placeholder**: "Search recipes..."
- **Icon**: Search icon left, close icon right
- **Animation**: Slide in from right (300ms)

### Search Results
- **Filter**: Real-time filtering of recipe cards
- **No Results**: 
  - Message: "No recipes found"
  - Suggestion: "Try a different search term"

## Context Menu (Long Press)

**Menu Items**:
1. **Share Recipe**: Share icon + "Share"
2. **Delete Recipe**: Trash icon + "Delete" (red text)

**Style**:
- Background: #FFFFFF
- Border Radius: 12px
- Shadow: 0px 8px 24px rgba(0,0,0,0.15)
- Item Height: 48px
- Item Font: Poppins Medium, 15px

## Interactions

### Card Tap
- **Ripple**: Material ripple effect
- **Navigation**: Slide transition to Recipe Display
- **Duration**: 300ms

### Card Long Press
- **Haptic**: Medium impact feedback
- **Menu**: Fade in (200ms)
- **Backdrop**: Semi-transparent overlay

### Delete Action
- **Confirmation**: Alert dialog
  - Title: "Delete Recipe?"
  - Message: "This action cannot be undone."
  - Actions: "Cancel" (text) / "Delete" (red, filled)
- **Animation**: Card fades out + slides left (300ms)
- **Feedback**: Toast "Recipe deleted"

### Pull to Refresh (Optional)
- **Gesture**: Pull down from top
- **Indicator**: Circular progress (Accent color)
- **Action**: Refresh recipe list from storage

## Sorting & Filtering (Future Enhancement)

**Sort Options**:
- Recently Added (default)
- Alphabetical (A-Z)
- Cook Time (shortest first)
- Cuisine Type

**Filter Options**:
- By Cuisine
- By Dietary Needs
- By Meal Type

**UI**: 
- Filter/Sort button in app bar
- Bottom sheet with options
