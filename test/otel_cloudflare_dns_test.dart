// Licensed under the Apache License, Version 2.0
// Copyright 2025, Mindful Software LLC, All rights reserved.

import 'package:otel_cloudflare_dns/otel_cloudflare_dns.dart';
import 'package:test/test.dart';

void main() {
  group('otel_cloudflare_dns', () {
    test('suppression toggles in zone', () async {
      expect(cloudflareDNSInstrumentationSuppressed(), isFalse);
      await runWithoutCloudflareDNSInstrumentationAsync(() async {
        expect(cloudflareDNSInstrumentationSuppressed(), isTrue);
      });
      expect(cloudflareDNSInstrumentationSuppressed(), isFalse);
    });

    test('CloudflareDNSResult fields default null', () {
      const r = CloudflareDNSResult();
      expect(r.statusCode, isNull);
    });
  });
}
