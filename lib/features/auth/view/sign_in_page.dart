import 'package:go_router/go_router.dart';
import 'package:emvigo_test/core/base/base_ui/base_page.dart';
import 'package:emvigo_test/core/base/base_ui/base_ui.dart';
import 'package:emvigo_test/core/router/app_routes.dart';
import 'package:emvigo_test/core/styles/app_text_styles.dart';
import 'package:emvigo_test/widgets/buttons/app_button.dart';
import 'package:emvigo_test/widgets/fields/app_text_field.dart';

import '../bloc/login_cubit/login_cubit.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => LoginCubit(), child: const _LoginView());
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView();

  @override
  Widget build(BuildContext context) {
    return BasePage(
      child: BlocConsumer<LoginCubit, LoginState>(
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
          final cubit = context.read<LoginCubit>();
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(flex: 50,),
                Text.rich(
                  TextSpan(
                    style: AppTextStyles.headline(color: context.theme.text),
                    children: [
                      const TextSpan(text: 'Welcome\nto '),
                      TextSpan(
                        text: 'TestApp',
                        style: TextStyle(color: context.theme.primary),
                      ),
                    ],
                  ),
                ),
                const Spacer(flex: 35,),
                Text(
                  'All users are verified to help prevent fake accounts.',
                  style: AppTextStyles.body(color: context.theme.hint),
                ),
                const Spacer(flex: 36,),
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
                const Spacer(flex: 35,),
                AppButton(
                  label: 'Login',
                  isLoading: state.isLoading,
                  onPressed: cubit.submit,
                ),
                const SizedBox(height: 377),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have account ",
                        style: AppTextStyles.body(
                          color: context.theme.hint,
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.go(Routes.signup),
                        child: Text(
                          'Signup',
                          style: AppTextStyles.body(
                            color: context.theme.text,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const Spacer(flex: 10,),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
