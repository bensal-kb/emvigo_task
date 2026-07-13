import 'package:emvigo_test/core/base/base_ui/base_ui.dart';
import 'package:emvigo_test/core/styles/app_text_styles.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.hintText,
    required this.onChanged,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
  });

  final String hintText;
  final ValueChanged<String> onChanged;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: AppTextStyles.input(color: context.theme.text),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyles.input(color: context.theme.hint),
        filled: true,
        fillColor: context.theme.surface,
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: context.theme.primary, width: 1.5),
        ),
      ),
    );
  }
}
