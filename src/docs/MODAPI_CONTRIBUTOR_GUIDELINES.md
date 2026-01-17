# SSF2 Mod API - Contributor Guidelines

## Overview

The **SSF2 Mod API** (`ModAPI`) is a small, utility-focused surface that ships with the IDK. It is independent of `SSF2API` and intentionally limited to maintained helpers (music fades, pitch-shifted SFX, time manipulators, debug output).
## Core Principles

1. **Independence**: ModAPI never modifies SSF2API; calls remain clearly distinct.
2. **Stable Scope**: Only the maintained helpers listed in `ModAPI.as` are supported.
3. **Safety First**: Always honor `isReady()` and avoid unsafe engine access.
4. **Low Noise**: Keep debug output concise and avoid noisy traces.
5. **Traceability**: Update version/changelog when behavior changes.

## Quick Start (Using ModAPI)

```actionscript
if (!ModAPI.isReady())
{
    return;
}

ModAPI.playMusicWithFadeOut("bgm_menu", 90000, 2500);
ModAPI.stopTime(self.getUID(), 60, 2, 1);
```

## What Contributions Are In Scope

- Bug fixes to existing helpers (music fade, pitch shift, time stop/freeze, debug output)
- Documentation updates that reflect actual behavior and parameters
- Safety/guard improvements (null checks, bounds checks, error messages)
- Compatibility fixes to keep ModAPI aligned with engine changes
- Light ergonomics (clearer ASDoc examples, minimal logging improvements)

## What Is Out of Scope

- Expanding ModAPI beyond its current helper set without maintainer sign-off
- Modifying SSF2API or unrelated engine systems
- Adding new dependencies or heavy runtime overhead
- Changing any original engine functionality (e.g. changing how Air Dodges fundamentally work)

## Implementation Guidelines

- Gate all behavior with `ModAPI.isReady()`; return early on failure.
- Use `getEngineAPI()` only when strictly necessary; guard nulls before use.
- Keep debug output routed through `ModAPI.print()` and minimal in volume.
- For time manipulators, validate UIDs and reject invalid priorities/buffer values.
- For audio helpers, keep pitch values within documented ranges and handle missing sounds gracefully.
- Update `VERSION_REVISION` (or higher) and the changelog when behavior changes.

## Testing Checklist

- Music fades: start, mid-song trigger, and end-of-song trigger paths
- Pitch-shifted SFX: play, live pitch updates, volume updates, stop, and state checks
- Time manipulators: stop/resume, freeze/unfreeze, priority and buffer edge cases
- Ready-state guards: ensure calls safely no-op when ModAPI is not initialized

## Documentation Expectations

- Keep ASDoc for each public method accurate (parameters, ranges, expected state).
- Keep code comments succinct and only where intent is non-obvious.
- Reflect any parameter/default changes in README and changelog.

## Need Help?

- Read `ModAPI.as` for the source of truth on available helpers and defaults.
- Use `SSF2API` documentation for engine context when needed.
- Reach out in the [SSF2 Mods Discord](https://discord.gg/yVPkqKQsx2)m if behavior needs clarification.

---

Thanks for helping maintain ModAPI’s focused utility surface.
