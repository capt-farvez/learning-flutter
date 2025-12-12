# StatelessWidget

A `StatelessWidget` is an immutable widget that describes part of the UI. Once created, it cannot changeif the UI needs to update, Flutter creates a new instance with new configuration.

---

## Theory: The Immutability Principle

### Why Immutability?

Flutter's rendering is based on a key insight: **building widgets is cheap, mutating them is complex**.

Instead of tracking changes to existing objects, Flutter:
1. Rebuilds the widget tree when state changes
2. Efficiently diffs the new tree against the old
3. Updates only the actual render objects that changed

```
State Change ’ New Widget Tree ’ Diff ’ Minimal Render Updates
```

### StatelessWidget's Role

A `StatelessWidget` is a **pure function of its configuration**:

```
Configuration (constructor args) ’ Widget Tree (build method)
```

- Same inputs always produce the same output
- No internal state to track
- Framework can freely recreate, cache, or discard instances

---

## Basic Structure

```dart
class Greeting extends StatelessWidget {
  final String name;
  final TextStyle? style;

  const Greeting({
    super.key,
    required this.name,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      'Hello, $name!',
      style: style ?? Theme.of(context).textTheme.headlineMedium,
    );
  }
}

// Usage
Greeting(name: 'Flutter')
Greeting(name: 'Dart', style: TextStyle(color: Colors.blue))
```

---

## The build() Method

The `build` method is called whenever the widget needs to render. It receives a `BuildContext` and must return a widget.

```dart
@override
Widget build(BuildContext context) {
  // Access inherited widgets via context
  final theme = Theme.of(context);
  final mediaQuery = MediaQuery.of(context);

  // Return widget tree
  return Container(
    padding: EdgeInsets.all(16),
    color: theme.primaryColor,
    child: Text(
      'Screen width: ${mediaQuery.size.width}',
    ),
  );
}
```

### When build() is Called

| Trigger | Example |
|---------|---------|
| First insertion | Widget added to tree |
| Parent rebuilds | Parent's `setState()` |
| InheritedWidget changes | Theme, MediaQuery updates |
| Hot reload | During development |

---

## Using BuildContext

`BuildContext` is your widget's location in the widget tree. Use it to:

### Access Inherited Data

```dart
@override
Widget build(BuildContext context) {
  // Theme
  final theme = Theme.of(context);
  final primaryColor = theme.primaryColor;

  // Media information
  final size = MediaQuery.sizeOf(context);
  final padding = MediaQuery.paddingOf(context);

  // Navigation
  final navigator = Navigator.of(context);

  // Localization
  final locale = Localizations.localeOf(context);

  // Scaffold (if inside one)
  final scaffold = Scaffold.maybeOf(context);

  return Container();
}
```

### Navigate

```dart
@override
Widget build(BuildContext context) {
  return ElevatedButton(
    onPressed: () {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => NextScreen()),
      );
    },
    child: Text('Go'),
  );
}
```

### Show Dialogs/Snackbars

```dart
@override
Widget build(BuildContext context) {
  return ElevatedButton(
    onPressed: () {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Hello'),
        ),
      );
    },
    child: Text('Show Dialog'),
  );
}
```

---

## Constructor Best Practices

### Use const Constructors

`const` constructors enable compile-time constant widgets, improving performance:

```dart
class MyWidget extends StatelessWidget {
  final String title;
  final int count;

  // const constructor
  const MyWidget({
    super.key,
    required this.title,
    this.count = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Text('$title: $count');
  }
}

// Usage - creates compile-time constant
const MyWidget(title: 'Items', count: 5)

// Without const - creates new instance each build
MyWidget(title: 'Items', count: 5)
```

### Make Fields Final

All fields must be `final` (immutable):

```dart
class UserCard extends StatelessWidget {
  // All fields are final
  final String name;
  final String? email;
  final VoidCallback? onTap;
  final Widget? leading;

  const UserCard({
    super.key,
    required this.name,
    this.email,
    this.onTap,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading ?? Icon(Icons.person),
      title: Text(name),
      subtitle: email != null ? Text(email!) : null,
      onTap: onTap,
    );
  }
}
```

### Use Named Parameters

Prefer named parameters for clarity:

```dart
// Good - clear and self-documenting
const Button(
  label: 'Submit',
  onPressed: handleSubmit,
  isEnabled: true,
)

// Less clear - positional parameters
const Button('Submit', handleSubmit, true)
```

---

## Common Patterns

### Composition Over Inheritance

Build complex widgets by composing simpler ones:

```dart
class ProfileCard extends StatelessWidget {
  final User user;

  const ProfileCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Avatar(url: user.avatarUrl),      // Composed widget
            SizedBox(height: 8),
            UserName(name: user.name),         // Composed widget
            UserBio(bio: user.bio),            // Composed widget
          ],
        ),
      ),
    );
  }
}
```

### Conditional Rendering

```dart
class StatusBadge extends StatelessWidget {
  final Status status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getColor(),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }

  Color _getColor() {
    return switch (status) {
      Status.active => Colors.green,
      Status.pending => Colors.orange,
      Status.inactive => Colors.grey,
    };
  }
}
```

### Builder Pattern for Complex Configuration

```dart
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final ButtonStyle? style;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.style,
    this.isLoading = false,
  });

  // Named constructors for common variants
  const CustomButton.primary({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
  }) : style = null;  // Uses default primary style

  const CustomButton.secondary({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
  }) : style = null;  // Uses secondary style

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: style,
      child: isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon),
                  SizedBox(width: 8),
                ],
                Text(label),
              ],
            ),
    );
  }
}
```

### Extracting Helper Methods

Keep `build()` readable by extracting complex parts:

```dart
class OrderSummary extends StatelessWidget {
  final Order order;

  const OrderSummary({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          _buildHeader(context),
          Divider(),
          _buildItems(),
          Divider(),
          _buildTotal(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return ListTile(
      title: Text('Order #${order.id}'),
      subtitle: Text(order.date.toString()),
      trailing: _buildStatusChip(),
    );
  }

  Widget _buildStatusChip() {
    return Chip(
      label: Text(order.status.name),
      backgroundColor: order.status.color,
    );
  }

  Widget _buildItems() {
    return Column(
      children: order.items.map((item) => ListTile(
        title: Text(item.name),
        trailing: Text('\$${item.price}'),
      )).toList(),
    );
  }

  Widget _buildTotal(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Total', style: Theme.of(context).textTheme.titleLarge),
          Text('\$${order.total}', style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
    );
  }
}
```

---

## Performance Considerations

### Use const Wherever Possible

```dart
@override
Widget build(BuildContext context) {
  return Column(
    children: [
      // const - single instance reused
      const Text('Static Title'),
      const SizedBox(height: 16),
      const Icon(Icons.star),

      // Not const - new instance each build
      Text('Count: $count'),
    ],
  );
}
```

### Avoid Expensive Operations in build()

```dart
class MyWidget extends StatelessWidget {
  final List<Item> items;

  const MyWidget({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    // BAD: Expensive computation every build
    // final sortedItems = items.toList()..sort((a, b) => a.name.compareTo(b.name));

    // GOOD: Do in parent, pass pre-computed data
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) => ItemTile(item: items[index]),
    );
  }
}
```

### Keys for Widget Identity

Use keys when widgets in a list might reorder:

```dart
@override
Widget build(BuildContext context) {
  return Column(
    children: items.map((item) => ItemCard(
      key: ValueKey(item.id),  // Helps Flutter track identity
      item: item,
    )).toList(),
  );
}
```

---

## When to Use StatelessWidget

| Use Case | Widget Type |
|----------|-------------|
| Pure display of data | StatelessWidget |
| No internal state | StatelessWidget |
| UI depends only on constructor args | StatelessWidget |
| Needs to change over time | StatefulWidget |
| Has animations | StatefulWidget |
| Manages form inputs | StatefulWidget |
| Subscribes to streams | StatefulWidget (or StreamBuilder) |

---

## Comparison: Stateless vs Stateful

```dart
// StatelessWidget - simple, no state
class DisplayWidget extends StatelessWidget {
  final String text;

  const DisplayWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text);  // Just displays what it's given
  }
}

// StatefulWidget - manages internal state
class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _count = 0;  // Internal mutable state

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => setState(() => _count++),
      child: Text('Count: $_count'),
    );
  }
}
```

---

## Best Practices Summary

1. **Use const constructors** - Enable compile-time constants
2. **Make all fields final** - Enforce immutability
3. **Prefer named parameters** - Improve readability
4. **Keep build() pure** - No side effects
5. **Extract helper methods** - Keep build() readable
6. **Compose, don't inherit** - Build from smaller widgets
7. **Use const in build()** - For static child widgets
8. **Avoid expensive operations** - No heavy computation in build()
9. **Pass callbacks, not state** - Let parents manage state
10. **Use keys for lists** - When items can reorder
