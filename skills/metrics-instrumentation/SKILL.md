---
name: metrics-instrumentation
description: Designs the tracking plan that captures the events behind a UX metric — event names, properties, naming conventions, taxonomy, PII rules, tool-agnostic schema. Triggers on "tracking plan", "event taxonomy", "what should we log", "event naming convention", "instrumentation", "how do I capture this metric". Skip for picking which metric to track (use metrics-ux), for the broader measurement plan (use metrics-spec), for tool-specific config (the analytics vendor's docs).
allowed-tools: Read
---

## Overview

Turns a metric into the events and properties that capture it. Five jobs: (1) name a **convention** (Object–Action, snake_case vs Title Case, tense, casing) and stick to it, (2) decide what is an **event** vs a **property** (the most common source of taxonomy mess), (3) specify **required properties** every event must carry (user_id, session_id, timestamp, platform, app_version), (4) commit to **PII / consent rules** that keep the plan compliant and auditable, (5) emit a **tracking plan artefact** the eng team can implement against.

This skill is tool-agnostic. It uses the Segment CDP spec as a baseline ([Segment Spec](https://segment.com/docs/connections/spec/)) and cites Mixpanel/Amplitude/PostHog/Heap conventions where they diverge, but it does not generate vendor-specific configuration. Tool config belongs to the vendor's own documentation.

This skill produces a plan, not code. The eng team implements the plan in their analytics SDK of choice. The plan is the contract between design/PM and eng.

## When to Use

Use this skill when a designer, PM, analyst, or eng asks any of the following — phrased differently by seniority but matching the same job-to-be-done:

| Designer level | Typical phrasing that should trigger this skill |
|---|---|
| **Junior** | "How do I track this metric?" / "What events do we need?" / "PM asked for a tracking plan and I don't know where to start" |
| **Middle** | "We need a tracking plan for the new onboarding flow" / "Eng asked for the event spec" / "What properties should this event have?" |
| **Senior** | "Our event names are inconsistent and the dashboard is a mess — how do we clean this up?" / "We're migrating from one analytics tool to another, want to redo the taxonomy" / "How do we handle PII in event properties?" |
| **Lead** | "Set the team's instrumentation standard" / "We have 700+ event names and nobody can find anything; how do we restructure?" |

Cross-cutting triggers (any seniority):

- The user mentions: tracking plan, event spec, taxonomy, event naming, properties, instrumentation, "what to log".
- The user is starting a new feature/product and wants the events designed up front.
- The user is auditing an existing analytics setup and wants to find issues.
- The user is migrating analytics tools and wants the schema to survive the move.
- The user mentions PII, GDPR, CCPA, consent, or "what we shouldn't log".

Skip this skill when:

- The user is picking which metric to track → use `metrics-ux`.
- The user wants the broader measurement plan around an event → use `metrics-spec`.
- The user wants tool-specific configuration (Amplitude project setup, Mixpanel JQL, PostHog filters) → point to the vendor's docs.
- The user has data and is diagnosing a movement → use `metrics-diagnose`.
- The user is presenting results → use `metrics-present`.

## Process

### Step 1 — Detect mode

| Mode | Signal | Action |
|---|---|---|
| **Direct** | Asks the convention or template directly ("what's the Object–Action naming pattern?", "give me the tracking plan template") | Skip questionnaire. Open [naming-conventions.md](references/naming-conventions.md) or [tracking-plan-template.md](references/tracking-plan-template.md). |
| **Specific** | Has the feature, the metric, and the audience ("we need to track onboarding completion, mobile + web, going into Amplitude") | Skip questionnaire. Walk through Steps 3–7 inline. |
| **Vague** | Wants instrumentation but no specifics ("we need a tracking plan") | Run hybrid questionnaire (Step 2). |

### Step 2 — Hybrid questionnaire (vague mode only)

Same 4 anchors as the other skills (SCOPE, STAGE, AUDIENCE, DATA — see [`metrics-basics/references/context-questions.md`](../metrics-basics/references/context-questions.md)) plus two instrumentation-specific anchors:

5. **PLATFORM** — what surfaces need to be instrumented (web, iOS, Android, server, all of the above)
6. **EXISTING TAXONOMY** — is there a convention already in use, or is this greenfield?

If EXISTING TAXONOMY is "yes, but inconsistent", flag it: cleaning an existing taxonomy is a different job than designing a new one, and the user should pick a mode (greenfield design vs audit-and-migrate) before continuing.

Maximum 4 questions per session. Follow the "How to ask" section in [`context-questions.md`](../metrics-basics/references/context-questions.md).

### Step 3 — Pick a naming convention

The convention is the single most important decision. Once events are flowing under a convention, changing it is a migration — slow, expensive, and incomplete in practice. Pick one of the two industry-standard conventions and stick to it.

| Convention | Shape | Example | Used by |
|---|---|---|---|
| **Object–Action, Title Case, past tense** | `<Object> <Past-Tense-Action>` | `Order Completed`, `Article Viewed`, `Account Created` | Segment Spec, Mixpanel docs, Amplitude default examples |
| **snake_case, present tense** | `<object>_<action>` | `order_complete`, `article_view`, `account_create` | Heap default, internal tools, log-line conventions |

Open [naming-conventions.md](references/naming-conventions.md) for the full ruleset, edge cases (what is "Object"? what counts as an "Action"?), and the rewrite table for common mistakes.

**Recommendation:** Object–Action Title Case past tense (the Segment convention) for product analytics. It scales better as the taxonomy grows, separates events from properties cleanly, and is the dominant convention across major analytics tools. snake_case is fine when the org is already committed to it — what matters is consistency, not the choice itself.

**Hard rules** that apply regardless of convention:

- One convention per workspace. Mixing `Order Completed` and `order_complete` produces two events that mean the same thing — the dashboard becomes unreadable.
- No emojis, no spaces in property keys, no leading underscores (reserved by most tools).
- Names are stable contracts — once an event ships, renaming breaks every downstream dashboard, alert, and warehouse model.

### Step 4 — Event vs property

The most common taxonomy bug. The rule:

> **Events are things users do. Properties describe those things.**

| Right | Wrong |
|---|---|
| Event: `Article Viewed`. Property: `article_category = "news"`. | Event: `News Article Viewed`. Event: `Sports Article Viewed`. |
| Event: `Button Clicked`. Property: `button_id = "primary_cta"`. | Event: `Primary CTA Clicked`. Event: `Secondary CTA Clicked`. |
| Event: `Search Submitted`. Property: `query_length = 12, has_filters = true`. | Event: `Long Search Submitted`. Event: `Filtered Search Submitted`. |

Use properties to **describe** the event. Use events to mark **distinct user actions**. The test: if the only difference between two events is a label, they should be one event with a property.

Open [taxonomy-patterns.md](references/taxonomy-patterns.md) for the three event archetypes (funnel, lifecycle, feature) and how each maps to property design.

**When to split.** Three exceptions where two events are correct, not one:

1. The actions involve **different mechanisms** (different APIs, different validation, different downstream effects). `Account Created` and `Account Deleted` are different events even though both are about accounts.
2. The actions belong to **different funnels** at the analytics level. `Signed Up` and `Signed In` look similar but feed different lifecycle metrics.
3. The actions need **different schemas** (different required properties). `Video Played` and `Video Completed` both reference a video but `Completed` needs `watch_duration` which `Played` doesn't.

### Step 5 — Required properties

Every event carries a baseline of properties so downstream analysis isn't crippled. The Segment Spec lists these as automatic; if your tool doesn't capture them automatically, instrument them.

| Property | Purpose | Example |
|---|---|---|
| `user_id` | Logged-in user identifier (stable across sessions and devices) | `"u_8472"` |
| `anonymous_id` | Anonymous identifier for pre-login activity | `"anon_a1b2c3"` |
| `session_id` | Session identifier (typically refreshes after 30 min inactivity) | `"s_2026_03_05_18_42"` |
| `timestamp` | Server-side ingestion time (ISO 8601, UTC) | `"2026-03-05T18:42:00Z"` |
| `platform` | `web` / `ios` / `android` / `server` | `"ios"` |
| `app_version` | App / web build version | `"4.12.0"` |
| `locale` | User's locale (helps with segment analysis) | `"en-US"` |

**Event-specific properties** are added on top. Use enum-style values where possible (`status: "success" | "failure" | "timeout"`) rather than free text — free-text property values become an unbounded mess that breaks aggregation.

Open [tracking-plan-template.md](references/tracking-plan-template.md) for the full template and a filled example.

### Step 6 — PII and consent rules

Two failure modes: capturing data you shouldn't, and not handling consent properly. Both have legal exposure (GDPR Articles 5–7, CCPA, similar regimes).

| Category | Rule | Example |
|---|---|---|
| **Never log raw PII in event properties** | Email addresses, full names, phone numbers, government IDs, full IP addresses, full credit card numbers go in dedicated user-profile fields with proper access controls, not in event properties. | Wrong: `event: Signup Completed, properties: { email: "x@y.com" }`. Right: identify the user once with the email in the user-profile system; events reference `user_id`. |
| **Never log content the user typed** | Search queries, free-text inputs, chat messages, comments. These often contain PII the user didn't realize they were sharing. | Wrong: `property: query = "my SSN is 123-45-6789"`. Right: `property: query_length = 27, has_results = true`. |
| **Hash or truncate identifiers when needed** | If a property must carry a sensitive identifier for analysis, hash it (SHA-256) or truncate (e.g. domain only from email). | `email_domain: "gmail.com"` instead of full email. |
| **Honor consent** | Users who declined tracking (cookie banner, GDPR consent) must not have events sent. The SDK config or wrapper must enforce this — relying on downstream filtering is risky and often non-compliant. | Check: when consent = false, no events fire. Test this in QA. |
| **Document data retention** | Each event type should have a stated retention window (e.g. 13 months for product analytics, 6 months for marketing attribution). The plan names the policy; eng/ops implement deletion. | Documented in the tracking plan, owned by privacy/legal. |

Open [pii-rules.md](references/pii-rules.md) for the full rule set, the GDPR/CCPA-relevant decisions, and a pre-launch privacy review checklist.

**When in doubt, don't log it.** Adding a property later is easier than removing one that's already in 500 dashboards.

### Step 7 — Emit the tracking plan artefact

Use [tracking-plan-template.md](references/tracking-plan-template.md). The deliverable is a table — one row per event — that eng implements against:

| Column | Purpose |
|---|---|
| `Event name` | Final name per convention (Step 3) |
| `Trigger` | What user action fires this event |
| `Properties` | Schema: name, type, required/optional, allowed values |
| `PII flag` | Whether any property carries PII risk (sensitive: yes/no, with note) |
| `Owner` | Who designed it (usually the PM or designer) |
| `Implemented by` | Eng owner |
| `Version` | Schema version (changes when properties added/removed/renamed) |
| `Status` | Planned / In progress / Live / Deprecated |

Keep it in markdown or a shared sheet, version-controlled. The tracking plan is the contract between design/PM and eng; treat it like a schema.

### Step 8 — Verify

End every plan with: **"Does this fit your setup, or should we adjust before instrumentation starts?"**

If the tracking plan is feeding into a `metrics-spec`, confirm the spec's primary, counter, and guardrail metrics each map to events in the plan. If they don't, the spec is unimplementable until the plan is updated.

## Example

**User prompt (specific mode):** *"We're adding a new AI assistant feature to our mobile app. Need a tracking plan. We use Amplitude. Going live in 3 weeks. Primary metric is activation (invoked + returned within 7 days). Counter is core-flow task success. How do we instrument it?"*

**Mode detection:** Specific — feature, metric, audience, DATA, timeline all present.

**Step 3 — Naming convention:** Object–Action Title Case past tense (Segment standard, works well with Amplitude). Apply consistently.

**Step 4 — Event vs property design.** The activation metric requires marking two distinct user actions: invocation and return. Plus diagnostic events for funnel analysis.

| Concept | Event | Properties (event-specific) |
|---|---|---|
| User opens the assistant | `Assistant Opened` | `entry_point: "main_nav" \| "in_context" \| "cmd_palette"` |
| User submits a query | `Assistant Query Submitted` | `query_length: int`, `has_attachment: bool`, `session_query_index: int` (1st in session, 2nd, ...) |
| Assistant responds | `Assistant Response Received` | `response_time_ms: int`, `response_status: "success" \| "error" \| "timeout"`, `tokens: int` |
| User reacts | `Assistant Response Rated` | `rating: "thumbs_up" \| "thumbs_down"`, `comment_length: int` (NOT the comment itself) |
| User returns (counts toward activation) | tracked from `Assistant Opened` with `session_index` property — no separate event needed |

Note the choice to *not* create `Mobile Assistant Opened` and `Web Assistant Opened` as separate events. Platform is captured in the required `platform` property. Same for entry point (`main_nav`, `in_context`, etc.).

**Step 5 — Required properties on every event:** `user_id`, `anonymous_id`, `session_id`, `timestamp`, `platform`, `app_version`, `locale` (Step 5 default set).

**Step 6 — PII and consent:**

- `Assistant Query Submitted` carries `query_length`, NOT the query text. The query may contain PII the user wasn't aware of.
- `Assistant Response Rated` carries `comment_length`, NOT the comment text. Same reason.
- If product later wants to qualitatively review what users typed, that goes into a separate, consented research pipeline with explicit opt-in — not into product analytics.
- Consent: if user has not consented to product analytics, no events fire. Confirmed in QA.

**Step 7 — Artefact (excerpt from the tracking plan):**

```
Event: Assistant Opened
Trigger: user taps the AI assistant entry point
Properties:
  entry_point     (enum, required)   "main_nav" | "in_context" | "cmd_palette"
  user_id         (string, required) (Step 5 baseline)
  session_id      (string, required) (Step 5 baseline)
  ...
PII flag: no
Owner: Azar (design lead)
Implemented by: Sam (eng lead)
Version: 1.0
Status: Planned

Event: Assistant Query Submitted
Trigger: user submits a query via send button or enter key
Properties:
  query_length          (int, required)
  has_attachment        (bool, required)
  session_query_index   (int, required) — 1 for first query in session, etc.
  user_id, session_id, timestamp, platform, app_version, locale  (Step 5 baseline)
PII flag: no (query text NOT logged; only length and attachment presence)
Owner: Azar (design lead)
Implemented by: Sam (eng lead)
Version: 1.0
Status: Planned

[... rows for Assistant Response Received, Assistant Response Rated ...]
```

**Step 8 — Verify:** "Does this fit your setup, or should we adjust before instrumentation starts?"

**Notes for the user:**

- Activation Rate (primary metric from the spec) is computable from `Assistant Opened` events: `users with ≥1 Assistant Opened in week 1 AND ≥1 Assistant Opened in their next session within 7 days`. No separate `Activated` event needed — derived from existing events. This is correct; resist the temptation to add a `User Activated` event.
- Counter (core-flow task success) is owned by the existing taxonomy — confirm with eng that those events already fire on mobile.
- If product wants to add `chat_satisfaction_score` later, that's a property on an existing event, not a new event. Version bump.

### Example 2 — auditing an existing messy taxonomy

**User prompt (vague mode):** *"We have ~700 event names in our analytics. The dashboard is a mess. Different designers added events with different conventions. Where do we start?"*

**Mode detection:** Vague — auditing rather than greenfield.

**Anchor parse:**
- SCOPE: present (whole product)
- STAGE: present (mature)
- AUDIENCE: missing (who's leading the cleanup?)
- DATA: present (existing analytics, mixed conventions)
- PLATFORM: missing
- EXISTING TAXONOMY: present (yes, inconsistent)

**Question:** "Three things before I recommend a cleanup approach: 1) **AUDIENCE** — is this a design-team-only cleanup, or are PM/eng joining? 2) **PLATFORM** — which surfaces (web, mobile, all)? 3) Is the goal to clean **up** the live taxonomy, or to migrate to a new convention?"

**User reply:** *"Design and analytics joining; web only; want to migrate to a new convention because the current one is unsalvageable."*

**Recommended approach (high-level — full reference in [taxonomy-patterns.md](references/taxonomy-patterns.md)):**

1. **Audit first, don't migrate yet.** Export all event names and their volume (last 90 days). Bucket them: high-volume + dashboard-referenced (must migrate), medium-volume + ad-hoc-referenced (decide case by case), low-volume + orphaned (deprecate).
2. **Pick the target convention.** Object–Action Title Case (Step 3). Document it in a one-page standard.
3. **Build the rename map.** For each high-volume event, name its target name. For duplicate events (`Article Viewed` and `news_article_view`), pick one target and consolidate.
4. **Implement gradually.** Eng instruments the new event names alongside the old ones; both fire for 8–12 weeks while dashboards migrate. Then deprecate the old names with a 30-day notice.
5. **Lock the convention.** Add a CI check (lint rule on event-firing code) that rejects new events not matching the convention.

Step 5 is where most cleanups fail — without enforcement, the next designer adds a one-off and the cycle restarts.

## Common Pitfalls

These apply across most tracking plans. Each is also covered in the references.

- **Mixed conventions.** `Order Completed` and `order_complete` coexist. Dashboard breaks. Pick one and enforce it.
- **Events that should be properties.** `Primary CTA Clicked`, `Secondary CTA Clicked`, `Tertiary CTA Clicked` — collapse into `CTA Clicked` with `cta_id` property.
- **Properties that should be events.** `Generic Event` with a `type` property that has 50 values, each a different user action. Split into one event per type.
- **Free-text property values.** `status: "success!"`, `status: "Success"`, `status: "ok"` — three values for one concept. Use enums.
- **PII in event properties.** Email, full name, raw search query. Move to user-profile fields or hash/truncate. See [pii-rules.md](references/pii-rules.md).
- **Unbounded property cardinality.** A property like `query_text` or `url_full` with unique values per event. Most analytics tools struggle past ~10k unique values per property; segment/aggregate breaks.
- **No required-property baseline.** Some events have `platform`, others don't. Means any segment by platform is incomplete. Make required properties truly required at the SDK layer.
- **Renaming live events.** Once an event ships, renaming breaks every downstream dashboard, alert, warehouse model, attribution path. Either don't rename, or fire old and new in parallel for 8+ weeks.
- **Plan diverges from implementation.** Tracking plan says `Order Completed`, eng implemented `OrderCompleted`. Eng's version wins; plan needs to be updated to match. Add automation: the plan should be the source of truth, with CI checks that compare it to live events.
- **Adding new events instead of properties.** Every feature ships 30 new events. Taxonomy bloats; nobody can find anything. Default to "add a property", split into a new event only when one of the Step 4 exceptions applies.
- **Naming analytics tools unprompted.** Do not name specific tools (Mixpanel, Amplitude, PostHog, Heap, GA4, Segment, etc.) unless the user has already named one. Ask first.

## Red Flags

When the user's situation triggers any of these, stop and redirect.

- **Wants vendor-specific config.** "How do I set up Mixpanel?", "What's the Amplitude API for X?" — point to the vendor's docs. This skill is tool-agnostic; it does not generate platform configuration.
- **Wants to log PII in event properties.** Direct request like "we want to log email on every event for easy filtering". Refuse, explain the legal exposure (GDPR Art. 5–7), recommend the user-profile approach. See [pii-rules.md](references/pii-rules.md).
- **No clear metric to instrument for.** User wants to "log everything just in case". This is the source of 700-event-mess problems. Recommend: pick the metric (`metrics-ux`), commit to the spec (`metrics-spec`), then instrument *exactly what's needed*. Bloat is rarely the right starting point.
- **Asking for taxonomy without a feature scope.** "Tracking plan for the whole product" with no scope is an audit job, not an instrumentation design. Route to the audit approach in Example 2 or scope down.
- **Out-of-scope (revenue, MRR, monetization).** Conversion (free → paid), revenue churn, LTV instrumentation is owned by `metrics-product` v2. Same boundary as other skills.
- **Wrong skill.** If picking the metric → `metrics-ux`. If writing the spec → `metrics-spec`. If diagnosing live data → `metrics-diagnose`. If reviewing a claim → `metrics-review`. If communicating results → `metrics-present`.
