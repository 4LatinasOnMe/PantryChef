# Backend Server Recommendations

## Why You Need a Backend

Currently, your API keys are embedded in the APK, which means:
- ❌ **Security Risk**: Anyone can extract your OpenAI and Unsplash API keys from the APK
- ❌ **No Usage Control**: You can't limit how much each user consumes
- ❌ **No User Accounts**: Can't sync data across devices
- ❌ **No Analytics**: Can't track usage patterns or popular recipes

## Recommended Architecture

```
┌─────────────┐         ┌─────────────┐         ┌─────────────┐
│   Flutter   │  HTTPS  │   Backend   │   API   │   OpenAI    │
│     App     │ ◄─────► │   Server    │ ◄─────► │  Unsplash   │
│  (Mobile)   │         │  (Node.js)  │         │             │
└─────────────┘         └─────────────┘         └─────────────┘
                              │
                              ▼
                        ┌─────────────┐
                        │  Database   │
                        │ (PostgreSQL)│
                        └─────────────┘
```

## Backend Features to Implement

### Phase 1: Core Security (Essential)
1. **API Proxy**
   - Move all OpenAI/Unsplash calls to backend
   - App sends ingredients → Backend calls OpenAI → Returns recipes
   - API keys never exposed to client

2. **Rate Limiting**
   - Limit requests per user (e.g., 10 recipes/day for free users)
   - Prevent abuse and control costs

3. **User Authentication**
   - Firebase Auth, Auth0, or custom JWT
   - Track usage per user

### Phase 2: Enhanced Features
4. **Cloud Recipe Storage**
   - Save recipes to database instead of local storage
   - Sync across devices
   - Backup and restore

5. **Recipe Caching**
   - Cache generated recipes on server
   - Serve cached results for common ingredient combinations
   - Reduce OpenAI API costs

6. **Analytics**
   - Track popular ingredients
   - Most generated cuisines
   - User engagement metrics

### Phase 3: Community Features
7. **Recipe Sharing**
   - Users can share recipes publicly
   - Community ratings and reviews
   - Trending recipes

8. **Social Features**
   - Follow other users
   - Share meal plans
   - Recipe collections

## Technology Stack Recommendations

### Option 1: Node.js + Express (Recommended)
**Pros:**
- Fast development
- Large ecosystem
- Easy to deploy (Vercel, Railway, Render)
- Good for API-heavy apps

**Tech Stack:**
```
- Runtime: Node.js 18+
- Framework: Express.js
- Database: PostgreSQL (Supabase)
- Auth: Firebase Auth or Supabase Auth
- Hosting: Railway, Render, or Vercel
- Cache: Redis (optional)
```

**Estimated Cost:** $5-20/month

### Option 2: Firebase (Easiest)
**Pros:**
- Fastest to implement
- Built-in auth, database, hosting
- Free tier available
- No server management

**Tech Stack:**
```
- Backend: Firebase Cloud Functions
- Database: Firestore
- Auth: Firebase Auth
- Hosting: Firebase Hosting
- Storage: Firebase Storage
```

**Estimated Cost:** $0-10/month (free tier covers most needs)

### Option 3: Supabase (Modern)
**Pros:**
- Open-source Firebase alternative
- PostgreSQL database
- Built-in auth and storage
- Real-time subscriptions

**Tech Stack:**
```
- Backend: Supabase Edge Functions
- Database: PostgreSQL (Supabase)
- Auth: Supabase Auth
- Storage: Supabase Storage
```

**Estimated Cost:** $0-25/month

## Implementation Roadmap

### Week 1: Setup Backend
1. Choose platform (Firebase recommended for speed)
2. Set up project and authentication
3. Create API endpoints:
   - `POST /api/recipes/generate` - Generate recipes
   - `GET /api/recipes/:id` - Get recipe details
   - `POST /api/recipes/save` - Save recipe to user account

### Week 2: Migrate API Calls
1. Create backend service layer in Flutter app
2. Replace direct OpenAI calls with backend API calls
3. Implement authentication in app
4. Test thoroughly

### Week 3: Add Cloud Features
1. Implement cloud recipe storage
2. Add sync functionality
3. Implement rate limiting
4. Add analytics

### Week 4: Polish & Deploy
1. Error handling and retry logic
2. Performance optimization
3. Deploy to production
4. Monitor and iterate

## Sample Backend Code (Node.js + Express)

```javascript
// server.js
const express = require('express');
const OpenAI = require('openai');
const rateLimit = require('express-rate-limit');

const app = express();
const openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });

// Rate limiting: 10 requests per hour per user
const limiter = rateLimit({
  windowMs: 60 * 60 * 1000,
  max: 10,
  message: 'Too many recipe requests, please try again later'
});

app.use(express.json());
app.use('/api/', limiter);

// Generate recipes endpoint
app.post('/api/recipes/generate', async (req, res) => {
  try {
    const { ingredients, cuisineType, dietaryNeeds, count } = req.body;
    
    // Validate input
    if (!ingredients || ingredients.length === 0) {
      return res.status(400).json({ error: 'Ingredients required' });
    }

    // Call OpenAI
    const response = await openai.chat.completions.create({
      model: 'gpt-4o-mini',
      messages: [
        {
          role: 'system',
          content: 'You are a professional chef...'
        },
        {
          role: 'user',
          content: buildPrompt(ingredients, cuisineType, dietaryNeeds, count)
        }
      ],
      temperature: 0.9,
      max_tokens: 4000,
    });

    const recipes = JSON.parse(response.choices[0].message.content);
    
    // Cache result (optional)
    await cacheRecipes(ingredients, recipes);
    
    res.json(recipes);
  } catch (error) {
    console.error('Error generating recipes:', error);
    res.status(500).json({ error: 'Failed to generate recipes' });
  }
});

app.listen(3000, () => {
  console.log('Server running on port 3000');
});
```

## Sample Flutter Integration

```dart
// lib/services/backend_service.dart
class BackendService {
  static const String _baseUrl = 'https://your-backend.com/api';
  
  Future<List<Recipe>> generateRecipes({
    required List<String> ingredients,
    String? cuisineType,
    List<String>? dietaryNeeds,
    int count = 4,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/recipes/generate'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await getAuthToken()}',
      },
      body: jsonEncode({
        'ingredients': ingredients,
        'cuisineType': cuisineType,
        'dietaryNeeds': dietaryNeeds,
        'count': count,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['recipes'] as List)
          .map((json) => Recipe.fromJson(json))
          .toList();
    } else if (response.statusCode == 429) {
      throw Exception('Rate limit exceeded. Please try again later.');
    } else {
      throw Exception('Failed to generate recipes');
    }
  }
}
```

## Cost Estimation

### Current Setup (Direct API Calls)
- OpenAI: $0.15 per 1M input tokens, $0.60 per 1M output tokens
- Unsplash: Free (50 requests/hour)
- **Risk**: Unlimited user consumption, potential for abuse

### With Backend (Recommended)
- Backend Hosting: $5-20/month (Railway, Render)
- Database: $0-10/month (Supabase free tier)
- OpenAI: Same rates, but controlled
- **Total**: $5-30/month + OpenAI usage
- **Benefit**: Full control, no abuse, scalable

## Security Best Practices

1. **Environment Variables**
   - Never commit API keys
   - Use `.env` files locally
   - Use platform secrets in production

2. **HTTPS Only**
   - All API calls must use HTTPS
   - Prevent man-in-the-middle attacks

3. **Input Validation**
   - Sanitize all user inputs
   - Limit request sizes
   - Prevent injection attacks

4. **Rate Limiting**
   - Per-user limits
   - Per-IP limits
   - Exponential backoff

5. **Monitoring**
   - Log all API calls
   - Alert on unusual patterns
   - Track costs daily

## Next Steps

1. **Immediate** (This Week)
   - Choose backend platform (Firebase recommended)
   - Set up basic project
   - Create first API endpoint

2. **Short Term** (This Month)
   - Migrate all API calls to backend
   - Implement authentication
   - Deploy to production

3. **Long Term** (Next 3 Months)
   - Add cloud sync
   - Implement community features
   - Add analytics dashboard

## Questions?

If you need help implementing the backend, I can:
1. Generate complete backend code (Node.js, Firebase, or Supabase)
2. Create deployment guides
3. Write Flutter integration code
4. Set up CI/CD pipelines

Let me know which platform you'd like to use!
