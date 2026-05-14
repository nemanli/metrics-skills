# Tracking plan template

The deliverable from `metrics-instrumentation`. One row per event. The plan is the contract between design/PM and eng — treat it like a schema. The pattern is standard in CDP guidance ([Segment — Tracking Plan](https://segment.com/docs/protocols/tracking-plan/create/), [Amplitude — taxonomy planning](https://amplitude.com/blog/event-tracking-plan), [Mixpanel — data structure](https://docs.mixpanel.com/docs/data-structure/events-and-properties)).

## Format

A markdown table or shared sheet. Markdown is easier to version-control; sheets are easier for non-technical reviewers.

## Required columns

| Column | Purpose | Notes |
|---|---|---|
| `Event name` | Final name per convention | One convention per workspace; see [naming-conventions.md](naming-conventions.md). |
| `Trigger` | What user action fires this event | One specific sentence. |
| `Properties` | Schema for event-specific properties | Name, type, required/optional, allowed enum values. |
| `PII flag` | Whether any property carries PII risk | `no` / `yes (note)`. See [pii-rules.md](pii-rules.md). |
| `Owner` | Who designed the event | Usually PM or designer. |
| `Implemented by` | Eng owner | The person who instruments it. |
| `Version` | Schema version | Increment when schema changes. |
| `Status` | Lifecycle status | Planned / In progress / Live / Deprecated. |

## Optional columns

| Column | Purpose |
|---|---|
| `Source metric(s)` | Which metric(s) the event feeds (Activation Rate, Day 7 Retention, ...). Links the plan to upstream `metrics-spec`. |
| `Sampled?` | Whether the event is sampled or 100% captured. Default 100%. |
| `Retention` | How long the event is stored. E.g. "13 months" — aligned with [GDPR Art. 5(1)(e) — storage limitation](https://gdpr-info.eu/art-5-gdpr/). |
| `Consent layer` | Which consent layer governs the event ([IAB Europe TCF v2.2](https://iabeurope.eu/tcf-2-2/) is one common framework). |

---

## Template

```
| Event name              | Trigger                                | Properties                                       | PII flag | Owner   | Implemented by | Version | Status   |
|-------------------------|----------------------------------------|--------------------------------------------------|----------|---------|----------------|---------|----------|
| <Object Action>         | <one-sentence user action>             | <name: type, required/optional, allowed values>  | no/yes   | <name>  | <name>         | 1.0     | Planned  |
```

YAML alternative when the team prefers structured data:

```yaml
- name: Onboarding Completed
  trigger: User reaches the final onboarding screen (post-step-N) with all required actions confirmed.
  properties:
    signup_id:        { type: string, required: true }
    steps_completed:  { type: int,    required: true }
    time_to_complete_sec: { type: int, required: true }
    skipped_optional: { type: bool,   required: false }
  pii_flag: no
  source_metrics: [onboarding_completion_rate, activation_rate]
  owner: Azar (design lead)
  implemented_by: Sam (eng)
  version: 1.0
  status: Planned
```

---

## Required properties (baseline)

These attach to **every** event. Implement them at the SDK / wrapper layer so they are automatic. The baseline set comes from the [Segment Spec common fields](https://segment.com/docs/connections/spec/common/).

| Property | Type | Source | Notes |
|---|---|---|---|
| `user_id` | string | App auth state | Empty for anonymous users. |
| `anonymous_id` | string | SDK-generated | Stable across sessions for the same device pre-login. |
| `session_id` | string | App session manager | Typically refreshes after 30 min inactivity. |
| `timestamp` | ISO 8601 string | Server-side ingestion time, UTC | Do not trust client clocks for ordering. |
| `platform` | enum: `web`/`ios`/`android`/`server` | App context | |
| `app_version` | string | Build constant | E.g. `"4.12.0"`. |
| `locale` | string | Device or app setting | E.g. `"en-US"`. |

Do not duplicate these in the per-event property column — assume they fire on every event.

---

## Filled example

Adapted from the AI assistant case in the SKILL:

```
| Event name                  | Trigger                                | Properties                                                                                          | PII flag | Owner | Implemented by | Version | Status  |
|-----------------------------|----------------------------------------|-----------------------------------------------------------------------------------------------------|----------|-------|----------------|---------|---------|
| Assistant Opened            | User taps the AI assistant entry point.| entry_point (enum, req): "main_nav" \| "in_context" \| "cmd_palette"                                | no       | Azar  | Sam            | 1.0     | Planned |
| Assistant Query Submitted   | User submits a query (send or enter).  | query_length (int, req); has_attachment (bool, req); session_query_index (int, req)                 | no       | Azar  | Sam            | 1.0     | Planned |
| Assistant Response Received | Assistant returns a response.          | response_time_ms (int, req); response_status (enum, req): "success"/"error"/"timeout"; tokens (int) | no       | Azar  | Sam            | 1.0     | Planned |
| Assistant Response Rated    | User taps thumbs-up / thumbs-down.     | rating (enum, req): "thumbs_up" \| "thumbs_down"; comment_length (int, opt)                          | no       | Azar  | Sam            | 1.0     | Planned |
```

Source metrics the plan feeds:

- **Activation Rate** = users with ≥1 `Assistant Opened` in week 1 AND ≥1 in their next session within 7 days. Derived from `Assistant Opened`; no separate `Activated` event.
- **Response satisfaction** = share of `Assistant Response Rated` with `rating = "thumbs_up"` over total ratings.
- **Latency p95** = 95th percentile of `Assistant Response Received.response_time_ms`. (Guardrail.)

PII review: `Assistant Query Submitted` records `query_length`, not the query text — see [pii-rules.md](pii-rules.md).

---

## How to write the `Trigger` column

Specific enough that eng can implement against it without re-asking design.

| Specific | Vague |
|---|---|
| "User taps the 'Submit' button at the end of the form OR presses Enter while focus is in any form field." | "User submits the form." |
| "User reaches the order-confirmation screen after a successful payment API response." | "User completes their order." |
| "User taps an article card on the home feed (not a search result, not a recommendation widget)." | "User opens an article." |

Specificity prevents implementation drift: eng fires the event from the wrong code path, and the event measures something subtly different from what design intended.

---

## Versioning the plan

The plan as a whole gets a version. Increment when events are added or schemas change.

```
## Changelog

### 1.4.0 — 2026-05-15
- Added `Assistant Response Rated` event.
- Added `comment_length` (optional) property.

### 1.3.0 — 2026-04-20
- Added `Assistant Query Submitted` event.
```

The version eng implements against is the version the plan was at when the work started. If the plan changes mid-implementation, communicate the diff explicitly.

---

## Lifecycle status meanings

| Status | Meaning |
|---|---|
| `Planned` | Spec-ed but not implemented. Eng can pick up. |
| `In progress` | Implementation in flight. No downstream consumers yet. |
| `Live` | Fired in production. Stable contract; breaking changes require versioning. |
| `Deprecated` | No longer recommended. Document the migration target. |
| `Removed` | No longer fires. Keep in changelog only. |

---

## Linking the plan to the spec

When this plan supports a `metrics-spec`:
- The spec's block 8 (Instrumentation status) names the plan version and the events that must be `Live` before launch.
- The plan's optional `Source metric(s)` column lists which metrics each event feeds.

If a spec metric has no event in the plan, the metric is unimplementable — flag this before the spec is signed off.

---

## See also

- [naming-conventions.md](naming-conventions.md) — the convention for the `Event name` column.
- [taxonomy-patterns.md](taxonomy-patterns.md) — funnel / lifecycle / feature archetypes.
- [pii-rules.md](pii-rules.md) — what cannot go in the `Properties` column.
- [Segment — Tracking Plan documentation](https://segment.com/docs/protocols/tracking-plan/create/).
- [Amplitude — Event Tracking Plan blog](https://amplitude.com/blog/event-tracking-plan).
