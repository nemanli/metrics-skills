# Taxonomy patterns — event archetypes

Three archetypes that cover most product analytics needs. Each has a different shape of event design. Mixing them within one feature is the most common source of "too many events" bloat. The funnel / lifecycle / interaction split mirrors the [Segment Spec](https://segment.com/docs/connections/spec/) family (Ecommerce, Mobile, B2B) and is the dominant pattern across [Mixpanel](https://docs.mixpanel.com/docs/data-structure/events-and-properties) and [Amplitude](https://amplitude.com/blog/event-tracking-plan).

## The three archetypes

| Archetype | What it tracks | Example events |
|---|---|---|
| **Funnel** | Sequential steps toward a goal | `Checkout Started`, `Shipping Submitted`, `Payment Submitted`, `Order Completed` |
| **Lifecycle** | State transitions of a long-lived entity | `Account Created`, `Subscription Started`, `Subscription Cancelled`, `Account Deleted` |
| **Feature interaction** | Discrete actions on a feature | `Comment Posted`, `Filter Applied`, `Article Saved`, `Settings Changed` |

Most features touch all three. The trick is to recognize which archetype each event belongs to, because the property design differs.

---

## Funnel events

**Purpose:** measure progression through a multi-step flow.

**Shape:** one event per step. Properties capture step-level context.

**Example: onboarding funnel** (the most common designer-led funnel)

| Event | Trigger | Required event-specific properties |
|---|---|---|
| `Signup Started` | User submits signup form | `signup_method` (enum: email/google/apple), `signup_id` |
| `Profile Step Completed` | User finishes step in profile setup | `step_name`, `step_index`, `signup_id` |
| `First Action Completed` | User reaches the activation moment | `action_type`, `time_since_signup_sec`, `signup_id` |
| `Onboarding Completed` | User reaches end of onboarding | `steps_completed`, `total_time_sec`, `signup_id` |

**Key design rules:**

- **Carry a shared identifier (`signup_id` here) across all funnel events.** This lets the analyst stitch the funnel together for any individual user, especially across sessions.
- **Each step is a distinct event.** Do not collapse them into a single `Onboarding Step` event with a `step_number` property — that prevents using built-in funnel charts in most tools and makes per-step drop-off analysis painful.
- **Capture the relevant *snapshot* at each step.** `Onboarding Completed` carries `total_time_sec` because that is the moment the full duration is final; `Signup Started` carries `signup_method` because the channel matters for "did email signups complete more than social signups?".
- **Don't track an explicit `Funnel Step Failed` event.** Absence of the next step is the failure signal. Adding a "failed" event doubles the schema for no analytical gain.

The same shape applies to e-commerce checkout — the canonical [Segment Ecommerce Spec](https://segment.com/docs/connections/spec/ecommerce/v2/) example designers encounter when working on commerce surfaces:

| Event | Trigger | Required event-specific properties |
|---|---|---|
| `Checkout Started` | User clicks "Checkout" from cart | `cart_value_usd`, `cart_item_count`, `cart_id` |
| `Shipping Submitted` | User submits shipping form | `shipping_method`, `address_country`, `cart_id` |
| `Payment Submitted` | User submits payment form | `payment_method`, `cart_id` |
| `Order Completed` | Order confirmation page reached | `order_id`, `revenue_usd`, `item_count`, `payment_method`, `cart_id` |

Same rules apply: shared identifier (`cart_id`), distinct event per step, semantic naming. **Common funnel mistakes:**

| Wrong | Right |
|---|---|
| `Checkout Step` event with `step: "shipping"` | Separate events per step. |
| Each step fires the cart value | Carry the cart_id; join to cart state at analysis time if needed. |
| Adding a `step_status: "failed"` property | Absence of the next event = failure. |
| Naming with step numbers (`Checkout Step 1`) | Name semantically (`Shipping Submitted`); steps can be reordered, numbers can't. |

---

## Lifecycle events

**Purpose:** track state transitions of a long-lived entity (user, account, subscription, content).

**Shape:** one event per transition. Properties capture the from/to state and the reason.

**Example: subscription lifecycle** (pattern from the [Segment B2B Saas Spec](https://segment.com/docs/connections/spec/b2b-saas/))

| Event | Trigger | Required event-specific properties |
|---|---|---|
| `Subscription Started` | New subscription created | `plan_id`, `billing_period`, `price_usd`, `is_trial`, `referral_source` |
| `Subscription Upgraded` | Plan changed to higher tier | `previous_plan_id`, `new_plan_id`, `price_delta_usd` |
| `Subscription Downgraded` | Plan changed to lower tier | `previous_plan_id`, `new_plan_id`, `price_delta_usd` |
| `Subscription Cancelled` | User cancels (vs lapses) | `previous_plan_id`, `cancel_reason` (enum), `days_active` |
| `Subscription Reactivated` | Cancelled user re-subscribes | `previous_cancel_date`, `new_plan_id` |

**Key design rules:**

- **State transitions, not state checks.** Don't fire an event "every day the user is subscribed". Fire when state *changes*. The current state is queried from the user-profile system, not reconstructed from events.
- **Capture from-state and to-state.** Subscription change is meaningless without knowing what was before and after. Properties like `previous_plan_id` + `new_plan_id`.
- **Capture the reason when it's available.** `cancel_reason` (enum: `too_expensive`, `not_using`, `switching_to_competitor`, `temporary`, `other`) is far more useful than just knowing they cancelled.
- **Don't fire on internal/system events.** A subscription auto-renewing without user action is a billing event, not a user lifecycle event. Track it separately or in the billing system, not in product analytics.

**Common lifecycle mistakes:**

| Wrong | Right |
|---|---|
| `Subscription Active` event fired daily | Fire on state change only. Current state is a user-profile property. |
| `Subscription Cancelled` without `cancel_reason` | Always include the reason enum, even if "other" is one option. |
| Splitting into `Pro Subscription Started`, `Team Subscription Started` | One `Subscription Started` event with `plan_id` property. |
| Mixing with feature events | Lifecycle is its own archetype; don't mix `Subscription Cancelled` with `Settings Changed`. |

---

## Feature interaction events

**Purpose:** measure usage of a feature or surface.

**Shape:** one event per discrete user action. Properties capture what was acted on.

**Example: article feature interactions**

| Event | Trigger | Required event-specific properties |
|---|---|---|
| `Article Viewed` | User opens an article | `article_id`, `article_category`, `entry_point` (enum: `feed`, `search`, `recommendation`, `direct_link`) |
| `Article Saved` | User taps "Save" | `article_id`, `is_saved` (true on save, false on unsave) |
| `Article Shared` | User taps "Share" | `article_id`, `share_destination` (enum: `link_copy`, `email`, `twitter`, `whatsapp`, `other`) |
| `Article Commented` | User posts a comment | `article_id`, `comment_length` (NOT content) |

**Key design rules:**

- **The feature's primary object is the entity.** Articles → `Article` events. Settings → `Settings` events. Filter UI → `Filter` events.
- **Use `entry_point` to track how the user reached the feature.** Crucial for understanding which discovery paths convert.
- **Avoid splitting on surface details.** `Mobile Article Viewed`, `Web Article Viewed` are wrong — `platform` is a baseline required property; use it.
- **Avoid catch-all events.** A single `Article Interaction` event with `interaction_type` property has 20 enum values and three contradicting required-property schemas. Split into proper events per Step 4 of the SKILL.

**Common feature mistakes:**

| Wrong | Right |
|---|---|
| `Generic Interaction Event` with a `type` property | Split into one event per type. |
| `Comment Posted` with `content: "..."` | `comment_length: int`; never log content. See [pii-rules.md](pii-rules.md). |
| `Filter Applied` per filter (`Date Filter Applied`, `Category Filter Applied`) | `Filter Applied` with `filter_type` and `filter_value` properties. |
| Tracking *every* hover, scroll, viewport entry | Most of these are noise. Track interactions tied to a defined metric, not "anything that moves". |

---

## When archetypes mix in one feature

Most features touch all three archetypes. Example: a new AI assistant feature ships:

- **Lifecycle:** `Assistant Feature Enabled`, `Assistant Feature Disabled` (user toggles the feature in settings).
- **Funnel:** `Assistant Opened` → `Assistant Query Submitted` → `Assistant Response Received` → `Assistant Response Rated`.
- **Feature interaction:** `Assistant Conversation Saved`, `Assistant Conversation Exported`.

Each lives in its archetype. Don't merge across — `Assistant Action` with 10 types blurs lifecycle, funnel, and interaction signals together and makes the dashboard unanalyzable.

---

## Anti-pattern: the catch-all event

> `event: User Activity`, `properties: { activity_type: "..." }`

What's wrong: every analysis becomes "filter where activity_type=X", losing the analytical affordances tools provide (funnel charts, retention by event, etc.). The taxonomy is technically present but practically useless.

When this pattern appears:

- The user wants flexibility without committing to event design.
- The team is afraid of "too many events".
- The eng is reusing one event-emission code path for everything.

The fix: separate events for separate user actions. "Too many events" with the right names is far less painful than "one event" with 30 mystery branches.

---

## Anti-pattern: the surface-named event

> `event: Settings Page Viewed`, `event: Profile Page Viewed`, `event: Dashboard Page Viewed`, ...

What's wrong: each page becomes a separate event. As pages are added, events bloat unbounded. Migration breaks every time UI is restructured.

The fix: one `Page Viewed` event with a `page_name` property (or its equivalent in your taxonomy). Or, more rigorously: capture pageview as a baseline event and reserve named events for actions, not navigations.

---

## Anti-pattern: tracking everything "just in case"

> "Let's track every click, every hover, every scroll, so we have the data if we need it."

What is wrong: cost explodes, dashboards become unfilterable, PII risk multiplies, and the team cannot tell which events are load-bearing vs noise. Both [Mixpanel](https://docs.mixpanel.com/docs/data-structure/events-and-properties) and [Amplitude](https://amplitude.com/blog/event-tracking-plan) warn against this pattern: instrument only what feeds a defined metric.

The fix: track what feeds a defined metric (from `metrics-ux` and `metrics-spec`). If no metric uses the event, do not capture it.

---

## Recommended counts

Rough guidance, not hard rules:

| Product maturity | Reasonable event count |
|---|---|
| MVP / early prototype | 5–15 |
| Single-feature beta | 15–40 |
| Mature product, one team | 40–100 |
| Mature product, multi-team | 100–300 |
| Multi-product platform | 300–700 |

Above 700 events usually means the taxonomy has grown organically rather than been designed — see Example 2 in the SKILL for the audit-and-migrate path.

---

## See also

- [naming-conventions.md](naming-conventions.md) — the conventions every event in this reference assumes.
- [tracking-plan-template.md](tracking-plan-template.md) — the artefact that captures the events you design with these archetypes.
- [pii-rules.md](pii-rules.md) — what cannot go in any of these archetypes' properties.

External:
- [Segment Spec — Ecommerce, Mobile, B2B Spec](https://segment.com/docs/connections/spec/) — canonical funnel and lifecycle event names.
- [Amplitude — Taxonomy planning](https://amplitude.com/blog/event-tracking-plan).
- [Mixpanel — Data Structure](https://docs.mixpanel.com/docs/data-structure/events-and-properties).
