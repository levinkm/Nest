# Comprehensive Budgeting System - Design Document

## 1. Core Philosophy

**Frictionless Finance for M-PESA Users**
- Zero manual entry by default (SMS-driven)
- Visual, mobile-first experience
- Goal-oriented (not just limits)
- Smart suggestions from transaction history
- Real-time tracking with predictive alerts

## 2. Budgeting Models Supported

### A. Category-Based (Traditional)
- Set limits per category (Food, Transport, etc.)
- Track spending vs limit
- Best for: Regular expense management

### B. Project-Based (Goal-Driven)
- Budget for specific goals (Wedding, Phone, Trip)
- Link transactions to projects
- Track progress toward completion
- Best for: One-time purchases, savings goals

### C. Envelope-Style (Zero-Based)
- Allocate entire income to categories
- Unallocated funds highlighted
- Best for: Tight budget control

### D. 50/30/20 Rule
- 50% Needs, 30% Wants, 20% Savings
- Auto-categorize transactions
- Best for: Beginners

### E. Income Percentage
- Set budgets as % of income
- Auto-adjust when income changes
- Best for: Variable income earners

## 3. Data Model

### Budget Entity
```dart
{
  id: String,
  name: String,
  type: 'category' | 'project' | 'envelope' | 'percentage',
  category: String?,
  amount: double,
  spent: double,
  period: 'daily' | 'weekly' | 'monthly' | 'yearly' | 'custom',
  startDate: DateTime,
  endDate: DateTime,
  
  // Smart features
  autoAllocate: bool,
  percentageOfIncome: double?,
  rolloverEnabled: bool,
  rolloverAmount: double,
  
  // Project-based
  isProject: bool,
  projectGoal: String?,
  linkedTransactionIds: List<String>,
  
  // Alerts
  alertAt: double, // percentage (e.g., 80%)
  notificationsEnabled: bool,
  
  // Analytics
  averageSpending: double,
  predictedSpending: double,
  healthScore: int,
  
  // Metadata
  createdAt: DateTime,
  updatedAt: DateTime,
  isActive: bool,
}
```

### Budget Template
```dart
{
  id: String,
  name: String,
  description: String,
  budgetType: String,
  categories: Map<String, double>, // category -> amount/percentage
  icon: String,
  isRecommended: bool,
}
```

### Budget Alert
```dart
{
  id: String,
  budgetId: String,
  type: 'threshold' | 'overspend' | 'pace' | 'suggestion',
  message: String,
  severity: 'info' | 'warning' | 'critical',
  timestamp: DateTime,
  isRead: bool,
}
```

## 4. Smart Onboarding Flow

### Step 1: Income Detection
- Scan SMS for salary patterns
- Suggest monthly income
- Allow manual input

### Step 2: Budget Style Selection
- Show 4-5 templates with visuals
- "50/30/20 Rule" (Recommended for beginners)
- "Category Budgets" (Most popular)
- "Project-Based" (For specific goals)
- "Custom" (Advanced)

### Step 3: Smart Suggestions
- Analyze last 3 months of transactions
- Suggest category budgets based on:
  - Average spending + 10% buffer
  - Median spending (more stable)
  - 80th percentile (conservative)
- Show sliders for easy adjustment

### Step 4: Quick Setup
- Pre-fill all values
- User just reviews and adjusts
- One-tap to activate

## 5. Real-Time Tracking Logic

### Spending Calculation
```dart
spent = sum(transactions where:
  - category matches budget.category
  - date >= budget.startDate
  - date <= budget.endDate
  - type == 'expense'
)
```

### Progress Calculation
```dart
progress = (spent / amount) * 100
remaining = amount - spent
daysLeft = budget.endDate.difference(now).inDays
dailyBudget = remaining / daysLeft
```

### Pace Tracking
```dart
daysElapsed = now.difference(budget.startDate).inDays
totalDays = budget.endDate.difference(budget.startDate).inDays
expectedSpent = amount * (daysElapsed / totalDays)
paceStatus = spent > expectedSpent ? 'ahead' : 'on-track'
```

## 6. Budget Projects

### Structure
- Name: "New Phone"
- Target: KSh 30,000
- Deadline: 3 months
- Linked transactions: Manual or auto-tagged
- Progress: Visual bar + percentage

### Auto-Linking
- Keyword matching (e.g., "phone" → Phone project)
- Merchant matching
- Manual selection during transaction entry

## 7. Smart Notifications & Insights

### Alert Types

**Threshold Alerts**
- 50% spent: "You're halfway through your Food budget"
- 80% spent: "⚠️ 80% of Transport budget used"
- 100% spent: "🚨 Shopping budget exceeded"

**Pace Alerts**
- "You're spending 20% faster than planned"
- "At this rate, you'll exceed budget by KSh 2,000"

**Predictive Alerts**
- "Based on your pattern, you'll likely spend KSh 15,000 this month"
- "You usually spend more on weekends. Budget accordingly"

**Smart Suggestions**
- "You saved KSh 1,000 on Food this month. Move to Savings?"
- "Your Transport costs are 30% higher than last month"
- "Consider setting a budget for Entertainment (KSh 5,000 spent)"

### Notification Timing
- Real-time: On overspend
- Daily: Morning summary (8 AM)
- Weekly: Sunday evening review
- Monthly: End-of-month analysis

## 8. End-of-Month Analysis

### Variance Report
```
Category      | Budget  | Spent   | Variance | Status
Food          | 10,000  | 8,500   | +1,500   | ✅ Under
Transport     | 5,000   | 6,200   | -1,200   | ❌ Over
Entertainment | 3,000   | 2,800   | +200     | ✅ Under
```

### Trends
- Month-over-month comparison
- Category spending trends (↑↓)
- Best/worst performing categories

### Suggestions
- "Reduce Transport by 20% next month"
- "You consistently underspend on Food. Lower budget?"
- "Set a budget for Airtime (KSh 2,000 avg)"

## 9. Rollover & Flexibility

### Rollover Mechanics
- **Enabled**: Unused budget → next period
- **Disabled**: Reset to original amount
- **Capped**: Max 50% rollover

### Mid-Period Adjustments
- Allow budget increases (with confirmation)
- Track adjustment history
- Show "adjusted budget" vs "original budget"

### Budget Pausing
- Temporarily disable without deleting
- Useful for travel, emergencies

## 10. Savings Integration

### Auto-Save Rules
- "Save 10% of unspent budget"
- "Round up transactions to nearest 100"
- "Save leftover at month-end"

### Goal Linking
- Link budget savings to specific goals
- "Food savings → Emergency Fund"

## 11. Budget Health Score

### Calculation (0-100)
```dart
score = (
  adherenceScore * 0.4 +      // % of budgets met
  savingsScore * 0.3 +         // % saved vs income
  consistencyScore * 0.2 +     // Low variance month-to-month
  coverageScore * 0.1          // % of expenses budgeted
)
```

### Breakdown
- 90-100: Excellent 🌟
- 75-89: Good ✅
- 60-74: Fair ⚠️
- <60: Needs Improvement 🚨

## 12. AI-Assisted Coaching

### Insights
- "You spend 40% more on weekends"
- "M-Pesa fees are 5% of your spending"
- "Your Food budget is 2x the national average"

### Recommendations
- "Switch to weekly budgets for better control"
- "Set a project budget for your phone purchase"
- "Enable rollover to build a buffer"

### Challenges
- "Try spending <KSh 500/day this week"
- "No-spend weekend challenge"
- "Save KSh 1,000 this month"

## 13. Mobile UI Structure

### Tab 1: Overview
- Total budget summary card
- Budget health score
- Quick actions (Add, Adjust, Analyze)
- Top 3 budgets (visual progress bars)

### Tab 2: Active Budgets
- List of all budgets
- Visual progress (circular/linear)
- Quick filters (All, Category, Project, Over)
- Swipe actions (Edit, Delete, Pause)

### Tab 3: Projects
- Goal-based budgets
- Visual cards with images
- Progress tracking
- Linked transactions

### Tab 4: Insights
- Spending trends chart
- Category breakdown pie chart
- Month-over-month comparison
- Smart suggestions feed

### Tab 5: History
- Past budgets
- Performance archive
- Trend analysis

## 14. Key Screens

### Budget Creation
- Template selection
- Smart suggestions with sliders
- Period picker (visual calendar)
- Category/project toggle
- One-tap create

### Budget Detail
- Large progress circle
- Spent / Remaining / Daily budget
- Transaction list (filtered)
- Pace indicator
- Quick actions (Add transaction, Adjust, Delete)

### Budget Adjustment
- Current vs new amount
- Impact preview
- Reason selector (Income change, Emergency, etc.)

### End-of-Month Review
- Celebration animation (if goals met)
- Variance report
- Suggestions for next month
- One-tap to renew budgets

## 15. Edge Cases

### No Income Detected
- Skip income-based budgets
- Suggest fixed amounts
- Show national averages

### Irregular Income
- Use 3-month average
- Suggest percentage-based budgets
- Weekly budgets instead of monthly

### Mid-Month Start
- Pro-rate budget amounts
- Adjust daily budget calculation
- Clear messaging

### Multiple Accounts
- Aggregate spending across accounts
- Filter by account
- Separate budgets per account (optional)

### Shared Expenses
- Tag transactions as "shared"
- Split budget tracking
- Exclude from personal budgets

### Budget Conflicts
- Transaction matches multiple budgets
- User selects primary budget
- Split transaction across budgets

## 16. Algorithms

### Smart Budget Suggestion
```dart
double suggestBudget(String category, List<Transaction> history) {
  var categoryTxns = history.where((t) => t.category == category);
  if (categoryTxns.isEmpty) return 0;
  
  var amounts = categoryTxns.map((t) => t.amount).toList();
  var median = calculateMedian(amounts);
  var average = amounts.reduce((a, b) => a + b) / amounts.length;
  
  // Use median + 10% buffer (more stable than average)
  return median * 1.1;
}
```

### Predictive Spending
```dart
double predictMonthlySpending(Budget budget, List<Transaction> currentMonth) {
  var daysElapsed = DateTime.now().difference(budget.startDate).inDays;
  var totalDays = budget.endDate.difference(budget.startDate).inDays;
  
  if (daysElapsed == 0) return budget.spent;
  
  var dailyRate = budget.spent / daysElapsed;
  return dailyRate * totalDays;
}
```

### Health Score
```dart
int calculateBudgetHealth(List<Budget> budgets, double income) {
  var adherence = budgets.where((b) => !b.isOverBudget).length / budgets.length;
  var totalBudgeted = budgets.fold(0.0, (sum, b) => sum + b.amount);
  var totalSpent = budgets.fold(0.0, (sum, b) => sum + b.spent);
  var savingsRate = income > 0 ? (income - totalSpent) / income : 0;
  
  return ((adherence * 0.6 + savingsRate * 0.4) * 100).round();
}
```

## 17. Technical Considerations

### Performance
- Cache budget calculations
- Lazy load transaction lists
- Paginate history

### Offline Support
- Queue budget updates
- Sync when online
- Conflict resolution (last-write-wins)

### Data Migration
- Handle budget period transitions
- Archive old budgets
- Preserve history

### Privacy
- Local-only data
- Optional cloud backup
- No third-party analytics

### Accessibility
- Screen reader support
- High contrast mode
- Large text support

## 18. M-PESA Ecosystem Optimizations

### SMS-First Design
- Auto-create budgets from SMS patterns
- Real-time updates on SMS receipt
- No manual transaction entry needed

### Low Data Usage
- Minimal API calls
- Offline-first architecture
- Compressed images

### Kenyan Context
- Default currency: KSh
- Local spending averages
- M-Pesa fee tracking
- Fuliza debt integration

### Mobile Money Features
- Track M-Pesa float
- Agent commission budgets
- Airtime reseller budgets

## 19. Implementation Priority

### Phase 1 (MVP)
- Category-based budgets
- Smart suggestions
- Real-time tracking
- Basic alerts (80%, 100%)

### Phase 2
- Project budgets
- Rollover mechanics
- End-of-month analysis
- Budget health score

### Phase 3
- AI coaching
- Predictive alerts
- Advanced templates
- Savings integration

### Phase 4
- Shared budgets
- Multi-account support
- Export/reports
- Gamification
