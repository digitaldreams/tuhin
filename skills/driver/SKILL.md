---
name: driver
description: >
  Scaffold a swappable vendor driver behind an interface: new driver class, config entry, env
  switch, container binding — zero edits to existing drivers. Use whenever the user says "add a
  driver", "new provider", "make X swappable", "integrate <vendor> as a fallback/alternative",
  "faker driver", or wants to switch an external service (LLM, email, ranking, search, payment,
  storage) via configuration. Enforces open/closed: a new variant is a new class, never a
  modification of an existing one.
---

# Driver — Swappable Vendor Integration

Goal state, always: "change the .env and everything works like a charm — no code-level changes." A new vendor is a new class behind an existing contract. Existing drivers are untouchable.

## Phase 1 — Discover the Existing Pattern

1. Find the contract: grep for `*Interface`/`*Contract` matching the service domain, the manager/resolver that picks implementations, and the config file holding the switch.
2. Read one existing driver end to end — it defines the shape the new driver must mirror: constructor dependencies, error handling, return types, logging.
3. Read the config + env wiring: how the current default is selected, how credentials flow in.

## Phase 2 — If No Contract Exists Yet

1. Design the interface from the **actual call sites** — the 1–3 methods callers really use today. Small and focused; never a fat interface absorbing every conceivable capability (a send-mail contract does not grow a read-inbox method "for later").
2. Extract the existing concrete implementation behind that interface as driver #1, changing its callers to type-hint the interface. This is the only time existing code is edited — and it is a pure extraction, behavior identical, proven by the existing tests staying green.

## Phase 3 — Build the New Driver

1. One new class implementing the contract, named `{Vendor}{Domain}Driver`. It lives beside its siblings.
2. Config entry + env variable for selection and credentials. No `env()` calls outside config files.
3. Container/manager binding so the switch resolves it.
4. **Zero edits to existing drivers.** If the new driver "needs" a change in a sibling, the abstraction is wrong — stop and redesign the contract instead of patching around it.
5. Full substitutability: no caller may check which concrete driver it received. If a capability differs by vendor, it belongs in the contract or in config — never in an `instanceof` branch.

## Phase 4 — Symmetry & Tests

1. **Symmetric-paths check**: the new driver's post-processing (response parsing, error mapping, retry/backoff, logging, spend/usage recording) must match its siblings step for step. Diff them mentally; any asymmetry is a bug waiting.
2. Tests at the contract seam:
   - the new driver satisfies the interface (feature test with the vendor's HTTP faked)
   - the config switch resolves the right driver per env value
   - one swap test proving a caller works identically with either driver
3. Full suite green.

## Output Contract

1. Files created (driver, config, binding, tests) — and confirmation that no existing driver was edited (Phase 2 extraction excepted, called out separately if it happened).
2. The exact env lines that select the new driver.
3. Symmetry check result versus siblings.
4. Test results.
