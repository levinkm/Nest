class PlanningItem {
  final String id;
  final String name;
  final double estimatedCost;
  final double actualCost;
  final String notes;
  final bool isCompleted;
  final String? parentId;
  final int sortOrder;
  final String? tag;
  final int quantity;

  PlanningItem({
    required this.id,
    required this.name,
    required this.estimatedCost,
    this.actualCost = 0.0,
    this.notes = '',
    this.isCompleted = false,
    this.parentId,
    required this.sortOrder,
    this.tag,
    this.quantity = 1,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'estimated_cost': estimatedCost,
      'actual_cost': actualCost,
      'notes': notes,
      'is_completed': isCompleted ? 1 : 0,
      'parent_id': parentId,
      'sort_order': sortOrder,
      'tag': tag,
      'quantity': quantity,
    };
  }

  factory PlanningItem.fromMap(Map<String, dynamic> map) {
    return PlanningItem(
      id: map['id'],
      name: map['name'],
      estimatedCost: map['estimated_cost'],
      actualCost: map['actual_cost'] ?? 0.0,
      notes: map['notes'] ?? '',
      isCompleted: map['is_completed'] == 1,
      parentId: map['parent_id'],
      sortOrder: map['sort_order'],
      tag: map['tag'],
      quantity: map['quantity'] ?? 1,
    );
  }

  PlanningItem copyWith({
    String? name,
    double? estimatedCost,
    double? actualCost,
    String? notes,
    bool? isCompleted,
    String? parentId,
    int? sortOrder,
    String? tag,
    int? quantity,
  }) {
    return PlanningItem(
      id: id,
      name: name ?? this.name,
      estimatedCost: estimatedCost ?? this.estimatedCost,
      actualCost: actualCost ?? this.actualCost,
      notes: notes ?? this.notes,
      isCompleted: isCompleted ?? this.isCompleted,
      parentId: parentId ?? this.parentId,
      sortOrder: sortOrder ?? this.sortOrder,
      tag: tag ?? this.tag,
      quantity: quantity ?? this.quantity,
    );
  }
}
