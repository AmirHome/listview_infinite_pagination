import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listview_infinite_pagination/listview_infinite_pagination.dart';

void main() {
  Widget buildHost(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: child,
      ),
    );
  }

  testWidgets('renders fetched items', (tester) async {
    await tester.pumpWidget(
      buildHost(
        ListviewInfinitePagination<String>(
          dataFetcher: (page) async => ['page $page item 1', 'page $page item 2'],
          itemBuilder: (index, item) => Text('$index:$item'),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('0:page 1 item 1'), findsOneWidget);
    expect(find.text('1:page 1 item 2'), findsOneWidget);
  });

  testWidgets('renders empty state when first page is empty', (tester) async {
    await tester.pumpWidget(
      buildHost(
        ListviewInfinitePagination<String>(
          dataFetcher: (page) async => <String>[],
          itemBuilder: (index, item) => Text('$index:$item'),
          onEmpty: const Text('Nothing here'),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Nothing here'), findsOneWidget);
    expect(find.text('Fetched all of the content'), findsNothing);
  });

  testWidgets('renders the default error state when fetching fails', (tester) async {
    await tester.pumpWidget(
      buildHost(
        ListviewInfinitePagination<String>(
          dataFetcher: (page) async {
            throw Exception('boom');
          },
          itemBuilder: (index, item) => Text('$index:$item'),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Something went wrong'), findsOneWidget);
  });

  testWidgets('uses the provided scroll controller', (tester) async {
    final controller = ScrollController();

    await tester.pumpWidget(
      buildHost(
        ListviewInfinitePagination<String>(
          controller: controller,
          dataFetcher: (page) async => ['item $page'],
          itemBuilder: (index, item) => Text(item),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(controller.hasClients, isTrue);
  });
}
