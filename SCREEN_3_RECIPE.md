# Screen 3: Recipe Display Screen

## Purpose
Present the AI-generated recipe with maximum readability and usability for hands-on cooking.

## Visual Mockup

```
┌─────────────────────────────────────┐
│  [← Back]  Recipe         [🔖]     │
├─────────────────────────────────────┤
│                                     │
│  Creamy Chicken Pasta               │
│                                     │
│  A delicious Italian-inspired dish  │
│  with tender chicken and tomatoes   │
│                                     │
│  ┌────┐  ┌────┐  ┌────┐            │
│  │⏱️15│  │🍳30│  │👥 4│            │
│  │min │  │min │  │serv│            │
│  └────┘  └────┘  └────┘            │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  Ingredients                        │
│  ☑ 2 cups pasta                     │
│  ☐ 1 lb chicken breast              │
│  ☐ 3 tomatoes, diced                │
│  ☐ 2 cloves garlic, minced          │
│  ☐ 2 tbsp olive oil                 │
│  ☐ 1 tsp dried oregano              │
│  ☐ Salt and pepper to taste         │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  Instructions                       │
│  ① Bring a large pot of salted      │
│     water to a boil. Add pasta...   │
│                                     │
│  ② Heat olive oil in a large        │
│     skillet over medium-high...     │
│                                     │
│  ③ Cook chicken for 5-6 minutes,    │
│     stirring occasionally...        │
│                                     │
└─────────────────────────────────────┘
```

## Specifications

### App Bar
- **Height**: 56px
- **Background**: #FFFFFF
- **Border Bottom**: 1px solid #E0E0E0
- **Left**: Back button (← icon, 24x24px, #2C2C2C)
- **Center**: "Recipe" (Poppins Medium, 16px, #2C2C2C)
- **Right**: Bookmark button (24x24px)
  - Unfilled: `bookmark_border` (#6B6B6B)
  - Filled: `bookmark` (#FF7F6A)

### Recipe Header
- **Padding**: 24px horizontal, 24px top
- **Background**: #FFFFFF

**Title**:
- Poppins SemiBold, 26px, #2C2C2C
- Letter spacing: -0.5px
- Line height: 34px
- Margin bottom: 12px

**Description**:
- Poppins Regular, 15px, #6B6B6B
- Line height: 22px
- Margin bottom: 20px
- Max 3 lines (expandable with "Read more")

### Info Cards
- **Layout**: 3 cards, equal width, 12px gap
- **Background**: #F8F8F8
- **Border Radius**: 12px
- **Padding**: 12px vertical, 8px horizontal
- **Alignment**: Center

**Card Content**:
- **Icon**: 20x20px, #FF7F6A, top
- **Label**: Poppins Regular, 11px, #9E9E9E (e.g., "PREP")
- **Value**: Poppins SemiBold, 16px, #2C2C2C (e.g., "15 min")

**Types**:
1. Prep Time: ⏱️ "PREP" "15 min"
2. Cook Time: 🍳 "COOK" "30 min"
3. Servings: 👥 "SERVES" "4"

### Divider
- **Height**: 1px
- **Color**: #E0E0E0
- **Margin**: 24px vertical

### Ingredients Section
- **Header**: "Ingredients" (Poppins SemiBold, 22px, #2C2C2C)
- **Margin Bottom**: 16px

**Ingredient Item**:
- **Layout**: Horizontal row, 12px gap between items
- **Padding**: 12px vertical
- **Tap Area**: Full width

**Checkbox**:
- **Size**: 24x24px
- **Unchecked**: 2px #E0E0E0 border, 6px radius, white background
- **Checked**: #4CAF50 background, white checkmark (16x16px)
- **Animation**: Scale + color (200ms)

**Text**:
- Poppins Regular, 15px, #2C2C2C
- Line height: 22px
- Margin left: 12px from checkbox
- **Checked State**: #9E9E9E color, line-through

### Instructions Section
- **Header**: "Instructions" (Poppins SemiBold, 22px, #2C2C2C)
- **Margin Bottom**: 16px
- **Gap**: 20px between steps

**Step Item**:
- **Layout**: Horizontal row

**Step Number**:
- **Size**: 32x32px circle
- **Background**: #FF7F6A
- **Text**: White, Poppins SemiBold, 16px, centered

**Step Text**:
- Poppins Regular, 15px, #2C2C2C
- Line height: 24px
- Margin left: 16px from number
- Flex: 1 (takes remaining width)

## Interactions

### Checkbox
- **Tap**: Toggle state with ripple + scale
- **Persistence**: Save to local storage
- **Reset**: Menu option to reset all

### Bookmark
- **Tap**: Save/unsave recipe
- **Animation**: Scale + color + haptic
- **Feedback**: Toast "Recipe saved!" or "Recipe removed"

### Scroll
- **App Bar**: Fixed at top
- **Content**: Smooth scrolling
- **Indicator**: System default

## Optional Features

### Share Button
- Position: App bar right (next to bookmark)
- Icon: Share (24x24px, #6B6B6B)
- Action: System share sheet

### Adjust Servings
- Position: Below servings card
- UI: +/- buttons
- Behavior: Recalculate ingredients

### Timer Integration
- Position: Inline with time steps
- UI: "Start Timer" button
- Action: Launch timer
