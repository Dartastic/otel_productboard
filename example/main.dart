// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:otel_productboard/otel_productboard.dart';

/// Traces Productboard calls with OpenTelemetry.
///
/// `otel_productboard` depends on the OpenTelemetry API only, so the application
/// initializes an SDK once at startup. Wrap each Productboard call in
/// [tracedProductboard]; the `invoke` callback makes the real call and reports what
/// came back, which is recorded on the span.
Future<void> main() async {
  await OTel.initialize(serviceName: 'productboard-example');

  // Wraps a Productboard API call in a CLIENT span.
  final productboardId = await tracedProductboard<String>(
    operation: 'notes.create',
    invoke: () async {
      // Make the Productboard call here, then report what it returned.
      const id = 'productboard_8f3a2c';
      return const ProductboardCallResult(
          value: id,
          result: ProductboardResult(
              workspaceId: 'workspace_8f3a2c',
              entityKind: 'note',
              entityId: 'entity_8f3a2c',
              noteId: 'note_8f3a2c',
              noteSource: 'Email',
              companyId: 'company_8f3a2c',
              companyDomain: 'example',
              userId: 'user_8f3a2c',
              featureId: 'feature_8f3a2c',
              featureStatus: 'idea',
              featureTimeframe: 'now',
              productId: 'product_8f3a2c',
              componentId: 'component_8f3a2c',
              releaseId: 'release_8f3a2c',
              objectiveId: 'objective_8f3a2c',
              linkedNotesCount: 3,
              linkedInsightsCount: 3,
              statusCode: 201));
    },
  );
  OTelLog.info('tracedProductboard notes.create returned $productboardId');

  // Calls that should not be traced, such as health checks, run inside
  // runWithoutProductboardInstrumentationAsync.
  await runWithoutProductboardInstrumentationAsync(
    () => tracedProductboard<String>(
      operation: 'notes.create',
      invoke: () async {
        const id = 'productboard_8f3a2c';
        return const ProductboardCallResult(
            value: id,
            result: ProductboardResult(
                workspaceId: 'workspace_8f3a2c',
                entityKind: 'note',
                entityId: 'entity_8f3a2c',
                noteId: 'note_8f3a2c',
                noteSource: 'Email',
                companyId: 'company_8f3a2c',
                companyDomain: 'example',
                userId: 'user_8f3a2c',
                featureId: 'feature_8f3a2c',
                featureStatus: 'idea',
                featureTimeframe: 'now',
                productId: 'product_8f3a2c',
                componentId: 'component_8f3a2c',
                releaseId: 'release_8f3a2c',
                objectiveId: 'objective_8f3a2c',
                linkedNotesCount: 3,
                linkedInsightsCount: 3,
                statusCode: 201));
      },
    ),
  );

  await OTel.shutdown();
}
