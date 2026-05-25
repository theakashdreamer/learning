import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  final bool hasFilters;
  final VoidCallback onClearFilters;

  const EmptyStateWidget({
    super.key,
    required this.hasFilters,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history_toggle_off,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 24),
          Text(
            hasFilters ? 'No rides found' : 'No ride history',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hasFilters
                ? 'Try changing your filters'
                : 'Your ride history will appear here',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          if (hasFilters)
            ElevatedButton(
              onPressed: onClearFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              child: const Text(
                'Clear Filters',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}