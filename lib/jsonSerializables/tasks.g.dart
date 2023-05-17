// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasks.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TasksList _$TasksListFromJson(Map<String, dynamic> json) =>
    TasksList(
      tasks: (json['tasks'] as List<dynamic>)
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TasksListToJson(TasksList instance) =>
    <String, dynamic>{
      'employees': instance.tasks,
    };

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
      id: json['_id'] as String,
      name: json['name'] as String,
      content: json['content'] as String,
      accontableID: json['accontableID'] as String,
    );

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'content': instance.content,
      'accontableID': instance.accontableID,
    };
