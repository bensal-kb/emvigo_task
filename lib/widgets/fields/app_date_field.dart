import 'package:emvigo_test/core/base/base_ui/base_ui.dart';
import 'package:emvigo_test/core/styles/app_text_styles.dart';
import 'package:intl/intl.dart';

class AppDateField extends StatelessWidget {
  const AppDateField({
    super.key,
    required this.date,
    required this.onChanged,
    this.hintText = 'dd-mm-yyyy',
  });

  final DateTime? date;
  final ValueChanged<DateTime> onChanged;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        context.removeFocus();
        final now = DateTime.now();
        final picked = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime(now.year - 18, now.month, now.day),
          firstDate: DateTime(now.year - 100),
          lastDate: now,
        );
        if (picked != null) onChanged(picked);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: context.theme.surface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          date != null ? DateFormat('dd-MM-yyyy').format(date!) : hintText,
          style: AppTextStyles.input(
            color: date != null ? context.theme.text : context.theme.hint,
          ),
        ),
      ),
    );
  }
}
