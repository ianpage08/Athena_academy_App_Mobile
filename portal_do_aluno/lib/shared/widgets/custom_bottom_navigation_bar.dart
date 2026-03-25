import 'package:flutter/material.dart';

class CustomBottomItem {
  final String label;
  final IconData icon;
  const CustomBottomItem({required this.label, required this.icon});
}

class CustomBottomNavigationBar extends StatelessWidget {
  final int pageIndex;
  final ValueChanged<int> onTap;
  final List<CustomBottomItem> items;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color backgroundColor;
  final Duration animationDuration;

  const CustomBottomNavigationBar({
    super.key,
    required this.pageIndex,
    required this.onTap,
    required this.items,
    this.activeColor,
    this.inactiveColor,
    this.backgroundColor = Colors.white,
    this.animationDuration = const Duration(milliseconds: 400),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedColor = activeColor ?? theme.primaryColor;
    final unselectedColor = inactiveColor ?? theme.hintColor;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      height: 75,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(items.length, (index) {
          final isSelected = index == pageIndex;
          final item = items[index];

          return GestureDetector(
            onTap: () => onTap(index),
            behavior: HitTestBehavior.opaque,
            child: _NavBarItem(
              item: item,
              isSelected: isSelected,
              activeColor: selectedColor,
              inactiveColor: unselectedColor,
              duration: animationDuration,
            ),
          );
        }),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final CustomBottomItem item;
  final bool isSelected;
  final Color activeColor;
  final Color inactiveColor;
  final Duration duration;

  const _NavBarItem({
    required this.item,
    required this.isSelected,
    required this.activeColor,
    required this.inactiveColor,

    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration,
      curve: Curves.elasticOut,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? activeColor.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            item.icon,
            size: 26,
            color: isSelected ? activeColor : inactiveColor,
          ),

          AnimatedSize(
            duration: duration,
            curve: Curves.easeInOut,
            child: SizedBox(
              width: isSelected ? null : 0,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  isSelected ? item.label : "",
                  style: TextStyle(
                    color: activeColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
