/// Code generator utilities to speed up development
/// Generate boilerplate code for common patterns
class CodeGenerator {
  /// Generate a new module template
  static String generateModule(String moduleName) {
    final className = _toPascalCase(moduleName);
    final fileName = _toSnakeCase(moduleName);
    
    return '''
import '../modules/module.dart';
import '../di/service_locator.dart';
import '../navigation/router.dart';

/// $className module
class ${className}Module extends AppModule {
  @override
  String get name => '$moduleName';

  @override
  String get version => '1.0.0';

  @override
  List<String> get dependencies => [];

  @override
  Future<void> initialize() async {
    // Register services
    final sl = ServiceLocator.instance;
    
    // TODO: Register your repositories and services
    // sl.registerLazySingleton<${className}Repository>(() => ${className}Repository());
    // sl.registerLazySingleton<${className}Service>(() => ${className}Service());
  }

  @override
  List<AppRoute> registerRoutes() {
    return [
      // TODO: Add your routes
      // AppRoute(
      //   path: '/$fileName',
      //   name: '$fileName',
      //   builder: (context) => ${className}Screen(),
      // ),
    ];
  }

  @override
  void dispose() {
    // Clean up resources
  }
}
''';
  }

  /// Generate a new screen template
  static String generateScreen(String screenName) {
    final className = _toPascalCase(screenName);
    
    return '''
import 'package:flutter/material.dart';

/// $className screen
class ${className}Screen extends StatefulWidget {
  const ${className}Screen({super.key});

  @override
  State<${className}Screen> createState() => _${className}ScreenState();
}

class _${className}ScreenState extends State<${className}Screen> {
  @override
  void initState() {
    super.initState();
    // TODO: Initialize state
  }

  @override
  void dispose() {
    // TODO: Dispose resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('$screenName'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('$className Screen'),
            // TODO: Add your content
          ],
        ),
      ),
    );
  }
}
''';
  }

  /// Generate a new repository template
  static String generateRepository(String entityName) {
    final className = _toPascalCase(entityName);
    
    return '''
import '../api/api_client.dart';

/// Repository for $className operations
class ${className}Repository {
  final ApiClient _apiClient;

  ${className}Repository({ApiClient? apiClient}) 
      : _apiClient = apiClient ?? ServiceLocator.instance.get<ApiClient>();

  /// Get all ${entityName}s
  Future<List<$className>> getAll() async {
    final response = await _apiClient.get<List<dynamic>>('/${_toSnakeCase(entityName)}s');
    return response.data!.map((json) => ${className}.fromJson(json)).toList();
  }

  /// Get $entityName by ID
  Future<$className> getById(String id) async {
    final response = await _apiClient.get<Map<String, dynamic>>('/${_toSnakeCase(entityName)}s/\$id');
    return ${className}.fromJson(response.data!);
  }

  /// Create new $entityName
  Future<$className> create(Map<String, dynamic> data) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/${_toSnakeCase(entityName)}s',
      data: data,
    );
    return ${className}.fromJson(response.data!);
  }

  /// Update $entityName
  Future<$className> update(String id, Map<String, dynamic> data) async {
    final response = await _apiClient.put<Map<String, dynamic>>(
      '/${_toSnakeCase(entityName)}s/\$id',
      data: data,
    );
    return ${className}.fromJson(response.data!);
  }

  /// Delete $entityName
  Future<void> delete(String id) async {
    await _apiClient.delete('/${_toSnakeCase(entityName)}s/\$id');
  }
}
''';
  }

  /// Generate a new service template
  static String generateService(String serviceName) {
    final className = _toPascalCase(serviceName);
    
    return '''
/// Service for $className business logic
class ${className}Service {
  final ${className}Repository _repository;

  ${className}Service({${className}Repository? repository})
      : _repository = repository ?? ServiceLocator.instance.get<${className}Repository>();

  // TODO: Add your business logic methods
}
''';
  }

  /// Generate a new model template
  static String generateModel(String modelName, Map<String, String> fields) {
    final className = _toPascalCase(modelName);
    
    final fieldDeclarations = fields.entries
        .map((e) => '  final ${e.value} ${e.key};')
        .join('\n');
    
    final constructorParams = fields.entries
        .map((e) => '    required this.${e.key},')
        .join('\n');
    
    final fromJsonFields = fields.entries
        .map((e) => "      ${e.key}: json['${e.key}'] as ${e.value},")
        .join('\n');
    
    final toJsonFields = fields.entries
        .map((e) => "      '${e.key}': ${e.key},")
        .join('\n');
    
    return '''
import 'package:json_annotation/json_annotation.dart';

part '${_toSnakeCase(modelName)}.g.dart';

@JsonSerializable()
class $className {
$fieldDeclarations

  $className({
$constructorParams
  });

  factory ${className}.fromJson(Map<String, dynamic> json) => _\$${className}FromJson(json);

  Map<String, dynamic> toJson() => _\$${className}ToJson(this);
}
''';
  }

  static String _toPascalCase(String input) {
    return input
        .split(RegExp(r'[_\s-]'))
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join('');
  }

  static String _toSnakeCase(String input) {
    return input
        .replaceAllMapped(
          RegExp(r'([A-Z])'),
          (match) => '_${match.group(1)!.toLowerCase()}',
        )
        .replaceAll(RegExp(r'^_'), '')
        .replaceAll(RegExp(r'[_\s-]+'), '_')
        .toLowerCase();
  }
}
