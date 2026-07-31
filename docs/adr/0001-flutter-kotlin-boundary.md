# ADR 0001: Flutter/Kotlin boundary

- Status: Accepted
- Date: 2026-07-31

## Context

Phone Detox is primarily a Flutter product but must use Android platform APIs for Home-role integration, package discovery, and explicit activity launching.

## Decision

Dart owns UI, navigation, state, product rules, schedules, settings, persistence, and entitlement decisions. Kotlin owns only Android platform integration. Controllers depend on a typed `LauncherRepository`; widgets never access `MethodChannel`. Native payloads use primitive, validated maps and lists.

## Consequences

The platform boundary remains small and replaceable in tests. Android behavior still requires device QA, while most product rules can be tested in Dart. New native capabilities require an explicit repository method and policy review.