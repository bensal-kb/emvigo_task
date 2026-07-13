import 'package:emvigo_test/core/base/base_ui/base_ui.dart';

class DefaultErrorWidget extends StatelessWidget {
  const DefaultErrorWidget({super.key, required this.state, this.retry});

  final BaseState state;
  final VoidCallback? retry;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.theme.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: 12, width: double.maxFinite),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              state.error?.message ?? 'Something went wrong!',
              textAlign: TextAlign.center,
            ),
          ),
          if (retry != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: retry,
              style: ElevatedButton.styleFrom(
                backgroundColor: context.theme.primary,
              ),
              child: Text(
                'Tap to retry',
                style: TextStyle(color: context.theme.light),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
