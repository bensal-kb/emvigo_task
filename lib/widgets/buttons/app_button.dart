import 'package:emvigo_test/core/base/base_ui/base_ui.dart';
import 'package:emvigo_test/core/styles/app_text_styles.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.uppercase = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool uppercase;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: context.theme.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
        child: isLoading
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2.4, color: context.theme.light),
              )
            : Text(
                uppercase ? label.toUpperCase() : label,
                style: AppTextStyles.body(
                  color: context.theme.light,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
      ),
    );
  }
}
