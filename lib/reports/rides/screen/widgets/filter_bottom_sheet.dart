import 'package:flutter/material.dart';
import '../../model/ride_model.dart';

class FilterBottomSheet extends StatefulWidget {
  final RideStatus? initialStatus;
  final RideType? initialType;
  final DateTimeRange? initialDateRange;
  final Function(RideStatus?, RideType?, DateTimeRange?) onApplyFilters;

  const FilterBottomSheet({
    super.key,
    this.initialStatus,
    this.initialType,
    this.initialDateRange,
    required this.onApplyFilters,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late RideStatus? _selectedStatus;
  late RideType? _selectedType;
  DateTimeRange? _selectedDateRange;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.initialStatus;
    _selectedType = widget.initialType;
    _selectedDateRange = widget.initialDateRange;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Icon(
              Icons.horizontal_rule_rounded,
              color: Colors.grey,
              size: 40,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Filter Rides',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          // Status Filter
          const Text(
            'Ride Status',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              _buildStatusChip('Completed', RideStatus.completed),
              _buildStatusChip('Cancelled', RideStatus.cancelled),
              _buildStatusChip('Upcoming', RideStatus.upcoming),
            ],
          ),

          const SizedBox(height: 24),

          // Ride Type Filter
          const Text(
            'Ride Type',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              _buildTypeChip('Bike', RideType.bike),
              _buildTypeChip('Auto', RideType.auto),
              _buildTypeChip('Car', RideType.car),
            ],
          ),

          const SizedBox(height: 24),

          // Date Range Filter
          const Text(
            'Date Range',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _selectDateRange,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[100],
              foregroundColor: Colors.black,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.calendar_today, size: 18),
                const SizedBox(width: 8),
                Text(
                  _selectedDateRange != null
                      ? '${_formatDate(_selectedDateRange!.start)} - ${_formatDate(_selectedDateRange!.end)}'
                      : 'Select Date Range',
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    _selectedStatus = null;
                    _selectedType = null;
                    _selectedDateRange = null;
                    setState(() {});
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Clear All'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onApplyFilters(
                      _selectedStatus,
                      _selectedType,
                      _selectedDateRange,
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Apply Filters',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label, RideStatus status) {
    final isSelected = _selectedStatus == status;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: Colors.orange.withOpacity(0.2),
      labelStyle: TextStyle(
        color: isSelected ? Colors.orange : Colors.black,
        fontWeight: FontWeight.w500,
      ),
      onSelected: (selected) {
        setState(() {
          _selectedStatus = selected ? status : null;
        });
      },
    );
  }

  Widget _buildTypeChip(String label, RideType type) {
    final isSelected = _selectedType == type;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: Colors.orange.withOpacity(0.2),
      labelStyle: TextStyle(
        color: isSelected ? Colors.orange : Colors.black,
        fontWeight: FontWeight.w500,
      ),
      onSelected: (selected) {
        setState(() {
          _selectedType = selected ? type : null;
        });
      },
    );
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      currentDate: DateTime.now(),
      saveText: 'Apply',
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}