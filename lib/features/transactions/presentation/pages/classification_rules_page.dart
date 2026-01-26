import 'package:flutter/material.dart';
import '../../../../core/utils/classification_rules.dart';
import '../../../../core/theme/app_colors.dart';

class ClassificationRulesPage extends StatefulWidget {
  const ClassificationRulesPage({super.key});

  @override
  State<ClassificationRulesPage> createState() => _ClassificationRulesPageState();
}

class _ClassificationRulesPageState extends State<ClassificationRulesPage> {
  ClassificationRules? _rules;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadRules();
  }

  Future<void> _loadRules() async {
    final rules = await ClassificationRules.load();
    setState(() {
      _rules = rules;
      _loading = false;
    });
  }

  Future<void> _saveRules() async {
    if (_rules != null) {
      await _rules!.save();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rules saved successfully')),
        );
      }
    }
  }

  Future<void> _resetToDefaults() async {
    setState(() => _rules = ClassificationRules.getDefaults());
    await _saveRules();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Classification Rules',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.textPrimary),
            tooltip: 'Reset to Defaults',
            onPressed: _resetToDefaults,
          ),
          IconButton(
            icon: const Icon(Icons.save, color: AppColors.primary),
            tooltip: 'Save',
            onPressed: _saveRules,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            'Income Keywords',
            'Words that indicate money received',
            _rules!.incomeKeywords.values.expand((e) => e).toList(),
            (keywords) {
              setState(() {
                _rules = ClassificationRules(
                  incomeKeywords: {'custom': keywords},
                  expenseKeywords: _rules!.expenseKeywords,
                  transferKeywords: _rules!.transferKeywords,
                  failureKeywords: _rules!.failureKeywords,
                  categoryKeywords: _rules!.categoryKeywords,
                );
              });
            },
          ),
          _buildSection(
            'Expense Keywords',
            'Words that indicate money spent',
            _rules!.expenseKeywords.values.expand((e) => e).toList(),
            (keywords) {
              setState(() {
                _rules = ClassificationRules(
                  incomeKeywords: _rules!.incomeKeywords,
                  expenseKeywords: {'custom': keywords},
                  transferKeywords: _rules!.transferKeywords,
                  failureKeywords: _rules!.failureKeywords,
                  categoryKeywords: _rules!.categoryKeywords,
                );
              });
            },
          ),
          _buildCategorySection(),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String subtitle, List<String> keywords, Function(List<String>) onUpdate) {
    return Card(
      color: AppColors.surface,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                ...keywords.map((kw) => Chip(
                  label: Text(kw, style: const TextStyle(color: AppColors.textPrimary)),
                  backgroundColor: AppColors.surfaceLight,
                  deleteIconColor: AppColors.error,
                  onDeleted: () {
                    final updated = List<String>.from(keywords)..remove(kw);
                    onUpdate(updated);
                  },
                )),
                ActionChip(
                  label: const Icon(Icons.add, size: 16, color: AppColors.primary),
                  backgroundColor: AppColors.surfaceLight,
                  onPressed: () => _addKeyword(keywords, onUpdate),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection() {
    return Card(
      color: AppColors.surface,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Category Keywords',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const Text(
              'Add merchant names and keywords for each category',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            ..._rules!.categoryKeywords.entries.map((entry) => ExpansionTile(
              title: Text(
                entry.key,
                style: const TextStyle(color: AppColors.textPrimary),
              ),
              iconColor: AppColors.textPrimary,
              collapsedIconColor: AppColors.textSecondary,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Wrap(
                    spacing: 8,
                    children: [
                      ...entry.value.map((kw) => Chip(
                        label: Text(kw, style: const TextStyle(color: AppColors.textPrimary)),
                        backgroundColor: AppColors.surfaceLight,
                        deleteIconColor: AppColors.error,
                        onDeleted: () {
                          final updated = Map<String, List<String>>.from(_rules!.categoryKeywords);
                          updated[entry.key] = List<String>.from(entry.value)..remove(kw);
                          setState(() {
                            _rules = ClassificationRules(
                              incomeKeywords: _rules!.incomeKeywords,
                              expenseKeywords: _rules!.expenseKeywords,
                              transferKeywords: _rules!.transferKeywords,
                              failureKeywords: _rules!.failureKeywords,
                              categoryKeywords: updated,
                            );
                          });
                        },
                      )),
                      ActionChip(
                        label: const Icon(Icons.add, size: 16, color: AppColors.primary),
                        backgroundColor: AppColors.surfaceLight,
                        onPressed: () => _addCategoryKeyword(entry.key, entry.value),
                      ),
                    ],
                  ),
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }

  void _addKeyword(List<String> current, Function(List<String>) onUpdate) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Add Keyword',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: const InputDecoration(
            hintText: 'Enter keyword',
            hintStyle: TextStyle(color: AppColors.textSecondary),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                onUpdate([...current, controller.text.toLowerCase()]);
              }
              Navigator.pop(context);
            },
            child: const Text('Add', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  void _addCategoryKeyword(String category, List<String> current) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          'Add to $category',
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: const InputDecoration(
            hintText: 'e.g., merchant name',
            hintStyle: TextStyle(color: AppColors.textSecondary),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                final updated = Map<String, List<String>>.from(_rules!.categoryKeywords);
                updated[category] = [...current, controller.text.toLowerCase()];
                setState(() {
                  _rules = ClassificationRules(
                    incomeKeywords: _rules!.incomeKeywords,
                    expenseKeywords: _rules!.expenseKeywords,
                    transferKeywords: _rules!.transferKeywords,
                    failureKeywords: _rules!.failureKeywords,
                    categoryKeywords: updated,
                  );
                });
              }
              Navigator.pop(context);
            },
            child: const Text('Add', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}
