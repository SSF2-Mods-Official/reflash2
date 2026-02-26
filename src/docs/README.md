# SSF2 Mod API (ModAPI)

**Version:** 0.3.0  

## Overview

The **SSF2 Mod API** is a community-maintained utility surface for Super Smash Flash 2. It operates independently from the official SSF2API and focuses on a handful of maintained capabilities: music fade control, pitch-shifted sound playback, controller rumble, time-control helpers, and lightweight debugging utilities.

### Key Benefits

- Clear separation: ModAPI calls stay distinct from SSF2API
- Guardrails: Ready-state checks and cautious engine access
- Audio control: Built-in music fades and pitch shifting for SFX
- Controller rumble: Dual-motor haptic feedback tied to characters
- Time manipulators: Time stop/freeze helpers for controlled gameplay moments
- Documented: ASDoc on every public method plus concise examples below

## Quick Start for Asset Developers

- First, ensure that you've included the `ModAPI` class as a library via the ActionScript Settings in Adobe Animate. It's typically looking for a folder, so you could place the .as file in a folder and then link that folder to the libraries section.

```actionscript
package
{

    public class MyCustomChar extends SSF2CharacterExt
    {
        public override function initialize():void
        {
            super.initialize();

            if (!ModAPI.isReady())
            {
                return;
            }

            // Trigger a short music fade when spawning
            ModAPI.startImmediateFadeOut(1500);
        }
    }
}
```

## Core Methods (static)

Lifecycle
- isReady() — true when ModAPI is initialized for the current match
- getAPIVersion() — returns MAJOR.MINOR.REVISION (e.g. "0.3.0")
- print(text) — debug output tagged with [ModAPI]
- getEngineAPI() — returns StageData (advanced use only)
- getSSF2API() — returns the SSF2API class for interop

Music Fade Control
- playMusicWithFadeOut(soundName, songEndTimeMs, fadeDurationMs=2000)
- startImmediateFadeOut(fadeDurationMs=2000)
- isMusicFadingOut()

Pitch-Shifted SFX
- playPitchShiftedEffect(soundName, initialPitch=1.0, scaleVolume=1.0) — returns Boolean
- updatePitchShift(newPitch)
- updatePitchShiftVolume(volume)
- stopPitchShiftedEffect()
- isPitchShiftedEffectPlaying()

Controller Rumble
- rumbleController(character, leftMotor, rightMotor, durationMs)
- stopRumble(character)
- supportsRumble(character) — returns Boolean
- isRumbleEnabled() — returns Boolean (global setting)
- triggerMenuRumble(controllerIndex) — light rumble for menu interactions
- stopMenuRumble() — stops rumble on all controllers

Time Manipulators
- stopTime(character, length=-1, buffer=0, priority=int.MAX_VALUE-1, bypassOptions=null)
- resumeTime(character)
- applyTimeFreeze(character, length=-1)
- removeTimeFreeze(character)

> **Note:** Time and rumble methods accept a character object (SSF2Character, MovieClip with a uid property) or an integer UID.

## Usage Examples

Music Fade
```actionscript
if (ModAPI.isReady())
{
    ModAPI.playMusicWithFadeOut("boss_theme", 120000, 2500);
}
```

Pitch Shifted Voice
```actionscript
if (ModAPI.playPitchShiftedEffect("jump_voice", 1.3, 0.9))
{
    ModAPI.updatePitchShift(1.3 + (momentum * 0.1));
}
```

Controller Rumble
```actionscript
if (ModAPI.isReady() && ModAPI.supportsRumble(this))
{
    // Heavy hit: strong low-freq, moderate high-freq, 200ms
    ModAPI.rumbleController(this, 0.8, 0.5, 200);
}

// Stop rumble early
ModAPI.stopRumble(this);
```

Time Stop / Freeze
```actionscript
if (ModAPI.isReady())
{
    // Stop time for 150 frames with 3-frame buffer at priority 1
    ModAPI.stopTime(this, 150, 3, 1);
}

// Later, cleanly resume
ModAPI.resumeTime(this);
```

```actionscript
// Freeze a specific character for 60 frames
ModAPI.applyTimeFreeze(target, 60);

// Unfreeze early
ModAPI.removeTimeFreeze(target);
```

## Safety & Best Practices

- Always gate calls with isReady() before touching audio/time/rumble helpers.
- Keep time-stop priority and buffer values reasonable to avoid conflicts.
- Avoid long-running pitch shifts without updatePitchShift(); stale values may sound rough.
- Use print() sparingly to keep the debug console readable.
- Check supportsRumble() before relying on haptic feedback — not all controllers support it.
- applyTimeFreeze/removeTimeFreeze are ignored while a time stop is active.

## Troubleshooting

- "ModAPI not ready": Calls must happen during an active match lifecycle.
- No audio change: Confirm the sound ID exists and your fade/pitch values are within expected ranges.
- Time helpers not responding: Verify the character is valid and not null; time stop ignores invalid characters. applyTimeFreeze/removeTimeFreeze will no-op when a time stop is already active.
- Rumble not working: Check that isRumbleEnabled() returns true and supportsRumble(character) returns true. Non-player characters (CPUs, sandbags) don't have controllers.

## Version & Compatibility

- Current Version: 0.3.0
- Format: MAJOR.MINOR.REVISION (semantic versioning)
- ModAPI versions are independent of SSF2API. When ModAPI behavior changes, the version and changelog are updated by maintainers.

## Directory Notes

```
src/
├── engine/
│   └── ModAPI.as          # Engine implementation
├── stub/
│   └── shared/
│       └── ModAPI.as      # Asset stub for FLA compilation
└── docs/
    ├── README.md
    ├── MODAPI_CHANGELOG.md
    ├── MODAPI_CONTRIBUTOR_GUIDELINES.md
    ├── INTEGRATION_GUIDE.md
    └── PROJECT_SUMMARY.md
```

## Support

- Review ASDoc in ModAPI.as for parameter details.
- See MODAPI_CONTRIBUTOR_GUIDELINES.md for maintenance rules.
- Changelog lives in MODAPI_CHANGELOG.md.

---

ModAPI is maintained by the community and limited to the utilities listed above.

## Want to contribute?
Please reach out via the official [SSF2 Mods Discord](https://discord.gg/yVPkqKQsx2) and review the [ModAPI Contributor Guidelines](MODAPI_CONTRIBUTOR_GUIDELINES.md).
