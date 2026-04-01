// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:timezone/timezone.dart' as tz;

class Job extends Equatable {
  final String id;
  final void Function() callback;
  final DateTime exec;
  final String locationName; // e.g., 'America/New_York'

  const Job({
    required this.id,
    required this.callback,
    required this.exec,
    required this.locationName,
  });

  @override
  List<Object> get props => [
        id,
        callback,
        exec,
        locationName,
      ];

  /// Calculates the next occurrence of this task in its specific timezone
  tz.TZDateTime getNextOccurrence() {
    final location = tz.getLocation(locationName);
    final now = tz.TZDateTime.now(location);

    var scheduledDate = tz.TZDateTime(
      location,
      exec.year,
      exec.month,
      exec.day,
      exec.hour,
      exec.minute,
    );

    // If the time has already passed today, schedule for one hour later
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(hours: 1));
    }

    return scheduledDate;
  }
}
