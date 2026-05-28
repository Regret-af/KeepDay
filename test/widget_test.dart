import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keepday/app/app.dart';
import 'package:keepday/data/database/app_database.dart';
import 'package:keepday/data/database/database_provider.dart';

void main() {
  testWidgets('KeepDay shell renders', (tester) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(database)],
        child: const KeepDayApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('KeepDay'), findsOneWidget);
    expect(find.text('还没有习惯'), findsOneWidget);
    expect(find.text('创建习惯'), findsWidgets);

    await database.close();
  });
}
