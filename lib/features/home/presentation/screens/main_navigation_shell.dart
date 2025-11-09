import 'package:eco_route_mobile_app/core/l10n/app_strings.dart';
import 'package:eco_route_mobile_app/core/widgets/animated_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainNavigationShell extends StatefulWidget {
  final Widget child;
  final String location;

  const MainNavigationShell({
    super.key,
    required this.child,
    required this.location,
  });

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _getCurrentIndex(String location) {
    if (location.startsWith('/home')) {
      return 0;
    } else if (location.startsWith('/tickets')) {
      return 1;
    } else if (location.startsWith('/profile')) {
      return 2;
    }
    return 0;
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/tickets');
        break;
      case 2:
        context.go('/profile');
        break;
    }
  }

  PreferredSizeWidget? _getAppBar(String location) {
    // Home screen doesn't need AppBar as it has its own header
    if (location.startsWith('/home')) {
      return null;
    } else if (location.startsWith('/tickets')) {
      return AppBar(
        title: const Text(AppStrings.ticketsTitle),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
      );
    } else if (location.startsWith('/profile')) {
      return AppBar(
        title: const Text(AppStrings.profileTitle),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getCurrentIndex(widget.location);

    return Scaffold(
      appBar: _getAppBar(widget.location),
      body: widget.child,
      bottomNavigationBar: AnimatedBottomNavBar(
        currentIndex: currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
