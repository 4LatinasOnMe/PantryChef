# PantryChef Quick Reference

## Design Tokens Cheat Sheet

### Colors
```dart
// Primary Colors
const Color background = Color(0xFFF8F8F8);      // Off-White
const Color surface = Color(0xFFFFFFFF);         // Pure White
const Color accent = Color(0xFFFF7F6A);          // Soft Coral
const Color accentLight = Color(0xFFFFB5A7);     // Light Coral
const Color accentDark = Color(0xFFE65A45);      // Deep Coral

// Text Colors
const Color textPrimary = Color(0xFF2C2C2C);     // Charcoal
const Color textSecondary = Color(0xFF6B6B6B);   // Medium Gray
const Color textTertiary = Color(0xFF9E9E9E);    // Light Gray

// Functional Colors
const Color success = Color(0xFF4CAF50);         // Fresh Green
const Color warning = Color(0xFFFFA726);         // Warm Orange
const Color error = Color(0xFFEF5350);           // Soft Red
const Color divider = Color(0xFFE0E0E0);         // Light Gray
```

### Typography
```dart
// Headings
TextStyle h1 = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 28,
  fontWeight: FontWeight.w600,
  letterSpacing: -0.5,
);

TextStyle h2 = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 22,
  fontWeight: FontWeight.w600,
  letterSpacing: -0.3,
);

TextStyle h3 = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 18,
  fontWeight: FontWeight.w500,
);

// Body Text
TextStyle bodyLarge = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 16,
  height: 1.5,
);

TextStyle bodyMedium = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 14,
  height: 1.43,
);

TextStyle bodySmall = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 12,
  height: 1.5,
);

// Interactive
TextStyle button = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 16,
  fontWeight: FontWeight.w600,
  letterSpacing: 0.5,
);
```

### Spacing
```dart
// Base spacing units (8px grid)
const double spaceXXS = 4.0;
const double spaceXS = 8.0;
const double spaceS = 12.0;
const double spaceM = 16.0;
const double spaceL = 24.0;
const double spaceXL = 32.0;
const double spaceXXL = 48.0;

// Common usage
const double screenPaddingH = 20.0;  // Horizontal screen padding
const double screenPaddingV = 16.0;  // Vertical screen padding
const double cardPadding = 20.0;     // Card internal padding
const double chipGap = 12.0;         // Gap between chips
const double sectionGap = 32.0;      // Gap between sections
```

### Border Radius
```dart
const double radiusS = 8.0;
const double radiusM = 12.0;
const double radiusL = 16.0;
const double radiusXL = 20.0;
const double radiusPill = 999.0;  // Pill shape

// Common usage
const double buttonRadius = 16.0;
const double cardRadius = 20.0;
const double inputRadius = 16.0;
const double chipRadius = 20.0;
```

### Shadows
```dart
// Elevation 1 (subtle)
BoxShadow shadowLight = BoxShadow(
  color: Colors.black.withOpacity(0.06),
  offset: Offset(0, 2),
  blurRadius: 8,
);

// Elevation 2 (standard)
BoxShadow shadowMedium = BoxShadow(
  color: Colors.black.withOpacity(0.08),
  offset: Offset(0, 4),
  blurRadius: 12,
);

// Elevation 3 (prominent)
BoxShadow shadowHeavy = BoxShadow(
  color: Colors.black.withOpacity(0.12),
  offset: Offset(0, 6),
  blurRadius: 16,
);

// Accent shadow (for primary button)
BoxShadow shadowAccent = BoxShadow(
  color: Color(0xFFFF7F6A).withOpacity(0.3),
  offset: Offset(0, 4),
  blurRadius: 12,
);
```

---

## Component Snippets

### Primary Button
```dart
ElevatedButton(
  onPressed: () {},
  style: ElevatedButton.styleFrom(
    backgroundColor: Color(0xFFFF7F6A),
    foregroundColor: Colors.white,
    minimumSize: Size(double.infinity, 56),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    elevation: 2,
    shadowColor: Color(0xFFFF7F6A).withOpacity(0.3),
  ),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        'Generate Recipe',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
      SizedBox(width: 8),
      Text('🔥', style: TextStyle(fontSize: 20)),
    ],
  ),
)
```

### Choice Chip (Unselected)
```dart
ChoiceChip(
  label: Text('Italian'),
  selected: false,
  onSelected: (bool selected) {},
  backgroundColor: Colors.white,
  selectedColor: Color(0xFFFF7F6A),
  labelStyle: TextStyle(
    color: Color(0xFF2C2C2C),
    fontSize: 14,
    fontWeight: FontWeight.w500,
  ),
  side: BorderSide(color: Color(0xFFE0E0E0), width: 1.5),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
  ),
  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
)
```

### Choice Chip (Selected)
```dart
ChoiceChip(
  label: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(Icons.check, size: 16, color: Colors.white),
      SizedBox(width: 6),
      Text('Italian'),
    ],
  ),
  selected: true,
  onSelected: (bool selected) {},
  backgroundColor: Colors.white,
  selectedColor: Color(0xFFFF7F6A),
  labelStyle: TextStyle(
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  ),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
  ),
  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
)
```

### Text Input (Multi-line)
```dart
TextField(
  maxLines: null,
  minLines: 5,
  decoration: InputDecoration(
    hintText: 'e.g., chicken breast, tomatoes, pasta...',
    hintStyle: TextStyle(
      color: Color(0xFF9E9E9E),
      fontSize: 16,
    ),
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 2),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 2),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Color(0xFFFF7F6A), width: 2),
    ),
    contentPadding: EdgeInsets.all(16),
  ),
  style: TextStyle(
    fontSize: 16,
    color: Color(0xFF2C2C2C),
    height: 1.5,
  ),
)
```

### Recipe Card (Cookbook)
```dart
Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.08),
        offset: Offset(0, 4),
        blurRadius: 12,
      ),
    ],
  ),
  child: Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Food icon
            SvgPicture.asset(
              'assets/icons/food/pasta.svg',
              width: 64,
              height: 64,
              color: Color(0xFFFF7F6A),
            ),
            SizedBox(height: 16),
            // Title
            Text(
              'Creamy Chicken Pasta',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2C2C2C),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8),
            // Meta info
            Text(
              '30 min • 4 servings',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF9E9E9E),
              ),
            ),
          ],
        ),
      ),
    ),
  ),
)
```

### Ingredient Checkbox Item
```dart
InkWell(
  onTap: () {
    setState(() {
      isChecked = !isChecked;
    });
  },
  child: Padding(
    padding: EdgeInsets.symmetric(vertical: 12),
    child: Row(
      children: [
        // Checkbox
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: isChecked ? Color(0xFF4CAF50) : Colors.white,
            border: isChecked ? null : Border.all(
              color: Color(0xFFE0E0E0),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: isChecked
              ? Icon(Icons.check, size: 16, color: Colors.white)
              : null,
        ),
        SizedBox(width: 12),
        // Ingredient text
        Expanded(
          child: Text(
            '2 cups pasta (penne or fusilli)',
            style: TextStyle(
              fontSize: 15,
              color: isChecked ? Color(0xFF9E9E9E) : Color(0xFF2C2C2C),
              decoration: isChecked ? TextDecoration.lineThrough : null,
              height: 1.47,
            ),
          ),
        ),
      ],
    ),
  ),
)
```

### Instruction Step
```dart
Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    // Step number
    Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Color(0xFFFF7F6A),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '1',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ),
    SizedBox(width: 16),
    // Step text
    Expanded(
      child: Text(
        'Bring a large pot of salted water to a boil. Add pasta and cook according to package directions until al dente.',
        style: TextStyle(
          fontSize: 15,
          color: Color(0xFF2C2C2C),
          height: 1.6,
        ),
      ),
    ),
  ],
)
```

### Info Card
```dart
Container(
  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
  decoration: BoxDecoration(
    color: Color(0xFFF8F8F8),
    borderRadius: BorderRadius.circular(12),
  ),
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        Icons.schedule,
        size: 20,
        color: Color(0xFFFF7F6A),
      ),
      SizedBox(height: 4),
      Text(
        'PREP',
        style: TextStyle(
          fontSize: 11,
          color: Color(0xFF9E9E9E),
        ),
      ),
      SizedBox(height: 2),
      Text(
        '15 min',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2C2C2C),
        ),
      ),
    ],
  ),
)
```

---

## Animation Durations

```dart
// Standard durations
const Duration fast = Duration(milliseconds: 150);
const Duration medium = Duration(milliseconds: 300);
const Duration slow = Duration(milliseconds: 500);

// Specific animations
const Duration chipTap = Duration(milliseconds: 150);
const Duration screenTransition = Duration(milliseconds: 300);
const Duration fadeIn = Duration(milliseconds: 300);
const Duration slideUp = Duration(milliseconds: 300);
const Duration ripple = Duration(milliseconds: 200);
const Duration checkboxToggle = Duration(milliseconds: 200);
```

---

## Common Curves

```dart
// Standard easing
const Curve standard = Curves.easeInOut;
const Curve decelerate = Curves.easeOut;
const Curve accelerate = Curves.easeIn;

// Specific animations
const Curve buttonPress = Curves.easeInOut;
const Curve slideTransition = Curves.easeOut;
const Curve fadeTransition = Curves.easeInOut;
const Curve scaleAnimation = Curves.easeOut;
```

---

## Screen Padding Constants

```dart
class AppPadding {
  // Screen edges
  static const double screenH = 20.0;
  static const double screenV = 16.0;
  static const EdgeInsets screen = EdgeInsets.symmetric(
    horizontal: screenH,
    vertical: screenV,
  );
  
  // Components
  static const double card = 20.0;
  static const double button = 16.0;
  static const double input = 16.0;
  static const double chip = 16.0;
  
  // Sections
  static const double sectionTop = 32.0;
  static const double sectionBottom = 24.0;
  static const double betweenElements = 12.0;
}
```

---

## Icon Sizes

```dart
class AppIconSize {
  static const double small = 18.0;
  static const double medium = 24.0;
  static const double large = 32.0;
  static const double food = 64.0;
  static const double illustration = 120.0;
  static const double animation = 200.0;
}
```

---

## Common Widgets

### Section Header
```dart
Widget buildSectionHeader(String title) {
  return Padding(
    padding: EdgeInsets.only(top: 32, bottom: 12),
    child: Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color(0xFF2C2C2C),
      ),
    ),
  );
}
```

### Divider
```dart
Widget buildDivider() {
  return Container(
    height: 1,
    color: Color(0xFFE0E0E0),
    margin: EdgeInsets.symmetric(vertical: 24),
  );
}
```

### Empty State
```dart
Widget buildEmptyState({
  required String title,
  required String description,
  required VoidCallback onAction,
}) {
  return Center(
    child: Padding(
      padding: EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration
          SvgPicture.asset(
            'assets/illustrations/empty_cookbook.svg',
            width: 120,
            height: 120,
            color: Color(0xFFE0E0E0),
          ),
          SizedBox(height: 32),
          // Title
          Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C2C2C),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          // Description
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF6B6B6B),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32),
          // CTA Button
          ElevatedButton(
            onPressed: onAction,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFF7F6A),
              minimumSize: Size(200, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text('Generate Recipe'),
          ),
        ],
      ),
    ),
  );
}
```

---

## Responsive Breakpoints

```dart
class Breakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
  
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobile;
  }
  
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobile && width < desktop;
  }
  
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktop;
  }
}
```

---

## Accessibility Helpers

```dart
class A11y {
  // Minimum touch target size
  static const double minTouchTarget = 48.0;
  
  // Semantic labels
  static String chipLabel(String text, bool selected) {
    return '$text, ${selected ? "selected" : "not selected"}';
  }
  
  static String checkboxLabel(String text, bool checked) {
    return '$text, ${checked ? "checked" : "unchecked"}';
  }
  
  // Announce to screen reader
  static void announce(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 1),
      ),
    );
  }
}
```

---

## Common Transitions

### Slide Up Transition
```dart
PageRouteBuilder(
  pageBuilder: (context, animation, secondaryAnimation) => NextScreen(),
  transitionsBuilder: (context, animation, secondaryAnimation, child) {
    const begin = Offset(0.0, 1.0);
    const end = Offset.zero;
    const curve = Curves.easeOut;
    
    var tween = Tween(begin: begin, end: end).chain(
      CurveTween(curve: curve),
    );
    
    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  },
  transitionDuration: Duration(milliseconds: 300),
)
```

### Fade Transition
```dart
PageRouteBuilder(
  pageBuilder: (context, animation, secondaryAnimation) => NextScreen(),
  transitionsBuilder: (context, animation, secondaryAnimation, child) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  },
  transitionDuration: Duration(milliseconds: 300),
)
```

---

## Useful Extensions

```dart
extension ColorExtension on Color {
  Color lighten([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final lightness = (hsl.lightness + amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }
  
  Color darken([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

extension ContextExtension on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
```

---

**Quick Tip**: Bookmark this page for fast reference during development!

For complete specifications, see [DESIGN_SYSTEM.md](DESIGN_SYSTEM.md)
