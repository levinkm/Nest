class TransactionDescriptionHelper {
  static String getCleanDescription(
    String description,
    String? counterparty,
    String type,
  ) {
    // If counterparty exists, use it for clean description
    if (counterparty != null && counterparty.isNotEmpty) {
      // Shorten long counterparty names
      final cleanCounterparty = _shortenCounterparty(counterparty);
      if (type == 'income') {
        return '$cleanCounterparty → M-Pesa';
      } else {
        return 'M-Pesa → $cleanCounterparty';
      }
    }

    // Fallback: Extract counterparty from description
    final desc = description;

    // Check for ZIIDI first
    if (desc.toLowerCase().contains('ziidi')) {
      if (type == 'income') {
        return 'ZIIDI → M-Pesa';
      } else {
        return 'M-Pesa → ZIIDI';
      }
    }

    // For expenses: "sent to NAME" or "paid to NAME"
    if (type == 'expense') {
      final sentToRegex = RegExp(
        r'sent to ([A-Z][A-Z0-9\s&.-]+?)(?:\s+for|\s+\d{10}|\s+on|\.|\s+New)',
        caseSensitive: false,
      );
      final sentMatch = sentToRegex.firstMatch(desc);
      if (sentMatch != null) {
        return 'M-Pesa → ${_shortenCounterparty(sentMatch.group(1)!.trim())}';
      }

      final paidToRegex = RegExp(
        r'paid to ([A-Z][A-Z0-9\s&.-]+?)(?:\s+via|\.|\s+on|\s+New)',
        caseSensitive: false,
      );
      final paidMatch = paidToRegex.firstMatch(desc);
      if (paidMatch != null) {
        return 'M-Pesa → ${_shortenCounterparty(paidMatch.group(1)!.trim())}';
      }

      if (desc.toLowerCase().contains('sent') ||
          desc.toLowerCase().contains('paid')) {
        return 'M-Pesa → Expense';
      }
    }

    // For income: "received...from NAME" or "You have received...from NAME"
    if (type == 'income') {
      final receivedRegex = RegExp(
        r'received\s+ksh[\d,.]+\s+from\s+([A-Z][A-Z\s&.]+?)(?:\s+on|\.|\s+new\s+m)',
        caseSensitive: false,
      );
      final receivedMatch = receivedRegex.firstMatch(desc);
      if (receivedMatch != null) {
        return '${_shortenCounterparty(receivedMatch.group(1)!.trim())} → M-Pesa';
      }

      if (desc.toLowerCase().contains('received') &&
          desc.toLowerCase().contains('ksh')) {
        return 'Income → M-Pesa';
      }
    }

    // Otherwise return the original description (truncated if too long)
    return description.length > 50
        ? '${description.substring(0, 50)}...'
        : description;
  }

  static String _shortenCounterparty(String counterparty) {
    // Remove account numbers from counterparty
    final withoutAccount = counterparty.replaceAll(RegExp(r'\s+\d{7,}'), '');

    // If still too long, truncate
    if (withoutAccount.length > 25) {
      return '${withoutAccount.substring(0, 25)}...';
    }

    return withoutAccount;
  }
}
