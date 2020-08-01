import 'package:flutter_test/flutter_test.dart';

import 'package:CoTrack/main.dart';

void main() {
    testWidgets('Novid test', (WidgetTester tester) async {
        await tester.pumpWidget(Novid19App());
    });
}
