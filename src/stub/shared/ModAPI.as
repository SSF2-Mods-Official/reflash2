// SSF2 Mod API - Asset-Side Stub
// Simplified stub for compilation in assets (FLA files)
// Delegates to actual engine implementation at runtime

package
{
    import flash.display.MovieClip;
    import flash.geom.Point;
    import flash.utils.getDefinitionByName;

    /**
     * ModAPI Asset Stub
     *
     * Simplified stub for compilation in assets (FLA files).
     * Delegates to the engine ModAPI implementation at runtime.
     *
     * Example usage in FLA:
     *   if (ModAPI.isReady()) {
     *       ModAPI.startImmediateFadeOut(2000);
     *   }
     *
     * @version 0.2.0
     */
    public class ModAPI
    {
        public static const VERSION_MAJOR:int = 0;
        public static const VERSION_MINOR:int = 3;
        public static const VERSION_REVISION:int = 0;

        private static var m_api:*;

        /**
         * Initialize the ModAPI when an asset is loaded by ResourceManager.
         * This is called automatically by the engine during resource validation.
         * Uses a separate function name (initModAPI vs initAPI) to avoid conflicts with SSF2API initialization.
         *
         * @param ssf2api The engine's SSF2API reference (unused, but kept for consistency)
         * @return The ModAPI class for validation
         */
        public static function initModAPI(ssf2api:*):Class
        {
            trace("[ASSET-STUB ModAPI] initModAPI() called");

            // Try to find the engine ModAPI in the engine package
            try
            {
                var engineModAPI:Class = getDefinitionByName("com.mcleodgaming.ssf2.modapi.ModAPI") as Class;
                if (engineModAPI)
                {
                    trace("[ASSET-STUB ModAPI] initModAPI() - Found engine ModAPI class");
                    // Initialize with engine reference
                    init(engineModAPI);
                    trace("[ASSET-STUB ModAPI] initModAPI() - Initialized with engine ModAPI");
                }
                else
                {
                    trace("[ASSET-STUB ModAPI] initModAPI() - Engine ModAPI class not found");
                }
            }
            catch (error:Error)
            {
                trace("[ASSET-STUB ModAPI] initModAPI() - Error finding engine ModAPI: " + error.message);
            }

            return (ModAPI);
        }

        public static function init(root:*):Class
        {
            trace("[ASSET-STUB ModAPI] init() called with root=" + root);
            if (m_api)
            {
                trace("[ASSET-STUB ModAPI] init() - m_api already set, returning early");
                return (ModAPI);
            };
            m_api = root;
            trace("[ASSET-STUB ModAPI] init() - m_api assigned successfully");
            trace("[ASSET-STUB ModAPI] init() - m_api.isReady = " + (m_api ? m_api.isReady() : "m_api is null"));
            return (ModAPI);
        }

        public static function deinit():void
        {
            trace("[ASSET-STUB ModAPI] deinit() called");
            m_api = null;
            trace("[ASSET-STUB ModAPI] deinit() - m_api cleared");
        }

        /**
         * Deinitialize the ModAPI when an asset is unloaded by ResourceManager.
         * Uses a separate function name (deinitModAPI vs deinitAPI) to avoid conflicts.
         */
        public static function deinitModAPI():void
        {
            deinit();
        }

        public static function getAPIVersion():String
        {
            return ("0.2.0");
        }

        public static function print(text:String):void
        {
            if ((!(isReady())))
            {
                return;
            };
            m_api.print(text);
        }

        public static function isReady():Boolean
        {
            // Auto-initialize on first check if not yet initialized (lazy-init pattern)
            if (!m_api)
            {
                try
                {
                    var engineModAPI:Class = getDefinitionByName("com.mcleodgaming.ssf2.modapi.ModAPI") as Class;
                    if (engineModAPI && engineModAPI["isReady"]())
                    {
                        m_api = engineModAPI;
                    }
                }
                catch (error:Error)
                {
                }
            }

            return (((m_api) && (m_api.isReady())));
        }

        public static function getEngineAPI():*
        {
            if ((!(isReady())))
            {
                return (null);
            };
            return (m_api.getEngineAPI());
        }

        public static function getSSF2API():Class
        {
            if ((!(isReady())))
            {
                return (null);
            };
            return (m_api.getSSF2API());
        }

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
            if ((!(isReady())))
            {
                return;
            };
            m_api.playMusicWithFadeOut(soundName, songEndTimeMs, fadeDurationMs);
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
            trace("[ASSET-STUB ModAPI] startImmediateFadeOut() called - fadeDurationMs=" + fadeDurationMs);
            if ((!(isReady())))
            {
                trace("[ASSET-STUB ModAPI] startImmediateFadeOut() - NOT READY, returning");
                return;
            };
            trace("[ASSET-STUB ModAPI] startImmediateFadeOut() - Ready, delegating to engine");
            m_api.startImmediateFadeOut(fadeDurationMs);
        }

        /**
         * Check if music is currently fading out.
         *
         * @return Boolean <code>true</code> if a fade-out is in progress, <code>false</code> otherwise
         */
        public static function isMusicFadingOut():Boolean
        {
            if ((!(isReady())))
            {
                return (false);
            };
            return (m_api.isMusicFadingOut());
        }

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
            if ((!(isReady())))
            {
                return (false);
            };
            return (m_api.playPitchShiftedEffect(soundName, initialPitch, scaleVolume));
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
            if ((!(isReady())))
            {
                return;
            };
            m_api.updatePitchShift(newPitch);
        }

        /**
         * Update the volume of the currently playing pitch-shifted sound.
         *
         * @param volume New volume level (0.0 to 1.0)
         * @example ModAPI.updatePitchShiftVolume(0.5);
         */
        public static function updatePitchShiftVolume(volume:Number):void
        {
            if ((!(isReady())))
            {
                return;
            };
            m_api.updatePitchShiftVolume(volume);
        }

        /**
         * Stop the currently playing pitch-shifted sound.
         *
         * @example ModAPI.stopPitchShiftedEffect();
         */
        public static function stopPitchShiftedEffect():void
        {
            if ((!(isReady())))
            {
                return;
            };
            m_api.stopPitchShiftedEffect();
        }

        /**
         * Check if a pitch-shifted sound is currently playing.
         *
         * @return Boolean <code>true</code> if a pitch-shifted effect is active, <code>false</code> otherwise
         * @example if (ModAPI.isPitchShiftedEffectPlaying()) { ModAPI.updatePitchShift(newValue); }
         */
        public static function isPitchShiftedEffectPlaying():Boolean
        {
            if ((!(isReady())))
            {
                return (false);
            };
            return (m_api.isPitchShiftedEffectPlaying());
        }

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
            m_api.rumbleController(character, leftMotor, rightMotor, durationMs);
            trace("[ASSET-STUB ModAPI] rumbleController() called - character=" + character + ", leftMotor=" + leftMotor + ", rightMotor=" + rightMotor + ", durationMs=" + durationMs);
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
            m_api.stopRumble(character);
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
            return (m_api.supportsRumble(character));
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
            return (m_api.isRumbleEnabled());
        }

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
            m_api.stopTime(character, length, buffer, priority, bypassOptions);
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
            m_api.resumeTime(character);
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
            m_api.applyTimeFreeze(character, length);
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
            m_api.removeTimeFreeze(character);
        }
    }
} // package