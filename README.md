# otel_cloudflare_dns

Dartastic OpenTelemetry bridge for Cloudflare DNS (authoritative DNS + DNSSEC).

Wraps each call in a CLIENT-kind span with vendor-specific attributes following OpenTelemetry semantic conventions where applicable.

```dart
import 'package:otel_cloudflare_dns/otel_cloudflare_dns.dart';

await tracedCloudflareDNS<void>(
  operation: 'someOp',
  invoke: () async {
    final r = await client.someOp();
    return CloudflareDNSCallResult(value: r, result: CloudflareDNSResult(statusCode: 200));
  },
);
```

Suppress instrumentation within a block:

```dart
await runWithoutCloudflareDNSInstrumentationAsync(() async {
  await client.someInternalSync();
});
```
