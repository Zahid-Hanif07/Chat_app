class ChatThread {
  final String id;
  final String name;
  final String avatarUrl;
  final bool isOnline;
  final String lastMessage;
  final DateTime? lastMessageTime;
  final int unreadCount;

  ChatThread({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.isOnline,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
  });

  // Display time for ChatListItem
  String get time {
    if (lastMessageTime == null) {
      return '';
    }

    final now = DateTime.now();

    if (lastMessageTime!.year == now.year &&
        lastMessageTime!.month == now.month &&
        lastMessageTime!.day == now.day) {
      final hour = lastMessageTime!.hour > 12
          ? lastMessageTime!.hour - 12
          : lastMessageTime!.hour;

      final displayHour = hour == 0 ? 12 : hour;

      final minute = lastMessageTime!.minute.toString().padLeft(2, '0');

      final period = lastMessageTime!.hour >= 12 ? 'PM' : 'AM';

      return '$displayHour:$minute $period';
    }

    return '${lastMessageTime!.day}/${lastMessageTime!.month}';
  }
}
