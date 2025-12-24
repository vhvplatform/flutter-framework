# UI Kit Package

A comprehensive collection of reusable Material Design 3 UI components for Flutter SaaS applications.

## Features

### Theme System
- Material Design 3 theme implementation
- Light and dark mode support
- Customizable color schemes
- Predefined text styles and component themes

### Widgets

#### Buttons
- **AppButton**: Customizable button with 4 variants (primary, secondary, outline, text)
- **IconButton**: Icon-based buttons
- **FAB**: Floating action buttons

#### Input Components
- **AppTextField**: Advanced text input with validation, error display, and password toggle
- **AppSearchField**: Search input with clear button and suggestions
- **AppDropdown**: Dropdown selector with search support
- **AppCheckbox**: Styled checkbox with label
- **AppRadio**: Radio button group
- **AppSwitch**: Toggle switch with label
- **AppSlider**: Range slider with labels

#### Display Components
- **AppCard**: Container with elevation and border options
- **AppChip**: Chip widget for tags and filters
- **AppBadge**: Badge indicator for notifications
- **AppAvatar**: User avatar with fallback initials
- **AppDivider**: Horizontal and vertical dividers
- **AppTag**: Tag widget with colors

#### Feedback Components
- **LoadingIndicator**: Centered loading spinner
- **EmptyState**: Empty state with icon and message
- **ErrorView**: Error display with retry button
- **SnackbarHelper**: Easy snackbar notifications
- **DialogHelper**: Pre-built dialog templates
- **BottomSheetHelper**: Bottom sheet utilities

#### Layout Components
- **AppScaffold**: Enhanced scaffold with loading overlay
- **AppAppBar**: Customizable app bar
- **AppBottomNavigation**: Bottom navigation bar
- **AppDrawer**: Navigation drawer
- **ResponsiveLayout**: Responsive layout builder

#### List Components
- **AppListTile**: Enhanced list tile
- **SectionHeader**: Section headers for lists
- **SwipeAction**: Swipeable list item with actions

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  ui_kit:
    path: ../ui_kit
```

## Usage

### Import

```dart
import 'package:ui_kit/ui_kit.dart';
```

### Theme

```dart
MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  themeMode: ThemeMode.system,
  home: MyHomePage(),
)
```

### Buttons

```dart
// Primary button
AppButton(
  label: 'Submit',
  onPressed: () => print('Pressed'),
  variant: ButtonVariant.primary,
)

// Loading state
AppButton(
  label: 'Loading...',
  onPressed: null,
  isLoading: true,
)

// Icon button
AppButton.icon(
  icon: Icons.add,
  label: 'Add Item',
  onPressed: () {},
)
```

### Text Fields

```dart
AppTextField(
  label: 'Email',
  hint: 'Enter your email',
  validator: (value) {
    if (value?.isEmpty ?? true) return 'Email is required';
    return null;
  },
  prefixIcon: Icons.email,
  keyboardType: TextInputType.emailAddress,
)

// Password field
AppTextField(
  label: 'Password',
  hint: 'Enter password',
  obscureText: true,
  showPasswordToggle: true,
)

// Search field
AppSearchField(
  hint: 'Search...',
  onChanged: (value) => performSearch(value),
  onClear: () => clearSearch(),
)
```

### Cards

```dart
AppCard(
  child: Column(
    children: [
      Text('Card Title'),
      Text('Card content'),
    ],
  ),
)

// With custom styling
AppCard(
  elevation: 4,
  borderRadius: 16,
  padding: EdgeInsets.all(20),
  child: YourContent(),
)
```

### Dropdown

```dart
AppDropdown<String>(
  value: selectedValue,
  items: ['Option 1', 'Option 2', 'Option 3'],
  onChanged: (value) => setState(() => selectedValue = value),
  label: 'Select Option',
)
```

### Chips & Badges

```dart
// Chip
AppChip(
  label: 'Flutter',
  onDeleted: () => removeTag(),
)

// Badge
AppBadge(
  count: 5,
  child: Icon(Icons.notifications),
)
```

### Avatar

```dart
// With image
AppAvatar(
  imageUrl: 'https://example.com/avatar.jpg',
  size: 48,
)

// With initials
AppAvatar(
  name: 'John Doe',
  size: 48,
)
```

### Feedback Components

```dart
// Loading
LoadingIndicator()

// Empty state
EmptyState(
  icon: Icons.inbox,
  message: 'No items found',
  action: AppButton(
    label: 'Add Item',
    onPressed: () {},
  ),
)

// Error
ErrorView(
  message: 'Failed to load data',
  onRetry: () => loadData(),
)

// Snackbar
SnackbarHelper.showSuccess(
  context,
  'Operation successful!',
)

// Dialog
await DialogHelper.showConfirm(
  context,
  title: 'Delete Item',
  message: 'Are you sure?',
)
```

### Layout Components

```dart
// Scaffold with loading
AppScaffold(
  appBar: AppAppBar(
    title: 'Page Title',
    actions: [
      IconButton(icon: Icons.search, onPressed: () {}),
    ],
  ),
  body: YourContent(),
  isLoading: isLoadingData,
)

// Responsive layout
ResponsiveLayout(
  mobile: MobileView(),
  tablet: TabletView(),
  desktop: DesktopView(),
)
```

### List Components

```dart
// Enhanced list tile
AppListTile(
  leading: AppAvatar(name: user.name),
  title: user.name,
  subtitle: user.email,
  trailing: Icon(Icons.arrow_forward),
  onTap: () => openUser(user),
)

// Section header
SectionHeader(
  title: 'Recent Items',
  action: TextButton(
    child: Text('See All'),
    onPressed: () {},
  ),
)

// Swipeable item
SwipeAction(
  onDelete: () => deleteItem(),
  onEdit: () => editItem(),
  child: ListTile(title: Text('Item')),
)
```

## Theming

### Colors

Access theme colors:

```dart
final colors = AppColors;
colors.primary
colors.secondary
colors.error
colors.success
colors.warning
colors.info
```

### Text Styles

Access text styles:

```dart
final textStyles = AppTextStyles;
textStyles.h1
textStyles.h2
textStyles.body1
textStyles.body2
textStyles.caption
```

### Customization

Override theme values:

```dart
final customTheme = AppTheme.lightTheme.copyWith(
  primaryColor: Colors.blue,
  textTheme: AppTheme.lightTheme.textTheme.copyWith(
    bodyLarge: TextStyle(fontSize: 16),
  ),
);
```

## Best Practices

1. **Consistent Usage**: Use UI Kit components throughout your app for consistency
2. **Theme Compliance**: Always use theme colors and text styles
3. **Responsive Design**: Use ResponsiveLayout for different screen sizes
4. **Accessibility**: All widgets support semantic labels and screen readers
5. **Performance**: Widgets use const constructors where possible

## Examples

See the `example/` directory for complete usage examples.

## Contributing

When adding new widgets:
1. Follow Material Design 3 guidelines
2. Support light and dark themes
3. Add documentation with examples
4. Include null safety
5. Use const constructors where possible
6. Add tests

## License

This package is part of the SaaS Framework Flutter project.
