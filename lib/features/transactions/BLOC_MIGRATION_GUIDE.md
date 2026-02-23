# Converting TransactionsFilterPage to BLoC Pattern

## Summary
A `TransactionFilterBloc` has been created at:
`lib/features/transactions/presentation/bloc/transaction_filter_bloc.dart`

## Key Changes Needed

### 1. Wrap Page with BlocProvider
```dart
// In the parent widget or main.dart
BlocProvider(
  create: (context) => TransactionFilterBloc(),
  child: TransactionsFilterPage(),
)
```

### 2. Replace StatefulWidget with BlocBuilder
```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/transaction_filter_bloc.dart';

// Change from StatefulWidget to StatelessWidget or keep minimal state
// Use BlocBuilder to rebuild UI based on state changes
```

### 3. Replace setState Calls with BLoC Events

**Before (setState):**
```dart
setState(() => _showFilters = !_showFilters);
```

**After (BLoC):**
```dart
context.read<TransactionFilterBloc>().add(const TransactionFilterEvent.toggleFiltersVisibility());
```

### 4. Access State via BlocBuilder

**Before:**
```dart
if (_showFilters) ...
```

**After:**
```dart
BlocBuilder<TransactionFilterBloc, TransactionFilterState>(
  builder: (context, state) {
    if (state.showFilters) ...
  },
)
```

## Quick Reference: Event Mappings

| Action | Event |
|--------|-------|
| Toggle filters | `toggleFiltersVisibility()` |
| Update search | `updateSearch(query)` |
| Toggle category | `toggleCategory(category)` |
| Toggle type | `toggleType(type)` |
| Update date range | `updateDateRange(range)` |
| Update amount range | `updateAmountRange(min, max)` |
| Toggle bulk select | `toggleBulkSelect()` |
| Select transaction | `toggleTransactionSelection(id)` |
| Clear filters | `clearFilters()` |
| Expand transaction | `expandTransaction(id)` |

## Benefits
- Separation of business logic from UI
- Easier testing
- Better state management
- Predictable state changes

## Note
The BLoC is ready to use. To fully implement, replace all `setState` calls with corresponding BLoC events and wrap UI sections with `BlocBuilder` widgets.
