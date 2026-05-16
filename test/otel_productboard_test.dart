// Licensed under the Apache License, Version 2.0
// Copyright 2025, Mindful Software LLC, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:dartastic_opentelemetry/testing.dart';
import 'package:otel_productboard/otel_productboard.dart';
import 'package:test/test.dart';

void main() {
  late TestHarness harness;
  late InMemorySpanExporter spans;

  setUpAll(() async {
    harness = await maybeInitializeOtelForTest(
      serviceName: 'otel_productboard-test',
    );
    spans = harness.spans;
  });

  setUp(() => harness.clear());

  Map<String, Object> attrsOf(Span s) =>
      {for (final a in s.attributes.toList()) a.key: a.value};

  test('notes.create records source + company + linked-counts', () async {
    await tracedProductboard<String>(
      operation: 'notes.create',
      invoke: () async => const ProductboardCallResult(
        value: 'ok',
        result: ProductboardResult(
          workspaceId: 'ws_1',
          noteId: 'note_1',
          noteSource: 'Intercom',
          companyId: 'co_1',
          companyDomain: 'acme.com',
          userId: 'u_1',
          linkedNotesCount: 0,
          linkedInsightsCount: 1,
          statusCode: 201,
        ),
      ),
    );
    final a = attrsOf(spans.findSpanByName('productboard notes.create')!);
    expect(a['productboard.note.source'], 'Intercom');
    expect(a['productboard.company.domain'], 'acme.com');
    expect(a['productboard.linked_insights.count'], 1);
  });

  test('features.update records status + timeframe + hierarchy', () async {
    await tracedProductboard<String>(
      operation: 'features.update',
      invoke: () async => const ProductboardCallResult(
        value: 'ok',
        result: ProductboardResult(
          featureId: 'feat_1',
          featureStatus: 'in_progress',
          featureTimeframe: 'now',
          productId: 'prod_1',
          componentId: 'comp_1',
          releaseId: 'rel_1',
          linkedNotesCount: 42,
          statusCode: 200,
        ),
      ),
    );
    final a = attrsOf(spans.findSpanByName('productboard features.update')!);
    expect(a['productboard.feature.status'], 'in_progress');
    expect(a['productboard.feature.timeframe'], 'now');
    expect(a['productboard.linked_notes.count'], 42);
  });

  test('HTTP 422 sets span error', () async {
    await tracedProductboard<String>(
      operation: 'notes.create',
      invoke: () async => const ProductboardCallResult(
        value: 'ok',
        result: ProductboardResult(statusCode: 422),
      ),
    );
    expect(
      spans.findSpanByName('productboard notes.create')!.status,
      SpanStatusCode.Error,
    );
  });

  test('suppression skips spans', () async {
    await runWithoutProductboardInstrumentationAsync(() async {
      await tracedProductboard<String>(
        operation: 'features.list',
        invoke: () async => const ProductboardCallResult(value: 'v'),
      );
    });
    expect(spans.findSpansStartingWith('productboard '), isEmpty);
  });
}
