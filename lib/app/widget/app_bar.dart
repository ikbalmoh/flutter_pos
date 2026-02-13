import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart'
    show
        BuildContext,
        Column,
        MainAxisSize,
        PreferredSize,
        PreferredSizeWidget,
        Size,
        State,
        Widget;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selleri/shared/provider/connectivity_status_provider.dart';
import 'package:selleri/shared/widget/connection_baner_widget.dart';

class AppBar extends ConsumerStatefulWidget implements PreferredSizeWidget {
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Widget? title;
  final List<Widget>? actions;
  final Widget? flexibleSpace;
  final PreferredSizeWidget? bottom;
  final double? elevation;
  final double? scrolledUnderElevation;
  final bool Function(material.ScrollNotification) notificationPredicate;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final material.ShapeBorder? shape;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final material.IconThemeData? iconTheme;
  final material.IconThemeData? actionsIconTheme;
  final bool primary;
  final bool? centerTitle;
  final bool excludeHeaderSemantics;
  final double? titleSpacing;
  final double toolbarOpacity;
  final double bottomOpacity;
  final double? toolbarHeight;
  final double? leadingWidth;
  final material.TextStyle? toolbarTextStyle;
  final material.TextStyle? titleTextStyle;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final material.EdgeInsetsGeometry? actionsPadding;
  final bool forceMaterialTransparency;
  final material.Clip? clipBehavior;
  final bool hideBottom;

  const AppBar({
    super.key,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.title,
    this.actions,
    this.flexibleSpace,
    this.bottom,
    this.elevation,
    this.scrolledUnderElevation,
    this.notificationPredicate = material.defaultScrollNotificationPredicate,
    this.shadowColor,
    this.surfaceTintColor,
    this.shape,
    this.backgroundColor,
    this.foregroundColor,
    this.iconTheme,
    this.actionsIconTheme,
    this.primary = true,
    this.centerTitle,
    this.excludeHeaderSemantics = false,
    this.titleSpacing,
    this.toolbarOpacity = 1.0,
    this.bottomOpacity = 1.0,
    this.toolbarHeight,
    this.leadingWidth,
    this.toolbarTextStyle,
    this.titleTextStyle,
    this.systemOverlayStyle,
    this.actionsPadding,
    this.forceMaterialTransparency = false,
    this.clipBehavior,
    this.hideBottom = false,
  });

  static bool isConnected = true;

  @override
  ConsumerState<AppBar> createState() => _AppBarState();

  @override
  Size get preferredSize {
    // Base toolbar height
    final double toolbarH = toolbarHeight ?? material.kToolbarHeight;

    double bottomH = 0;

    if (hideBottom) {
      bottomH = 0;
    } else if (isConnected) {
      bottomH = bottom?.preferredSize.height ?? 0;
    } else {
      // Disconnected
      bottomH = (bottom?.preferredSize.height ?? 0) + 30; // 30 for banner
    }

    return Size.fromHeight(toolbarH + bottomH);
  }
}

class _AppBarState extends ConsumerState<AppBar> {
  @override
  Widget build(BuildContext context) {
    AppBar.isConnected =
        ref.watch(connectivityStatusProvider) == ConnectivityState.connected;

    PreferredSizeWidget? effectiveBottom;

    if (widget.hideBottom) {
      effectiveBottom = null;
    } else if (AppBar.isConnected) {
      effectiveBottom = widget.bottom;
    } else {
      // Disconnected: Show banner
      effectiveBottom = PreferredSize(
        preferredSize: Size.fromHeight(
          (widget.bottom?.preferredSize.height ?? 0) + 30, // 30 is banner height
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.bottom != null) widget.bottom!,
            const ConnectionBanerWidget(),
          ],
        ),
      );
    }

    return material.AppBar(
      leading: widget.leading,
      automaticallyImplyLeading: widget.automaticallyImplyLeading,
      title: widget.title,
      actions: widget.actions,
      flexibleSpace: widget.flexibleSpace,
      bottom: effectiveBottom,
      elevation: widget.elevation,
      scrolledUnderElevation: widget.scrolledUnderElevation,
      notificationPredicate: widget.notificationPredicate,
      shadowColor: widget.shadowColor,
      surfaceTintColor: widget.surfaceTintColor,
      shape: widget.shape,
      backgroundColor: widget.backgroundColor,
      foregroundColor: widget.foregroundColor,
      iconTheme: widget.iconTheme,
      actionsIconTheme: widget.actionsIconTheme,
      primary: widget.primary,
      centerTitle: widget.centerTitle,
      excludeHeaderSemantics: widget.excludeHeaderSemantics,
      titleSpacing: widget.titleSpacing,
      toolbarOpacity: widget.toolbarOpacity,
      bottomOpacity: widget.bottomOpacity,
      toolbarHeight: widget.toolbarHeight,
      leadingWidth: widget.leadingWidth,
      toolbarTextStyle: widget.toolbarTextStyle,
      titleTextStyle: widget.titleTextStyle,
      systemOverlayStyle: widget.systemOverlayStyle,
      actionsPadding: widget.actionsPadding,
      forceMaterialTransparency: widget.forceMaterialTransparency,
      clipBehavior: widget.clipBehavior,
    );
  }
}
