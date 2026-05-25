import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class CustomNotificationCard extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color color;
  final VoidCallback? onDismiss;
  final VoidCallback? onTap;
  final bool showCloseButton;
  final bool showActionButton;
  final String? actionText;
  final Color? backgroundColor;
  final double elevation;
  final bool showTimestamp;
  final DateTime? timestamp;
  final NotificationType? type;
  final double iconSize;
  final bool isRead;

  const CustomNotificationCard({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.notifications,
    this.color = Colors.blue,
    this.onDismiss,
    this.onTap,
    this.showCloseButton = true,
    this.showActionButton = false,
    this.actionText,
    this.backgroundColor,
    this.elevation = 4,
    this.showTimestamp = false,
    this.timestamp,
    this.type,
    this.iconSize = 24,
    this.isRead = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final cardColor = backgroundColor ?? (isDarkMode ? Colors.grey[900] : Colors.white);
    final borderColor = isRead ? Colors.transparent : color.withOpacity(0.3);
    return Card(
      elevation: elevation,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: borderColor,
          width: isRead ? 0 : 1.5,
        ),
      ),
      color: cardColor,
      shadowColor: Colors.black.withOpacity(0.1),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon with status indicator
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          color.withOpacity(0.15),
                          color.withOpacity(0.05),
                        ],
                      ),
                    ),
                    child: Icon(
                      _getIconForType(),
                      color: color,
                      size: iconSize,
                    ),
                  ),
                  if (!isRead)
                    Positioned(
                      top: -2,
                      right: -2,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.black,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(width: 16),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header row with title and time
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                              fontSize: 16,
                              color: isDarkMode ? Colors.white : Colors.grey[900],
                              letterSpacing: -0.3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (showTimestamp && timestamp != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              _formatTimestamp(timestamp!),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // Message
                    Text(
                      message,
                      style: TextStyle(
                        color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                        fontSize: 14,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 8),

                    // Action button
                    if (showActionButton && actionText != null)
                      SizedBox(
                        height: 32,
                        child: ElevatedButton(
                          onPressed: onTap,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: color.withOpacity(0.1),
                            foregroundColor: color,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          child: Text(actionText!),
                        ),
                      ),
                  ],
                ),
              ),

              // Close button
              if (showCloseButton && onDismiss != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: IconButton(
                    icon: Icon(
                      Icons.close,
                      size: 20,
                      color: Colors.grey[500],
                    ),
                    onPressed: onDismiss,
                    splashRadius: 20,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForType() {
    if (type != null) {
      switch (type) {
        case NotificationType.success:
          return Icons.check_circle;
        case NotificationType.error:
          return Icons.error;
        case NotificationType.warning:
          return Icons.warning;
        case NotificationType.info:
          return Icons.info;
        default:
          return icon;
      }
    }
    return icon;
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.month}/${timestamp.day}';
    }
  }
}

enum NotificationType {
  success,
  error,
  warning,
  info,
  custom,
}

class DismissibleNotificationCard extends StatefulWidget {
  final CustomNotificationCard notification;
  final VoidCallback onDismissed;

  const DismissibleNotificationCard({
    super.key,
    required this.notification,
    required this.onDismissed,
  });

  @override
  State<DismissibleNotificationCard> createState() => _DismissibleNotificationCardState();
}

class _DismissibleNotificationCardState extends State<DismissibleNotificationCard> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.notification.title),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => widget.onDismissed(),
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
          size: 28,
        ),
      ),
      child: widget.notification,
    );
  }
}
