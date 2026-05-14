# Naming conventions — events and properties

The single most important decision in a tracking plan. Once events flow under a convention, changing it is a migration. Pick one, write it down, enforce it.

## The two industry conventions

### Object–Action, Title Case, past tense (Segment standard)

> **Pattern:** `<Object> <Past-Tense-Action>` — e.g. `Order Completed`, `Article Viewed`, `Account Created`, `Subscription Cancelled`, `Push Notification Opened`.

Properties: `snake_case`, lowercase — e.g. `order_id`, `article_category`, `revenue_usd`.

**Used by:**
- [Segment Spec](https://segment.com/docs/connections/spec/) — defines this convention; the de-facto cross-tool standard.
- [Mixpanel — Data Structure: Events and Properties](https://docs.mixpanel.com/docs/data-structure/events-and-properties) — uses Title Case in all examples.
- [Amplitude — Event Tracking Plan](https://amplitude.com/blog/event-tracking-plan).

**Why it scales:**
- Object–Action separation makes events easy to find by feature ("everything that happens to an Order").
- Past tense matches the semantic — events fire **after** the action.
- Distinct casing for events (Title) vs properties (snake) makes them visually separable.

### snake_case, present tense (alternative)

> **Pattern:** `<object>_<action>` — e.g. `order_complete`, `article_view`, `account_create`.

Properties: also `snake_case`.

**Used by:** many in-house engineering tools and older codebases where the codebase convention dominates. ([Heap](https://heap.io) uses an autocapture-first model rather than a strict naming convention, but teams that name events manually often default to snake_case.)

**Why it is also fine:** one casing throughout; maps cleanly to backend log conventions; shorter to type.

### Recommendation

**Default to Object–Action Title Case past tense.** Three reasons:

1. **Cross-tool portability.** Most analytics, BI tools, and published examples use this convention.
2. **Visual separation.** Events and properties are easy to distinguish at a glance.
3. **Object–Action makes events findable.** Past ~100 events, sorting by object becomes essential.

snake_case is right when the org is already committed to it. What matters is **consistency**, not the choice. Mixing the two is the worst outcome — every analytics platform documentation warns against it explicitly ([Segment Spec](https://segment.com/docs/connections/spec/), [Mixpanel](https://docs.mixpanel.com/docs/data-structure/events-and-properties), [Amplitude](https://amplitude.com/blog/event-tracking-plan)).

---

## Hard rules (apply regardless of convention)

1. **One convention per workspace.** `Order Completed` and `order_complete` cannot coexist — most tools treat them as different events.
2. **No emojis, no spaces in property keys, no leading underscores.** Property keys: `snake_case`, ASCII letters, digits, underscores. Leading underscores are reserved by most tools ([Segment Spec — reserved names](https://segment.com/docs/connections/spec/common/#reserved-fields)).
3. **Stable contracts.** Once an event ships, its name and required properties are a contract. Renaming breaks dashboards, alerts, warehouse models, funnels.
4. **Reserved prefixes.** Do not prefix events with `_`, `$`, or tool-reserved tokens. Do not use `test`, `temp`, or `debug` in production event names.

---

## Object–Action: what counts as Object and Action?

**Object** = the entity the action happens to. A *noun*, ideally mapping to a domain concept the team uses.

| Domain concept | Object name |
|---|---|
| User account | `Account` (creation, deletion) or `User` (sessions, sign-ins) |
| Product item | `Product` |
| Order | `Order` |
| Cart | `Cart` or `Cart Item` |
| Search | `Search` |
| Notification | `Push Notification`, `Email`, `SMS` |
| Subscription | `Subscription` |
| Content | `Article`, `Post`, `Video` |
| Form | `Form` (submission), `Form Field` (per-field analytics) |

**Action** = a past-tense verb.

| Action type | Verb examples |
|---|---|
| Creation | `Created`, `Submitted`, `Started`, `Initiated` |
| Completion | `Completed`, `Finished`, `Confirmed`, `Sent` |
| View / impression | `Viewed`, `Impressed`, `Displayed` |
| Interaction | `Clicked`, `Tapped`, `Hovered`, `Opened`, `Closed` |
| State change | `Cancelled`, `Refunded`, `Suspended`, `Reactivated` |
| Failure | `Failed`, `Errored`, `Rejected` |

**Common mistakes:**

- **Object that is actually an adjective.** `Primary Button Clicked` — "Primary" describes the button; use `Button Clicked` + `button_type: "primary" | "secondary"`.
- **Action that is a noun.** `Order Completion` — use past tense.
- **Object that is a UI surface.** `Settings Page Viewed`, `Homepage Viewed` — consolidate into `Page Viewed` + `page_name`.
- **Verb that is not a user action.** `Page Loaded` is a system action; use `Page Viewed`.

---

## Rewrite table — common mistakes

| Wrong | Right | Why |
|---|---|---|
| `News Article Viewed`, `Sports Article Viewed`, ... | `Article Viewed` + `article_category` | Property describes; events mark distinct actions. |
| `Primary CTA Clicked`, `Secondary CTA Clicked` | `CTA Clicked` + `cta_id` | Same. |
| `Mobile Checkout Started`, `Web Checkout Started` | `Checkout Started` + baseline `platform` | Platform is a baseline property. |
| `Submit` | `Form Submitted` or `Order Placed` | Verb-only events are unparseable. |
| `User Action` (split into specific events) | One event per action type | Generic catch-all events are meaningless. |
| `User Login`, `User Logout`, `User Signup` | `Signed In`, `Signed Out`, `Signed Up` | Drop `User` — every event is implicitly user-attributed. |
| `New User Registered` | `Signed Up` | "New" is implicit. |
| `Page Viewed: Settings`, `Page Viewed: Profile` | `Page Viewed` + `page_name` | Properties handle the variant. |

---

## Property naming

| Rule | Right | Wrong |
|---|---|---|
| `snake_case`, lowercase | `article_category`, `order_id` | `articleCategory`, `OrderID` |
| Descriptive nouns | `revenue_usd`, `cart_item_count` | `r`, `cnt`, `val` |
| Units when ambiguous | `revenue_usd`, `duration_ms` | `revenue`, `duration` |
| Boolean prefix `is_`/`has_` | `is_first_purchase`, `has_attachment` | `first_purchase`, `attachment` |
| Enum values lowercase, no spaces | `status: "success" \| "failure" \| "timeout"` | `status: "Success!" \| "Failed"` |
| IDs end in `_id` | `user_id`, `order_id` | `user`, `userId` |
| Avoid PII in names | `email_domain`, `email_hash` | `email`, `full_email` |

### Property value rules

- **Enums when possible.** Free text becomes 50 spellings of "success".
- **Numbers as numbers, not strings.** `quantity: 3` not `"3"`.
- **Booleans as booleans.** `is_first: true` not `"true"`.
- **Timestamps in ISO 8601 UTC.** `"2026-03-05T18:42:00Z"`.
- **Bounded cardinality.** A property with millions of unique values breaks segment/aggregate; most tools struggle past ~10k unique values per property. Capture a derived form (`url_path` instead of `url_full`, `query_length` instead of `query`) when the source value is unbounded.

---

## Versioning

Most teams use a simple per-event version (`schema_version: 1`, then `2`).

| Change type | Backward-compatible? | Versioning |
|---|---|---|
| Add optional property | Yes | Document; no bump strictly required. |
| Add required property | No | Major version. Fire old + new in parallel. |
| Remove property | No | Major version. Deprecate with notice. |
| Rename property | No | Major version. Fire old + new in parallel. |
| Change value type | No | Major version. Migrate downstream. |

Keep a CHANGELOG for the tracking plan.

---

## Enforcement

Conventions do not survive without enforcement. Three mechanisms:

1. **Documentation.** A one-page standard in the team wiki.
2. **Code review.** A reviewer checks every PR firing new events.
3. **CI / lint rule.** Pre-commit hook scans for event names and rejects ones that do not match the convention regex. Fast and unmissable.

The third is the only one that scales. The first two erode within 6 months.

Sample regex for Object–Action Title Case past tense:

```
^([A-Z][a-z]+ )+[A-Z][a-z]+(ed|d|en|nt)$
```

Pair the regex with code review for cases it misses.

---

## See also

- [taxonomy-patterns.md](taxonomy-patterns.md) — event archetypes (funnel, lifecycle, feature).
- [tracking-plan-template.md](tracking-plan-template.md) — the artefact the convention produces.
- [pii-rules.md](pii-rules.md) — what cannot go in property values.
- [Segment Spec](https://segment.com/docs/connections/spec/) — canonical Object–Action reference.
- [Amplitude — taxonomy planning](https://amplitude.com/blog/event-tracking-plan) — practitioner guidance on naming and structure.
