import 'package:emvigo_test/core/base/base_ui/base_ui.dart';
import 'package:emvigo_test/core/base/base_ui/widgets/default_error_widget.dart';
import 'package:emvigo_test/core/base/base_ui/widgets/default_loading_widget.dart';

class StateWidget<B extends StateStreamableSource<BaseState>> extends StatelessWidget {
  const StateWidget({
    super.key,
    required this.builder,
    this.loadingBuilder,
    this.errorBuilder,
    this.initialBuilder,
    this.loadingBuilderTopPadding,
    this.retry,
  });

  final BlocWidgetBuilder<BaseState> builder;
  final BlocWidgetBuilder<BaseState>? loadingBuilder;
  final BlocWidgetBuilder<BaseState>? errorBuilder;
  final BlocWidgetBuilder<BaseState>? initialBuilder;
  final double? loadingBuilderTopPadding;
  final VoidCallback? retry;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<B, BaseState>(
      listener: (context, state) {
        if (state.isError) {
          logger.e('$B error: ${state.error?.exception ?? state.error?.message ?? 'Unknown'}');
        }
      },
      builder: (context, state) {
        if (state.isInitial) {
          return initialBuilder?.call(context, state) ?? const SizedBox.shrink();
        }
        if (state.isSuccess) {
          return builder(context, state);
        }
        if (state.isError) {
          return errorBuilder?.call(context, state) ??
              DefaultErrorWidget(state: state, retry: retry);
        }
        // loading
        if (loadingBuilder != null) {
          return loadingBuilder!(context, state);
        }
        return Center(
          child: Padding(
            padding: EdgeInsets.only(top: loadingBuilderTopPadding ?? 0),
            child: DefaultLoadingWidget(state: state),
          ),
        );
      },
    );
  }
}
