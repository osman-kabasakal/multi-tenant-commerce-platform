import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:store_user_app/domain/entities/catalog/interval_unit/interval_unit.dart';

class ReservationModel {
  final IntervalUnit intervalUnit;
  final DateTime startDate;
  final Map<String, String> parameters;

  ReservationModel({
    required this.intervalUnit,
    required this.startDate,
    required this.parameters,
  });
}

class ReservationInfoWidget extends StatefulWidget {
  final ReservationModel model;
  final String productId;
  final Function(Map<String, dynamic>) onReservationInfoChanged;

  const ReservationInfoWidget({
    super.key,
    required this.model,
    required this.productId,
    required this.onReservationInfoChanged,
  });

  @override
  State<ReservationInfoWidget> createState() => _ReservationInfoWidgetState();
}

class _ReservationInfoWidgetState extends State<ReservationInfoWidget> {
  String? selectedParameter;
  DateTime? selectedDate;
  DateTime? selectedEndDate;
  String? selectedHour;
  List<String> availableHours = [];

  @override
  void initState() {
    super.initState();
    selectedParameter = widget.model.parameters.isNotEmpty
        ? widget.model.parameters.keys.first
        : null;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? widget.model.startDate,
      firstDate: widget.model.startDate,
      lastDate: DateTime(widget.model.startDate.year + 1),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        // Reset hour when date changes
        selectedHour = null;
      });

      // Update parent component
      _updateReservationInfo();

      // Fetch available hours if necessary
      if (widget.model.intervalUnit != IntervalUnit.day) {
        _fetchAvailableHours(picked);
      }
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen başlangıç saati seçiniz')),
      );
      return;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          selectedEndDate ?? selectedDate!.add(const Duration(days: 1)),
      firstDate: selectedDate!,
      lastDate: DateTime(selectedDate!.year + 1),
    );
    if (picked != null && picked != selectedEndDate) {
      setState(() {
        selectedEndDate = picked;
      });

      // Update parent component
      _updateReservationInfo();
    }
  }

  void _fetchAvailableHours(DateTime date) {
    // This would be an API call in a real application
    // For now, we'll just simulate with some fixed hours
    setState(() {
      availableHours = [
        '09:00',
        '10:00',
        '11:00',
        '12:00',
        '13:00',
        '14:00',
        '15:00',
        '16:00',
        '17:00'
      ];
    });
  }

  void _updateReservationInfo() {
    final Map<String, dynamic> reservationInfo = {
      'parameter': selectedParameter,
      'startDate': selectedDate,
    };

    if (widget.model.intervalUnit == IntervalUnit.day) {
      reservationInfo['endDate'] = selectedEndDate;
    } else {
      reservationInfo['hour'] = selectedHour;
    }

    widget.onReservationInfoChanged(reservationInfo);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.model.parameters.isEmpty &&
        widget.model.intervalUnit != IntervalUnit.day &&
        widget.model.intervalUnit != IntervalUnit.hour) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.model.parameters.isNotEmpty) _buildParameterDropdown(),
          const SizedBox(height: 16),
          if (widget.model.intervalUnit == IntervalUnit.day)
            _buildDayReservation(context)
          else
            _buildHourReservation(context),
        ],
      ),
    );
  }

  Widget _buildParameterDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Products.AdditionalParameter:',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedParameter,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: widget.model.parameters.entries
              .map((entry) => DropdownMenuItem(
                    value: entry.key,
                    child: Text(entry.value),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              selectedParameter = value;
            });
            _updateReservationInfo();
          },
        ),
      ],
    );
  }

  Widget _buildDayReservation(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Products.Reservation.DateFrom:',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _selectDate(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedDate == null
                      ? 'Başlangıç tarihi'
                      : DateFormat('dd MM, yyyy').format(selectedDate!),
                ),
                const Icon(Icons.calendar_today),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Products.Reservation.DateTo:',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _selectEndDate(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedEndDate == null
                      ? 'Bitiş tarihi'
                      : DateFormat('dd MM, yyyy').format(selectedEndDate!),
                ),
                const Icon(Icons.calendar_today),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHourReservation(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Products.Reservation.Date:',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _selectDate(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedDate == null
                      ? 'Tarih Seç'
                      : DateFormat('dd MM, yyyy').format(selectedDate!),
                ),
                const Icon(Icons.calendar_today),
              ],
            ),
          ),
        ),
        if (selectedDate != null && availableHours.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            'Products.Reservation.Hour:',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: availableHours
                .map((hour) => InkWell(
                      onTap: () {
                        setState(() {
                          selectedHour = hour;
                        });
                        _updateReservationInfo();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: selectedHour == hour
                              ? Colors.blue
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          hour,
                          style: TextStyle(
                            color: selectedHour == hour
                                ? Colors.white
                                : Colors.black87,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ],
    );
  }
}
