import 'package:go_router/go_router.dart';
import 'package:emvigo_test/core/base/base_ui/base_page.dart';
import 'package:emvigo_test/core/base/base_ui/base_ui.dart';
import 'package:emvigo_test/core/router/app_routes.dart';
import 'package:emvigo_test/core/styles/app_text_styles.dart';
import 'package:emvigo_test/widgets/buttons/app_button.dart';
import 'package:emvigo_test/widgets/fields/app_date_field.dart';
import 'package:emvigo_test/widgets/fields/app_dropdown_field.dart';
import 'package:emvigo_test/widgets/fields/app_text_field.dart';

import '../bloc/create_profile_cubit/create_profile_cubit.dart';

const _nationalities = [
  'Indian',
  'American',
  'British',
  'Canadian',
  'Australian',
  'Other',
];
const _languages = ['English', 'Hindi', 'Spanish', 'French', 'German', 'Other'];

class CreateProfilePage extends StatelessWidget {
  const CreateProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CreateProfileCubit(),
      child: const _CreateProfileView(),
    );
  }
}

class _CreateProfileView extends StatelessWidget {
  const _CreateProfileView();

  @override
  Widget build(BuildContext context) {
    return BasePage(
      safeAreaBottom: true,
      child: BlocConsumer<CreateProfileCubit, CreateProfileState>(
        listener: (context, state) {
          if (state.isSuccess) {
            context.go(Routes.main);
          } else if (state.isError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error?.message ?? 'Something went wrong'),
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<CreateProfileCubit>();
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _BackButton(
                  onTap: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go(Routes.signup);
                    }
                  },
                ),
                const SizedBox(height: 24),
                Text.rich(
                  TextSpan(
                    style: AppTextStyles.headline(color: context.theme.text),
                    children: [
                      const TextSpan(text: 'Create your '),
                      TextSpan(
                        text: 'Profile',
                        style: TextStyle(color: context.theme.primary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Create your profile with some basic information',
                  style: AppTextStyles.body(
                    color: context.theme.text,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 28),
                const _FieldLabel("What's your Name"),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        hintText: 'First Name',
                        onChanged: cubit.firstNameChanged,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppTextField(
                        hintText: 'Last Name',
                        onChanged: cubit.lastNameChanged,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'First name is only visible on your profile.',
                  style: AppTextStyles.body(
                    color: context.theme.hint,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 24),
                const _FieldLabel("What's your date of birth"),
                const SizedBox(height: 8),
                AppDateField(
                  date: state.dateOfBirth,
                  onChanged: cubit.dateOfBirthChanged,
                ),
                const SizedBox(height: 24),
                const _FieldLabel("What's your gender"),
                const SizedBox(height: 8),
                RadioGroup<String>(
                  groupValue: state.gender,
                  onChanged: (value) {
                    if (value != null) cubit.genderChanged(value);
                  },
                  child: Row(
                    children: [
                      _GenderOption(
                        label: 'Male',
                        value: 'Male',
                        onTap: () => cubit.genderChanged('Male'),
                      ),
                      const SizedBox(width: 24),
                      _GenderOption(
                        label: 'Female',
                        value: 'Female',
                        onTap: () => cubit.genderChanged('Female'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const _FieldLabel("What's your nationality"),
                const SizedBox(height: 8),
                AppDropdownField<String>(
                  value: state.nationality,
                  items: _nationalities,
                  itemLabel: (item) => item,
                  onChanged: cubit.nationalityChanged,
                ),
                const SizedBox(height: 24),
                const _FieldLabel('Languages spoken'),
                const SizedBox(height: 8),
                AppDropdownField<String>(
                  value: state.language,
                  items: _languages,
                  itemLabel: (item) => item,
                  onChanged: cubit.languageChanged,
                ),
                const SizedBox(height: 32),
                AppButton(
                  label: 'Save',
                  uppercase: false,
                  isLoading: state.isLoading,
                  onPressed: cubit.submit,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.body(
        color: context.theme.text,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: context.theme.surface,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(Icons.chevron_left, color: context.theme.text),
      ),
    );
  }
}

class _GenderOption extends StatelessWidget {
  const _GenderOption({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<String>(value: value, activeColor: context.theme.primary),
          Text(label, style: AppTextStyles.body(color: context.theme.text)),
        ],
      ),
    );
  }
}
