import 'package:emvigo_test/core/base/base_ui/base_ui.dart';

class DefaultLoadingWidget extends StatelessWidget {
  const DefaultLoadingWidget({super.key, required this.state, this.color});

  final BaseState state;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: color ?? context.theme.primary,
      ),
    );
  }
}
