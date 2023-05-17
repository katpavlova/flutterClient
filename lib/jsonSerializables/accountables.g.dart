// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accountables.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountablesList _$AccountablesListFromJson(Map<String, dynamic> json) =>
    AccountablesList(
      accountables: (json['accountables'] as List<dynamic>)
          .map((e) => Accountable.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AccountablesListToJson(AccountablesList instance) =>
    <String, dynamic>{
      'accountables': instance.accountables,
    };

Accountable _$AccountableFromJson(Map<String, dynamic> json) => Accountable(
      id: json['_id'] as String,
      fullName: json['fullName'] as String,
      phone: json['phone'] as int,
      email: json['email'] as String,
    );

Map<String, dynamic> _$AccountableToJson(Accountable instance) => <String, dynamic>{
      '_id': instance.id,
      'fullName': instance.fullName,
      'phone': instance.phone,
      'email': instance.email,
    };
