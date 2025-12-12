import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;
  final Widget? leading;
  final Color? backgroundColor;
  final Color? titleColor;
  final double elevation;
  final bool centerTitle;
  final VoidCallback? onBackPressed;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.showBackButton = true,
    this.actions,
    this.leading,
    this.backgroundColor,
    this.titleColor,
    this.elevation = 0,
    this.centerTitle = true,
    this.onBackPressed,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: backgroundColor ?? theme.appBarTheme.backgroundColor,
      elevation: elevation,
      centerTitle: centerTitle,
      leading: showBackButton
          ? (leading ??
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: onBackPressed ?? () => Navigator.pop(context),
            color: titleColor ?? theme.appBarTheme.iconTheme?.color,
          ))
          : null,
      title: Text(
        title,
        style: theme.appBarTheme.titleTextStyle?.copyWith(
          color: titleColor,
        ),
      ),
      actions: actions,
      automaticallyImplyLeading: showBackButton,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
    );
  }
}

// Custom app bar with search
class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback? onSearch;
  final String hintText;
  final bool showBackButton;
  final List<Widget>? actions;

  const SearchAppBar({
    Key? key,
    required this.controller,
    required this.onChanged,
    this.onSearch,
    this.hintText = 'Search...',
    this.showBackButton = true,
    this.actions,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: theme.appBarTheme.backgroundColor,
      elevation: 0,
      leading: showBackButton
          ? IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      )
          : null,
      title: Container(
        height: 40,
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          onSubmitted: (_) => onSearch?.call(),
          decoration: InputDecoration(
            hintText: hintText,
            border: InputBorder.none,
            prefixIcon: const Icon(Icons.search, size: 20),
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            isDense: true,
          ),
          style: theme.textTheme.bodyMedium,
        ),
      ),
      actions: actions,
      automaticallyImplyLeading: showBackButton,
    );
  }
}

// Custom app bar with tabs
class TabbedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<String> tabs;
  final TabController? tabController;
  final int selectedIndex;
  final ValueChanged<int>? onTabChanged;
  final bool showBackButton;
  final List<Widget>? actions;

  const TabbedAppBar({
    Key? key,
    required this.title,
    required this.tabs,
    this.tabController,
    this.selectedIndex = 0,
    this.onTabChanged,
    this.showBackButton = true,
    this.actions,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight * 1.5);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: theme.appBarTheme.backgroundColor,
      elevation: 0,
      leading: showBackButton
          ? IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      )
          : null,
      title: Text(title),
      actions: actions,
      bottom: TabBar(
        controller: tabController,
        tabs: tabs.map((tab) => Tab(text: tab)).toList(),
        onTap: onTabChanged,
        indicatorColor: theme.primaryColor,
        labelColor: theme.primaryColor,
        unselectedLabelColor: theme.unselectedWidgetColor,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
      automaticallyImplyLeading: showBackButton,
    );
  }
}