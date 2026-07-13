import 'package:emvigo_test/core/base/base_ui/base_ui.dart';

class BasePage<B extends StateStreamableSource> extends StatelessWidget {
  const BasePage({
    super.key,
    this.child,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomSheet,
    this.bottomNavigationBar,
    this.decoration,
    this.backgroundColor,
    this.onPopInvoked,
    this.onRefresh,
    this.hasSafeArea = true,
    this.safeAreaBottom = false,
    this.canPop = true,
    this.resizeToAvoidBottomInset = true,
    this.extendBody,
  });

  final Widget? child;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomSheet;
  final Widget? bottomNavigationBar;
  final Decoration? decoration;
  final Color? backgroundColor;
  final PopInvokedWithResultCallback<dynamic>? onPopInvoked;
  final Future<void> Function()? onRefresh;
  final bool hasSafeArea;
  final bool safeAreaBottom;
  final bool canPop;
  final bool resizeToAvoidBottomInset;
  final bool? extendBody;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: context.removeFocus,
      child: Container(
        decoration: decoration ?? BoxDecoration(color: backgroundColor ?? context.theme.light),
        child: PopScope(
          canPop: canPop,
          onPopInvokedWithResult: onPopInvoked,
          child: _safeAreaWrapper(
            child: Scaffold(
              appBar: appBar,
              backgroundColor: context.theme.transparent,
              extendBody: extendBody ?? false,
              resizeToAvoidBottomInset: resizeToAvoidBottomInset,
              floatingActionButton: floatingActionButton,
              floatingActionButtonLocation: floatingActionButtonLocation,
              body: _refreshWrapper(child: child ?? const SizedBox.shrink()),
              bottomSheet: bottomSheet,
              bottomNavigationBar: bottomNavigationBar,
            ),
          ),
        ),
      ),
    );
  }

  Widget _safeAreaWrapper({required Widget child}) {
    if (!hasSafeArea) return child;
    return SafeArea(bottom: safeAreaBottom, child: child);
  }

  Widget _refreshWrapper({required Widget child}) {
    if (onRefresh == null) return child;
    return RefreshIndicator(onRefresh: onRefresh!, child: child);
  }
}
