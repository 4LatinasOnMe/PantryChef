# Screen 1: Home / Input Screen

## Purpose
The welcoming entry point where users input their available ingredients and preferences to generate AI-powered recipes.

## Visual Mockup

```
┌─────────────────────────────────────┐
│  🍳 PantryChef              [👤]    │
├─────────────────────────────────────┤
│                                     │
│  What's in your pantry?             │
│  Tell me what you have, and I'll    │
│  create something delicious!        │
│                                     │
│  ┌───────────────────────────────┐ │
│  │ e.g., chicken breast,         │ │
│  │ tomatoes, pasta, garlic,      │ │
│  │ olive oil...                  │ │
│  │                               │ │
│  └───────────────────────────────┘ │
│  Separate ingredients with commas   │
│                                     │
│  Cuisine Type                       │
│  ● Italian    ○ Asian               │
│  ○ Mexican    ○ American            │
│  ○ Mediterranean ○ Indian           │
│                                     │
│  Dietary Needs                      │
│  ○ Vegan      ● Vegetarian          │
│  ○ Gluten-Free ○ Dairy-Free         │
│  ○ Low-Carb   ○ Keto                │
│                                     │
│  Meal Type                          │
│  ○ Breakfast  ○ Lunch               │
│  ● Dinner     ○ Snack               │
│                                     │
│  ┌───────────────────────────────┐ │
│  │    Generate Recipe  🔥        │ │
│  └───────────────────────────────┘ │
│                                     │
└─────────────────────────────────────┘
```

## Specifications

### App Bar
- **Height**: 56px
- **Background**: #FFFFFF
- **Border Bottom**: 1px solid #E0E0E0
- **Left**: Chef hat icon + "PantryChef" (Poppins SemiBold, 20px, #2C2C2C)
- **Right**: Profile icon (24x24px, #6B6B6B)

### Welcome Header
- **Padding**: 32px top, 20px horizontal
- **Title**: "What's in your pantry?"
  - Poppins SemiBold, 28px, #2C2C2C
- **Subtitle**: "Tell me what you have, and I'll create something delicious!"
  - Poppins Regular, 16px, #6B6B6B
  - Margin Top: 8px

### Ingredient Input
- **Margin Top**: 24px
- **Background**: #FFFFFF
- **Border**: 2px solid #E0E0E0
- **Border Radius**: 16px
- **Min Height**: 140px
- **Padding**: 16px
- **Placeholder**: "e.g., chicken breast, tomatoes, pasta, garlic, olive oil..."
  - Color: #9E9E9E, Poppins Regular, 16px
- **Focus**: Border changes to #FF7F6A
- **Helper Text**: "Separate ingredients with commas" (12px, #9E9E9E)

### Chip Groups

**Section Headers**:
- Poppins SemiBold, 18px, #2C2C2C
- Margin Top: 32px, Margin Bottom: 12px

**Cuisine Type**: Italian, Asian, Mexican, American, Mediterranean, Indian, French, Thai

**Dietary Needs**: Vegan, Vegetarian, Gluten-Free, Dairy-Free, Low-Carb, Keto, Paleo, Nut-Free

**Meal Type**: Breakfast, Lunch, Dinner, Snack, Dessert, Appetizer

**Chip Styles**:
- **Unselected**: White background, 1.5px #E0E0E0 border, #2C2C2C text
- **Selected**: #FF7F6A background, white text, checkmark icon
- **Size**: 40px height, 20px border radius, 16px horizontal padding
- **Font**: Poppins Medium, 14px
- **Layout**: 2 columns, 12px gap

### Generate Button
- **Width**: Full width (minus 20px padding)
- **Height**: 56px
- **Background**: #FF7F6A
- **Border Radius**: 16px
- **Text**: "Generate Recipe" (Poppins SemiBold, 16px, White)
- **Icon**: Fire emoji 🔥 (20x20px)
- **Shadow**: 0px 4px 12px rgba(255, 127, 106, 0.3)
- **Pressed**: Background #E65A45, scale 0.98
- **Disabled**: Background #E0E0E0, text #9E9E9E (when no ingredients)

## Interactions
- **Chip tap**: Ripple effect + scale animation (150ms)
- **Input focus**: Border color transition (300ms)
- **Button press**: Scale + shadow reduction
- **Scroll**: Smooth with momentum

## Accessibility
- Input field labeled "Available Ingredients"
- Chips have checkbox role, announce state changes
- Minimum touch targets: 48px
- Button announces "Generate Recipe"
