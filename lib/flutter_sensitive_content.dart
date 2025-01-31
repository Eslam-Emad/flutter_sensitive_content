library flutter_sensitive_content;

import 'package:flutter/widgets.dart';

import 'lazy_indexed_stack.dart';

class SensitiveContent extends StatefulWidget {
  /// Protect you sensitive content with SensitiveContent widget.
  /// It listen for AppLifecycle states, when the app goes in background switch
  /// from child content to publicContent content.
  const SensitiveContent(
      {Key? key,
      required this.child,
      required this.publicContent,
      this.lazy = true})
      : super(key: key);

  final Widget child;
  final Widget publicContent;

  /// lazy loading prevent destroy widget data when rebuild
  final bool lazy;

  @override
  State<SensitiveContent> createState() => _SensitiveContentState();
}

class _SensitiveContentState extends State<SensitiveContent>
    with WidgetsBindingObserver {
  // This variable will tell you whether the application is in foreground or not.
  bool _isInForeground = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint("AppLifecycleState: $state");
    setState(() {
      _isInForeground = (state == AppLifecycleState.resumed);
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.lazy
        ? LazyIndexedStack(
            index: _isInForeground ? 0 : 1,
            children: [widget.child, widget.publicContent],
          )
        : Container(
            child: (_isInForeground) ? widget.child : widget.publicContent,
          );
  }
}
