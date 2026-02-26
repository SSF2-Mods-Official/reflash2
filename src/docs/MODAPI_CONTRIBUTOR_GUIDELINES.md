# SSF2 Mod API - Contributor Guidelines

## Overview

The **SSF2 Mod API** (`ModAPI`) is a small, utility-focused surface that ships with the IDK. It is independent of `SSF2API` and intentionally limited to maintained helpers (music fades, pitch-shifted SFX, controller rumble, time manipulators, debug output).

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
ModAPI.stopTime(this, 60, 2, 1);
ModAPI.rumbleController(this, 0.6, 0.4, 150);
```

## What Contributions Are In Scope

- Bug fixes to existing helpers (music fade, pitch shift, controller rumble, time stop/freeze, debug output)
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
- For time manipulators, validate characters/UIDs and reject invalid priorities/buffer values. Note that `applyTimeFreeze`/`removeTimeFreeze` no-op when a time stop is active (`_api.InTimeStop`).
- For audio helpers, keep pitch values within documented ranges (0.05–3.0) and handle missing sounds gracefully.
- For rumble helpers, resolve character-to-controller mapping gracefully; non-player characters silently no-op.
- Update `VERSION_REVISION` (or higher) and the changelog when behavior changes.

## Testing Checklist

- Music fades: start, mid-song trigger, and end-of-song trigger paths
- Pitch-shifted SFX: play, live pitch updates, volume updates, stop, and state checks
- Controller rumble: rumble start/stop, supportsRumble check, global enable/disable, non-player character handling
- Menu rumble: triggerMenuRumble with valid/invalid controller indices, stopMenuRumble
- Time manipulators: stop/resume, freeze/unfreeze, priority and buffer edge cases, freeze during active time stop
- Ready-state guards: ensure calls safely no-op when ModAPI is not initialized

## Documentation Expectations

- Keep ASDoc for each public method accurate (parameters, ranges, expected state).
- Keep code comments succinct and only where intent is non-obvious.
- Reflect any parameter/default changes in README and changelog.

## Need Help?

- Read `ModAPI.as` for the source of truth on available helpers and defaults.
- Use `SSF2API` documentation for engine context when needed.
- Reach out in the [SSF2 Mods Discord](https://discord.gg/yVPkqKQsx2) if behavior needs clarification.

---

Thanks for helping maintain ModAPI’s focused utility surface.
