import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_colors.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;

  const AppBottomNav({super.key, required this.currentIndex});

  static const _routes = [
    '/',
    '/search',
    '/map',
    '/favorites',
    '/skin-profile'
  ];

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.home_filled, 'Home'),
      (Icons.search, 'Search'),
      (Icons.map_outlined, 'Map'),
      (Icons.favorite_border, 'Favorites'),
      (Icons.person_outline, 'Profile'),
    ];

    return SafeArea(
      top: false,
      child: Container(
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.borderGrey)),
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final selected = index == currentIndex;

            return Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () {
                  final route = _routes[index];
                  if (GoRouterState.of(context).uri.path != route) {
                    context.go(route);
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      padding: EdgeInsets.symmetric(
                        horizontal: selected ? 14 : 0,
                        vertical: selected ? 7 : 0,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? const Color(0xFF42D8BC)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Icon(
                        item.$1,
                        size: 20,
                        color: selected
                            ? const Color(0xFF063D36)
                            : AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.$2,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: selected
                            ? const Color(0xFF063D36)
                            : AppColors.textDark,
                        fontSize: 10,
                        fontWeight:
                            selected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
