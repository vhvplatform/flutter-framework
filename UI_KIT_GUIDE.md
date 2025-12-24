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
