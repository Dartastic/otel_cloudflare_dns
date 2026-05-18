// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

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
