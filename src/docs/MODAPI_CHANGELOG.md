
# ModAPI Changelog

All notable changes to the SSF2 Mod API will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.3.0] - 2026-02-26

### Added

#### Menu Rumble
- `triggerMenuRumble(controllerIndex)` - Light haptic feedback for menu interactions (0.4/0.4 intensity, 100ms)
- `stopMenuRumble()` - Stops rumble on all connected controllers
- Checks global and per-player rumble settings before triggering

## [0.2.0] - 2026-01-28

### Added

#### Controller Rumble
- `rumbleController(character, leftMotor, rightMotor, durationMs)` - Dual-motor rumble tied to a character's controller
- `stopRumble(character)` - Immediately stop rumble for a character's controller
- `supportsRumble(character)` - Check if the character's controller supports rumble
- `isRumbleEnabled()` - Check if rumble is enabled globally in user settings
- Automatic character-to-controller resolution (SSF2Character, MovieClip with uid, or raw UID int)
- Graceful no-op for non-player characters (CPUs, sandbags)

#### Time Manipulation (Author: Jotardo)
- `stopTime(character, length, buffer, priority, bypassOptions)` - Per-character time stop with priority system
- `resumeTime(character)` - Remove a character's time stop
- `applyTimeFreeze(character, length)` - Freeze a specific character (ignored during active time stop)
- `removeTimeFreeze(character)` - Unfreeze a specific character (ignored during active time stop)
- All time methods accept SSF2Character, MovieClip, or integer UID

## [0.1.0] - 2026-01-14

### Added

#### Core API
- `ModAPI.as` - Foundation for community-driven engine extensions
- Automatic initialization/deinitialization synchronized with SSF2API
- `isReady()` - Check if ModAPI is initialized
- `getAPIVersion()` - Get version string
- `print()` - Debug output to console
- `getEngineAPI()` - Advanced engine access (StageData)
- `getSSF2API()` - Interop with official API

#### Music Features
- `playMusicWithFadeOut(soundName, songEndTimeMs, fadeDurationMs)` - Play music with automatic fade-out
- `startImmediateFadeOut(fadeDurationMs)` - Fade out current music immediately
- `isMusicFadingOut()` - Check if music is currently fading
- Timer-based fade system with smooth volume ramping
- Automatic cleanup and resource management

#### Pitch-Shifting Features
- `playPitchShiftedEffect(soundName, initialPitch, scaleVolume)` - Play sound with dynamic pitch
- `updatePitchShift(newPitch)` - Real-time pitch adjustment (0.05x to 3.0x)
- `updatePitchShiftVolume(volume)` - Volume control during playback
- `stopPitchShiftedEffect()` - Stop and cleanup pitch-shifted audio
- `isPitchShiftedEffectPlaying()` - Check pitch-shifting status
- Real-time sample-level pitch manipulation with linear interpolation

#### Architecture
- Direct static method approach (mirrors SSF2API design)
- Simple, straightforward API with no metadata registry
- Both engine and asset-side stubs provided

#### Integration
- ModAPI.init() integrated in StageData constructor
- ModAPI.deinit() integrated in StageData.endMatch()
- ModAPI.init()/deinit() called in MatchResultsMenu transitions
- SoundQueue enhanced with fade-out and pitch-shifting capabilities
- Auto-initialization with no manual setup required

#### Documentation
- `README.md` - Complete API reference and quick start guide
- `MODAPI_CONTRIBUTOR_GUIDELINES.md` - Contribution guide
- `INTEGRATION_GUIDE.md` - Technical integration details
- `PROJECT_SUMMARY.md` - Architecture overview and file descriptions
- ASDoc comments on all public methods and classes

---

## How to Contribute

See [MODAPI_CONTRIBUTOR_GUIDELINES.md](MODAPI_CONTRIBUTOR_GUIDELINES.md) for:
- Documentation requirements
- Testing procedures
- Submission checklist

---

## Version Compatibility

| ModAPI Version | SSF2 Version | Status |
|---|---|---|
| 0.3.0 | 1.4.0+ | Current |
| 0.2.0 | 1.4.0+ | Superseded |
| 0.1.0 | 1.4.0+ | Superseded |

---

## Notes for Future Maintainers

When adding new features or releasing new versions:

1. **Version Bumping Rules**
   - MAJOR: Breaking changes to public API
   - MINOR: New features, backward compatible
   - REVISION: Bug fixes, documentation

2. **Release Checklist**
   - [ ] All tests passing
   - [ ] Documentation updated
   - [ ] Changelog updated
   - [ ] Version numbers updated in both engine and stub ModAPI.as
   - [ ] All examples tested
   - [ ] Backward compatibility verified

3. **Community Guidelines**
   - Encourage contributions but maintain code quality
   - Require ASDoc for all public methods
   - Ensure proper cleanup in deinit()
   - No direct SSF2API modifications

---

**Last Updated:** 2026-02-26  
**Maintainer:** stariwinkle
