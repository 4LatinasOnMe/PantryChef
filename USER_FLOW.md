# PantryChef User Flow

## Overview
This document outlines the complete user journey through the PantryChef app, from initial launch to saving and revisiting recipes.

---

## Primary User Flow

```
┌─────────────────┐
│   App Launch    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Home Screen    │ ◄──────────────┐
│  (Input)        │                │
└────────┬────────┘                │
         │                         │
         │ User enters             │
         │ ingredients &           │
         │ preferences             │
         │                         │
         ▼                         │
┌─────────────────┐                │
│ Tap "Generate   │                │
│ Recipe" Button  │                │
└────────┬────────┘                │
         │                         │
         ▼                         │
┌─────────────────┐                │
│ Loading Screen  │                │
│ (Animation +    │                │
│  Cooking Tips)  │                │
└────────┬────────┘                │
         │                         │
         │ AI generates            │
         │ recipe (2-10s)          │
         │                         │
         ▼                         │
┌─────────────────┐                │
│ Recipe Display  │                │
│ Screen          │                │
└────────┬────────┘                │
         │                         │
         ├─────────────────┐       │
         │                 │       │
         ▼                 ▼       │
┌─────────────┐   ┌─────────────┐ │
│ Tap Back    │   │ Tap Save    │ │
│ Button      │   │ (Bookmark)  │ │
└──────┬──────┘   └──────┬──────┘ │
       │                 │         │
       │                 ▼         │
       │         ┌─────────────┐   │
       │         │ Recipe      │   │
       │         │ Saved to    │   │
       │         │ Cookbook    │   │
       │         └──────┬──────┘   │
       │                │         │
       └────────────────┴─────────┘
```

---

## Detailed Flow Steps

### 1. App Launch
**Entry Point**: User opens PantryChef app

**Actions**:
- App loads with splash screen (optional, 1-2s)
- Theme and fonts initialize
- Local storage checked for saved recipes
- Navigate to Home Screen

**Duration**: < 2 seconds

---

### 2. Home / Input Screen
**Purpose**: Collect user input for recipe generation

**User Actions**:
1. **View welcome message** and understand app purpose
2. **Enter ingredients** in multi-line text field
   - Type or paste ingredients
   - Separate with commas
   - See helper text below field
3. **Select cuisine type** (optional)
   - Tap chips to select/deselect
   - Multiple selections allowed
   - Visual feedback on selection
4. **Select dietary needs** (optional)
   - Tap chips for dietary restrictions
   - Multiple selections allowed
5. **Select meal type** (optional)
   - Choose breakfast, lunch, dinner, etc.
   - Single or multiple selection
6. **Tap "Generate Recipe" button**
   - Button disabled until ingredients entered
   - Button press animation
   - Transition to Loading Screen

**Validation**:
- Minimum: At least one ingredient required
- Button enabled only when valid input exists

**Edge Cases**:
- Empty input: Button remains disabled
- Very long ingredient list: Text field scrolls
- No preferences selected: App generates general recipe

---

### 3. Loading Screen
**Purpose**: Provide engaging feedback while AI processes request

**User Experience**:
1. **See animated illustration**
   - Chef's hat bouncing
   - Or stirring pot
   - Or combining ingredients
2. **Read status message**
   - "Creating your recipe..."
3. **View rotating cooking tips**
   - New tip every 4 seconds
   - Educational and entertaining
4. **Watch progress indicator**
   - Animated dots showing activity

**Duration**: 
- Typical: 2-10 seconds
- Minimum display: 2 seconds (even if faster)
- Maximum: 30 seconds (then show error)

**Error Handling**:
- If timeout (30s): Show error message
- Display "Try Again" button
- Allow user to return to Home Screen

**Transitions**:
- Entry: Fade in + scale up (300ms)
- Exit: Fade out + scale up (300ms)
- Next: Slide up to Recipe Display

---

### 4. Recipe Display Screen
**Purpose**: Present generated recipe for cooking

**User Actions**:

**Viewing Recipe**:
1. **Read recipe title and description**
2. **Check prep/cook time and servings**
3. **Review ingredients list**
   - Scroll through all ingredients
   - Tap checkboxes to mark gathered items
   - Checked items get strikethrough
4. **Follow cooking instructions**
   - Read numbered steps
   - Scroll through instructions
   - Follow step-by-step

**Interacting with Recipe**:
1. **Save recipe** (tap bookmark icon)
   - Icon fills with accent color
   - Haptic feedback
   - Toast message: "Recipe saved!"
   - Recipe added to Cookbook
2. **Unsave recipe** (tap filled bookmark)
   - Icon becomes outline
   - Toast message: "Recipe removed"
   - Recipe removed from Cookbook
3. **Share recipe** (tap share icon, optional)
   - Opens system share sheet
   - Share as text or link
4. **Adjust servings** (optional feature)
   - Tap +/- buttons
   - Ingredients recalculate automatically
5. **Start timer** (optional feature)
   - Tap timer button on time-related steps
   - Launch system or in-app timer

**Navigation**:
1. **Return to Home** (tap back button)
   - Slide down transition
   - Return to input screen
   - Previous inputs may be cleared or saved
2. **View saved recipes** (navigate to Cookbook)
   - Via bottom navigation or menu

**Persistence**:
- Checkbox states saved locally
- Bookmark status saved to storage
- Recipe data cached for offline viewing

---

### 5. My Cookbook Screen
**Purpose**: Access and manage saved recipes

**Initial State - Empty**:
1. **See empty state illustration**
2. **Read encouraging message**
   - "Your cookbook is empty"
   - "Start by generating a recipe..."
3. **Tap "Generate Recipe" button**
   - Navigate to Home Screen
   - Begin new recipe generation

**With Saved Recipes**:
1. **View recipe grid**
   - 2 columns of recipe cards
   - Scroll vertically
   - See recipe titles and icons
2. **Tap recipe card**
   - Navigate to Recipe Display
   - View full recipe details
   - All previous interactions available
3. **Long press recipe card**
   - Context menu appears
   - Options: Share, Delete
4. **Delete recipe**
   - Confirmation dialog appears
   - Confirm or cancel
   - Card animates out if confirmed
   - Toast: "Recipe deleted"
5. **Search recipes** (optional)
   - Tap search icon in app bar
   - Search bar expands
   - Type to filter recipes
   - Results update in real-time

**Navigation**:
- Access via bottom navigation
- Or via menu from other screens

---

## Alternative Flows

### Flow A: Quick Recipe Generation
**Scenario**: User wants a recipe fast, minimal preferences

1. Home Screen → Enter ingredients only
2. Tap Generate (skip all preferences)
3. Loading Screen → Recipe Display
4. Cook immediately without saving

**Duration**: < 30 seconds from launch to recipe

---

### Flow B: Curated Recipe Collection
**Scenario**: User builds a personal cookbook over time

1. Generate and save Recipe 1
2. Return to Home → Generate Recipe 2
3. Save Recipe 2 to Cookbook
4. Repeat for multiple recipes
5. Browse Cookbook → Select saved recipe
6. Cook from saved recipe

**Result**: Growing collection of favorite recipes

---

### Flow C: Recipe Refinement
**Scenario**: User wants to try variations

1. Generate recipe with Italian cuisine
2. Don't save, go back to Home
3. Change to Asian cuisine, same ingredients
4. Generate new recipe
5. Compare and save preferred version

**Benefit**: Explore different cooking styles

---

## Navigation Structure

```
Home Screen (Input)
    ↓ Generate
Loading Screen
    ↓ Complete
Recipe Display
    ↓ Save
My Cookbook
    ↓ Select Recipe
Recipe Display (Saved)
```

**Bottom Navigation** (Optional):
- Home (🏠)
- Cookbook (📖)
- Settings (⚙️)

**Always Available**:
- Back button (top left)
- Menu/Settings (top right)

---

## Key Interactions Summary

### Gestures
- **Tap**: Select chips, buttons, cards, checkboxes
- **Long Press**: Context menu on recipe cards
- **Scroll**: Vertical scrolling on all screens
- **Pull to Refresh**: Refresh cookbook (optional)

### Animations
- **Button Press**: Scale 0.98 + shadow reduction
- **Chip Selection**: Ripple + color change + scale
- **Screen Transition**: Slide or fade (300ms)
- **Loading**: Continuous animation loop
- **Card Interaction**: Elevation change + scale

### Feedback
- **Visual**: Color changes, animations, shadows
- **Haptic**: Button presses, saves, long press
- **Audio**: Optional success sounds
- **Toast Messages**: Confirmations and errors

---

## Error Handling

### No Internet Connection
- **Detection**: Before API call
- **Message**: "No internet connection"
- **Action**: "Retry" button or "Go Offline"
- **Offline Mode**: View saved recipes only

### API Error
- **Detection**: Failed API response
- **Message**: "Something went wrong"
- **Action**: "Try Again" button
- **Fallback**: Return to Home Screen

### Invalid Input
- **Detection**: Client-side validation
- **Message**: Inline error below input field
- **Prevention**: Button disabled until valid

### Timeout
- **Detection**: 30 seconds on Loading Screen
- **Message**: "This is taking longer than expected"
- **Action**: "Try Again" or "Cancel"

---

## Onboarding Flow (Optional)

### First Launch
1. **Welcome Screen**
   - App logo and tagline
   - "Get Started" button
2. **Feature Highlights** (3 slides)
   - Slide 1: "Enter Your Ingredients"
   - Slide 2: "Get AI-Powered Recipes"
   - Slide 3: "Save Your Favorites"
3. **Permission Requests** (if needed)
   - Notifications (optional)
   - Storage access
4. **Navigate to Home Screen**

**Skip Option**: "Skip" button on each slide

---

## Accessibility Considerations

### Screen Reader Support
- All buttons have semantic labels
- Images have alt text
- Headings properly structured
- Form fields labeled

### Keyboard Navigation
- Tab order logical
- Focus indicators visible
- All actions keyboard-accessible

### Visual Accessibility
- High contrast ratios (WCAG AAA)
- Large touch targets (48px minimum)
- Scalable text (up to 200%)
- Color not sole indicator

### Motor Accessibility
- Large tap targets
- No time-based interactions
- Undo options for destructive actions

---

## Performance Considerations

### Load Times
- Home Screen: < 1 second
- Recipe Generation: 2-10 seconds typical
- Screen Transitions: 300ms
- Image Loading: Progressive (if images added)

### Offline Capability
- Saved recipes available offline
- Cached recipe data
- Queue recipe generation when online

### Data Usage
- Minimal API calls
- Efficient JSON responses
- Optional image compression
- Local storage for persistence

---

## Future Enhancements

### Potential Features
1. **Recipe History**: View previously generated recipes
2. **Favorites**: Star system for top recipes
3. **Shopping List**: Auto-generate from ingredients
4. **Meal Planning**: Schedule recipes for the week
5. **Nutritional Info**: Calories, macros per serving
6. **Recipe Notes**: Add personal modifications
7. **Photo Upload**: Add photos of finished dishes
8. **Social Sharing**: Share to social media
9. **Recipe Collections**: Organize by tags/categories
10. **Voice Input**: Speak ingredients instead of typing

---

**Last Updated**: October 2025
**Version**: 1.0
