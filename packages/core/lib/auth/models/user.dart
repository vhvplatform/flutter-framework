import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

/// User model
@JsonSerializable()
class User {
  /// Creates a user
  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.tenantId,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates a user from JSON
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// User ID
  final String id;
  
  /// User email
  final String email;
  
  /// User name
  final String name;
  
  /// Tenant ID
  final String tenantId;
  
  /// Creation timestamp
  final DateTime createdAt;
  
  /// Last update timestamp
  final DateTime updatedAt;

  /// Converts user to JSON
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
