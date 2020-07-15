import 'package:flutter_test/flutter_test.dart';

import 'package:NOVID_19/main.dart';

void main() {
    testWidgets('Novid test', (WidgetTester tester) async {
        await tester.pumpWidget(Novid19());
    });
}
