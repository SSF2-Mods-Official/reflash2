// SSF2 Mod API
// Community-driven engine extension API for custom mod features
// Completely independent from SSF2API - no modifications to original engine API

package com.mcleodgaming.ssf2.modapi
{
    import com.mcleodgaming.ssf2.engine.StageData;
    import com.mcleodgaming.ssf2.util.Utils;
    import flash.display.MovieClip;
    import com.mcleodgaming.ssf2.engine.InteractiveSprite;
    import com.mcleodgaming.ssf2.engine.Character;
    import __AS3__.vec.Vector;
    import flash.geom.Point;
    import com.mcleodgaming.ssf2.controllers.MenuController;
    import com.mcleodgaming.ssf2.Main;
    import com.mcleodgaming.ssf2.audio.SoundQueue;
    import com.mcleodgaming.ssf2.util.ResourceManager;
    import com.mcleodgaming.ssf2.api.SSF2API;
    import com.mcleodgaming.ssf2.api.SSF2Character;
    import com.mcleodgaming.ssf2.util.SaveData;
    import com.mcleodgaming.ssf2.input.Gamepad;

    /**
     * ModAPI - Community-Driven Engine Extension API
     *
     * Provides direct access to custom engine features and utilities.
     * Maintains complete independence from SSF2API for clear separation of concerns.
     * Functions are organized by category and may be split into subclasses if the API grows.
     *
     * @author SSF2 Mods Official, stariwinkle
     * @version 0.2.0
     */
    public class ModAPI
    {
        // ========== VERSION INFORMATION ==========
        public static const VERSION_MAJOR:int = 0;
        public static const VERSION_MINOR:int = 3;
        public static const VERSION_REVISION:int = 0;

        // ========== INTERNAL STATE ==========
        private static var _api:StageData;
        private static var _isInitialized:Boolean = false;

        // ========== INITIALIZATION ==========

        /**
         * Initialize the ModAPI with the current stage/game context.
         * Called automatically alongside SSF2API.init() when a match begins.
         *
         * @param api The StageData instance (passed from engine)
         */
        public static function init(api:StageData):void
        {
            trace("[ENGINE ModAPI] init() called with api=" + api);
            _api = api;
            _isInitialized = true;
            trace("[ENGINE ModAPI] init() - _api assigned, _isInitialized = true");
            trace((((((("SSF2 Mod API Version " + VERSION_MAJOR) + ".") + VERSION_MINOR) + ".") + VERSION_REVISION) + " initialized."));
        }

        /**
         * Deinitialize the ModAPI when a match ends or transitions.
         * Called automatically alongside SSF2API.deinit().
         */
        public static function deinit():void
        {
            trace("[ENGINE ModAPI] deinit() called");
            _api = null;
            _isInitialized = false;
            trace("[ENGINE ModAPI] deinit() - _api cleared, _isInitialized = false");
            trace("ModAPI deactivated.");
        }

        /**
         * Get the current API version string.
         * Useful for version compatibility checks in assets.
         *
         * @return Version string in format "MAJOR.MINOR.REVISION"
         */
        public static function getAPIVersion():String
        {
            return ((((VERSION_MAJOR + ".") + VERSION_MINOR) + ".") + VERSION_REVISION);
        }

        /**
         * Check if ModAPI is currently initialized and ready to use.
         *
         * @return true if API is initialized, false otherwise
         */
        public static function isReady():Boolean
        {
            return ((_api) && (_isInitialized) && (_api.ActiveScripts));
        }

        // ========== UTILITY & DEBUGGING ==========

        /**
         * Print debug message to console (if debug mode is enabled).
         * Same interface as SSF2API.print() but clearly from ModAPI.
         *
         * @param text The message to print
         */
        public static function print(text:String):void
        {
            if (((Main.DEBUG) && (MenuController.debugConsole)))
            {
                MenuController.debugConsole.writeTextData(("[ModAPI] " + text));
            }
        }

        /**
         * Get the underlying StageData instance for advanced operations.
         * Use with caution - direct StageData manipulation can cause instability.
         *
         * @return The current StageData instance, or null if not initialized
         */
        public static function getEngineAPI():StageData
        {
            if (!isReady())
            {
                print("Warning: Attempted to access engine API while ModAPI not initialized");
                return (null);
            }
            return (_api);
        }

        /**
         * Get access to the parent SSF2API for interop between APIs.
         * Allows community features to leverage official engine features.
         *
         * @return The SSF2API class for static method calls
         */
        public static function getSSF2API():Class
        {
            return (SSF2API);
        }

        // ========== MUSIC FADE-OUT FEATURES ==========
        // Author: stariwinkle

        /**
         * Play music that automatically fades out at a specified time.
         *
         * <p>The music will play normally until it reaches the fade-out point, then
         * gradually decrease in volume over the fade duration before stopping.</p>
         *
         * @param soundName The music ID to play
         * @param songEndTimeMs When the fade-out should start (in milliseconds from song start)
         * @param fadeDurationMs How long the fade should take (default 2000ms)
         * @example ModAPI.playMusicWithFadeOut("boss_theme", 120000, 3000);
         */
        public static function playMusicWithFadeOut(soundName:String, songEndTimeMs:Number, fadeDurationMs:Number = 2000):void
        {
            if (!isReady())
            {
                print("Error: Cannot play music with fade-out - ModAPI not ready");
                return;
            }
            SoundQueue.instance.playMusicWithFadeOut(soundName, songEndTimeMs, fadeDurationMs);
        }

        /**
         * Start fading out the currently playing music immediately.
         *
         * <p>Useful for triggering fade-outs in response to game events without
         * needing to know the song's total duration in advance.</p>
         *
         * @param fadeDurationMs How long the fade should take (default 2000ms)
         * @example ModAPI.startImmediateFadeOut(1500);
         */
        public static function startImmediateFadeOut(fadeDurationMs:Number = 2000):void
        {
            if (!isReady())
            {
                return;
            }
            SoundQueue.instance.startImmediateFadeOut(fadeDurationMs);
        }

        /**
         * Check if music is currently fading out.
         *
         * @return Boolean <code>true</code> if a fade-out is in progress, <code>false</code> otherwise
         */
        public static function isMusicFadingOut():Boolean
        {
            if (!isReady())
            {
                return (false);
            }
            // Check if fade-out is enabled in SoundQueue
            return (SoundQueue.instance.isFadeOutEnabled());
        }

        // ========== PITCH-SHIFTING FEATURES ==========

        // Author: stariwinkle

        /**
         * Play a sound effect with dynamic pitch shifting.
         *
         * <p>Creates a real-time pitch-shifted version of the sound that can be
         * adjusted on-the-fly using updatePitchShift(). Useful for character voice effects,
         * slow-motion audio, or dynamic audio processing.</p>
         *
         * @param soundName The sound ID to play
         * @param initialPitch Starting pitch shift (1.0 = normal, 2.0 = one octave up, 0.5 = one octave down, range 0.05 to 3.0)
         * @param scaleVolume Volume multiplier (default 1.0)
         * @return Boolean <code>true</code> if successful, <code>false</code> if sound not found
         * @example ModAPI.playPitchShiftedEffect("jump_voice", 1.5, 1.0);
         */
        public static function playPitchShiftedEffect(soundName:String, initialPitch:Number = 1.0, scaleVolume:Number = 1):Boolean
        {
            if (!isReady())
            {
                print("Error: Cannot play pitch-shifted effect - ModAPI not ready");
                return (false);
            }
            return (SoundQueue.instance.playPitchShiftedEffect(soundName, initialPitch, scaleVolume));
        }

        /**
         * Update the pitch of the currently playing pitch-shifted sound in real-time.
         *
         * <p>Call this every frame during gameplay to create dynamic pitch-ramping effects,
         * such as speeding up audio as momentum builds or slowing it down for slow-motion effects.</p>
         *
         * @param newPitch New pitch value (1.0 = normal, 2.0 = one octave up, 0.5 = one octave down, range 0.05 to 3.0)
         * @example ModAPI.updatePitchShift(1.0 + (speedMultiplier * 0.5));
         */
        public static function updatePitchShift(newPitch:Number):void
        {
            if (!isReady())
            {
                return;
            }
            SoundQueue.instance.updatePitchShift(newPitch);
        }

        /**
         * Update the volume of the currently playing pitch-shifted sound.
         *
         * @param volume New volume level (0.0 to 1.0)
         * @example ModAPI.updatePitchShiftVolume(0.5);
         */
        public static function updatePitchShiftVolume(volume:Number):void
        {
            if (!isReady())
            {
                return;
            }
            SoundQueue.instance.updatePitchShiftVolume(volume);
        }

        /**
         * Stop the currently playing pitch-shifted sound.
         *
         * @example ModAPI.stopPitchShiftedEffect();
         */
        public static function stopPitchShiftedEffect():void
        {
            if (!isReady())
            {
                return;
            }
            SoundQueue.instance.stopPitchShiftedEffect();
        }

        /**
         * Check if a pitch-shifted sound is currently playing.
         *
         * @return Boolean <code>true</code> if a pitch-shifted effect is active, <code>false</code> otherwise
         * @example if (ModAPI.isPitchShiftedEffectPlaying()) { ModAPI.updatePitchShift(newValue); }
         */
        public static function isPitchShiftedEffectPlaying():Boolean
        {
            if (!isReady())
            {
                return (false);
            }
            return (SoundQueue.instance.isPitchShiftedEffectPlaying());
        }

        // ========== CONTROLLER RUMBLE ==========
        // Author: stariwinkle

        /**
         * Rumble the controller for the specified character.
         *
         * <p>Automatically detects which player/controller is associated with the character
         * and triggers dual-motor rumble. Intensity ranges from 0.0 (off) to 1.0 (maximum).</p>
         *
         * @param character The character object or UID whose controller should rumble
         * @param leftMotor Left motor intensity (0.0 to 1.0, controls low-frequency rumble)
         * @param rightMotor Right motor intensity (0.0 to 1.0, controls high-frequency rumble)
         * @param durationMs Duration of the rumble effect in milliseconds
         * @example ModAPI.rumbleController(this, 0.8, 0.5, 200);
         */
        public static function rumbleController(character:*, leftMotor:Number, rightMotor:Number, durationMs:int):void
        {
            if (!isReady())
            {
                return;
            }
            var uid:int;
            if (character is SSF2Character)
            {
                uid = SSF2Character(character).getUID();
            }
            else if (character is MovieClip)
            {
                var mc:MovieClip = MovieClip(character);
                if (mc.uid != undefined)
                {
                    uid = mc.uid;
                }
                else if (mc.parent && mc.parent.uid != undefined)
                {
                    uid = mc.parent.uid;
                }
                else
                {
                    print("Warning: Cannot resolve UID from MovieClip " + mc);
                    return;
                }
            }
            else
            {
                uid = int(character);
            }
            var characterObj:Character = _api.getCharacterByUID(uid);
            if (!characterObj)
            {
                print("Warning: Character with UID " + uid + " not found for rumble");
                return;
            }
            // Character.ID returns the player ID (1-based)
            var playerID:int = characterObj.ID;
            if (playerID <= 0)
            {
                // Non-player characters (CPUs, sandbags, etc.) don't have controllers
                return;
            }
            // Use the existing Gamepad rumble infrastructure
            Gamepad.rumbleForPlayer(playerID, leftMotor, rightMotor, durationMs);
        }

        /**
         * Stop rumble for the specified character's controller immediately.
         *
         * @param character The character object or UID whose controller rumble should stop
         * @example ModAPI.stopRumble(this);
         */
        public static function stopRumble(character:*):void
        {
            if (!isReady())
            {
                return;
            }
            var uid:int;
            if (character is SSF2Character)
            {
                uid = SSF2Character(character).getUID();
            }
            else if (character is MovieClip)
            {
                var mc:MovieClip = MovieClip(character);
                if (mc.uid != undefined)
                {
                    uid = mc.uid;
                }
                else if (mc.parent && mc.parent.uid != undefined)
                {
                    uid = mc.parent.uid;
                }
                else
                {
                    print("Warning: Cannot resolve UID from MovieClip " + mc);
                    return;
                }
            }
            else
            {
                uid = int(character);
            }
            var characterObj:Character = _api.getCharacterByUID(uid);
            if (!characterObj || characterObj.ID <= 0)
            {
                return;
            }
            // Stop rumble by setting both motors to 0 for 0ms duration
            Gamepad.rumbleForPlayer(characterObj.ID, 0, 0, 0);
        }

        /**
         * Check if the specified character's controller supports rumble.
         *
         * @param character The character object or UID to check
         * @return Boolean <code>true</code> if the controller supports rumble, <code>false</code> otherwise
         * @example if (ModAPI.supportsRumble(this)) { ModAPI.rumbleController(this, ...); }
         */
        public static function supportsRumble(character:*):Boolean
        {
            if (!isReady())
            {
                return (false);
            }
            var uid:int;
            if (character is SSF2Character)
            {
                uid = SSF2Character(character).getUID();
            }
            else if (character is MovieClip)
            {
                var mc:MovieClip = MovieClip(character);
                if (mc.uid != undefined)
                {
                    uid = mc.uid;
                }
                else if (mc.parent && mc.parent.uid != undefined)
                {
                    uid = mc.parent.uid;
                }
                else
                {
                    print("Warning: Cannot resolve UID from MovieClip " + mc);
                    return false;
                }
            }
            else
            {
                uid = int(character);
            }
            var characterObj:Character = _api.getCharacterByUID(uid);
            if (!characterObj || characterObj.ID <= 0)
            {
                return (false);
            }
            // Check if global rumble is enabled and if the player's controller supports it
            try
            {
                var index:int = characterObj.ID - 1;
                if (SaveData.Controllers && index >= 0 && index < SaveData.Controllers.length && SaveData.Controllers[index])
                {
                    var gamepad:Gamepad = SaveData.Controllers[index].GamepadInstance;
                    if (gamepad != null)
                    {
                        return (gamepad.supportsRumble());
                    }
                }
            }
            catch (e:Error)
            {
                // Silently fail
            }
            return (false);
        }

        /**
         * Check if rumble is currently enabled globally.
         *
         * <p>This checks the user's settings - rumble may be disabled even if the controller supports it.</p>
         *
         * @return Boolean <code>true</code> if global rumble is enabled, <code>false</code> otherwise
         * @example if (ModAPI.isRumbleEnabled()) { ModAPI.rumbleController(...); }
         */
        public static function isRumbleEnabled():Boolean
        {
            if (!isReady())
            {
                return (false);
            }
            return (Gamepad.getGlobalRumbleEnabled());
        }

        // ========== TIME MANIPULATION ==========
        // Author: Jotardo

        /**
         * Request character to trigger time stop.
         *
         * @param character The character object or UID
         * @param length The amount of time, counted in frames, the timestop should last, at 0 is equivalent to resumeTime(), below 0 make timestop go indefinitely
         * @param buffer Amount of time, counted in frames, before the timestop truly stops time, useful for invading timestop, must be larger or equals to 0;
         * @param priority The priority this time stop will be. The lower the number, the higher the priority is. Characters of higher priority overrides lower timestop, while characters of the same priority can move inside the time stop.
         *
         * @example ModAPI.stopTime(this, 30 * 5, 3, 1)
         */
        public static function stopTime(character:*, length:int = -1, buffer:int = 0, priority:int = int.MAX_VALUE - 1, bypassOptions:Object = null):void
        {
            if (!isReady())
            {
                return;
            }
            var uid:int;
            if (character is SSF2Character)
            {
                uid = SSF2Character(character).getUID();
            }
            else if (character is MovieClip)
            {
                var mc:MovieClip = MovieClip(character);
                if (mc.uid != undefined)
                {
                    uid = mc.uid;
                }
                else if (mc.parent && mc.parent.uid != undefined)
                {
                    uid = mc.parent.uid;
                }
                else
                {
                    print("Warning: Cannot resolve UID from MovieClip " + mc);
                    return;
                }
            }
            else
            {
                uid = int(character);
            }
            var baseUser:Character = _api.getCharacterByUID(uid);
            if (!baseUser)
            {
                return;
            }
            if (buffer < 0)
            {
                return;
            }
            if (priority >= int.MAX_VALUE)
            {
                return;
            }
            baseUser.stopTime(length, buffer, priority, bypassOptions);
        }

        /**
         * Remove the user's time stop
         *
         * @param character The character object or UID who triggered time stop
         */
        public static function resumeTime(character:*):void
        {
            if (!isReady())
            {
                return;
            }
            var uid:int;
            if (character is SSF2Character)
            {
                uid = SSF2Character(character).getUID();
            }
            else if (character is MovieClip)
            {
                var mc:MovieClip = MovieClip(character);
                if (mc.uid != undefined)
                {
                    uid = mc.uid;
                }
                else if (mc.parent && mc.parent.uid != undefined)
                {
                    uid = mc.parent.uid;
                }
                else
                {
                    print("Warning: Cannot resolve UID from MovieClip " + mc);
                    return;
                }
            }
            else
            {
                uid = int(character);
            }
            var baseUser:Character = _api.getCharacterByUID(uid);
            if (!baseUser)
            {
                return;
            }
            baseUser.resumeTime();
        }

        /**
         * Freeze a character based on their UID
         *
         * @param character The character object or UID
         */
        public static function applyTimeFreeze(character:*, length:int = -1):void
        {
            if (!isReady())
            {
                return;
            }
            var uid:int;
            if (character is SSF2Character)
            {
                uid = SSF2Character(character).getUID();
            }
            else if (character is MovieClip)
            {
                var mc:MovieClip = MovieClip(character);
                if (mc.uid != undefined)
                {
                    uid = mc.uid;
                }
                else if (mc.parent && mc.parent.uid != undefined)
                {
                    uid = mc.parent.uid;
                }
                else
                {
                    print("Warning: Cannot resolve UID from MovieClip " + mc);
                    return;
                }
            }
            else
            {
                uid = int(character);
            }
            var baseUser:Character = _api.getCharacterByUID(uid);
            if (!baseUser)
            {
                return;
            }
            if (_api.InTimeStop)
            {
                return;
            }
            baseUser.applyTimeFreeze(length);
        }

        /**
         * Unfreeze the character based on UID
         *
         * @param character The character object or UID
         */
        public static function removeTimeFreeze(character:*):void
        {
            if (!isReady())
            {
                return;
            }
            var uid:int;
            if (character is SSF2Character)
            {
                uid = SSF2Character(character).getUID();
            }
            else if (character is MovieClip)
            {
                var mc:MovieClip = MovieClip(character);
                if (mc.uid != undefined)
                {
                    uid = mc.uid;
                }
                else if (mc.parent && mc.parent.uid != undefined)
                {
                    uid = mc.parent.uid;
                }
                else
                {
                    print("Warning: Cannot resolve UID from MovieClip " + mc);
                    return;
                }
            }
            else
            {
                uid = int(character);
            }
            var baseUser:Character = _api.getCharacterByUID(uid);
            if (!baseUser)
            {
                return;
            }
            if (_api.InTimeStop)
            {
                return;
            }
            baseUser.removeTimeFreeze();
        }

        /**
         * Triggers rumble on a specific controller for menu interactions.
         * Checks global and per-player rumble settings before rumbling.
         *
         * @param controllerIndex The 0-based index of the controller to rumble.
         */
        public static function triggerMenuRumble(controllerIndex:int):void
        {
            if (Gamepad.getGlobalRumbleEnabled() && SaveData.getRumbleEnabled(controllerIndex + 1))
            {
                var gamepad:Gamepad = SaveData.Controllers[controllerIndex].GamepadInstance;
                if (gamepad != null)
                {
                    gamepad.setRumble(0.4, 0.4, 100);
                }
            }
        }

        /**
         * Stops rumble on all controllers.
         */
        public static function stopMenuRumble():void
        {
            for (var i:int = 0; i < SaveData.Controllers.length; i++)
            {
                if (SaveData.Controllers[i] && SaveData.Controllers[i].GamepadInstance)
                {
                    SaveData.Controllers[i].GamepadInstance.setRumble(0, 0, 1);
                }
            }
        }

    }
} // package com.mcleodgaming.ssf2.modapi