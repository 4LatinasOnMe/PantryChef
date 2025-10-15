# OpenAI API Setup Guide

## ✅ Setup Complete!

Your PantryChef app is now configured to use OpenAI's API for real recipe generation. Follow these steps to add your API key and start generating recipes.

---

## 🔑 Step 1: Get Your OpenAI API Key

1. Go to [OpenAI Platform](https://platform.openai.com/)
2. Sign in or create an account
3. Navigate to **API Keys**: https://platform.openai.com/api-keys
4. Click **"Create new secret key"**
5. Copy your API key (starts with `sk-...`)

**Important:** Keep your API key secret! Never share it or commit it to version control.

---

## 📝 Step 2: Add Your API Key

Open the `.env` file in the project root and replace the placeholder:

```env
# Before:
OPENAI_API_KEY=your_openai_api_key_here

# After (with your actual key):
OPENAI_API_KEY=sk-proj-xxxxxxxxxxxxxxxxxxxxx
```

**That's it!** Your API key is now configured.

---

## 🚀 Step 3: Install Dependencies & Run

```bash
# Install new packages
flutter pub get

# Run the app
flutter run
```

---

## 🧪 Step 4: Test Recipe Generation

1. **Enter ingredients**: `chicken, tomatoes, pasta, garlic, olive oil`
2. **Select preferences**: Italian cuisine, Vegetarian (optional)
3. **Tap "Generate Recipe"** 🔥
4. **Wait for AI**: The loading screen will show while OpenAI generates your recipe
5. **View your recipe**: A real, AI-generated recipe will appear!

---

## ⚙️ Configuration Options

### Change the AI Model

In `.env`, you can change the model:

```env
# Faster & cheaper (recommended)
OPENAI_MODEL=gpt-4o-mini

# More creative (costs more)
OPENAI_MODEL=gpt-4o

# Legacy model
OPENAI_MODEL=gpt-3.5-turbo
```

**Recommended:** `gpt-4o-mini` - Fast, affordable, and great quality!

---

## 💰 API Costs

OpenAI charges per token (words). Approximate costs per recipe:

- **gpt-4o-mini**: ~$0.001 - $0.003 per recipe (very affordable!)
- **gpt-4o**: ~$0.01 - $0.03 per recipe
- **gpt-3.5-turbo**: ~$0.0005 - $0.002 per recipe

**Example:** With gpt-4o-mini, you can generate ~300-1000 recipes for $1!

Check your usage: https://platform.openai.com/usage

---

## 🛡️ Security Features

✅ **API key stored in `.env`** - Not in code
✅ **`.env` added to `.gitignore`** - Won't be committed to Git
✅ **Environment variables loaded securely** - Using flutter_dotenv
✅ **Error handling** - Clear messages if key is missing or invalid

---

## 🔧 How It Works

### The Recipe Generation Flow

1. **User inputs ingredients** → Home Screen
2. **App sends request** → OpenAI API with your key
3. **AI generates recipe** → Returns JSON with recipe details
4. **App displays recipe** → Recipe Screen with all details
5. **User can save** → Stored locally on device

### What's Sent to OpenAI

```
Ingredients: chicken, tomatoes, pasta, garlic
Cuisine: Italian
Dietary needs: Vegetarian
Meal type: Dinner

+ Instructions to return JSON format
```

### What OpenAI Returns

```json
{
  "title": "Creamy Tomato Pasta with Herbs",
  "description": "A delicious Italian pasta...",
  "prep_time": 10,
  "cook_time": 20,
  "servings": 4,
  "ingredients": [...],
  "instructions": [...]
}
```

---

## ❌ Troubleshooting

### Error: "OpenAI API key not configured"
**Solution:** Add your API key to `.env` file

### Error: "Invalid API key"
**Solution:** 
- Check that your key starts with `sk-`
- Verify it's copied correctly (no extra spaces)
- Make sure the key is active on OpenAI platform

### Error: "Rate limit exceeded"
**Solution:** 
- You've made too many requests
- Wait a few minutes and try again
- Check your OpenAI account limits

### Error: "Network error"
**Solution:**
- Check your internet connection
- Verify you can access openai.com
- Check if a firewall is blocking the request

### App crashes on startup
**Solution:**
- Run `flutter clean`
- Run `flutter pub get`
- Make sure `.env` file exists in project root

### Recipe generation takes too long
**Solution:**
- Normal wait time is 5-15 seconds
- Check your internet speed
- Try switching to `gpt-4o-mini` (faster)

---

## 🎨 Customizing the AI Prompt

Want different recipe styles? Edit `lib/services/recipe_service.dart`:

```dart
String _buildPrompt(...) {
  final buffer = StringBuffer();
  buffer.writeln('Create a delicious recipe...');
  
  // Add your custom instructions here!
  buffer.writeln('Make it extra spicy!');
  buffer.writeln('Include cooking tips!');
  
  // ...
}
```

### Prompt Ideas
- "Include nutritional information"
- "Add wine pairing suggestions"
- "Make it kid-friendly"
- "Include substitution options"
- "Add plating suggestions"

---

## 📊 Monitoring Usage

### Check Your OpenAI Usage
1. Go to https://platform.openai.com/usage
2. View requests and costs
3. Set spending limits if needed

### Set Spending Limits
1. Go to https://platform.openai.com/account/billing/limits
2. Set monthly budget
3. Get alerts when approaching limit

---

## 🔒 Best Practices

### ✅ DO:
- Keep your API key secret
- Use `.env` for configuration
- Monitor your usage
- Set spending limits
- Use `gpt-4o-mini` for cost efficiency

### ❌ DON'T:
- Commit `.env` to Git
- Share your API key
- Hardcode the key in source code
- Use expensive models unnecessarily
- Ignore error messages

---

## 🆘 Need Help?

### OpenAI Resources
- [API Documentation](https://platform.openai.com/docs)
- [API Reference](https://platform.openai.com/docs/api-reference)
- [Community Forum](https://community.openai.com/)
- [Status Page](https://status.openai.com/)

### PantryChef Resources
- `GETTING_STARTED.md` - App setup guide
- `IMPLEMENTATION_COMPLETE.md` - Feature documentation
- `README.md` - Project overview

---

## 🎉 You're All Set!

Your PantryChef app is now powered by OpenAI's AI! 

**Next steps:**
1. Add your API key to `.env`
2. Run `flutter pub get`
3. Run `flutter run`
4. Generate your first AI recipe!

Happy cooking! 🍳👨‍🍳

---

**Files Modified:**
- ✅ `pubspec.yaml` - Added http & flutter_dotenv packages
- ✅ `.env` - Created for API key storage
- ✅ `.gitignore` - Added .env to prevent commits
- ✅ `lib/main.dart` - Added environment loading
- ✅ `lib/services/recipe_service.dart` - Integrated OpenAI API

**Status:** Ready for API Integration ✅
