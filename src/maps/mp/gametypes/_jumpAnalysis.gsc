#include maps\mp\gametypes\_utility;
#include maps\mp\gametypes\_jumpRecorder;
#include maps\mp\gametypes\_hudmod;
#include maps\mp\gametypes\_speedometer;
#include maps\mp\gametypes\_fpsmanager;

// Records the start of a jump and returns initial height
trackJumpStart(jumpStartPosition, jumpStartYaw, speed, previousZ)
{
    self.lastJumpTracked = false;
    self.jumpStartSpeed = speed;
    
    if (speed == 0)
        speed = self calculateSpeed();
    
    if(isDefined(self.jumpStatsHUD) && isDefined(self.jumpStatsHUD["prestrafe"]))
        self.jumpStatsHUD["prestrafe"] setValue(speed);
    
    self iprintln(&"HUD_PRE_JUMP_SPEED", int(speed * 100) / 100);
    
    return self.origin[2];
}

// Uses peak detection to track maximum height during a jump
trackJumpInProgress(jumpMaxZ, previousZ, initialZ)
{
    // Simple peak detection: If moving upward, update max height
    if (self.origin[2] >= previousZ)
    {
        if (self.origin[2] > jumpMaxZ)
            jumpMaxZ = self.origin[2];
    }
    // When moving downward, max height is retained
    
    return jumpMaxZ;
}

trackJumpLanding(jumpStartSpeed, jumpMaxZ, platformBaseZ, jumpStartYaw, jumpStartPosition)
{
    self.isFallingBelowInitial = false;
    
    if (self.LoadedPosition)
        return;
    
    if(isDefined(self.jumpStatsHUD) && isDefined(self.jumpStatsHUD["poststrafe"]))
        self.jumpStatsHUD["poststrafe"] setValue(self getLastDisplayedSpeed());

    jumpHeight = jumpMaxZ - platformBaseZ; 
    landingPosition = self.origin;
    distX = landingPosition[0] - jumpStartPosition[0];
    distY = landingPosition[1] - jumpStartPosition[1];
    jumpDistance = sqrt((distX * distX) + (distY * distY));
    
    landingYaw = self.angles[1];
    yawDiff = landingYaw - jumpStartYaw;
    yawDiff = self normalizeYawDifference(yawDiff);

    self updateJumpStatsHUD(jumpHeight, jumpStartYaw, landingYaw, yawDiff, 
                           jumpStartPosition, landingPosition, jumpDistance);

    self iprintln(&"HUD_POST_JUMP_SPEED", int(self getLastDisplayedSpeed() * 100) / 100);
    self iprintln(&"CJ_MAXHEIGHT", int(jumpHeight * 100) / 100);
    
    self storeJumpData(jumpStartSpeed, self getLastDisplayedSpeed(), jumpHeight, 
                      jumpStartYaw, landingYaw, yawDiff, jumpStartPosition, 
                      landingPosition, jumpDistance);
    
    self.lastJumpTracked = true;
    
    if (self.isRecordingEnabled) {
        self thread saveJumpToHTML();
    } 
    
    if(isDefined(self.measurePoint1) && isDefined(self.measurePoint2) && self.dominantAxis != "")
    {
        self thread calculateEdgeDistances();
    }
    
    self resetSpeedTracking();
}

// Initializes all required variables for jump tracking and analysis
initializeJumpVariables()
{
    self.fpsVariable = true;
    
    if(!isDefined(self.jumpNumber))
        self.jumpNumber = 0;
        
    if(!isDefined(self.FileName))
        self.FileName = "";
        
    self.lastJumpTracked = false;
    
    if(!isDefined(self.isRecordingEnabled))
        self.isRecordingEnabled = false;
        
    if(!isDefined(self.firstSuccessRecorded))
        self.firstSuccessRecorded = false;
        
    if(!isDefined(self.referenceJumpsCount))
        self.referenceJumpsCount = 0;
        
    self.jumpStartSpeed = 0;
    
    if(!isDefined(self.successfulJumps))
        self.successfulJumps = 0;
        
    if(!isDefined(self.totalJumps))
        self.totalJumps = 0;
        
    if(!isDefined(self.z_worldpos))
        self.z_worldpos = 0;
        
    self.maxSpeedDuringJump = 0;
    self.lastDisplayedSpeed = 0;
    
    if(!isDefined(self.isTrackingJumps))
        self.isTrackingJumps = false;
        
    if(!isDefined(self.reference_z_worldpos))
        self.reference_z_worldpos = 0;
}

setupHUDElements()
{
    if(!isDefined(self.posHUD))
        self.posHUD = true;
    
    self createKeyboardHUD();
    
    if(isDefined(self.jumpStatsHUD))
        self showJumpStatsHUD();
    
    self initializeSpeedometer();
}

setupJumpRecorder()
{
    if(self.isRecordingEnabled && self.FileName != "" && (!isDefined(self.lastInitTime) || getTime() - self.lastInitTime > 5000))
    {
        self.lastInitTime = getTime();
        if(!self fileExists(self.FileName))
        {
            self thread maps\mp\gametypes\_jumpRecorder::initializeJumpRecording();
        }
    }
}

// Core function that handles jump detection and state tracking
// Returns the updated state in a structured object
processGroundState(wasOnGround, jumpInProgress, jumpMaxZ, platformBaseZ, previousZ, jumpStartPosition, jumpStartYaw, lastGroundPos, lastGroundSpeed)
{
    updatedState = [];
    updatedState["wasOnGround"] = wasOnGround;
    updatedState["jumpInProgress"] = jumpInProgress;
    updatedState["jumpMaxZ"] = jumpMaxZ;
    updatedState["previousZ"] = previousZ;
    updatedState["jumpStartPosition"] = jumpStartPosition;
    updatedState["jumpStartYaw"] = jumpStartYaw;
    updatedState["lastGroundPos"] = lastGroundPos;
    updatedState["platformBaseZ"] = platformBaseZ;
    updatedState["lastGroundSpeed"] = lastGroundSpeed;
    
    speed = self calculateSpeed();
    
    if (self isOnGround())
    {
        // When on ground, track position and speed for jump start reference
        platformBaseZ = self.origin[2];
        previousZ = self.origin[2];
        lastGroundPos = (self.origin[0], self.origin[1], self.origin[2]);

        if (speed > 0)
            lastGroundSpeed = speed;

        if (!wasOnGround)
        {
            // Landing detected - process the jump that just ended
            maxSpeed = self getMaxJumpSpeed();
            
            self trackJumpLanding(self.jumpStartSpeed, jumpMaxZ, self.initialJumpHeight, jumpStartYaw, jumpStartPosition);
            jumpInProgress = false;
            
            self.initialJumpHeight = platformBaseZ;
        }
        
        wasOnGround = true;
        
        jumpMaxZ = platformBaseZ;
        
        if (self.LoadedPosition && (!isDefined(self.loadPosResetStarted) || !self.loadPosResetStarted))
        {
            self.loadPosResetStarted = true;
            self thread resetLoadedPositionAfterDelay();
        }
    }
    else
    {
        if (wasOnGround && !jumpInProgress)
        {
            // Jump start detected - player just left the ground
            jumpStartPosition = lastGroundPos;
            jumpStartYaw = self.angles[1];
            
            self.initialJumpHeight = platformBaseZ;
            
            jumpMaxZ = platformBaseZ;
            
            // Use lastGroundSpeed for prestrafe if valid, otherwise use current speed
            startSpeed = lastGroundSpeed;
            if (startSpeed <= 0 || !self isSpeedValidForJumpStart(startSpeed))
                startSpeed = speed;
                
            if (self isSpeedValidForJumpStart(startSpeed))
            {
                previousZ = self trackJumpStart(jumpStartPosition, jumpStartYaw, startSpeed, previousZ);
                jumpInProgress = true;
            }
        }
        
        if (wasOnGround)
        {
            self.initialJumpHeight = platformBaseZ;
            jumpMaxZ = platformBaseZ;
        }
        
        previousZ = self.origin[2];
        
        jumpMaxZ = self trackJumpInProgress(jumpMaxZ, previousZ, self.initialJumpHeight);
            
        wasOnGround = false;
    }
    
    updatedState["wasOnGround"] = wasOnGround;
    updatedState["jumpInProgress"] = jumpInProgress;
    updatedState["jumpMaxZ"] = jumpMaxZ;
    updatedState["previousZ"] = previousZ;
    updatedState["jumpStartPosition"] = jumpStartPosition;
    updatedState["jumpStartYaw"] = jumpStartYaw;
    updatedState["lastGroundPos"] = lastGroundPos;
    updatedState["platformBaseZ"] = platformBaseZ;
    updatedState["lastGroundSpeed"] = lastGroundSpeed;
    
    return updatedState;
}

// Updates speed display and keyboard visualization for current frame
updateHUDFrame()
{
    speed = self calculateSpeed();
    
    self updateSpeedHUD(speed);
    
    self updateKeyboardHUD();
    
    self trackMaxSpeedDuringJump(speed);
    
    return speed;
}

// Main function that initializes and runs the jump analysis system
// Continuously monitors player state and tracks jumps
initializeHUD(fpsValue)
{
    self endon("disconnect");
    self endon("stop_fps_display");
    self thread onPlayerDisconnect();
    self initializeJumpVariables();
    self initializeFPS(fpsValue);
    self setupHUDElements();
    self setupJumpRecorder();
       
    // Initialize jump tracking state
    wasOnGround = true;
    jumpInProgress = false;
    previousZ = self.origin[2];
    
    jumpStartPosition = (0, 0, 0);
    landingPosition = (0, 0, 0);
    jumpStartYaw = 0;
    platformBaseZ = self.origin[2];
    jumpMaxZ = platformBaseZ;
    jumpDistance = 0;
    jumpHeight = 0;
    lastGroundPos = (self.origin[0], self.origin[1], self.origin[2]);
    lastGroundSpeed = 0;
    
    setcvar("stat", "idle");
    self thread monitorRecordingCvar();
    
    // Main analysis loop - runs continuously to track jumps
    for(;;) 
    {   
        if(!isDefined(self.fpsVariable) || !self.fpsVariable)
        {
            if(self.fpsone || self.fpstwo || self.fpsthree || self.fpsfour || self.fpsfive)
                self.fpsVariable = true;
        }
        
        if(self.fpsVariable) 
        {
            self updateHUDFrame();
            
            if (self.sessionstate == "spectator")
            {
                if (isDefined(self.speedHUD))
                    self.speedHUD.alpha = 1;
                
                wait 0.05;
                continue; 
            }
            
            // Process ground state transitions and jump tracking
            stateData = self processGroundState(wasOnGround, jumpInProgress, jumpMaxZ, 
                                             platformBaseZ, previousZ, 
                                             jumpStartPosition, jumpStartYaw, lastGroundPos, lastGroundSpeed);
            
            wasOnGround = stateData["wasOnGround"];
            jumpInProgress = stateData["jumpInProgress"];
            jumpMaxZ = stateData["jumpMaxZ"];
            previousZ = stateData["previousZ"];
            jumpStartPosition = stateData["jumpStartPosition"];
            jumpStartYaw = stateData["jumpStartYaw"];
            lastGroundPos = stateData["lastGroundPos"];
            platformBaseZ = stateData["platformBaseZ"];
            lastGroundSpeed = stateData["lastGroundSpeed"];
        }
        
        wait 0.05;
    }
}

// Safely resets the LoadedPosition flag after a short delay
// Used to prevent jump tracking issues when loading positions
resetLoadedPositionAfterDelay()
{
    self endon("disconnect");
    self endon("stop_fps_display");
    
    wait 0.1;
    
    if (isDefined(self.LoadedPosition) && self.LoadedPosition && self isOnGround())
    {
        self.LoadedPosition = false;
    }
    
    self.loadPosResetStarted = false;
}