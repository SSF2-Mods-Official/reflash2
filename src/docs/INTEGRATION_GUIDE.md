
# ModAPI Integration & Initialization Guide

## Integration Overview

ModAPI is automatically integrated into the SSF2 engine lifecycle. No additional setup is required by asset developers or end users.

## Initialization Flow

### Match Start Sequence

```
User starts match (Versus, Training, etc.)
         ↓
[MatchResultsMenu.show() or similar]
         ↓
GameController.activateCharacters()
         ↓
SSF2API.init(stageData)  ← Official API initializes
         ↓
ModAPI.init(stageData)   ← Community API initializes
         ↓
Game Loop Begins
├─ Frame updates with active effects
├─ Audio processing
├─ Character/projectile updates
└─ User input processing
```

### Match End Sequence

```
Match Complete / Transition Triggered
         ↓
StageData.endMatch()
         ↓
SSF2API.deinit()  ← Official API cleans up
         ↓
ModAPI.deinit()   ← Community API cleans up
         ↓
├─ All audio effects stopped
├─ Resources released
└─ State cleared
         ↓
Results Screen or Return to Menu
```

## Code Integration Points

### Point 1: StageData Constructor (Match Initialization)

**File:** `com/mcleodgaming/ssf2/engine/StageData.as` (~Line 239)

```actionscript
public function StageData(stageAPI:Class=null, game:Game=null)
{
    super();
    SSF2API.init(this);        // ← Official API
    ModAPI.init(this);         // ← Community API (ADDED)
    this.m_apiInstance = ((stageAPI) ? new SSF2Stage(stageAPI, this) : null);
    // ... rest of initialization
}
```

**Trigger:** Game engine creates new match instance
**Frequency:** Once per match

---

### Point 2: StageData.endMatch() (Match End)

**File:** `com/mcleodgaming/ssf2/engine/StageData.as` (~Line 2097)

```actionscript
private function endMatch():void
{
    // ... cleanup code ...
    this.deactivateCharacters();
    SSF2API.deinit();          // ← Official API
    ModAPI.deinit();           // ← Community API (ADDED)
    this.stopCrowdChant();
    // ... more cleanup
}
```

**Trigger:** Match reaches end condition
**Frequency:** Once per match

---

### Point 3: MatchResultsMenu - Return to Versus

**File:** `com/mcleodgaming/ssf2/menus/MatchResultsMenu.as` (~Line 277)

```actionscript
private function backToVersusMenu(e:Event):void
{
    // ...
    GameController.stageData.deactivateCharacters();
    SSF2API.deinit();          // ← Official API
    ModAPI.deinit();           // ← Community API (ADDED)
    UnlockController.checkUnlocks();
    // ...
}
```

**Trigger:** User selects "Back" from results menu
**Frequency:** When replaying after match

---

### Point 4: MatchResultsMenu - Rematch

**File:** `com/mcleodgaming/ssf2/menus/MatchResultsMenu.as` (~Line 687)

```actionscript
private function rematch():void
{
    var game:Game = GameController.stageData.GameRef;
    GameController.stageData.activateCharacters();
    SSF2API.init(GameController.stageData);    // ← Official API
    ModAPI.init(GameController.stageData);     // ← Community API (ADDED)
    var i:int;
    // ... continue with rematch setup
}
```

**Trigger:** User selects "Rematch" from results menu
**Frequency:** When starting rematch

---

### Point 5: MatchResultsMenu - Online Mode Ready

**File:** `com/mcleodgaming/ssf2/menus/MatchResultsMenu.as` (~Line 377)

```actionscript
private function onlineModeReady(e:*=null):void
{
    // ...
    GameController.stageData.deactivateCharacters();
    GameController.destroyStageData();
    SSF2API.deinit();          // ← Official API
    ModAPI.deinit();           // ← Community API (ADDED)
    MultiplayerManager.resetMasterFrame();
    // ...
}
```

**Trigger:** Online mode transitions
**Frequency:** During online match setup

---

## Ready State Checks

ModAPI.isReady() returns true when:

-  `_api` is not null (valid StageData)
-  `_isInitialized` is true (initialization complete)
-  `_api.ActiveScripts` is true (engine ready)

All three conditions must be met before features execute.

## Error Handling

### Scenario 1: Asset calls ModAPI outside of match

```actionscript
// Menu code tries to use ModAPI
if (ModAPI.isReady()) {
    // This block skipped - returns false in menu
    ModAPI.print("This won't print");
}
// Safe - feature doesn't execute
```

### Scenario 2: Feature calls ModAPI after cleanup

```actionscript
// In deinit(), all state is cleared
ModAPI.deinit();

// Later, stale reference tries to use feature
ModAPI.startImmediateFadeOut(1500);  // Safe - checks isReady(), returns early
```

### Scenario 3: Nested initialization

```actionscript
// During init, ModAPI can safely use other systems
if (ModAPI.isReady()) {
    var ssf2:Class = ModAPI.getSSF2API();
    var players:Array = ssf2.getPlayers();  // Safe - SSF2API is already initialized
}
```

## Testing the Integration

### Verify Initialization

Add to any character or stage:

```actionscript
// In initialize() or onLoad()
if (ModAPI.isReady()) {
    var version:String = ModAPI.getAPIVersion();
    ModAPI.print("ModAPI " + version + " is ready");
}
```

### Monitor Frame Transitions

```actionscript
// Check readiness across match phases
public override function onUpdate():void
{
    // Will be true during match
    if (!ModAPI.isReady()) return;
    
    // Features are safe to use here
}
```

## Backward Compatibility

ModAPI integrates non-invasively:

-  No changes to SSF2API
-  No changes to core engine logic
-  No breaking changes to StageData, MatchResultsMenu
-  Only additions to initialization sequence
-  Assets without ModAPI imports work unchanged

## Performance Impact

- **Initialization**: < 1ms (state assignment only)
- **Runtime**: 0ms when features unused
- **Memory**: Minimal — static class with no persistent allocations beyond active effects
- **Deinitialization**: < 1ms (cleanup only)

## Debugging Integration

Enable debug output during match:

```actionscript
// ModAPI will print initialization messages:
if (ModAPI.isReady()) {
    ModAPI.print("ModAPI " + ModAPI.getAPIVersion() + " initialized");
}
```

## Lifecycle Guarantees

### Initialization Sequence (Guaranteed Order)

1. StageData constructor called
2. SSF2API.init(this)
3. ModAPI.init(this)
4. Game loop begins
5. Features are usable

### Cleanup Sequence (Guaranteed Order)

1. Match ends
2. SSF2API.deinit()
3. ModAPI.deinit()
4. All state cleared
5. Ready for next match

---