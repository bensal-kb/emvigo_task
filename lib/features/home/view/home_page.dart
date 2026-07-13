import 'package:emvigo_test/core/base/base_ui/base_page.dart';

import '../../../core/base/base_ui/base_ui.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      child: Center(
        child: Column(
          children: [
            const Spacer(flex: 4),
            const Text(
              'Home Page',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            const Spacer(flex: 2),
            ElevatedButton(
              onPressed: () {
                //logout
              },
              child: const Text('Logout'),
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
