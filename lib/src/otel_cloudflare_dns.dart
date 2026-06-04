// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';

import 'otel_cloudflare_dns_suppression.dart';

class CloudflareDNSResult {
  const CloudflareDNSResult({
    this.zoneId,
    this.zoneName,
    this.recordId,
    this.recordName,
    this.recordType,
    this.proxied,
    this.ttl,
    this.dnssecEnabled,
    this.statusCode,
    this.errorCode,
    this.errorMessage,
  });

  final String? zoneId;
  final String? zoneName;
  final String? recordId;
  final String? recordName;
  final String? recordType;
  final bool? proxied;
  final int? ttl;
  final bool? dnssecEnabled;
  final int? statusCode;
  final String? errorCode;
  final String? errorMessage;
}

class CloudflareDNSCallResult<T> {
  const CloudflareDNSCallResult({required this.value, this.result});
  final T value;
  final CloudflareDNSResult? result;
}

Future<T> tracedCloudflareDNS<T>({
  required String operation,
  required Future<CloudflareDNSCallResult<T>> Function() invoke,
  Tracer? tracer,
}) async {
  if (cloudflareDNSInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final t = tracer ?? OTel.tracerProvider().getTracer('otel_cloudflare_dns');
  final span = t.startSpan('cfdns $operation', kind: SpanKind.client);
  try {
    span.addAttributes(
        OTel.attributes([OTel.attributeString('rpc.system', 'cloudflare')]));
    span.addAttributes(
        OTel.attributes([OTel.attributeString('dns.system', 'cloudflare')]));
    final r = await invoke();
    final res = r.result;
    if (res != null) {
      if (res.zoneId != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('cloudflare.zone.id', res.zoneId!)]));
      }
      if (res.zoneName != null) {
        span.addAttributes(
            OTel.attributes([OTel.attributeString('dns.zone', res.zoneName!)]));
      }
      if (res.recordId != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('cloudflare.dns.record.id', res.recordId!)]));
      }
      if (res.recordName != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('dns.name', res.recordName!)]));
      }
      if (res.recordType != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('dns.record.type', res.recordType!)]));
      }
      if (res.proxied != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeBool('cloudflare.dns.proxied', res.proxied!)]));
      }
      if (res.ttl != null) {
        span.addAttributes(
            OTel.attributes([OTel.attributeInt('dns.ttl', res.ttl!)]));
      }
      if (res.dnssecEnabled != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeBool('dns.dnssec.enabled', res.dnssecEnabled!)]));
      }
      if (res.statusCode != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeInt('http.response.status_code', res.statusCode!)]));
      }
      if (res.errorCode != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('cfdns.error.code', res.errorCode!)]));
      }
      final fail = res.errorCode != null ||
          (res.statusCode != null && res.statusCode! >= 400);
      if (fail) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString(
            ErrorResource.errorType.key,
            res.errorCode ?? 'cloudflare_dns.error',
          )
        ]));
        span.setStatus(SpanStatusCode.Error, res.errorMessage);
      }
    }
    return r.value;
  } catch (e, st) {
    span.recordException(e, stackTrace: st);
    span.setStatus(SpanStatusCode.Error, e.toString());
    rethrow;
  } finally {
    span.end();
  }
}
