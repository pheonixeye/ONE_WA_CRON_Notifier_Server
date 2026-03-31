// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class Job extends Equatable {
  final String id;
  final void Function() callback;
  final DateTime exec;

  const Job({
    required this.id,
    required this.callback,
    required this.exec,
  });

  @override
  List<Object> get props => [id, callback, exec];
}
