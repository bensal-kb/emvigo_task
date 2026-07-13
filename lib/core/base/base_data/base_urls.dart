import 'package:emvigo_test/core/enums/flavors.dart';

String getBaseUrls(Flavors flavor) {
  switch (flavor) {
    case Flavors.dev:
      return 'https://dev-api.yourapp.com/api/v1';
    case Flavors.stage:
      return 'https://stage-api.yourapp.com/api/v1';
    case Flavors.prod:
      return 'https://api.yourapp.com/api/v1';
  }
}
