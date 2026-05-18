// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';

import 'otel_productboard_suppression.dart';

const _tracerName = 'dartastic_otel_libs_productboard';

Tracer _tracer() => OTel.tracerProvider().getTracer(_tracerName);

class ProductboardResult {
  const ProductboardResult({
    this.workspaceId,
    this.entityKind,
    this.entityId,
    this.noteId,
    this.noteSource,
    this.companyId,
    this.companyDomain,
    this.userId,
    this.featureId,
    this.featureStatus,
    this.featureTimeframe,
    this.productId,
    this.componentId,
    this.releaseId,
    this.objectiveId,
    this.linkedNotesCount,
    this.linkedInsightsCount,
    this.statusCode,
  });

  /// Productboard workspace.
  final String? workspaceId;

  /// `note` / `feature` / `component` / `product` / `release` /
  /// `objective` / `key_result` / `company` / `user` / `tag` /
  /// `link` / `webhook` / `custom_field`.
  final String? entityKind;

  final String? entityId;

  final String? noteId;

  /// `Email` / `In-app feedback` / `Chrome extension` / `Intercom` /
  /// `Zendesk` / `Salesforce` / `Slack` / `Webhook` / `API` /
  /// `Manual entry`.
  final String? noteSource;

  /// Linked company on the note.
  final String? companyId;

  /// Domain string Productboard uses to dedupe companies.
  final String? companyDomain;

  /// Linked end-user.
  final String? userId;

  final String? featureId;

  /// `idea` / `discovery` / `planned` / `in_progress` / `done` /
  /// `archived`.
  final String? featureStatus;

  /// `now` / `next` / `later` / `none` — feature timeframe.
  final String? featureTimeframe;

  final String? productId;
  final String? componentId;
  final String? releaseId;

  final String? objectiveId;

  /// Number of notes linked to this feature.
  final int? linkedNotesCount;

  /// Number of insights (note excerpts) linked.
  final int? linkedInsightsCount;

  final int? statusCode;
}

class ProductboardCallResult<T> {
  const ProductboardCallResult({required this.value, this.result});
  final T value;
  final ProductboardResult? result;
}

/// Wraps a Productboard API call in a CLIENT span. [operation] is
/// one of `notes.create`, `notes.list`, `notes.update`,
/// `features.create`, `features.list`, `features.update`,
/// `components.list`, `products.list`, `releases.list`,
/// `objectives.list`, `companies.list`, `companies.create`,
/// `users.list`, `links.create`, `webhooks.create`,
/// `custom_fields.set`.
Future<T> tracedProductboard<T>({
  required String operation,
  required Future<ProductboardCallResult<T>> Function() invoke,
}) async {
  if (productboardInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final m = <String, Object>{
    'rpc.system': 'productboard',
    'rpc.method': operation,
    'productboard.operation': operation,
  };

  final span = _tracer().startSpan(
    'productboard $operation',
    kind: SpanKind.client,
    attributes: OTel.attributesFromMap(m),
  );
  try {
    final r = await invoke();
    if (r.result != null) {
      final extras = <Attribute<Object>>[];
      if (r.result!.workspaceId != null) {
        extras.add(OTel.attributeString(
          'productboard.workspace.id',
          r.result!.workspaceId!,
        ));
      }
      if (r.result!.entityKind != null) {
        extras.add(OTel.attributeString(
          'productboard.entity.kind',
          r.result!.entityKind!,
        ));
      }
      if (r.result!.entityId != null) {
        extras.add(OTel.attributeString(
          'productboard.entity.id',
          r.result!.entityId!,
        ));
      }
      if (r.result!.noteId != null) {
        extras.add(OTel.attributeString(
          'productboard.note.id',
          r.result!.noteId!,
        ));
      }
      if (r.result!.noteSource != null) {
        extras.add(OTel.attributeString(
          'productboard.note.source',
          r.result!.noteSource!,
        ));
      }
      if (r.result!.companyId != null) {
        extras.add(OTel.attributeString(
          'productboard.company.id',
          r.result!.companyId!,
        ));
      }
      if (r.result!.companyDomain != null) {
        extras.add(OTel.attributeString(
          'productboard.company.domain',
          r.result!.companyDomain!,
        ));
      }
      if (r.result!.userId != null) {
        extras.add(OTel.attributeString(
          'productboard.user.id',
          r.result!.userId!,
        ));
      }
      if (r.result!.featureId != null) {
        extras.add(OTel.attributeString(
          'productboard.feature.id',
          r.result!.featureId!,
        ));
      }
      if (r.result!.featureStatus != null) {
        extras.add(OTel.attributeString(
          'productboard.feature.status',
          r.result!.featureStatus!,
        ));
      }
      if (r.result!.featureTimeframe != null) {
        extras.add(OTel.attributeString(
          'productboard.feature.timeframe',
          r.result!.featureTimeframe!,
        ));
      }
      if (r.result!.productId != null) {
        extras.add(OTel.attributeString(
          'productboard.product.id',
          r.result!.productId!,
        ));
      }
      if (r.result!.componentId != null) {
        extras.add(OTel.attributeString(
          'productboard.component.id',
          r.result!.componentId!,
        ));
      }
      if (r.result!.releaseId != null) {
        extras.add(OTel.attributeString(
          'productboard.release.id',
          r.result!.releaseId!,
        ));
      }
      if (r.result!.objectiveId != null) {
        extras.add(OTel.attributeString(
          'productboard.objective.id',
          r.result!.objectiveId!,
        ));
      }
      if (r.result!.linkedNotesCount != null) {
        extras.add(OTel.attributeInt(
          'productboard.linked_notes.count',
          r.result!.linkedNotesCount!,
        ));
      }
      if (r.result!.linkedInsightsCount != null) {
        extras.add(OTel.attributeInt(
          'productboard.linked_insights.count',
          r.result!.linkedInsightsCount!,
        ));
      }
      if (r.result!.statusCode != null) {
        extras.add(OTel.attributeInt(
          'http.response.status_code',
          r.result!.statusCode!,
        ));
        if (r.result!.statusCode! >= 400) {
          span.setStatus(
            SpanStatusCode.Error,
            'Productboard HTTP ${r.result!.statusCode}',
          );
        }
      }
      if (extras.isNotEmpty) span.addAttributes(OTel.attributes(extras));
    }
    return r.value;
  } catch (e, st) {
    span.addAttributes(OTel.attributes([
      OTel.attributeString(
        ErrorResource.errorType.key,
        e.runtimeType.toString(),
      ),
    ]));
    span.recordException(e, stackTrace: st);
    span.setStatus(SpanStatusCode.Error, e.toString());
    rethrow;
  } finally {
    span.end();
  }
}
