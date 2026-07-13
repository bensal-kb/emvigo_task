import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:emvigo_test/core/base/base_ui/base_page.dart';
import 'package:emvigo_test/core/base/base_ui/base_ui.dart';
import 'package:emvigo_test/core/base/base_ui/widgets/default_error_widget.dart';
import 'package:emvigo_test/core/base/base_ui/widgets/default_loading_widget.dart';
import 'package:emvigo_test/core/router/app_routes.dart';
import 'package:emvigo_test/core/styles/app_text_styles.dart';
import 'package:emvigo_test/widgets/buttons/app_button.dart';

import '../bloc/home_cubit/home_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(sl(), sl()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return BasePage(
      safeAreaBottom: true,
      child: BlocConsumer<HomeCubit, BaseState>(
        listener: (context, state) {
          if (state is ProfileMissingState) {
            context.go(Routes.createProfile);
          } else if (state.isSuccess && state is! HomeState) {
            context.go(Routes.signIn);
          } else if (state.isError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error?.message ?? 'Something went wrong')),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<HomeCubit>();

          if (state is HomeState) {
            return _HomeContent(state: state, onLogout: cubit.logout);
          }
          if (state.isError) {
            return DefaultErrorWidget(state: state, retry: cubit.loadProfile);
          }
          return DefaultLoadingWidget(state: state);
        },
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.state, required this.onLogout});

  final HomeState state;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final profile = state.profile;
    final initials = _initials(profile.firstName, profile.lastName);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Avatar(initials: initials),
          const SizedBox(height: 20),
          Text.rich(
            TextSpan(
              style: AppTextStyles.headline(color: context.theme.text, fontSize: 26),
              children: [
                const TextSpan(text: 'Hello, '),
                TextSpan(text: profile.firstName, style: TextStyle(color: context.theme.primary)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Here\'s your profile summary',
            style: AppTextStyles.body(color: context.theme.hint),
          ),
          const SizedBox(height: 28),
          _ProfileCard(
            rows: [
              _InfoRow(icon: Icons.email_outlined, label: 'Email', value: state.email ?? '-'),
              _InfoRow(
                icon: Icons.badge_outlined,
                label: 'Name',
                value: '${profile.firstName} ${profile.lastName}',
              ),
              _InfoRow(
                icon: Icons.cake_outlined,
                label: 'Date of Birth',
                value: DateFormat('dd-MM-yyyy').format(profile.dateOfBirth),
              ),
              _InfoRow(icon: Icons.wc_outlined, label: 'Gender', value: profile.gender),
              _InfoRow(icon: Icons.public, label: 'Nationality', value: profile.nationality),
              _InfoRow(icon: Icons.translate, label: 'Languages', value: profile.language),
            ],
          ),
          const SizedBox(height: 32),
          AppButton(label: 'Logout', uppercase: false, onPressed: onLogout),
        ],
      ),
    );
  }

  String _initials(String firstName, String lastName) {
    final first = firstName.isNotEmpty ? firstName[0] : '';
    final last = lastName.isNotEmpty ? lastName[0] : '';
    return '$first$last'.toUpperCase();
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.initials});

  final String initials;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: context.theme.primary, shape: BoxShape.circle),
      child: Text(
        initials,
        style: AppTextStyles.body(
          color: context.theme.light,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.rows});

  final List<Widget> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: context.theme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) Divider(color: context.theme.divider, height: 1),
            rows[i],
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: context.theme.primaryBackground,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: context.theme.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.body(color: context.theme.hint, fontSize: 12)),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppTextStyles.body(
                    color: context.theme.text,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
