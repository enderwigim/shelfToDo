// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
      title: json['title'] as String,
      completed: json['completed'] as bool? ?? false,
    )
      ..description = json['description'] as String?
      ..deadLine = json['deadLine'] == null
          ? null
          : DateTime.parse(json['deadLine'] as String);

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'completed': instance.completed,
      'deadLine': instance.deadLine?.toIso8601String(),
    };
