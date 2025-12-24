import 'package:flutter/material.dart';

/// Tenant switcher widget for multi-tenant apps
class TenantSwitcher extends StatelessWidget {
  /// Creates a tenant switcher
  const TenantSwitcher({
    required this.currentTenantId,
    required this.tenants,
    required this.onTenantChanged,
    super.key,
  });

  /// Current tenant ID
  final String currentTenantId;
  
  /// List of available tenants
  final List<Map<String, String>> tenants;
  
  /// Callback when tenant is changed
  final void Function(String tenantId) onTenantChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: currentTenantId,
      items: tenants.map((tenant) {
        return DropdownMenuItem<String>(
          value: tenant['id']!,
          child: Text(tenant['name']!),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          onTenantChanged(value);
        }
      },
    );
  }
}
