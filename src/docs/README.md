# SSF2 Mod API (ModAPI)

**Version:** 0.1.0  

## Overview

The **SSF2 Mod API** is a community-maintained utility surface for Super Smash Flash 2. It operates independently from the official SSF2API and focuses on a handful of maintained capabilities: music fade control, pitch-shifted sound playback, limited time-control helpers, and lightweight debugging utilities. ModAPI no longer supports registering or distributing third-party feature modules.

### Key Benefits

- Clear separation: ModAPI calls stay distinct from SSF2API
- Guardrails: Ready-state checks and cautious engine access
- Audio control: Built-in music fades and pitch shifting for SFX
- Time manipulators: Time stop/freeze helpers for controlled gameplay moments
- Documented: ASDoc on every public method plus concise examples below

## Quick Start for Asset Developers

- First, ensure that you've included the `ModAPI` class a library via the ActionScript Settings in Adobe Animate. It's typically looking for a folder, so you could place the .as file in a folder and then link that folder to the libraries section.

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
- getAPIVersion() — returns MAJOR.MINOR.REVISION
- print(text) — debug output tagged with [ModAPI]
- getEngineAPI() — returns StageData (advanced use only)
- getSSF2API() — returns the SSF2API class for interop

Music Fade Control
- playMusicWithFadeOut(soundName, endTimeMs, fadeDurationMs=2000)
- startImmediateFadeOut(fadeDurationMs=2000)
- isMusicFadingOut()

Pitch-Shifted SFX
- playPitchShiftedEffect(soundName, initialPitch=1.0, scaleVolume=1.0)
- updatePitchShift(newPitch)
- updatePitchShiftVolume(volume)
- stopPitchShiftedEffect()
- isPitchShiftedEffectPlaying()

Time Manipulators
- stopTime(characterUID, length=-1, buffer=0, priority=int.MAX_VALUE-1, bypassOptions=null)
- resumeTime(characterUID)
- applyTimeFreeze(characterUID, length=-1)
- removeTimeFreeze(characterUID)

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

Time Stop / Freeze
```actionscript
if (ModAPI.isReady())
{
    ModAPI.stopTime(self.getUID(), 90, 3, 1);
}

// Later, cleanly resume
ModAPI.resumeTime(self.getUID());
```

## Safety & Best Practices

- Always gate calls with isReady() before touching audio/time helpers.
- Keep time-stop priority and buffer values reasonable to avoid conflicts.
- Avoid long-running pitch shifts without updatePitchShift(); stale values may sound rough.
- Use print() sparingly to keep the debug console readable.

## Troubleshooting

- "ModAPI not ready": Calls must happen during an active match lifecycle.
- No audio change: Confirm the sound ID exists and your fade/pitch values are within expected ranges.
- Time helpers not responding: Verify the character UID is valid and not null; time stop ignores invalid UIDs.

## Version & Compatibility

- Current Version: 0.1.0
- Format: MAJOR.MINOR.REVISION (semantic versioning)
- ModAPI versions are independent of SSF2API. When ModAPI behavior changes, the version and changelog are updated by maintainers.

## Directory Notes

```
com/mcleodgaming/ssf2/modapi/
├── ModAPI.as
├── MODAPI_CONTRIBUTOR_GUIDELINES.md
├── MODAPI_CHANGELOG.md
└── README.md
```

## Support

- Review ASDoc in ModAPI.as for parameter details.
- See MODAPI_CONTRIBUTOR_GUIDELINES.md for maintenance rules.
- Changelog lives in MODAPI_CHANGELOG.md.

---

ModAPI is maintained by the community and limited to the utilities listed above.

## Want to contribute?
Please reach out via the official [SSF2 Mods Discord](https://discord.gg/yVPkqKQsx2) and review the [ModAPI Contributor Guidelines](MODAPI_CONTRIBUTOR_GUIDELINES.md).
