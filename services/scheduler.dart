import 'dart:async';

import 'package:timezone/timezone.dart' as tz;

import '../models/job.dart';

class Scheduler {
  //TODO: needs to be reimplemented

  // A sorted list acting as a simple Min-Heap (earliest task first)
  final List<Job> _taskQueue = [];
  Timer? _timer;

  void _resetTimer() {
    // If the timer is already running, stop it to recalculate
    // based on the new "earliest" task in the queue.
    _timer?.cancel();

    if (_taskQueue.isEmpty) return;

    final nextTask = _taskQueue.first;
    final now = DateTime.now();
    final delay = nextTask.exec.difference(now);

    // If the time has already passed, execute immediately (0 delay)
    _timer = Timer(delay.isNegative ? Duration.zero : delay, _executeNext);
  }

  void _executeNext() {
    if (_taskQueue.isEmpty) return;

    final task = _taskQueue.removeAt(0);

    // Execute the action asynchronously so it doesn't block the scheduler
    Future.microtask(task.callback);

    _resetTimer();
  }

  void schedule(Job task) {
    final nextRun = task.getNextOccurrence();

    // Convert the localized 'nextRun' to a simple Duration from 'now'
    final now = tz.TZDateTime.now(tz.getLocation(task.locationName));
    final delay = nextRun.difference(now);

    // print(
    // ignore: lines_longer_than_80_chars
    //     "Scheduling ${task.id} for $nextRun (In ${delay.inHours}h ${delay.inMinutes % 60}m)");

    _timer = Timer(delay, () {
      task.callback();
      // For a daily recurring task, simply reschedule
      schedule(task);
    });
  }
}
