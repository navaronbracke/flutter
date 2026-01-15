// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// This file defines basic widgets for use in tests for Widgets in `flutter/widgets`.

import 'package:flutter/widgets.dart';

/// Get a color for use in a widget test.
///
/// The returned color will be fully opaque,
/// but the [Color.r], [Color.g], and [Color.b] channels
/// will each be randomized between `00` and `FF`.
Color getTestColor(int index) {
  const colors = [
    Color(0xFFFF0000),
    Color(0xFF00FF00),
    Color(0xFF0000FF),
    Color(0xFFFFFF00),
    Color(0xFFFF00FF),
    Color(0xFF00FFFF),
  ];

  return colors[index % colors.length];
}

/// A [Page] implementation for testing, which does not apply a transition animation
/// and has no [PageRoute.barrierColor].
///
/// See also [TestPageRoute], which is the [PageRoute] version of this class.
class TestPage<T> extends Page<T> {
  const TestPage({
    required this.child,
    this.maintainState = true,
    this.fullscreenDialog = false,
    this.allowSnapshotting = true,
    super.key,
    super.canPop,
    super.onPopInvoked,
    super.name,
    super.arguments,
    super.restorationId,
  });

  final Widget child;
  final bool maintainState;
  final bool fullscreenDialog;
  final bool allowSnapshotting;

  @override
  Route<T> createRoute(BuildContext context) {
    return _PageBasedTestPageRoute<T>(page: this, allowSnapshotting: allowSnapshotting);
  }
}

class _PageBasedTestPageRoute<T> extends PageRoute<T> {
  _PageBasedTestPageRoute({required TestPage<T> page, super.allowSnapshotting})
    : super(settings: page) {
    assert(opaque);
  }

  TestPage<T> get _page => settings as TestPage<T>;

  @override
  bool get maintainState => _page.maintainState;

  @override
  bool get fullscreenDialog => _page.fullscreenDialog;

  @override
  String get debugLabel => '${super.debugLabel}(${_page.name})';

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => 'TestPage barrier';

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return _page.child;
  }

  @override
  Duration get transitionDuration => Duration.zero;
}

/// A [PageRoute] implementation for testing, which does not apply a transition animation
/// and has no [PageRoute.barrierColor].
///
/// See also [TestPage], which is the [Page] version of this class.
class TestPageRoute<T> extends PageRoute<T> {
  TestPageRoute({
    required this.builder,
    super.settings,
    super.requestFocus,
    this.maintainState = true,
    super.fullscreenDialog,
    super.allowSnapshotting = true,
    super.barrierDismissible = false,
    super.traversalEdgeBehavior,
    super.directionalTraversalEdgeBehavior,
  });

  final WidgetBuilder builder;

  @override
  final bool maintainState;

  @override
  String get debugLabel => '${super.debugLabel}(${settings.name})';

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => 'TestPageRoute barrier';

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return builder(context);
  }

  @override
  Duration get transitionDuration => Duration.zero;
}

// TODO(justinmc): replace with `RawButton` or equivalent when available.
/// A very basic button for use in widget tests.
class TestButton extends StatelessWidget {
  const TestButton({
    required this.child,
    this.focusNode,
    this.autofocus = false,
    this.onPressed,
    super.key,
  });

  final bool autofocus;
  final FocusNode? focusNode;
  final VoidCallback? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onPressed != null,
      onTap: onPressed,
      child: FocusableActionDetector(
        enabled: onPressed != null,
        focusNode: focusNode,
        autofocus: autofocus,
        child: GestureDetector(onTap: onPressed, child: child),
      ),
    );
  }
}
