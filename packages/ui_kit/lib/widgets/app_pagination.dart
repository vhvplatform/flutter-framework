import 'package:flutter/material.dart';

/// A pagination widget for navigating through pages
class AppPagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;
  final int maxVisiblePages;
  final Color? activeColor;
  final Color? inactiveColor;

  const AppPagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
    this.maxVisiblePages = 5,
    this.activeColor,
    this.inactiveColor,
  });

  List<int> _getVisiblePages() {
    if (totalPages <= maxVisiblePages) {
      return List.generate(totalPages, (i) => i + 1);
    }

    final half = maxVisiblePages ~/ 2;
    int start = currentPage - half;
    int end = currentPage + half;

    if (start < 1) {
      start = 1;
      end = maxVisiblePages;
    } else if (end > totalPages) {
      end = totalPages;
      start = totalPages - maxVisiblePages + 1;
    }

    return List.generate(end - start + 1, (i) => start + i);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeClr = activeColor ?? theme.colorScheme.primary;
    final inactiveClr = inactiveColor ?? theme.textTheme.bodyMedium?.color?.withOpacity(0.6);

    final visiblePages = _getVisiblePages();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Previous button
        IconButton(
          onPressed: currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
          icon: const Icon(Icons.chevron_left),
          color: currentPage > 1 ? activeClr : inactiveClr,
        ),

        // First page
        if (visiblePages.first > 1) ...[
          _PageButton(
            page: 1,
            isActive: currentPage == 1,
            activeColor: activeClr,
            inactiveColor: inactiveClr,
            onTap: () => onPageChanged(1),
          ),
          if (visiblePages.first > 2)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text('...', style: TextStyle(color: inactiveClr)),
            ),
        ],

        // Visible pages
        ...visiblePages.map(
          (page) => _PageButton(
            page: page,
            isActive: currentPage == page,
            activeColor: activeClr,
            inactiveColor: inactiveClr,
            onTap: () => onPageChanged(page),
          ),
        ),

        // Last page
        if (visiblePages.last < totalPages) ...[
          if (visiblePages.last < totalPages - 1)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text('...', style: TextStyle(color: inactiveClr)),
            ),
          _PageButton(
            page: totalPages,
            isActive: currentPage == totalPages,
            activeColor: activeClr,
            inactiveColor: inactiveClr,
            onTap: () => onPageChanged(totalPages),
          ),
        ],

        // Next button
        IconButton(
          onPressed:
              currentPage < totalPages ? () => onPageChanged(currentPage + 1) : null,
          icon: const Icon(Icons.chevron_right),
          color: currentPage < totalPages ? activeClr : inactiveClr,
        ),
      ],
    );
  }
}

class _PageButton extends StatelessWidget {
  final int page;
  final bool isActive;
  final Color activeColor;
  final Color? inactiveColor;
  final VoidCallback onTap;

  const _PageButton({
    required this.page,
    required this.isActive,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Material(
        color: isActive ? activeColor : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            child: Text(
              '$page',
              style: TextStyle(
                color: isActive ? Colors.white : inactiveColor,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
