# PII and consent rules

Two failure modes: capturing data you shouldn't, and handling consent incorrectly. Both have legal exposure (GDPR, CCPA, similar regimes). This reference holds the rules and a pre-launch privacy review checklist.

## What counts as PII

**PII (Personally Identifiable Information)** is any data that identifies, or could be combined with other data to identify, a specific individual. Categories from [GDPR Article 4(1)](https://gdpr-info.eu/art-4-gdpr/) and [CCPA §1798.140](https://oag.ca.gov/privacy/ccpa):

| Category | Examples |
|---|---|
| **Direct identifiers** | Full name, email, phone number, government ID, SSN, account number |
| **Online identifiers** | IP address (full), device fingerprint, cookie ID linked to an account, advertising ID |
| **Location** | Precise geolocation (coarser-than-city is usually fine; precise is PII) |
| **Biometric / health** | Photos, voice, fingerprints, health metrics |
| **Special-category data (GDPR Art. 9)** | Race, religion, political opinion, sexual orientation, trade-union membership, health, biometric |
| **Indirect identifiers** | Combinations that uniquely identify (postcode + birth year + gender often re-identifies) |
| **Free-text content** | Comments, search queries, chat messages, support tickets — high risk for *unintentional* PII (user types their email into a search bar) |

The hard rule for product analytics: **default to treating user-generated content as PII risk, even when no PII is structurally required.**

---

## Core rules

### 1. Never log raw PII in event properties

PII belongs in the **user-profile system** (the `identify` call in [Segment](https://segment.com/docs/connections/spec/identify/) or the equivalent in [Mixpanel](https://docs.mixpanel.com/docs/data-structure/user-profiles) and [Amplitude](https://amplitude.com/docs/apis/analytics/identify)), not in event properties. The user-profile system typically has:

- Stronger access controls.
- Deletion-on-request support.
- Audit logs.
- Documented retention.

Event properties typically don't. Event payloads end up in warehouse tables, dashboards, exports — places where PII shouldn't be casually exposed.

| Wrong | Right |
|---|---|
| `event: Order Completed`, `properties: { email: "x@y.com" }` | `event: Order Completed`, `properties: { ... }`. Email lives in the user-profile system, keyed by `user_id`. Analysis joins on `user_id` when needed. |
| `event: Signup Completed`, `properties: { full_name: "Jane Doe", phone: "+1..." }` | Same — these are user-profile traits, not event properties. |

### 2. Never log content the user typed

Free-text fields (search queries, comments, chat messages, support inputs) are the highest-risk source of accidental PII. Even when the field's purpose is benign, users will paste emails, account IDs, full names, addresses.

| Wrong | Right |
|---|---|
| `event: Search Submitted`, `properties: { query: "my SSN is 123-..." }` | `event: Search Submitted`, `properties: { query_length: 27, has_results: true, result_count: 12 }` |
| `event: Comment Posted`, `properties: { content: "..." }` | `event: Comment Posted`, `properties: { content_length: 142, has_attachment: false, mentions_user: true }` |

The pattern: capture **shape** (length, presence/absence, structure) without capturing **content**.

If the team genuinely needs to review what users typed (e.g. to improve search quality), build a **separate, consented research pipeline** with explicit opt-in. Don't try to do it through product analytics.

### 3. Hash or truncate when an identifier is needed for analysis

Some analyses legitimately need an identifier in the event payload. Example: tracking which referring email domain converted.

| Wrong | Right |
|---|---|
| `referral_email: "user@gmail.com"` | `referral_email_domain: "gmail.com"` |
| `internal_user_token: "u_8472"` (raw, joinable) | `user_id: hash("u_8472")` (one-way SHA-256, joinable within the workspace but not back to the user) |
| `phone: "+1-415-555-0100"` | `phone_country_code: "US"` |

Hashing is fine for **joining within the analytics workspace**; it is not fine if the hash function is weak or the salt is missing. SHA-256 with a workspace-secret salt is the practical baseline.

### 4. IP addresses

Full IP addresses are PII under GDPR per the [*Breyer* ruling, CJEU C-582/14 (2016)](https://curia.europa.eu/juris/document/document.jsf?docid=184668), and treated as such by most consent frameworks (e.g. [IAB Europe TCF v2.2](https://iabeurope.eu/tcf-2-2/)).

| Wrong | Right |
|---|---|
| `client_ip: "203.0.113.42"` (full) | `client_country: "US"`, `client_region: "CA"` (geo lookup before storing) |
| Storing `203.0.113.42` for fraud / abuse detection | Use a dedicated fraud system with proper access controls and retention; not product analytics. |

Most analytics tools support automatic IP truncation or geo-resolution; turn that on at the source if available.

### 5. Honor consent at the SDK layer

When the user declines tracking (cookie banner, GDPR consent, in-app privacy toggle), **no events fire**. The SDK config or a wrapper must enforce this. Relying on downstream filtering ("we'll drop them in the warehouse") is:

- Often non-compliant — events that reached the analytics tool may already be replicated to other systems.
- Brittle — a forgotten filter ships PII to a place it shouldn't be.
- Hard to audit — proving compliance requires showing the data never existed, not that it was filtered.

**Test in QA.** When consent = `false`, the analytics SDK is silent. Verify with network inspection before launch.

### 6. Document data retention

Each event type should have a stated retention window — the storage-limitation principle under [GDPR Art. 5(1)(e)](https://gdpr-info.eu/art-5-gdpr/). Typical bands:

| Use case | Retention |
|---|---|
| Product analytics | 13 months (covers year-over-year analysis with a margin) |
| Marketing attribution | 6 months |
| Operational monitoring | 30 days |
| Compliance / audit logs | per regulatory requirement (often 7+ years) |

The tracking plan names the retention; eng/ops implement automated deletion. Privacy/legal owns the policy.

---

## Special-category data (GDPR Art. 9)

Extra-protected categories under [GDPR Art. 9](https://gdpr-info.eu/art-9-gdpr/): race, ethnicity, religion, political opinion, philosophical belief, trade-union membership, genetic data, biometric data, health, sexual orientation, sex life.

**Default: do not log.** Even structured fields that appear neutral can carry inference risk (e.g. self-described dietary preference → religion).

If a product feature genuinely requires processing one of these (e.g. a health app), the legal basis is explicit consent under Art. 9(2)(a), and the analytics treatment is a separate decision from the feature itself. Loop in privacy/legal early.

---

## Children's data (COPPA, GDPR Art. 8)

If the product is intended for, or known to be used by, children under 13 ([COPPA — 16 CFR Part 312](https://www.ecfr.gov/current/title-16/chapter-I/subchapter-C/part-312)) or 16 ([GDPR Art. 8](https://gdpr-info.eu/art-8-gdpr/) baseline, varies by member state):

- Default: do not capture analytics events from these users.
- If captured, requires verifiable parental consent.
- Special retention and access rules.

This is a feature-level decision, not an analytics decision. If unsure, flag to legal.

---

## Pre-launch privacy review checklist

Before any new tracking plan goes live:

- [ ] No raw email, phone, full name, government ID, full IP, full credit card in any event property.
- [ ] No user-typed free text logged as event property (length / presence / shape only).
- [ ] All identifiers needed for analysis are hashed or truncated.
- [ ] All location data is at appropriate coarseness (country/region usually fine; precise geolocation needs explicit consent and reason).
- [ ] Consent state checked at SDK layer. When consent = false, events do not fire.
- [ ] Consent test cases pass QA: consent denied → no events fire; consent withdrawn mid-session → events stop firing.
- [ ] Special-category data is not logged unless explicit consent + documented legal basis.
- [ ] If product is or might be used by minors, COPPA/GDPR Art. 8 path is reviewed.
- [ ] Retention window documented for each event.
- [ ] Deletion-on-request supported (user requests deletion of their data → events are deleted, not just suppressed).
- [ ] Plan reviewed by someone other than the author (PM, eng lead, privacy DRI).

If any row is unchecked, the plan is not ready.

---

## Common mistakes

- **"We'll just delete it later."** Once data lands in the warehouse, replicas exist downstream (BI tools, exports, analyst notebooks). "Delete later" rarely means delete in practice.
- **"We need it for debugging."** Debug logs are not analytics. Separate the pipelines; debug data has different retention and access requirements.
- **"It's just a length, not the content."** True for `query_length`; check for `query_first_chars`, `query_preview`, or similar fields that smuggle content back in.
- **"The user_id is anonymous."** A user_id that is stable and joinable to other systems (CRM, support) is not anonymous in any practical sense. Treat as PII unless truly ephemeral.
- **"Consent is handled in the cookie banner."** Banner click ≠ SDK actually stopped firing. Verify at the network layer.
- **"It's just for internal analysis."** Internal access is still access. Legal exposure under [GDPR Art. 32](https://gdpr-info.eu/art-32-gdpr/) (security of processing) applies to internal systems too.

---

## When to involve privacy/legal

Always:

- Special-category data (Art. 9).
- Minors.
- Cross-border transfers (especially EU → outside EU/EEA without Standard Contractual Clauses).
- New analytics vendors (each vendor is a data processor; needs DPA review).

When in doubt:

- New event types that touch sensitive surfaces (account, payment, health, identity).
- Changes to consent flows.
- Retention extensions.

The cost of asking is a meeting. The cost of not asking is a regulator letter.

---

## See also

- [naming-conventions.md](naming-conventions.md) — what cannot go in property *names* (PII in names is as risky as in values).
- [tracking-plan-template.md](tracking-plan-template.md) — the `PII flag` and `Consent layer` columns where these decisions are documented.

External:
- [GDPR Articles 4–7, 9, 32](https://gdpr-info.eu/) — definitions, legal basis, special-category data, security.
- [CCPA §1798.140](https://oag.ca.gov/privacy/ccpa) — California definitions and consumer rights.
- [Segment — PII and event payloads](https://segment.com/docs/privacy/) — practical guidance aligned with the Segment Spec.
- [Mixpanel — Data privacy](https://docs.mixpanel.com/docs/privacy/protecting-user-data).
- [Court of Justice of the EU — *Breyer* C-582/14 (2016)](https://curia.europa.eu/) — IP addresses as personal data.
