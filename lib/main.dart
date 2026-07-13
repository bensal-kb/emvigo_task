import 'package:emvigo_test/core/enums/flavors.dart';
import 'package:emvigo_test/main_dev.dart';

// Default entry — runs dev. Use main_dev/main_stage/main_prod for explicit flavors.
void main() => runFlavor(Flavors.dev);
