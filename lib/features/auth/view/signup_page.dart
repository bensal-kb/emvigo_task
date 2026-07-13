import 'package:go_router/go_router.dart';
import 'package:emvigo_test/core/base/base_ui/base_page.dart';
import 'package:emvigo_test/core/base/base_ui/base_ui.dart';
import 'package:emvigo_test/core/router/app_routes.dart';
import 'package:emvigo_test/core/styles/app_text_styles.dart';
import 'package:emvigo_test/widgets/buttons/app_button.dart';
import 'package:emvigo_test/widgets/fields/app_text_field.dart';

import '../bloc/signup_cubit/signup_cubit.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignupCubit(sl()),
      child: const _SignupView(),
    );
  }
}

class _SignupView extends StatelessWidget {
  const _SignupView();

  @override
  Widget build(BuildContext context) {
    return BasePage(
      safeAreaBottom: true,
      child: BlocConsumer<SignupCubit, SignupState>(
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
          final cubit = context.read<SignupCubit>();
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(flex: 50,),
                Text(
                  'Create Account',
                  style: AppTextStyles.headline(color: context.theme.text),
                ),
                const Spacer(flex: 35,),
                Text(
                  'All users are verified to help prevent fake accounts.',
                  style: AppTextStyles.body(color: context.theme.textButton),
                ),
                const Spacer(flex: 74,),
                AppTextField(
                  hintText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  onChanged: cubit.emailChanged,
                ),
                const Spacer(flex: 28,),
                AppTextField(
                  hintText: 'Password',
                  obscureText: true,
                  onChanged: cubit.passwordChanged,
                ),
                const Spacer(flex: 28,),
                AppTextField(
                  hintText: 'Confirm Password',
                  obscureText: true,
                  onChanged: cubit.confirmPasswordChanged,
                ),
                const Spacer(flex: 40,),
                AppButton(
                  label: 'Signup',
                  isLoading: state.isLoading,
                  onPressed: cubit.submit,
                ),
                const Spacer(flex: 300,),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have account, ',
                        style: AppTextStyles.body(color: context.theme.textButton),
                      ),
                      GestureDetector(
                        onTap: () => context.go(Routes.signIn),
                        child: Text(
                          'SignIn',
                          style: AppTextStyles.body(
                            color: context.theme.text,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(flex: 10,),

              ],
            ),
          );
        },
      ),
    );
  }
}
