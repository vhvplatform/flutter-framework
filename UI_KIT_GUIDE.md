# UI Kit Complete Guide

Complete documentation for all UI components in the Flutter SaaS framework.

## Table of Contents

- [Installation](#installation)
- [Theme System](#theme-system)
- [Input Components](#input-components)
- [Display Components](#display-components)
- [Feedback Components](#feedback-components)
- [Layout Components](#layout-components)
- [Best Practices](#best-practices)
- [Examples](#examples)

---

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  ui_kit:
    path: ../packages/ui_kit
```

Import in your code:

```dart
import 'package:ui_kit/ui_kit.dart';
```

---

## Theme System

### Setup Theme

```dart
MaterialApp(
  title: 'SaaS App',
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  themeMode: ThemeMode.system, // or ThemeMode.light, ThemeMode.dark
  home: HomePage(),
)
```

### Access Theme Colors

```dart
// Using AppColors
final primaryColor = AppColors.primary;
final secondaryColor = AppColors.secondary;
final errorColor = AppColors.error;
final successColor = AppColors.success;

// Or from context
final theme = Theme.of(context);
final primaryColor = theme.colorScheme.primary;
```

### Access Text Styles

```dart
// Using AppTextStyles
Text('Heading', style: AppTextStyles.h1);
Text('Body', style: AppTextStyles.body1);
Text('Caption', style: AppTextStyles.caption);

// Or from context
Text('Heading', style: Theme.of(context).textTheme.headlineLarge);
```

---

## Input Components

### AppButton

Customizable button with multiple variants and loading states.

```dart
// Primary button
AppButton(
  label: 'Submit',
  onPressed: () => handleSubmit(),
  variant: ButtonVariant.primary,
)

// Secondary button
AppButton(
  label: 'Cancel',
  onPressed: () => handleCancel(),
  variant: ButtonVariant.secondary,
)

// Outline button
AppButton(
  label: 'View Details',
  onPressed: () {},
  variant: ButtonVariant.outline,
)

// Text button
AppButton(
  label: 'Skip',
  onPressed: () {},
  variant: ButtonVariant.text,
)

// With loading state
AppButton(
  label: isLoading ? 'Saving...' : 'Save',
  onPressed: isLoading ? null : () => save(),
  isLoading: isLoading,
)

// Full width button
AppButton(
  label: 'Continue',
  onPressed: () {},
  isFullWidth: true,
)

// Button with icon
AppButton.icon(
  icon: Icons.add,
  label: 'Add Item',
  onPressed: () {},
)
```

### AppTextField

Advanced text input with validation and error display.

```dart
// Basic text field
AppTextField(
  label: 'Username',
  hint: 'Enter your username',
  controller: usernameController,
)

// With validation
AppTextField(
  label: 'Email',
  hint: 'Enter your email',
  controller: emailController,
  validator: (value) {
    if (value?.isEmpty ?? true) return 'Email is required';
    if (!value!.contains('@')) return 'Invalid email';
    return null;
  },
)

// Password field with toggle
AppTextField(
  label: 'Password',
  hint: 'Enter password',
  controller: passwordController,
  obscureText: true,
  showPasswordToggle: true,
)

// With prefix and suffix icons
AppTextField(
  label: 'Phone',
  hint: '+1 234 567 8900',
  prefixIcon: Icons.phone,
  suffixIcon: Icons.check_circle,
  keyboardType: TextInputType.phone,
)

// Multiline text field
AppTextField(
  label: 'Description',
  hint: 'Enter description',
  maxLines: 4,
)
```

### AppSearchField

Search input with clear button.

```dart
AppSearchField(
  hint: 'Search users...',
  onChanged: (value) {
    // Perform search
    performSearch(value);
  },
  onClear: () {
    // Clear search results
    clearSearch();
  },
  autofocus: true,
)

// With controller
final searchController = TextEditingController();

AppSearchField(
  controller: searchController,
  hint: 'Search...',
  onSubmitted: (value) {
    // Handle enter key
    executeSearch(value);
  },
)
```

### AppDropdown

Dropdown selector with custom item builder.

```dart
// Simple dropdown
AppDropdown<String>(
  value: selectedOption,
  items: ['Option 1', 'Option 2', 'Option 3'],
  onChanged: (value) {
    setState(() => selectedOption = value);
  },
  label: 'Select Option',
  hint: 'Choose one...',
)

// With custom objects
AppDropdown<User>(
  value: selectedUser,
  items: users,
  onChanged: (user) {
    setState(() => selectedUser = user);
  },
  label: 'Select User',
  itemBuilder: (user) => user.name,
)

// Disabled dropdown
AppDropdown<String>(
  value: lockedValue,
  items: options,
  onChanged: (value) {},
  enabled: false,
)
```

---

## Display Components

### AppCard

Container with elevation and customizable styling.

```dart
// Basic card
AppCard(
  child: Column(
    children: [
      Text('Card Title'),
      SizedBox(height: 8),
      Text('Card content goes here'),
    ],
  ),
)

// With custom styling
AppCard(
  elevation: 4,
  borderRadius: 16,
  padding: EdgeInsets.all(20),
  color: Colors.blue[50],
  child: YourContent(),
)

// No padding card
AppCard(
  padding: EdgeInsets.zero,
  child: Image.network('...'),
)
```

### AppChip

Chip widget for tags and filters.

```dart
// Deletable chip
AppChip(
  label: 'Flutter',
  onDeleted: () {
    removeTag('Flutter');
  },
)

// Action chip
AppChip(
  label: 'Filter Active',
  onTap: () {
    openFilterDialog();
  },
)

// With avatar
AppChip(
  label: 'John Doe',
  avatar: CircleAvatar(child: Text('J')),
)

// Selected chip
AppChip(
  label: 'Selected',
  selected: true,
)

// Custom colored chip
AppChip(
  label: 'Important',
  backgroundColor: Colors.red[100],
)
```

### AppBadge

Badge indicator for notifications.

```dart
// Basic badge
AppBadge(
  count: 5,
  child: Icon(Icons.notifications),
)

// With max count
AppBadge(
  count: 150,
  maxCount: 99, // Shows "99+"
  child: Icon(Icons.mail),
)

// Custom color
AppBadge(
  count: 3,
  color: Colors.green,
  child: Icon(Icons.shopping_cart),
)

// Show even when zero
AppBadge(
  count: 0,
  showZero: true,
  child: Icon(Icons.favorite),
)
```

### AppAvatar

User avatar with automatic initials fallback.

```dart
// With image URL
AppAvatar(
  imageUrl: 'https://example.com/avatar.jpg',
  size: 48,
)

// With name (generates initials)
AppAvatar(
  name: 'John Doe', // Shows "JD"
  size: 48,
)

// Custom colors
AppAvatar(
  name: 'Jane Smith',
  size: 56,
  backgroundColor: Colors.purple,
  textColor: Colors.white,
)

// Different sizes
AppAvatar(name: user.name, size: 32) // Small
AppAvatar(name: user.name, size: 48) // Medium
AppAvatar(name: user.name, size: 64) // Large
```

### AppDivider

Horizontal and vertical dividers.

```dart
// Horizontal divider
AppDivider()

// With custom thickness
AppDivider(
  thickness: 2,
  color: Colors.grey[300],
)

// With indents
AppDivider(
  indent: 16,
  endIndent: 16,
)

// Vertical divider
AppDivider.vertical(
  height: 50,
  thickness: 1,
)
```

---

## Feedback Components

### LoadingIndicator

Centered loading spinner.

```dart
// Basic loading
LoadingIndicator()

// In a container
Container(
  height: 200,
  child: LoadingIndicator(),
)
```

### EmptyState

Empty state with icon and message.

```dart
// Basic empty state
EmptyState(
  icon: Icons.inbox,
  message: 'No items found',
)

// With action button
EmptyState(
  icon: Icons.folder_open,
  message: 'No documents yet',
  action: AppButton(
    label: 'Upload Document',
    onPressed: () => uploadDocument(),
  ),
)
```

### ErrorView

Error display with retry functionality.

```dart
// Basic error
ErrorView(
  message: 'Failed to load data',
  onRetry: () => loadData(),
)

// Custom error
ErrorView(
  message: error.toString(),
  onRetry: () async {
    await retryOperation();
  },
)
```

### SnackbarHelper

Easy snackbar notifications.

```dart
// Success message
SnackbarHelper.showSuccess(
  context,
  'Profile updated successfully!',
);

// Error message
SnackbarHelper.showError(
  context,
  'Failed to save changes',
);

// Warning message
SnackbarHelper.showWarning(
  context,
  'Storage is almost full',
);

// Info message
SnackbarHelper.showInfo(
  context,
  'New features available',
);

// Custom duration
SnackbarHelper.showSuccess(
  context,
  'Saved!',
  duration: Duration(seconds: 5),
);

// With action
SnackbarHelper.show(
  context,
  'Item deleted',
  action: SnackBarAction(
    label: 'UNDO',
    onPressed: () => undoDelete(),
  ),
);
```

### DialogHelper

Pre-built dialog templates.

```dart
// Confirmation dialog
final confirmed = await DialogHelper.showConfirm(
  context,
  title: 'Delete Item',
  message: 'Are you sure you want to delete this item?',
  confirmText: 'Delete',
  cancelText: 'Cancel',
  isDestructive: true,
);

if (confirmed) {
  deleteItem();
}

// Alert dialog
await DialogHelper.showAlert(
  context,
  title: 'Success',
  message: 'Operation completed successfully',
  buttonText: 'OK',
);

// Loading dialog
DialogHelper.showLoading(
  context,
  message: 'Saving changes...',
);

// Later, hide it
await performSave();
DialogHelper.hideLoading(context);

// Custom dialog
await DialogHelper.showCustom(
  context,
  child: AlertDialog(
    title: Text('Custom Dialog'),
    content: YourCustomContent(),
  ),
);
```

---

## Layout Components

### AppListTile

Enhanced list tile with better styling.

```dart
// Basic list tile
AppListTile(
  title: 'Item Title',
  subtitle: 'Item description',
  onTap: () => handleTap(),
)

// With leading and trailing
AppListTile(
  leading: AppAvatar(name: user.name),
  title: user.name,
  subtitle: user.email,
  trailing: Icon(Icons.arrow_forward_ios, size: 16),
  onTap: () => openUser(user),
)

// Selected state
AppListTile(
  title: 'Selected Item',
  selected: true,
  onTap: () {},
)

// Disabled tile
AppListTile(
  title: 'Disabled Item',
  enabled: false,
)
```

### SectionHeader

Section headers for organized lists.

```dart
// Basic header
SectionHeader(
  title: 'Recent Items',
)

// With action button
SectionHeader(
  title: 'Notifications',
  action: TextButton(
    child: Text('See All'),
    onPressed: () => viewAllNotifications(),
  ),
)

// Custom padding
SectionHeader(
  title: 'Settings',
  padding: EdgeInsets.all(20),
)
```

### ResponsiveLayout

Responsive layout for different screen sizes.

```dart
// Basic responsive layout
ResponsiveLayout(
  mobile: MobileView(),
  tablet: TabletView(),
  desktop: DesktopView(),
)

// Mobile and desktop only
ResponsiveLayout(
  mobile: CompactView(),
  desktop: WideView(),
)

// Custom breakpoints
ResponsiveLayout(
  mobile: SmallScreen(),
  tablet: MediumScreen(),
  desktop: LargeScreen(),
  mobileBreakpoint: 480,
  tabletBreakpoint: 1024,
)

// Using context extension
Widget build(BuildContext context) {
  if (context.isMobile) {
    return MobileLayout();
  } else if (context.isTablet) {
    return TabletLayout();
  } else {
    return DesktopLayout();
  }
}
```

---

## Best Practices

### 1. Consistent Component Usage

✅ **Do:**
```dart
// Use UI Kit components consistently
AppButton(label: 'Save', onPressed: save)
AppTextField(label: 'Name', controller: nameController)
```

❌ **Don't:**
```dart
// Mix with standard widgets unnecessarily
ElevatedButton(child: Text('Save'), onPressed: save)
TextField(decoration: InputDecoration(labelText: 'Name'))
```

### 2. Theme Compliance

✅ **Do:**
```dart
// Use theme colors and styles
Text('Title', style: AppTextStyles.h2)
Container(color: AppColors.primary)
```

❌ **Don't:**
```dart
// Hardcode colors and styles
Text('Title', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
Container(color: Color(0xFF2196F3))
```

### 3. Responsive Design

✅ **Do:**
```dart
// Adapt to screen size
ResponsiveLayout(
  mobile: SingleColumn(),
  desktop: TwoColumns(),
)

// Use context extensions
if (context.isMobile) {
  // Mobile-specific logic
}
```

❌ **Don't:**
```dart
// Fixed layouts that break on different sizes
Row(children: [Column1(), Column2()]) // Breaks on mobile
```

### 4. Accessibility

✅ **Do:**
```dart
// Provide semantic information
AppButton(
  label: 'Delete',
  onPressed: delete,
  semanticLabel: 'Delete item',
)
```

### 5. Performance

✅ **Do:**
```dart
// Use const constructors
const AppDivider()
const LoadingIndicator()

// Reuse controllers
final controller = TextEditingController();
```

❌ **Don't:**
```dart
// Create new instances repeatedly
AppTextField(controller: TextEditingController()) // Creates new each build
```

---

## Examples

### Login Form

```dart
class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Login', style: AppTextStyles.h2),
          SizedBox(height: 24),
          
          AppTextField(
            label: 'Email',
            hint: 'Enter your email',
            controller: _emailController,
            prefixIcon: Icons.email,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Email is required';
              return null;
            },
          ),
          SizedBox(height: 16),
          
          AppTextField(
            label: 'Password',
            hint: 'Enter password',
            controller: _passwordController,
            prefixIcon: Icons.lock,
            obscureText: true,
            showPasswordToggle: true,
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Password is required';
              return null;
            },
          ),
          SizedBox(height: 24),
          
          AppButton(
            label: 'Login',
            onPressed: _isLoading ? null : _handleLogin,
            isLoading: _isLoading,
            isFullWidth: true,
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);
    
    try {
      await login(_emailController.text, _passwordController.text);
      SnackbarHelper.showSuccess(context, 'Login successful!');
    } catch (e) {
      SnackbarHelper.showError(context, 'Login failed: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
```

### User List

```dart
class UserListScreen extends StatelessWidget {
  final List<User> users;
  
  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return EmptyState(
        icon: Icons.people,
        message: 'No users found',
        action: AppButton(
          label: 'Add User',
          onPressed: () => addUser(),
        ),
      );
    }

    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return AppListTile(
          leading: AppAvatar(
            name: user.name,
            imageUrl: user.avatarUrl,
          ),
          title: user.name,
          subtitle: user.email,
          trailing: AppBadge(
            count: user.unreadCount,
            child: Icon(Icons.arrow_forward_ios, size: 16),
          ),
          onTap: () => openUser(user),
        );
      },
    );
  }
}
```

### Responsive Dashboard

```dart
class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: _buildMobileLayout(),
      tablet: _buildTabletLayout(),
      desktop: _buildDesktopLayout(),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(),
          _buildStats(),
          _buildRecentActivity(),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            children: [
              _buildHeader(),
              _buildStats(),
            ],
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _buildRecentActivity(),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return AppCard(
      child: Row(
        children: [
          AppAvatar(name: 'John Doe', size: 48),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome back!', style: AppTextStyles.caption),
                Text('John Doe', style: AppTextStyles.h3),
              ],
            ),
          ),
          AppBadge(
            count: 5,
            child: IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return AppCard(
      child: Column(
        children: [
          SectionHeader(title: 'Statistics'),
          // Stats content
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return AppCard(
      child: Column(
        children: [
          SectionHeader(
            title: 'Recent Activity',
            action: TextButton(
              child: Text('View All'),
              onPressed: () {},
            ),
          ),
          // Activity list
        ],
      ),
    );
  }
}
```

---

## Summary

The UI Kit provides:

- **25+ production-ready components**
- **Consistent Material Design 3 theming**
- **Light and dark mode support**
- **Responsive layout utilities**
- **Accessibility built-in**
- **Comprehensive documentation**
- **Real-world examples**

For more information, see:
- [UI Kit README](packages/ui_kit/README.md)
- [Theme Documentation](packages/ui_kit/lib/theme/app_theme.dart)
- [Component Examples](packages/ui_kit/example/)

### AppSwitch

Toggle switch with label and description support.

```dart
// Basic switch
AppSwitch(
  value: _enabled,
  onChanged: (value) => setState(() => _enabled = value),
  label: 'Enable notifications',
)

// With description
AppSwitch(
  value: _darkMode,
  onChanged: (value) => setState(() => _darkMode = value),
  label: 'Dark Mode',
  description: 'Use dark theme across the app',
)

// Custom color
AppSwitch(
  value: _autoSave,
  onChanged: (value) => setState(() => _autoSave = value),
  label: 'Auto-save',
  activeColor: Colors.green,
)
```

### AppCheckbox

Checkbox with label support.

```dart
// Basic checkbox
AppCheckbox(
  value: _agreed,
  onChanged: (value) => setState(() => _agreed = value ?? false),
  label: 'I agree to the terms and conditions',
)

// Disabled checkbox
AppCheckbox(
  value: _accepted,
  onChanged: null, // Disabled
  label: 'Accepted',
)

// Custom color
AppCheckbox(
  value: _checked,
  onChanged: (value) => setState(() => _checked = value ?? false),
  label: 'Remember me',
  activeColor: Colors.purple,
)
```

### AppRadio & AppRadioGroup

Radio button with label support and radio groups.

```dart
// Single radio button
AppRadio<String>(
  value: 'option1',
  groupValue: _selectedOption,
  onChanged: (value) => setState(() => _selectedOption = value),
  label: 'Option 1',
)

// Radio group
AppRadioGroup<String>(
  value: _selectedPayment,
  onChanged: (value) => setState(() => _selectedPayment = value),
  title: 'Payment Method',
  options: [
    RadioOption(value: 'card', label: 'Credit Card'),
    RadioOption(value: 'paypal', label: 'PayPal'),
    RadioOption(value: 'bank', label: 'Bank Transfer'),
  ],
)
```

### AppSlider

Range slider with label and value display.

```dart
// Basic slider
AppSlider(
  value: _volume,
  onChanged: (value) => setState(() => _volume = value),
  label: 'Volume',
  min: 0,
  max: 100,
  showValue: true,
)

// With divisions
AppSlider(
  value: _brightness,
  onChanged: (value) => setState(() => _brightness = value),
  label: 'Brightness',
  min: 0,
  max: 100,
  divisions: 10,
  showValue: true,
)

// Custom formatter
AppSlider(
  value: _price,
  onChanged: (value) => setState(() => _price = value),
  label: 'Price Range',
  min: 0,
  max: 1000,
  showValue: true,
  valueFormatter: (value) => '\$${value.toStringAsFixed(0)}',
)
```

---

## Display Components (Extended)

### AppProgress

Linear and circular progress indicators with percentage display.

```dart
// Linear progress
AppLinearProgress(
  value: 0.65,
  label: 'Upload progress',
  showPercentage: true,
  color: Colors.blue,
)

// Indeterminate linear progress
AppLinearProgress(
  label: 'Loading...',
)

// Circular progress with percentage
AppCircularProgress(
  value: 0.75,
  size: 100,
  showPercentage: true,
  color: Colors.green,
)

// Indeterminate circular progress
AppCircularProgress(
  size: 48,
)
```

### AppShimmer

Shimmer loading effect for skeleton screens.

```dart
// Custom shimmer
AppShimmer(
  child: Container(
    width: double.infinity,
    height: 100,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
  ),
)

// Pre-built list item skeleton
ShimmerListItem(
  hasLeading: true,
  hasTrailing: false,
  lines: 2,
)

// Pre-built card skeleton
ShimmerCard(
  height: 200,
)

// Loading list with shimmer
ListView.builder(
  itemCount: _isLoading ? 5 : items.length,
  itemBuilder: (context, index) {
    if (_isLoading) {
      return ShimmerListItem();
    }
    return ListTile(title: Text(items[index]));
  },
)
```

---

## Feedback Components (Extended)

### AppTooltip

Customized tooltip with better styling.

```dart
AppTooltip(
  message: 'This is a helpful tooltip',
  child: Icon(Icons.info_outline),
)

// Custom duration
AppTooltip(
  message: 'Hold to see more',
  waitDuration: Duration(milliseconds: 300),
  showDuration: Duration(seconds: 3),
  child: IconButton(
    icon: Icon(Icons.help_outline),
    onPressed: () {},
  ),
)
```

### BottomSheetHelper

Helper for showing bottom sheets with consistent styling.

```dart
// Custom bottom sheet
await BottomSheetHelper.show(
  context,
  title: 'Filter Options',
  builder: (context) => ListView(
    shrinkWrap: true,
    children: [
      ListTile(title: Text('Option 1')),
      ListTile(title: Text('Option 2')),
    ],
  ),
)

// Bottom sheet with options
final result = await BottomSheetHelper.showOptions(
  context,
  title: 'Choose Action',
  options: [
    BottomSheetOption(
      label: 'Edit',
      icon: Icons.edit,
      value: 'edit',
    ),
    BottomSheetOption(
      label: 'Share',
      icon: Icons.share,
      value: 'share',
    ),
    BottomSheetOption(
      label: 'Delete',
      icon: Icons.delete,
      value: 'delete',
      isDestructive: true,
    ),
  ],
);

if (result == 'delete') {
  // Handle delete
}
```

---

## Layout Components (Extended)

### AppTabs

Customized tab bar with modern styling.

```dart
AppTabs(
  tabs: ['Home', 'Profile', 'Settings'],
  currentIndex: _currentTab,
  onTap: (index) => setState(() => _currentTab = index),
)

// Custom colors
AppTabs(
  tabs: ['Active', 'Completed', 'Archived'],
  currentIndex: _currentTab,
  onTap: (index) => setState(() => _currentTab = index),
  activeColor: Colors.purple,
  indicatorColor: Colors.purpleAccent,
)
```

### AppExpansionTile

Expansion tile with modern styling.

```dart
AppExpansionTile(
  title: 'Advanced Settings',
  subtitle: 'Tap to expand',
  children: [
    ListTile(title: Text('Option 1')),
    ListTile(title: Text('Option 2')),
    ListTile(title: Text('Option 3')),
  ],
)

// With leading icon
AppExpansionTile(
  title: 'Account Information',
  leading: Icon(Icons.account_circle),
  children: [
    ListTile(
      title: Text('Email'),
      subtitle: Text('user@example.com'),
    ),
    ListTile(
      title: Text('Phone'),
      subtitle: Text('+1 234 567 8900'),
    ),
  ],
)
```

### AppStepper

Horizontal stepper for multi-step processes.

```dart
AppStepper(
  steps: ['Account', 'Profile', 'Confirmation'],
  currentStep: _currentStep,
  onStepTap: (index) {
    if (index < _currentStep) {
      setState(() => _currentStep = index);
    }
  },
)

// Custom colors
AppStepper(
  steps: ['Select Plan', 'Payment', 'Complete'],
  currentStep: _currentStep,
  activeColor: Colors.purple,
  completedColor: Colors.green,
  inactiveColor: Colors.grey,
)

// Full example with navigation
Column(
  children: [
    AppStepper(
      steps: _steps,
      currentStep: _currentStep,
    ),
    Expanded(
      child: _getStepContent(_currentStep),
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (_currentStep > 0)
          AppButton(
            label: 'Back',
            onPressed: () => setState(() => _currentStep--),
            variant: ButtonVariant.outline,
          ),
        AppButton(
          label: _currentStep < _steps.length - 1 ? 'Next' : 'Finish',
          onPressed: _handleNext,
        ),
      ],
    ),
  ],
)
```

---

## Real-World Examples (Extended)

### Multi-Step Form with Stepper

```dart
class SignupFlow extends StatefulWidget {
  @override
  _SignupFlowState createState() => _SignupFlowState();
}

class _SignupFlowState extends State<SignupFlow> {
  int _currentStep = 0;
  final _steps = ['Account', 'Profile', 'Preferences'];
  
  String _email = '';
  String _password = '';
  String _name = '';
  bool _notifications = true;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Column(
        children: [
          AppStepper(
            steps: _steps,
            currentStep: _currentStep,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: _buildStepContent(),
            ),
          ),
          _buildButtons(),
        ],
      ),
    );
  }
  
  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return Column(
          children: [
            AppTextField(
              label: 'Email',
              value: _email,
              onChanged: (value) => setState(() => _email = value),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            AppTextField(
              label: 'Password',
              value: _password,
              onChanged: (value) => setState(() => _password = value),
              isPassword: true,
            ),
          ],
        );
      case 1:
        return Column(
          children: [
            AppTextField(
              label: 'Full Name',
              value: _name,
              onChanged: (value) => setState(() => _name = value),
            ),
            SizedBox(height: 16),
            AppButton(
              label: 'Upload Avatar',
              onPressed: () {},
              variant: ButtonVariant.outline,
            ),
          ],
        );
      case 2:
        return Column(
          children: [
            AppSwitch(
              value: _notifications,
              onChanged: (value) => setState(() => _notifications = value),
              label: 'Enable Notifications',
              description: 'Receive updates and alerts',
            ),
          ],
        );
      default:
        return Container();
    }
  }
  
  Widget _buildButtons() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentStep > 0)
            AppButton(
              label: 'Back',
              onPressed: () => setState(() => _currentStep--),
              variant: ButtonVariant.outline,
            ),
          AppButton(
            label: _currentStep < _steps.length - 1 ? 'Next' : 'Finish',
            onPressed: _handleNext,
          ),
        ],
      ),
    );
  }
  
  void _handleNext() {
    if (_currentStep < _steps.length - 1) {
      setState(() => _currentStep++);
    } else {
      // Complete signup
      _completeSignup();
    }
  }
  
  void _completeSignup() async {
    // Handle signup completion
    SnackbarHelper.showSuccess(context, 'Account created successfully!');
    Navigator.of(context).pop();
  }
}
```

### Settings Screen with All Components

```dart
class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;
  bool _darkMode = false;
  double _volume = 50;
  String _language = 'en';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListView(
        children: [
          SectionHeader(title: 'Preferences'),
          AppSwitch(
            value: _notifications,
            onChanged: (value) => setState(() => _notifications = value),
            label: 'Notifications',
            description: 'Receive push notifications',
          ),
          AppSwitch(
            value: _darkMode,
            onChanged: (value) => setState(() => _darkMode = value),
            label: 'Dark Mode',
            description: 'Use dark theme',
          ),
          AppDivider(),
          
          SectionHeader(title: 'Audio'),
          AppSlider(
            value: _volume,
            onChanged: (value) => setState(() => _volume = value),
            label: 'Volume',
            min: 0,
            max: 100,
            showValue: true,
          ),
          AppDivider(),
          
          SectionHeader(title: 'Language'),
          AppRadioGroup<String>(
            value: _language,
            onChanged: (value) => setState(() => _language = value!),
            options: [
              RadioOption(value: 'en', label: 'English'),
              RadioOption(value: 'vi', label: 'Tiếng Việt'),
              RadioOption(value: 'es', label: 'Español'),
            ],
          ),
          AppDivider(),
          
          SectionHeader(title: 'Account'),
          AppExpansionTile(
            title: 'Account Information',
            leading: Icon(Icons.account_circle),
            children: [
              ListTile(
                title: Text('Email'),
                subtitle: Text('user@example.com'),
              ),
              ListTile(
                title: Text('Member since'),
                subtitle: Text('January 2024'),
              ),
            ],
          ),
          
          Padding(
            padding: EdgeInsets.all(16),
            child: AppButton(
              label: 'Save Changes',
              onPressed: _saveSettings,
            ),
          ),
        ],
      ),
    );
  }
  
  void _saveSettings() async {
    // Show loading
    final loadingDialog = DialogHelper.showLoading(context, message: 'Saving...');
    
    await Future.delayed(Duration(seconds: 1));
    
    Navigator.of(context).pop(); // Close loading
    SnackbarHelper.showSuccess(context, 'Settings saved successfully!');
  }
}
```

---

## Component Summary

**Total: 36+ Components**

### Input (8)
- AppButton, AppTextField, AppSearchField, AppDropdown
- AppSwitch, AppCheckbox, AppRadio/AppRadioGroup, AppSlider

### Display (7)
- AppCard, AppChip, AppBadge, AppAvatar
- AppDivider, AppProgress (Linear/Circular), AppShimmer

### Feedback (7)
- LoadingIndicator, EmptyState, ErrorView
- SnackbarHelper, DialogHelper, BottomSheetHelper, AppTooltip

### Layout (8)
- AppListTile, SectionHeader, ResponsiveLayout
- AppTabs, AppExpansionTile, AppStepper
- ResponsiveContext extensions

All components support:
- ✅ Material Design 3
- ✅ Light/Dark themes
- ✅ Null safety
- ✅ Accessibility
- ✅ Customization


---

## Navigation & Selection Components

### AppMenu

Popup menu with icon support and destructive actions.

```dart
AppMenu(
  child: IconButton(
    icon: Icon(Icons.more_vert),
    onPressed: () {},
  ),
  items: [
    AppMenuItem(
      label: 'Edit',
      icon: Icons.edit,
      onTap: () => editItem(),
    ),
    AppMenuItem(
      label: 'Share',
      icon: Icons.share,
      onTap: () => shareItem(),
    ),
    AppMenuItem(
      label: 'Delete',
      icon: Icons.delete,
      isDestructive: true,
      onTap: () => deleteItem(),
    ),
  ],
)
```

### AppSegmentedButton

Modern segmented control for selecting between options.

```dart
// Single selection
AppSegmentedButton<String>(
  selectedValue: selectedView,
  options: [
    SegmentOption(value: 'list', label: 'List', icon: Icons.list),
    SegmentOption(value: 'grid', label: 'Grid', icon: Icons.grid_view),
  ],
  onChanged: (value) => setState(() => selectedView = value),
)

// Multi-selection
AppSegmentedButton<String>(
  selectedValues: selectedFilters,
  options: [
    SegmentOption(value: 'new', label: 'New'),
    SegmentOption(value: 'active', label: 'Active'),
    SegmentOption(value: 'completed', label: 'Completed'),
  ],
  multiSelectionEnabled: true,
  onMultiChanged: (values) => setState(() => selectedFilters = values),
)
```

### AppTag & AppTagGroup

Tag widgets for labels and filters.

```dart
// Single tag
AppTag(
  label: 'Flutter',
  color: Colors.blue.withOpacity(0.1),
  textColor: Colors.blue,
  onDeleted: () => removeTag('Flutter'),
  onTap: () => selectTag('Flutter'),
)

// Tag group with wrap layout
AppTagGroup(
  tags: ['Flutter', 'Dart', 'Mobile', 'UI/UX'],
  color: Colors.purple.withOpacity(0.1),
  outlined: false,
  onTagDeleted: (tag) => removeTag(tag),
  onTagTapped: (tag) => filterByTag(tag),
  spacing: 8,
  runSpacing: 8,
)
```

### AppBreadcrumb

Breadcrumb navigation for hierarchical navigation.

```dart
AppBreadcrumb(
  items: [
    BreadcrumbItem(
      label: 'Home',
      onTap: () => navigateToHome(),
    ),
    BreadcrumbItem(
      label: 'Products',
      onTap: () => navigateToProducts(),
    ),
    BreadcrumbItem(
      label: 'Category',
      onTap: () => navigateToCategory(),
    ),
    BreadcrumbItem(label: 'Item Details'), // Current page (no onTap)
  ],
)
```

### AppPagination

Pagination widget with page numbers and navigation arrows.

```dart
AppPagination(
  currentPage: currentPage,
  totalPages: 20,
  onPageChanged: (page) {
    setState(() => currentPage = page);
    loadPage(page);
  },
  maxVisiblePages: 5,
)
```

---

## Data Display Components

### AppTimeline

Timeline widget for displaying chronological events.

```dart
AppTimeline(
  items: [
    TimelineItem(
      title: 'Order Placed',
      subtitle: 'Your order has been placed successfully',
      timestamp: '2 hours ago',
      dotColor: Colors.green,
    ),
    TimelineItem(
      title: 'Processing',
      subtitle: 'Your order is being prepared',
      timestamp: '1 hour ago',
    ),
    TimelineItem(
      title: 'Shipped',
      subtitle: 'Package is on its way',
      timestamp: '30 minutes ago',
      child: Text('Tracking: #ABC123'),
    ),
    TimelineItem(
      title: 'Delivered',
      subtitle: 'Expected delivery today',
      timestamp: 'Pending',
    ),
  ],
)
```

### AppStatCard & AppStatGrid

Statistics cards with icons, values, and change indicators.

```dart
// Single stat card
AppStatCard(
  title: 'Total Users',
  value: '24,567',
  icon: Icons.people,
  iconColor: Colors.blue,
  change: '+12.5%',
  isPositiveChange: true,
  onTap: () => viewUserDetails(),
)

// Grid of stat cards
AppStatGrid(
  crossAxisCount: 2,
  cards: [
    AppStatCard(
      title: 'Revenue',
      value: '\$45,231',
      icon: Icons.attach_money,
      iconColor: Colors.green,
      change: '+18.2%',
      isPositiveChange: true,
    ),
    AppStatCard(
      title: 'Orders',
      value: '1,234',
      icon: Icons.shopping_cart,
      iconColor: Colors.orange,
      change: '+5.4%',
      isPositiveChange: true,
    ),
    AppStatCard(
      title: 'Visitors',
      value: '8,562',
      icon: Icons.visibility,
      iconColor: Colors.purple,
      change: '-3.1%',
      isPositiveChange: false,
    ),
    AppStatCard(
      title: 'Conversion',
      value: '3.24%',
      icon: Icons.trending_up,
      iconColor: Colors.blue,
      change: '+0.8%',
      isPositiveChange: true,
    ),
  ],
)
```

### AppDataTable

Customized data table with sorting support.

```dart
AppDataTable(
  columns: [
    DataColumn(label: Text('Name')),
    DataColumn(label: Text('Email')),
    DataColumn(
      label: Text('Status'),
      onSort: (columnIndex, ascending) {
        sortByStatus(ascending);
      },
    ),
  ],
  rows: users.map((user) {
    return DataRow(
      cells: [
        DataCell(Text(user.name)),
        DataCell(Text(user.email)),
        DataCell(
          AppChip(
            label: user.status,
            color: user.isActive ? Colors.green : Colors.grey,
          ),
        ),
      ],
    );
  }).toList(),
  sortColumnIndex: 2,
  sortAscending: true,
)
```

### AppBanner

Banner widget for displaying important messages.

```dart
// Info banner
AppBanner(
  message: 'New features are available. Update your app to get them!',
  type: BannerType.info,
  actions: [
    TextButton(
      onPressed: () => updateApp(),
      child: Text('Update'),
    ),
  ],
  onDismiss: () => dismissBanner(),
)

// Success banner
AppBanner(
  message: 'Your changes have been saved successfully!',
  type: BannerType.success,
  icon: Icons.check_circle,
  onDismiss: () {},
)

// Warning banner
AppBanner(
  message: 'Your session will expire in 5 minutes.',
  type: BannerType.warning,
  actions: [
    TextButton(
      onPressed: () => extendSession(),
      child: Text('Extend'),
    ),
  ],
)

// Error banner
AppBanner(
  message: 'Failed to connect to server. Please try again.',
  type: BannerType.error,
  actions: [
    TextButton(
      onPressed: () => retry(),
      child: Text('Retry'),
    ),
  ],
)
```

---

## Real-World Example: Dashboard with New Components

```dart
class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          // Segmented button for view mode
          AppSegmentedButton<String>(
            selectedValue: 'overview',
            options: [
              SegmentOption(value: 'overview', label: 'Overview', icon: Icons.dashboard),
              SegmentOption(value: 'analytics', label: 'Analytics', icon: Icons.analytics),
            ],
            onChanged: (value) => changeView(value),
          ),
          // Menu for actions
          AppMenu(
            child: IconButton(icon: Icon(Icons.more_vert)),
            items: [
              AppMenuItem(label: 'Export', icon: Icons.download, onTap: () {}),
              AppMenuItem(label: 'Settings', icon: Icons.settings, onTap: () {}),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info banner
            AppBanner(
              message: 'Your free trial ends in 7 days. Upgrade now!',
              type: BannerType.info,
              actions: [
                TextButton(child: Text('Upgrade'), onPressed: () {}),
              ],
              onDismiss: () {},
            ),
            SizedBox(height: 16),
            
            // Breadcrumb navigation
            AppBreadcrumb(
              items: [
                BreadcrumbItem(label: 'Home', onTap: () {}),
                BreadcrumbItem(label: 'Dashboard'),
              ],
            ),
            SizedBox(height: 24),
            
            // Stats grid
            AppStatGrid(
              crossAxisCount: 2,
              cards: [
                AppStatCard(
                  title: 'Total Revenue',
                  value: '\$54,231',
                  icon: Icons.attach_money,
                  iconColor: Colors.green,
                  change: '+18.2%',
                  isPositiveChange: true,
                ),
                AppStatCard(
                  title: 'Active Users',
                  value: '2,345',
                  icon: Icons.people,
                  iconColor: Colors.blue,
                  change: '+12.5%',
                  isPositiveChange: true,
                ),
              ],
            ),
            SizedBox(height: 24),
            
            // Tag filters
            Text('Filter by:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            AppTagGroup(
              tags: ['All', 'Active', 'Pending', 'Completed'],
              outlined: true,
              onTagTapped: (tag) => filterBy(tag),
            ),
            SizedBox(height: 24),
            
            // Timeline of recent activity
            Text('Recent Activity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            AppTimeline(
              items: [
                TimelineItem(
                  title: 'New user registered',
                  subtitle: 'john@example.com',
                  timestamp: '2 minutes ago',
                ),
                TimelineItem(
                  title: 'Payment received',
                  subtitle: '\$299.00',
                  timestamp: '15 minutes ago',
                  dotColor: Colors.green,
                ),
                TimelineItem(
                  title: 'New feature deployed',
                  subtitle: 'Version 2.1.0',
                  timestamp: '1 hour ago',
                ),
              ],
            ),
            SizedBox(height: 24),
            
            // Pagination
            AppPagination(
              currentPage: 1,
              totalPages: 10,
              onPageChanged: (page) => loadPage(page),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## Component Summary (45+ Total)

### Input (8)
- AppButton, AppTextField, AppSearchField, AppDropdown
- AppSwitch, AppCheckbox, AppRadio/AppRadioGroup, AppSlider

### Display (7)
- AppCard, AppChip, AppBadge, AppAvatar
- AppDivider, AppProgress (Linear/Circular), AppShimmer

### Feedback (7)
- LoadingIndicator, EmptyState, ErrorView
- SnackbarHelper, DialogHelper, BottomSheetHelper, AppTooltip

### Layout (8)
- AppListTile, SectionHeader, ResponsiveLayout
- AppTabs, AppExpansionTile, AppStepper
- ResponsiveContext extensions

### Navigation & Selection (5)
- AppMenu, AppSegmentedButton, AppTag/AppTagGroup
- AppBreadcrumb, AppPagination

### Data Display (4)
- AppTimeline, AppStatCard/AppStatGrid
- AppDataTable, AppBanner

### Image & Media (1)
- OptimizedImage

**Total: 45+ production-ready components**

All components support:
- ✅ Material Design 3
- ✅ Light/Dark themes
- ✅ Null safety
- ✅ Accessibility
- ✅ Customization
- ✅ Comprehensive documentation
