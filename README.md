# PantryChef 🍳

An AI-powered mobile cooking companion that transforms your available ingredients into delicious, personalized recipes.

## Overview

PantryChef helps you discover what to cook based on what you already have. Simply enter your ingredients, select your preferences, and let AI generate creative recipes tailored to your pantry.

## Features

- 🥘 **Smart Recipe Generation**: AI-powered recipes from your ingredients
- 🎨 **Beautiful UI**: Clean, minimalist design with warm, appetizing aesthetics
- 📖 **Personal Cookbook**: Save and organize your favorite recipes
- ✅ **Interactive Cooking**: Check off ingredients and follow step-by-step instructions
- 🔥 **Delightful Experience**: Engaging animations and cooking tips while you wait

## Design Documentation

Complete UI/UX design specifications are available in the following files:

- **[DESIGN_OVERVIEW.md](DESIGN_OVERVIEW.md)** - Executive summary of all design concepts
- **[DESIGN_SYSTEM.md](DESIGN_SYSTEM.md)** - Complete design system (colors, typography, components)
- **[SCREEN_1_HOME.md](SCREEN_1_HOME.md)** - Home/Input screen specifications
- **[SCREEN_2_LOADING.md](SCREEN_2_LOADING.md)** - Loading screen with animations
- **[SCREEN_3_RECIPE.md](SCREEN_3_RECIPE.md)** - Recipe display screen
- **[SCREEN_4_COOKBOOK.md](SCREEN_4_COOKBOOK.md)** - Cookbook collection screen
- **[USER_FLOW.md](USER_FLOW.md)** - Complete user journey documentation
- **[ASSETS_GUIDE.md](ASSETS_GUIDE.md)** - Visual assets and implementation guide

## Design Highlights

### Color Palette
- **Background**: #F8F8F8 (Off-White)
- **Accent**: #FF7F6A (Soft Coral)
- **Text**: #2C2C2C (Charcoal)
- **Success**: #4CAF50 (Fresh Green)

### Typography
- **Font**: Poppins (Google Fonts)
- **Weights**: 300, 400, 500, 600, 700
- **Clean hierarchy** for maximum readability

### Key Screens
1. **Home Screen**: Ingredient input with cuisine and dietary preference chips
2. **Loading Screen**: Delightful animations with rotating cooking tips
3. **Recipe Display**: Kitchen-ready layout with checkable ingredients
4. **Cookbook**: Personal collection with beautiful recipe cards

## Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd PantryChef
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Required Packages

Add these to `pubspec.yaml`:
```yaml
dependencies:
  flutter:
    sdk: flutter
  google_fonts: ^6.1.0        # Poppins font
  flutter_svg: ^2.0.9         # SVG illustrations
  lottie: ^3.0.0              # Loading animations
  shared_preferences: ^2.2.2  # Local storage
```

## Project Structure

```
lib/
├── main.dart
├── screens/
│   ├── home_screen.dart
│   ├── loading_screen.dart
│   ├── recipe_screen.dart
│   └── cookbook_screen.dart
├── widgets/
│   ├── ingredient_input.dart
│   ├── preference_chips.dart
│   ├── recipe_card.dart
│   └── loading_animation.dart
├── models/
│   ├── recipe.dart
│   └── ingredient.dart
├── services/
│   ├── ai_service.dart
│   └── storage_service.dart
└── theme/
    └── app_theme.dart

assets/
├── icons/
├── animations/
└── illustrations/
```

## Development Roadmap

### Phase 1: Design & Planning ✅
- [x] Design system definition
- [x] Screen mockups and specifications
- [x] User flow documentation
- [x] Asset requirements

### Phase 2: Core Implementation ✅
- [x] Set up project structure
- [x] Implement theme and design system
- [x] Build Home/Input screen
- [x] Build Loading screen with animations
- [x] Build Recipe Display screen
- [x] Build Cookbook screen

### Phase 3: Features & Integration ✅ (Partial)
- [x] Mock recipe generation service (ready for AI API)
- [x] Implement local storage for saved recipes
- [x] Add ingredient checkbox persistence
- [ ] Integrate real AI API for recipe generation
- [ ] Implement search functionality
- [ ] Add share functionality

### Phase 4: Polish & Testing ✅ (Partial)
- [x] Animations and transitions
- [x] Accessibility improvements
- [x] Performance optimization
- [ ] User testing and feedback
- [ ] Bug fixes and refinements

## Contributing

Contributions are welcome! Please read the design documentation before making UI changes to maintain consistency.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Design inspired by modern minimalist food apps
- Icons from Material Icons and custom SVG illustrations
- Animations powered by Lottie

---

## Quick Start

### 1. Setup Environment Variables

**Copy the example file:**
```bash
cp .env.example .env
```

**Add your API keys to `.env`:**
```env
OPENAI_API_KEY=your_openai_api_key_here
OPENAI_MODEL=gpt-4o-mini
UNSPLASH_ACCESS_KEY=your_unsplash_access_key_here
```

**Get your API keys:**
- OpenAI: https://platform.openai.com/api-keys
- Unsplash: https://unsplash.com/developers

⚠️ **Important:** Never commit your `.env` file to GitHub! It's already in `.gitignore`.

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Run the App
```bash
flutter run
```

### 4. Generate Recipes!
Enter your ingredients and let AI create delicious recipes for you! 🍳

---

## Environment Setup

This project uses environment variables to keep API keys secure:

- **`.env`** - Your actual API keys (never commit this!)
- **`.env.example`** - Template file (safe to commit)
- **`api_config.dart`** - Loads keys from `.env` file

**For contributors:** Copy `.env.example` to `.env` and add your own API keys.

---

**Status**: OpenAI Integration Complete ✅ | Ready to Use 🚀

**Documentation:**
- [OpenAI Setup Guide](OPENAI_SETUP.md) - **START HERE** - Add your API key
- [API Integration Summary](API_INTEGRATION_SUMMARY.md) - Quick overview
- [Getting Started Guide](GETTING_STARTED.md) - App usage
- [Implementation Summary](IMPLEMENTATION_COMPLETE.md) - Complete feature list
- [Design Overview](DESIGN_OVERVIEW.md) - Design specifications
