import 'dart:async';

import '../models/job.dart';

final _now = DateTime.now();
const _duration = Duration(seconds: 5);

class Scheduler {
  Scheduler() {
    if (_execStarted) {
      return;
    } else {
      _exec();
    }
  }

  static final List<Job> _jobs = [];

  void register(Job job) {
    print('called register(${job.id})');
    _jobs.add(job);
    print('jobs.length(${_jobs.length})');
  }

  static DateTime get secondlessNow => DateTime(
        _now.year,
        _now.month,
        _now.day,
        _now.hour,
        _now.minute,
      );

  static bool _execStarted = false;

  static void _exec() {
    _execStarted = true;
    Timer.periodic(_duration, (_) {
      for (var i = 0; i < _jobs.length; i++) {
        final job = _jobs[i];
        print('called _exec(${job.id})');

        if (job.exec.isAtSameMomentAs(secondlessNow)) {
          job.callback();
        }
        if (job.exec.isAfter(secondlessNow)) {
          _jobs.removeAt(i);
        }
      }
    });
  }
}
