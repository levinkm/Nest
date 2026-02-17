import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/planning_item.dart';

class PlanningItemRow extends StatefulWidget {
  final PlanningItem item;
  final List<PlanningItem> children;
  final String currency;
  final bool isChild;
  final bool isExpanded;
  final Function(PlanningItem) onUpdate;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback? onAddChild;
  final VoidCallback? onToggleExpand;

  const PlanningItemRow({
    super.key,
    required this.item,
    this.children = const [],
    required this.currency,
    this.isChild = false,
    this.isExpanded = true,
    required this.onUpdate,
    required this.onToggle,
    required this.onDelete,
    this.onAddChild,
    this.onToggleExpand,
  });

  @override
  State<PlanningItemRow> createState() => _PlanningItemRowState();
}

class _PlanningItemRowState extends State<PlanningItemRow> {
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
    _estimatedController = TextEditingController(
      text: widget.item.estimatedCost.toStringAsFixed(0),
    );
    _actualController = TextEditingController(
      text: widget.item.actualCost.toStringAsFixed(0),
    );
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

  void _saveField(String field) {
    PlanningItem updated = widget.item;
    switch (field) {
      case 'name':
        if (_nameController.text.isNotEmpty) {
          updated = widget.item.copyWith(name: _nameController.text);
        }
        setState(() => _isEditingName = false);
        break;
      case 'estimated':
        updated = widget.item.copyWith(
          estimatedCost: double.tryParse(_estimatedController.text) ?? 0,
        );
        setState(() => _isEditingEstimated = false);
        break;
      case 'actual':
        updated = widget.item.copyWith(
          actualCost: double.tryParse(_actualController.text) ?? 0,
        );
        setState(() => _isEditingActual = false);
        break;
      case 'notes':
        updated = widget.item.copyWith(notes: _notesController.text);
        setState(() => _isEditingNotes = false);
        break;
    }
    widget.onUpdate(updated);
  }

  @override
  Widget build(BuildContext context) {
    final hasChildren = widget.children.isNotEmpty;
    final childEstimated = widget.children.fold(
      0.0,
      (sum, child) => sum + child.estimatedCost,
    );
    final childActual = widget.children.fold(
      0.0,
      (sum, child) => sum + child.actualCost,
    );
    final totalEstimated = widget.item.estimatedCost + childEstimated;
    final totalActual = widget.item.actualCost + childActual;

    return Container(
      margin: EdgeInsets.only(
        bottom: widget.isChild ? 0 : 8,
        left: widget.isChild ? 32 : 0,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: widget.item.isCompleted
              ? AppColors.income.withValues(alpha: 0.3)
              : Colors.transparent,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          children: [
            Row(
              children: [
                if (hasChildren && !widget.isChild)
                  GestureDetector(
                    onTap: widget.onToggleExpand,
                    child: Icon(
                      widget.isExpanded
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_right,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                  )
                else
                  const SizedBox(width: 20),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: widget.onToggle,
                  child: Icon(
                    widget.item.isCompleted
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    color: widget.item.isCompleted
                        ? AppColors.income
                        : AppColors.textSecondary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: _isEditingName
                      ? TextField(
                          controller: _nameController,
                          autofocus: true,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: widget.isChild ? 14 : 15,
                            fontWeight: widget.isChild
                                ? FontWeight.normal
                                : FontWeight.w600,
                          ),
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none,
                          ),
                          onSubmitted: (_) => _saveField('name'),
                        )
                      : GestureDetector(
                          onTap: () => setState(() => _isEditingName = true),
                          child: Text(
                            widget.item.name.isEmpty
                                ? 'Untitled'
                                : widget.item.name,
                            style: TextStyle(
                              color: widget.item.name.isEmpty
                                  ? AppColors.textSecondary
                                  : AppColors.textPrimary,
                              fontSize: widget.isChild ? 14 : 15,
                              fontWeight: widget.isChild
                                  ? FontWeight.normal
                                  : FontWeight.w600,
                              decoration: widget.item.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ),
                ),
                Expanded(
                  flex: 2,
                  child: _isEditingEstimated
                      ? TextField(
                          controller: _estimatedController,
                          autofocus: true,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.right,
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none,
                          ),
                          onSubmitted: (_) => _saveField('estimated'),
                        )
                      : GestureDetector(
                          onTap: () =>
                              setState(() => _isEditingEstimated = true),
                          child: Text(
                            '${widget.currency} ${totalEstimated.toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
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
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: TextStyle(
                            color: totalActual > 0
                                ? AppColors.primary
                                : AppColors.textSecondary,
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.right,
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none,
                          ),
                          onSubmitted: (_) => _saveField('actual'),
                        )
                      : GestureDetector(
                          onTap: () => setState(() => _isEditingActual = true),
                          child: Text(
                            '${widget.currency} ${totalActual.toStringAsFixed(0)}',
                            style: TextStyle(
                              color: totalActual > 0
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                              fontSize: 13,
                              fontWeight: totalActual > 0
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.more_vert,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                  color: AppColors.surface,
                  onSelected: (value) {
                    if (value == 'add_child') widget.onAddChild?.call();
                    if (value == 'delete') widget.onDelete();
                    if (value == 'add_note') {
                      setState(() => _isEditingNotes = true);
                    }
                  },
                  itemBuilder: (context) => [
                    if (!widget.isChild)
                      const PopupMenuItem(
                        value: 'add_child',
                        child: Row(
                          children: [
                            Icon(
                              Icons.add,
                              size: 18,
                              color: AppColors.textPrimary,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Add sub-item',
                              style: TextStyle(color: AppColors.textPrimary),
                            ),
                          ],
                        ),
                      ),
                    const PopupMenuItem(
                      value: 'add_note',
                      child: Row(
                        children: [
                          Icon(
                            Icons.note_add,
                            size: 18,
                            color: AppColors.textPrimary,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Add note',
                            style: TextStyle(color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 18, color: AppColors.error),
                          SizedBox(width: 8),
                          Text(
                            'Delete',
                            style: TextStyle(color: AppColors.error),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (widget.item.notes.isNotEmpty || _isEditingNotes)
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 36),
                child: _isEditingNotes
                    ? TextField(
                        controller: _notesController,
                        autofocus: true,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                        decoration: const InputDecoration(
                          isDense: true,
                          hintText: 'Add a note...',
                          hintStyle: TextStyle(color: AppColors.textSecondary),
                          border: InputBorder.none,
                        ),
                        onSubmitted: (_) => _saveField('notes'),
                      )
                    : GestureDetector(
                        onTap: () => setState(() => _isEditingNotes = true),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.item.notes,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
              ),
          ],
        ),
      ),
    );
  }
}
