import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_helper.dart';
import '../../data/models/planning_item.dart';
import '../../data/datasources/planning_database.dart';

class PlanningPage extends StatefulWidget {
  const PlanningPage({super.key});

  @override
  State<PlanningPage> createState() => _PlanningPageState();
}

class _PlanningPageState extends State<PlanningPage> {
  final _db = PlanningDatabase();
  List<PlanningItem> _items = [];
  String _currency = 'KSh';
  final Set<String> _expandedItems = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final currency = await CurrencyHelper.getCurrency();
    final items = await _db.getAllItems();
    setState(() {
      _currency = currency;
      _items = items;
    });
  }

  List<PlanningItem> get _parentItems =>
      _items.where((item) => item.parentId == null).toList();

  List<PlanningItem> _getChildren(String parentId) =>
      _items.where((item) => item.parentId == parentId).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text(
          'Planning',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: Column(
        children: [
          Expanded(
            child: _items.isEmpty
                ? Center(
                    child: Text(
                      'No planning items yet',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _buildTableHeader(),
                      const SizedBox(height: 8),
                      ..._parentItems.map(
                        (item) => _buildItemWithChildren(item),
                      ),
                    ],
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewItem,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addNewItem({String? parentId}) async {
    final newItem = PlanningItem(
      id: const Uuid().v4(),
      name: '',
      estimatedCost: 0,
      actualCost: 0,
      notes: '',
      parentId: parentId,
      sortOrder: _items.length,
    );
    await _db.insertItem(newItem);
    _loadData();
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const SizedBox(width: 40),
          const Expanded(
            flex: 3,
            child: Text(
              'Item',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Estimated',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text(
              'Actual',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildItemWithChildren(PlanningItem item) {
    final children = _getChildren(item.id);
    final isExpanded = _expandedItems.contains(item.id);
    final hasChildren = children.isNotEmpty;
    final activeChildren = children.where((c) => !c.isCompleted).toList();
    final completedChildren = children.where((c) => c.isCompleted).toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: item.isCompleted
              ? AppColors.income.withOpacity(0.3)
              : Colors.transparent,
        ),
      ),
      child: Column(
        children: [
          _buildItemRow(item, children, isExpanded, hasChildren, false),
          if (isExpanded && activeChildren.isNotEmpty)
            ...activeChildren.map(
              (child) => Column(
                children: [
                  const Divider(
                    height: 1,
                    color: AppColors.border,
                    indent: 12,
                    endIndent: 12,
                  ),
                  _buildItemRow(child, [], false, false, true),
                ],
              ),
            ),
          if (isExpanded && hasChildren)
            Column(
              children: [
                const Divider(
                  height: 1,
                  color: AppColors.border,
                  indent: 12,
                  endIndent: 12,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(44, 8, 12, 8),
                  child: GestureDetector(
                    onTap: () => _addNewItem(parentId: item.id),
                    child: Row(
                      children: [
                        Icon(
                          Icons.add,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Add sub-item',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          else if (!hasChildren && !item.isCompleted)
            Column(
              children: [
                const Divider(
                  height: 1,
                  color: AppColors.border,
                  indent: 12,
                  endIndent: 12,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(44, 8, 12, 8),
                  child: GestureDetector(
                    onTap: () => _addNewItem(parentId: item.id),
                    child: Row(
                      children: [
                        Icon(
                          Icons.add,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Add sub-item',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          if (isExpanded && completedChildren.isNotEmpty)
            Column(
              children: [
                const Divider(
                  height: 1,
                  color: AppColors.border,
                  indent: 12,
                  endIndent: 12,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(44, 8, 12, 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 14,
                        color: AppColors.income,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${completedChildren.length} completed',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                ...completedChildren.map(
                  (child) => Column(
                    children: [
                      const Divider(
                        height: 1,
                        color: AppColors.border,
                        indent: 12,
                        endIndent: 12,
                      ),
                      _buildItemRow(child, [], false, false, true),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildItemRow(
    PlanningItem item,
    List<PlanningItem> children,
    bool isExpanded,
    bool hasChildren,
    bool isChild,
  ) {
    final childEstimated = children.fold(
      0.0,
      (sum, child) => sum + (child.estimatedCost * child.quantity),
    );
    final childActual = children.fold(
      0.0,
      (sum, child) => sum + (child.actualCost * child.quantity),
    );
    // For parent items with children, show parent's own cost + child totals
    // For items without children, show their own costs
    final totalEstimated = hasChildren 
        ? (item.estimatedCost * item.quantity) + childEstimated 
        : (item.estimatedCost * item.quantity);
    final totalActual = hasChildren 
        ? (item.actualCost * item.quantity) + childActual 
        : (item.actualCost * item.quantity);

    return _ItemRowWidget(
      item: item,
      isChild: isChild,
      hasChildren: hasChildren,
      isExpanded: isExpanded,
      currency: _currency,
      totalEstimated: totalEstimated,
      totalActual: totalActual,
      onToggleExpand: () {
        setState(() {
          if (isExpanded) {
            _expandedItems.remove(item.id);
          } else {
            _expandedItems.add(item.id);
          }
        });
      },
      onToggle: () async {
        await _toggleComplete(item);
        if (!isChild && hasChildren) {
          final allChildrenComplete = children.every((c) => c.isCompleted);
          if (allChildrenComplete && !item.isCompleted) {
            await _toggleComplete(item);
          }
        }
      },
      onUpdate: (updated) async {
        await _db.updateItem(updated);
        _loadData();
      },
      onDelete: () => _deleteItem(item.id),
    );
  }

  Future<void> _toggleComplete(PlanningItem item) async {
    await _db.updateItem(item.copyWith(isCompleted: !item.isCompleted));

    // Auto-complete parent if all children are complete
    if (item.parentId != null) {
      final parent = _items.firstWhere((i) => i.id == item.parentId);
      final siblings = _getChildren(item.parentId!);
      final allComplete = siblings.every((s) => s.isCompleted);

      if (allComplete && !parent.isCompleted) {
        await _db.updateItem(parent.copyWith(isCompleted: true));
      } else if (!allComplete && parent.isCompleted) {
        await _db.updateItem(parent.copyWith(isCompleted: false));
      }
    }

    _loadData();
  }

  Future<void> _deleteItem(String id) async {
    await _db.deleteItem(id);
    _loadData();
  }
}

class _ItemRowWidget extends StatefulWidget {
  final PlanningItem item;
  final bool isChild;
  final bool hasChildren;
  final bool isExpanded;
  final String currency;
  final double totalEstimated;
  final double totalActual;
  final VoidCallback onToggleExpand;
  final VoidCallback onToggle;
  final Function(PlanningItem) onUpdate;
  final VoidCallback onDelete;

  const _ItemRowWidget({
    required this.item,
    required this.isChild,
    required this.hasChildren,
    required this.isExpanded,
    required this.currency,
    required this.totalEstimated,
    required this.totalActual,
    required this.onToggleExpand,
    required this.onToggle,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<_ItemRowWidget> createState() => _ItemRowWidgetState();
}

class _ItemRowWidgetState extends State<_ItemRowWidget> {
  late TextEditingController _nameController;
  late TextEditingController _estimatedController;
  late TextEditingController _actualController;
  late TextEditingController _notesController;
  bool _isEditingName = false;
  bool _isEditingEstimated = false;
  bool _isEditingActual = false;
  bool _isEditingNotes = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item.name);
    _estimatedController = TextEditingController(text: widget.item.estimatedCost.toStringAsFixed(0));
    _actualController = TextEditingController(text: widget.item.actualCost.toStringAsFixed(0));
    _notesController = TextEditingController(text: widget.item.notes);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _estimatedController.dispose();
    _actualController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(widget.isChild ? 44 : 12, 12, 12, 12),
      child: Column(
        children: [
          Row(
            children: [
              if (widget.hasChildren && !widget.isChild)
                GestureDetector(
                  onTap: widget.onToggleExpand,
                  child: Icon(
                    widget.isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                )
              else if (!widget.isChild)
                const SizedBox(width: 20),
              if (!widget.isChild) const SizedBox(width: 4),
              GestureDetector(
                onTap: widget.onToggle,
                child: Icon(
                  widget.item.isCompleted ? Icons.check_box : Icons.check_box_outline_blank,
                  color: widget.item.isCompleted ? AppColors.income : AppColors.textSecondary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    if (widget.item.quantity > 1)
                      Container(
                        margin: const EdgeInsets.only(right: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(
                          'x${widget.item.quantity}',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    Expanded(
                      child: _isEditingName
                          ? TextField(
                              controller: _nameController,
                              autofocus: true,
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: widget.isChild ? 14 : 15,
                                fontWeight: widget.isChild ? FontWeight.normal : FontWeight.w600,
                              ),
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                              ),
                              onSubmitted: (_) {
                                if (_nameController.text.isNotEmpty) {
                                  widget.onUpdate(widget.item.copyWith(name: _nameController.text));
                                }
                                setState(() => _isEditingName = false);
                              },
                            )
                          : GestureDetector(
                              onLongPress: () => setState(() => _isEditingName = true),
                              child: Text(
                                widget.item.name.isEmpty ? 'Untitled' : widget.item.name,
                                style: TextStyle(
                                  color: widget.item.name.isEmpty ? AppColors.textSecondary : AppColors.textPrimary,
                                  fontSize: widget.isChild ? 14 : 15,
                                  fontWeight: widget.isChild ? FontWeight.normal : FontWeight.w600,
                                  decoration: widget.item.isCompleted ? TextDecoration.lineThrough : null,
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: _isEditingEstimated
                    ? TextField(
                        controller: _estimatedController,
                        autofocus: true,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                        textAlign: TextAlign.right,
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                        ),
                        onSubmitted: (_) {
                          widget.onUpdate(widget.item.copyWith(
                            estimatedCost: double.tryParse(_estimatedController.text) ?? 0,
                          ));
                          setState(() => _isEditingEstimated = false);
                        },
                      )
                    : GestureDetector(
                        onLongPress: () => setState(() => _isEditingEstimated = true),
                        child: Text(
                          '${widget.currency} ${widget.totalEstimated.toStringAsFixed(0)}',
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                          textAlign: TextAlign.right,
                        ),
                      ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: _isEditingActual
                    ? TextField(
                        controller: _actualController,
                        autofocus: true,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          color: widget.totalActual > 0 ? AppColors.primary : AppColors.textSecondary,
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.right,
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                        ),
                        onSubmitted: (_) {
                          widget.onUpdate(widget.item.copyWith(
                            actualCost: double.tryParse(_actualController.text) ?? 0,
                          ));
                          setState(() => _isEditingActual = false);
                        },
                      )
                    : GestureDetector(
                        onLongPress: () => setState(() => _isEditingActual = true),
                        child: Text(
                          '${widget.currency} ${widget.totalActual.toStringAsFixed(0)}',
                          style: TextStyle(
                            color: widget.totalActual > 0 ? AppColors.primary : AppColors.textSecondary,
                            fontSize: 13,
                            fontWeight: widget.totalActual > 0 ? FontWeight.w600 : FontWeight.normal,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
              ),
              if (widget.isChild)
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_horiz, color: AppColors.textSecondary, size: 20),
                  color: AppColors.surface,
                  onSelected: (value) {
                    if (value == 'quantity') _showQuantityPicker(context);
                    if (value == 'note') setState(() => _isEditingNotes = true);
                    if (value == 'tag') _showTagPicker(context);
                    if (value == 'delete') widget.onDelete();
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'quantity',
                      child: Row(
                        children: [
                          Icon(Icons.filter_9_plus, size: 18, color: AppColors.textPrimary),
                          SizedBox(width: 8),
                          Text('Quantity', style: TextStyle(color: AppColors.textPrimary)),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'note',
                      child: Row(
                        children: [
                          Icon(Icons.note_add, size: 18, color: AppColors.textPrimary),
                          SizedBox(width: 8),
                          Text('Add note', style: TextStyle(color: AppColors.textPrimary)),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'tag',
                      child: Row(
                        children: [
                          Icon(Icons.label_outline, size: 18, color: AppColors.textPrimary),
                          SizedBox(width: 8),
                          Text('Add tag', style: TextStyle(color: AppColors.textPrimary)),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 18, color: AppColors.error),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: AppColors.error)),
                        ],
                      ),
                    ),
                  ],
                )
              else
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: AppColors.textSecondary, size: 20),
                  color: AppColors.surface,
                  onSelected: (value) {
                    if (value == 'delete') widget.onDelete();
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 18, color: AppColors.error),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: AppColors.error)),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
          if (widget.item.tag != null || widget.item.notes.isNotEmpty || _isEditingNotes)
            Padding(
              padding: const EdgeInsets.only(top: 6, left: 36),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.item.tag != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getTagColor(widget.item.tag!),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        widget.item.tag!,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  if (widget.item.notes.isNotEmpty || _isEditingNotes)
                    Padding(
                      padding: EdgeInsets.only(top: widget.item.tag != null ? 4 : 0),
                      child: _isEditingNotes
                          ? TextField(
                              controller: _notesController,
                              autofocus: true,
                              style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                              decoration: const InputDecoration(
                                isDense: true,
                                hintText: 'Add note...',
                                hintStyle: TextStyle(color: AppColors.textSecondary),
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                              ),
                              onSubmitted: (_) {
                                widget.onUpdate(widget.item.copyWith(notes: _notesController.text));
                                setState(() => _isEditingNotes = false);
                              },
                            )
                          : GestureDetector(
                              onLongPress: () => setState(() => _isEditingNotes = true),
                              child: Text(
                                widget.item.notes,
                                style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                              ),
                            ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Color _getTagColor(String tag) {
    switch (tag.toLowerCase()) {
      case 'phase 1':
      case 'high':
        return AppColors.error.withOpacity(0.3);
      case 'phase 2':
      case 'medium':
        return AppColors.warning.withOpacity(0.3);
      case 'phase 3':
      case 'low':
        return AppColors.income.withOpacity(0.3);
      default:
        return AppColors.primary.withOpacity(0.3);
    }
  }

  void _showTagPicker(BuildContext context) {
    final tagController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Tag',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: tagController,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Enter tag name',
                hintStyle: const TextStyle(color: AppColors.textSecondary),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.border),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ['Phase 1', 'Phase 2', 'Phase 3', 'High', 'Medium', 'Low']
                    .map((tag) => GestureDetector(
                          onTap: () {
                            widget.onUpdate(widget.item.copyWith(tag: tag));
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getTagColor(tag),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              tag,
                              style: const TextStyle(color: AppColors.textPrimary, fontSize: 12),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
        actions: [
          if (widget.item.tag != null)
            TextButton(
              onPressed: () {
                widget.onUpdate(widget.item.copyWith(tag: ''));
                Navigator.pop(context);
              },
              child: const Text('Remove', style: TextStyle(color: AppColors.error)),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              if (tagController.text.isNotEmpty) {
                widget.onUpdate(widget.item.copyWith(tag: tagController.text));
                Navigator.pop(context);
              }
            },
            child: const Text('Save', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  void _showQuantityPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Quantity', style: TextStyle(color: AppColors.textPrimary)),
        content: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [1, 2, 3, 4, 5, 10]
              .map((qty) => GestureDetector(
                    onTap: () {
                      widget.onUpdate(widget.item.copyWith(quantity: qty));
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: widget.item.quantity == qty
                            ? AppColors.primary
                            : AppColors.primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'x$qty',
                        style: TextStyle(
                          color: widget.item.quantity == qty
                              ? Colors.white
                              : AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
