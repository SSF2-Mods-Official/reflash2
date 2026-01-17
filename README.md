# ReFlash2
Super Smash Flash 2, rebuilt with quality-of-life changes, modding-friendly features and a community-driven API for custom content.

This repository hosts a built copy of SSF2 with a variety of changes made to either enhance the base experience, as well make things significantly easier for aspiring mod content creators. It also includes source code and documentation for the new ModAPI, which is a custom set of features written and contributed to by the SSF2 Modding Community.

The build for ReFlash2 is based on a reverse engineered SSF2 engine, while the game data remains almost entirely unmodified from the original game that can be found here: https://www.supersmashflash.com/play/ssf2/

If anyone wishes to independently inspect the security of this build for any reason, they may use Flash decompilation software such as [JPEXS Free Flash Decompiler](https://github.com/jindrapetrik/jpexs-decompiler) or [AS3 Sorcerer](https://www.buraks.com/as3sorcerer/), both of which are excellent with script and asset inspection and have been used by the modding community for years.

## Unique Features

### Quality of Life
- Discord Rich Presence: If you run the game while Discord is open (and your settings allow for it), the game will pass detailed status information to your profile about what menu you're on, selected character/stage, current mode, and more. When you host a room in Online Mode, you can even invite players to your lobby via Discord chat. (For this to work, they must also be playing on a copy of ReFlash2.)

### Quality of Modding
- All .ssf files have their original, unencrypted names, making it easy to identify which file is responsible for what.
- All files are decompressed as well, meaning that inspecting the file in a decompiler is as simple as renaming it to an SWF.
- Debug Mode: Enjoy simple features that assist in development and/or content creation via the Debug Console, accessed by pressing the tilde key (~). In addition to that, the Adobe AIR debugger is always on in case an error occurs.
- Expansion Slot: An easy way to test modded characters, especially when they're in development. When you replace `id` with `expansion` in a character's Main class, name the file `test1.swf`, and drop it in `/build/data/character/`, it should appear in the game when you select the purple XP slot, given that there are no errors.

## SSF2 Mod API
The ModAPI is a custom, community-driven featureset for modded content that goes beyond the normal capabilities of the SSF2 engine. Example features include advanced audio processing (fading, pitch-shifting), as well as time manipulation (used for things like Chaos Control from the Sonic the Hedgehog franchise).

The source code and documentation for the Mod API class is available in `/src/`. One version of it is what's included in the engine that's compiled for ReFlash2, and the other is a stub version of the API meant to be compiled alongside modded content.


# Downloads
**For players**: Just get the zipped copy from the [Releases](https://github.com/stariwinkle/reflash2/releases).

**For developers**: Clone the repository.


## Want to contribute?
Please reach out via the official [SSF2 Mods Discord](https://discord.gg/yVPkqKQsx2) and review the [ModAPI Contributor Guidelines](src/docs/MODAPI_CONTRIBUTOR_GUIDELINES.md).

*All of the code related to the ModAPI consists of contributions from the SSF2 community, and as such, the source code and documentation for it contains ***no original code*** from McLeodGaming nor SSF2 Team.*



