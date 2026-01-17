
# ModAPI Changelog

All notable changes to the SSF2 Mod API will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
- PitchShiftSound.as class for advanced audio processing

#### Architecture
- Direct static method approach (mirrors SSF2API design)
- Simple, straightforward API with no metadata registry
- Ready for future subclass division if needed
- Both engine and asset-side stubs provided

#### Integration
- ModAPI.init() integrated in StageData constructor
- ModAPI.deinit() integrated in StageData.endMatch()
- ModAPI.init()/deinit() called in MatchResultsMenu transitions
- SoundQueue enhanced with fade-out AND pitch-shifting capabilities
- All 4 initialization/deinitialization points updated
- Auto-initialization with no manual setup required

#### Documentation
- `README.md` - Complete API reference and quick start guide
- `MODAPI_CONTRIBUTOR_GUIDELINES.md` - Comprehensive contribution guide
- `INDEX.md` - Documentation hub and navigation guide
- `INTEGRATION_GUIDE.md` - Technical integration details
- `PROJECT_SUMMARY.md` - Architecture overview and file descriptions
- `00_START_HERE.md` - Project completion summary
- ASDoc comments on all public methods and classes
- Feature metadata template with author, version, description, dependencies, usage
- 30+ examples of feature implementation and usage patterns
- Best practices guide for safe engine access
- Troubleshooting section

#### Directory Structure
- `com/mcleodgaming/ssf2/modapi/` - Core API module
- `com/mcleodgaming/ssf2/modapi/features/` - Community features directory
- `com/mcleodgaming/ssf2/modapi/docs/` - Documentation folder
- Organized for scalability with multiple contributors

---

## How to Contribute

See [MODAPI_CONTRIBUTOR_GUIDELINES.md](MODAPI_CONTRIBUTOR_GUIDELINES.md) for:
- Documentation requirements
- Testing procedures
- Submission checklist

### Contributor Recognition

Contributors will be credited in:
3. API documentation
4. Community credits

---

## Version Compatibility

| ModAPI Version | SSF2 Version | Status |
|---|---|---|
| 0.1.0 | 1.4.0+ | ✅ Current |

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
   - [ ] Version numbers updated in ModAPI.as
   - [ ] All examples tested
   - [ ] Backward compatibility verified

3. **Community Guidelines**
   - Encourage contributions but maintain code quality
   - Require ASDoc for all public methods
   - Require feature metadata registration
   - Ensure proper cleanup in deinit()
   - No direct SSF2API modifications

---

**Last Updated:** 2026-01-14  
**Maintainer:** stariwinkle
