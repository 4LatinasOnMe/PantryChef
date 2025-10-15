# Getting Started with PantryChef

## Quick Start Guide

### Prerequisites
- Flutter SDK (3.9.2 or higher)
- Dart SDK
- Android Studio or VS Code with Flutter extensions
- iOS Simulator (Mac) or Android Emulator

---

## Installation Steps

### 1. Install Dependencies

Open your terminal in the project directory and run:

```bash
flutter pub get
```

This will install:
- `google_fonts` - For Poppins font family
- `shared_preferences` - For local data storage

### 2. Verify Installation

Check that everything is set up correctly:

```bash
flutter doctor
```

Ensure all checkmarks are green for your target platform.

### 3. Run the App

**For Android Emulator:**
```bash
flutter run
```

**For iOS Simulator (Mac only):**
```bash
flutter run -d ios
```

**For Chrome (Web):**
```bash
flutter run -d chrome
```

**For specific device:**
```bash
flutter devices  # List available devices
flutter run -d <device-id>
```

---

## First Time Usage

### Testing the App Flow

1. **Home Screen**
   - Enter ingredients: `chicken, tomatoes, pasta, garlic`
   - Select cuisine: Tap "Italian"
   - Select dietary: Tap "Vegetarian" (optional)
   - Select meal: Tap "Dinner"
   - Tap "Generate Recipe" 🔥

2. **Loading Screen**
   - Watch the chef animation
   - Read cooking tips (changes every 4 seconds)
   - Wait 3 seconds for recipe generation

3. **Recipe Display**
   - Read the generated recipe
   - Tap checkboxes to mark ingredients
   - Scroll through instructions
   - Tap bookmark icon to save

4. **Cookbook**
   - Tap cookbook icon in home screen
   - View your saved recipe
   - Tap card to view details
   - Long-press to delete

---

## Project Structure Overview

```
lib/
├── main.dart                    # App entry point
├── theme/
│   └── app_theme.dart          # Design system & theme
├── models/
│   └── recipe.dart             # Recipe data model
├── services/
│   ├── recipe_service.dart     # Recipe generation (mock)
│   └── storage_service.dart    # Local storage
└── screens/
    ├── home_screen.dart        # Ingredient input
    ├── loading_screen.dart     # Loading animation
    ├── recipe_screen.dart      # Recipe display
    └── cookbook_screen.dart    # Saved recipes
```

---

## Key Features to Test

### ✅ Home Screen
- [ ] Enter ingredients (comma-separated)
- [ ] Select cuisine type
- [ ] Select dietary needs (multiple)
- [ ] Select meal type
- [ ] Button disabled when input empty
- [ ] Button enabled when input provided
- [ ] Navigate to Cookbook

### ✅ Loading Screen
- [ ] Chef animation bounces
- [ ] Cooking tips rotate every 4 seconds
- [ ] Progress dots animate
- [ ] Transitions to recipe after 3 seconds

### ✅ Recipe Display
- [ ] Recipe title and description shown
- [ ] Prep time, cook time, servings displayed
- [ ] Tap ingredient checkboxes
- [ ] Checked items show strikethrough
- [ ] Numbered instruction steps
- [ ] Bookmark icon saves recipe
- [ ] Toast message on save
- [ ] Back button returns to home

### ✅ Cookbook
- [ ] Shows empty state when no recipes
- [ ] Displays saved recipes in grid
- [ ] Tap card to view recipe
- [ ] Long-press shows context menu
- [ ] Delete recipe with confirmation
- [ ] Recipe removed from grid

---

## Customization Guide

### Change Colors

Edit `lib/theme/app_theme.dart`:

```dart
class AppColors {
  static const Color accent = Color(0xFFFF7F6A); // Change this!
  // ... other colors
}
```

### Add More Cooking Tips

Edit `lib/screens/loading_screen.dart`:

```dart
final List<String> _cookingTips = [
  '💡 Your new tip here!',
  // ... add more tips
];
```

### Modify Cuisine Types

Edit `lib/screens/home_screen.dart`:

```dart
final List<String> _cuisineTypes = [
  'Italian',
  'Your New Cuisine', // Add here
  // ...
];
```

### Change Recipe Icons

Edit `lib/screens/cookbook_screen.dart`:

```dart
String _getRecipeIcon(Recipe recipe) {
  final cuisineIcons = {
    'Italian': '🍝',
    'YourCuisine': '🍜', // Add here
    // ...
  };
}
```

---

## Integrating Real AI API

### Replace Mock Service

Edit `lib/services/recipe_service.dart`:

```dart
Future<Recipe> generateRecipe({
  required List<String> ingredients,
  String? cuisineType,
  List<String>? dietaryNeeds,
  String? mealType,
}) async {
  // Replace this mock implementation with your AI API call
  
  // Example with HTTP:
  // final response = await http.post(
  //   Uri.parse('YOUR_API_ENDPOINT'),
  //   body: jsonEncode({
  //     'ingredients': ingredients,
  //     'cuisine': cuisineType,
  //     'dietary': dietaryNeeds,
  //     'meal': mealType,
  //   }),
  // );
  // 
  // final data = jsonDecode(response.body);
  // return Recipe.fromJson(data);
  
  // Current mock implementation...
}
```

### Add HTTP Package

Update `pubspec.yaml`:

```yaml
dependencies:
  http: ^1.1.0  # Add this
```

Then run:
```bash
flutter pub get
```

---

## Common Issues & Solutions

### Issue: Fonts not loading
**Solution**: Run `flutter clean` then `flutter pub get`

### Issue: App crashes on startup
**Solution**: Check Flutter version with `flutter --version`
Ensure you're using Flutter 3.9.2 or higher

### Issue: Hot reload not working
**Solution**: Stop the app and run `flutter run` again

### Issue: SharedPreferences not persisting
**Solution**: Check device storage permissions
On iOS: Ensure app has proper entitlements

### Issue: Slow performance
**Solution**: Run in release mode: `flutter run --release`

---

## Development Tips

### Hot Reload
Save your file or press `r` in terminal for hot reload
Press `R` for hot restart (clears state)

### Debug Mode
Run with debug flag:
```bash
flutter run --debug
```

### Release Mode (Faster)
```bash
flutter run --release
```

### View Logs
```bash
flutter logs
```

### Clear Data
To test empty states, clear app data:
- Android: Settings → Apps → PantryChef → Clear Data
- iOS: Uninstall and reinstall app

---

## Building for Production

### Android APK
```bash
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle (for Play Store)
```bash
flutter build appbundle --release
```
Output: `build/app/outputs/bundle/release/app-release.aab`

### iOS (Mac only)
```bash
flutter build ios --release
```
Then open Xcode and archive

---

## Testing Checklist

### Before Deployment
- [ ] Test on multiple screen sizes
- [ ] Test with long ingredient lists
- [ ] Test with very long recipe titles
- [ ] Test empty states
- [ ] Test with no internet (should still work)
- [ ] Test save/delete functionality
- [ ] Test navigation flow
- [ ] Check for memory leaks
- [ ] Verify animations are smooth
- [ ] Test on both Android and iOS

---

## Useful Commands

```bash
# Clean build files
flutter clean

# Get dependencies
flutter pub get

# Run app
flutter run

# Run on specific device
flutter run -d <device-id>

# Build release APK
flutter build apk --release

# Analyze code
flutter analyze

# Format code
flutter format lib/

# Check outdated packages
flutter pub outdated

# Upgrade packages
flutter pub upgrade
```

---

## Resources

### Documentation
- [Flutter Docs](https://docs.flutter.dev/)
- [Dart Docs](https://dart.dev/guides)
- [Material Design](https://m3.material.io/)

### Design Files
- `DESIGN_SYSTEM.md` - Complete design specifications
- `DESIGN_OVERVIEW.md` - Design summary
- `QUICK_REFERENCE.md` - Code snippets

### Implementation
- `IMPLEMENTATION_COMPLETE.md` - Feature checklist
- `SCREEN_*.md` - Individual screen specs

---

## Support

### Common Questions

**Q: How do I add more ingredients?**
A: Just type them separated by commas in the input field

**Q: Can I select multiple cuisines?**
A: Currently only one cuisine, but multiple dietary needs

**Q: Where are recipes stored?**
A: Locally on your device using SharedPreferences

**Q: Does this need internet?**
A: Only for Google Fonts download (first time). Recipe generation is currently mock (offline)

**Q: How do I reset the app?**
A: Clear app data from device settings

---

## Next Steps

1. ✅ Run the app and test all features
2. ⏳ Integrate real AI API for recipe generation
3. ⏳ Add custom icons and illustrations
4. ⏳ Implement search functionality
5. ⏳ Add recipe photos
6. ⏳ Implement share feature
7. ⏳ Add more advanced features
8. ⏳ Prepare for app store submission

---

## Contributing

When making changes:
1. Follow the existing code style
2. Use the design system constants
3. Test on multiple devices
4. Update documentation if needed
5. Keep the design consistent

---

**Happy Cooking! 🍳👨‍🍳**

For questions or issues, refer to the documentation files or Flutter's official resources.
