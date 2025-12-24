import 'package:json_annotation/json_annotation.dart';

part 'tokens.g.dart';

/// Authentication tokens
@JsonSerializable()
class Tokens {
  /// Creates tokens
  const Tokens({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });

  /// Creates tokens from JSON
  factory Tokens.fromJson(Map<String, dynamic> json) => 
      _$TokensFromJson(json);

  /// Access token for API requests
  final String accessToken;
  
  /// Refresh token for obtaining new access tokens
  final String refreshToken;
  
  /// Expiration time in seconds
  final int expiresIn;

  /// Converts tokens to JSON
  Map<String, dynamic> toJson() => _$TokensToJson(this);
}
