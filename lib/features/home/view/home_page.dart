import 'package:go_router/go_router.dart';
import 'package:emvigo_test/core/base/base_ui/base_page.dart';
import 'package:emvigo_test/core/base/base_ui/base_ui.dart';
import 'package:emvigo_test/core/router/app_routes.dart';

import '../bloc/home_cubit/home_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(sl()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return BasePage(
      child: BlocConsumer<HomeCubit, BaseState>(
        listener: (context, state) {
          if (state.isSuccess) {
            context.go(Routes.signIn);
          } else if (state.isError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error?.message ?? 'Something went wrong')),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<HomeCubit>();
          return Center(
            child: Column(
              children: [
                const Spacer(flex: 4),
                const Text(
                  'Welcome to Emvigo!',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                ),
                const Spacer(flex: 2),
                ElevatedButton(
                  onPressed: state.isLoading ? null : cubit.logout,
                  child: state.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(' Logout '),
                        ),
                ),
                const Spacer(flex: 2),
              ],
            ),
          );
        },
      ),
    );
  }
}
