import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/planning_item.dart';

class PlanningItemDialog extends StatefulWidget {
  final PlanningItem? item;
  final String? parentId;

  const PlanningItemDialog({super.key, this.item, this.parentId});

  @override
  State<PlanningItemDialog> createState() => _PlanningItemDialogState();
}

class _PlanningItemDialogState extends State<PlanningItemDialog> {
  late TextEditingController _nameController;
  late TextEditingController _estimatedController;
  late TextEditingController _actualController;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item?.name ?? '');
    _estimatedController = TextEditingController(
      text: widget.item?.estimatedCost.toStringAsFixed(0) ?? '',
    );
    _actualController = TextEditingController(
      text: widget.item?.actualCost.toStringAsFixed(0) ?? '0',
    );
    _notesController = TextEditingController(text: widget.item?.notes ?? '');
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
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.item == null ? 'Add Planning Item' : 'Edit Planning Item',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                labelText: 'Item Name',
                labelStyle: const TextStyle(color: AppColors.textSecondary),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.border),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.primary),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _estimatedController,
                    style: const TextStyle(color: AppColors.textPrimary),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      labelText: 'Estimated Cost',
                      labelStyle: const TextStyle(
                        color: AppColors.textSecondary,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: AppColors.border),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: AppColors.primary),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _actualController,
                    style: const TextStyle(color: AppColors.textPrimary),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      labelText: 'Actual Cost',
                      labelStyle: const TextStyle(
                        color: AppColors.textSecondary,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: AppColors.border),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: AppColors.primary),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _notesController,
              style: const TextStyle(color: AppColors.textPrimary),
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Notes',
                labelStyle: const TextStyle(color: AppColors.textSecondary),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.border),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.primary),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _save() {
    if (_nameController.text.isEmpty || _estimatedController.text.isEmpty) {
      return;
    }

    final item =
        widget.item?.copyWith(
          name: _nameController.text,
          estimatedCost: double.parse(_estimatedController.text),
          actualCost: double.parse(
            _actualController.text.isEmpty ? '0' : _actualController.text,
          ),
          notes: _notesController.text,
        ) ??
        PlanningItem(
          id: '',
          name: _nameController.text,
          estimatedCost: double.parse(_estimatedController.text),
          actualCost: double.parse(
            _actualController.text.isEmpty ? '0' : _actualController.text,
          ),
          notes: _notesController.text,
          parentId: widget.parentId,
          sortOrder: 0,
        );

    Navigator.pop(context, item);
  }
}
