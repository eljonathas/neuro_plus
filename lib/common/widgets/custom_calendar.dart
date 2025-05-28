import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neuro_plus/common/config/theme.dart';
import 'package:neuro_plus/common/services/appointments/appointments_service.dart';
import 'package:neuro_plus/models/appointment.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:neuro_plus/common/widgets/custom_card.dart';

class CustomCalendar extends StatelessWidget {
  final DateTime selectedDate;
  final void Function(DateTime) onDateSelected;

  const CustomCalendar({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final appointments = AppointmentsService.getAllAppointments();

    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: TableCalendar(
          locale: 'pt_BR',
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: selectedDate,
          selectedDayPredicate: (day) => isSameDay(day, selectedDate),
          onDaySelected: (day, _) => onDateSelected(day),
          calendarFormat: CalendarFormat.month,
          daysOfWeekHeight: 32,
          rowHeight: 44,
          eventLoader: (day) => _getEventsForDay(day, appointments),
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextFormatter: (date, locale) {
              final raw = DateFormat(
                'MMMM yyyy',
                locale.toString(),
              ).format(date);
              return raw[0].toUpperCase() + raw.substring(1);
            },
            titleTextStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.gray[950],
            ),
            leftChevronIcon: Icon(
              Icons.chevron_left,
              color: AppColors.blueRibbon[500],
            ),
            rightChevronIcon: Icon(
              Icons.chevron_right,
              color: AppColors.blueRibbon[500],
            ),
          ),
          calendarStyle: CalendarStyle(
            isTodayHighlighted: false,
            selectedDecoration: BoxDecoration(
              color: AppColors.blueRibbon[500],
              shape: BoxShape.circle,
            ),
            selectedTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            weekendTextStyle: TextStyle(
              color: AppColors.gray[950],
              fontWeight: FontWeight.w600,
            ),
            defaultTextStyle: TextStyle(
              color: AppColors.gray[950],
              fontWeight: FontWeight.w600,
            ),
            outsideTextStyle: TextStyle(
              color: AppColors.gray[300],
              fontWeight: FontWeight.w600,
            ),
            markerDecoration: BoxDecoration(
              color: AppColors.blueRibbon[400],
              shape: BoxShape.circle,
            ),
            markerSize: 6,
            markersMaxCount: 3,
          ),
          calendarBuilders: CalendarBuilders(
            dowBuilder: (context, day) {
              const labels = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];
              return Center(
                child: Text(
                  labels[day.weekday % 7],
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  List<Appointment> _getEventsForDay(
    DateTime day,
    List<Appointment> appointments,
  ) {
    return appointments
        .where(
          (appointment) =>
              appointment.date.year == day.year &&
              appointment.date.month == day.month &&
              appointment.date.day == day.day,
        )
        .toList();
  }
}
