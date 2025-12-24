import 'package:flutter/material.dart';

/// A customized data table widget
class AppDataTable extends StatelessWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final bool sortAscending;
  final int? sortColumnIndex;
  final double? dataRowHeight;
  final double? headingRowHeight;
  final EdgeInsets? headingPadding;
  final EdgeInsets? cellPadding;

  const AppDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.sortAscending = true,
    this.sortColumnIndex,
    this.dataRowHeight,
    this.headingRowHeight,
    this.headingPadding,
    this.cellPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).dividerColor.withOpacity(0.1),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: columns,
          rows: rows,
          sortAscending: sortAscending,
          sortColumnIndex: sortColumnIndex,
          dataRowHeight: dataRowHeight,
          headingRowHeight: headingRowHeight,
          horizontalMargin: 24,
          columnSpacing: 56,
          headingTextStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }
}
