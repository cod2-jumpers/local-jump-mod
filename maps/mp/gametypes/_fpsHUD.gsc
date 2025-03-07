#include maps\mp\gametypes\_utility;
#include maps\mp\gametypes\_jumper_mod;

initializeHUD(fpsValue)
{
    self endon("disconnect");
    self endon("stop_fps_display");
    
    freshInitialization = !isDefined(self.FileName) || self.FileName == "";
    
    // Reset all jump tracking variables
    if(isDefined(self.jumpNumber))
        self.jumpNumber = self.jumpNumber;
    else
        self.jumpNumber = 0;
        
    if(isDefined(self.FileName))
        self.FileName = self.FileName;
    else
        self.FileName = "";
        
    self.lastJumpTracked = false;
    
    if(isDefined(self.isRecordingEnabled))
        self.isRecordingEnabled = self.isRecordingEnabled;
    else
        self.isRecordingEnabled = false;
        
    if(isDefined(self.firstSuccessRecorded))
        self.firstSuccessRecorded = self.firstSuccessRecorded;
    else
        self.firstSuccessRecorded = false;
        
    if(isDefined(self.referenceJumpsCount))
        self.referenceJumpsCount = self.referenceJumpsCount;
    else
        self.referenceJumpsCount = 0;
        
    self.jumpStartSpeed = 0;
    
    if(isDefined(self.successfulJumps))
        self.successfulJumps = self.successfulJumps;
    else
        self.successfulJumps = 0;
        
    if(isDefined(self.totalJumps))
        self.totalJumps = self.totalJumps;
    else
        self.totalJumps = 0;
        
    if(isDefined(self.z_worldpos))
        self.z_worldpos = self.z_worldpos;
    else
        self.z_worldpos = 0;
        
    self.maxSpeedDuringJump = 0;
    self.lastDisplayedSpeed = 0;
    
    if(isDefined(self.isTrackingJumps))
        self.isTrackingJumps = self.isTrackingJumps;
    else
        self.isTrackingJumps = false;
        
    if(isDefined(self.reference_z_worldpos))
        self.reference_z_worldpos = self.reference_z_worldpos;
    else
        self.reference_z_worldpos = 0;
        
    // Edge distance measurement variables
    self.measurePoint1 = undefined;
    self.measurePoint2 = undefined;
    self.dominantAxis = "";
    self.edgeDistanceStart = 0;
    self.edgeDistanceEnd = 0;
    self.hasmeasure = false;
    
    // Jump data tracking variables
    self.jumpData = [];
    self.jumpData["prestrafe"] = 0;
    self.jumpData["poststrafe"] = 0;
    self.jumpData["maxheight"] = 0;
    self.jumpData["startyaw"] = 0;
    self.jumpData["endyaw"] = 0;
    self.jumpData["yawdiff"] = 0;
    self.jumpData["startx"] = 0;
    self.jumpData["starty"] = 0;
    self.jumpData["endx"] = 0;
    self.jumpData["endy"] = 0;
    self.jumpData["distance"] = 0;
    self.jumpData["edgedistance_start"] = 0;
    self.jumpData["edgedistance_end"] = 0;
    self.jumpData["success"] = true;
    
    // Set up disconnect handler to close file
    self thread onPlayerDisconnect();
    
    // FPS setting logic
    switch (fpsValue)
    {
        case 43:
            self.fpsVariable = self.fpsfive;
            self setClientCvar("com_maxfps", "43");
            self iPrintLnBold("FPS changed to " + fpsValue);
            break;
        case 76:
            self.fpsVariable = self.fpsfour;
            self setClientCvar("com_maxfps", "76");
            self iPrintLnBold("FPS changed to " + fpsValue);
            break;
        case 125:
            self.fpsVariable = self.fpsone;
            self setClientCvar("com_maxfps", "125");
            self iPrintLnBold("FPS changed to " + fpsValue);
            break;
        case 250:
            self.fpsVariable = self.fpstwo;
            self setClientCvar("com_maxfps", "250");
            self iPrintLnBold("FPS changed to " + fpsValue);
            break;
        case 333:
            self.fpsVariable = self.fpsthree;
            self setClientCvar("com_maxfps", "333");
            self iPrintLnBold("FPS changed to " + fpsValue);
            break;        
        default:
            return; 
    }
    self createKeyboardHUD();
    // Constants 
    MIN_SPEED_ON_GROUND = 240;
    MAX_SPEED_JUMP = 10000;
       
    wasOnGround = true;
    jumpInProgress = false;
    previousZ = 0;
    
    // Initialize positions and measurements
    jumpStartPosition = (0, 0, 0);
    landingPosition = (0, 0, 0);
    jumpStartYaw = 0;
    jumpMaxZ = 0;
    jumpDistance = 0;
    jumpHeight = 0;
    platformBaseZ = 0;
    lastGroundPos = (0, 0, 0);

    if (freshInitialization)
    { 
        self iPrintLnBold("Set stat to 'record' to begin recording");
        self iPrintLnBold("Set stat to 'stop' to end recording");
    }
    
    // Set up the cvar monitoring for recording control
    setcvar("stat", "idle");
    self thread monitorRecordingCvar();
    
    for(;;) 
    {   
        if(self.fpsVariable) 
        {
            newvel = self getVelocity();
            speedSquared = (newvel[0] * newvel[0]) + (newvel[1] * newvel[1]);
            speed = sqrt(speedSquared);
            
            updateSpeedHUD(speed);
            

            if (self.sessionstate == "spectator")
            {

                if (isDefined(self.speedHUD))
                    self.speedHUD.alpha = 1;
                    
                updateKeyboardHUD();
                
                wait 0.05;
                continue; 
            }
            
            // Track the maximum speed during jump
            if (!self isOnGround() && speed > self.maxSpeedDuringJump && speed <= MAX_SPEED_JUMP)
            {
                self.maxSpeedDuringJump = speed;
                self.lastDisplayedSpeed = speed;  // Store the actual displayed speed
            }
            
            updateKeyboardHUD();
            
			wait 0.05;

            if (self isOnGround())
            {
       
                platformBaseZ = self.origin[2];
                previousZ = self.origin[2];
                lastGroundPos = (self.origin[0], self.origin[1], self.origin[2]);
                
                if (!wasOnGround)  // Detect ALL landings
                {
                    // Use the tracked maximum speed
                    maxSpeed = self.maxSpeedDuringJump;
                    
                    // Only update HUD and reset values if this wasn't from loading a position
                    if (!self.LoadedPosition)
                    {
                        // Update poststrafe speed with the max speed we actually displayed
                        if(isDefined(self.jumpStatsHUD) && isDefined(self.jumpStatsHUD["poststrafe"]))
                            self.jumpStatsHUD["poststrafe"] setValue(self.lastDisplayedSpeed);

                        // Calculate jump height and other metrics
                        jumpHeight = jumpMaxZ - platformBaseZ;
                        
                        // Calculate landing position and distance
                        landingPosition = self.origin;
                        distX = landingPosition[0] - jumpStartPosition[0];
                        distY = landingPosition[1] - jumpStartPosition[1];
                        jumpDistance = sqrt((distX * distX) + (distY * distY));
                        
                        // Get landing yaw and calculate difference
                        landingYaw = self.angles[1];
                        yawDiff = landingYaw - jumpStartYaw;
                        // Normalize yaw difference (-180 to 180 degrees)
                        if (yawDiff > 180)
                            yawDiff -= 360;
                        else if (yawDiff < -180)
                            yawDiff += 360;

                        // Update all HUD elements with the values
                        if(isDefined(self.jumpStatsHUD))
                        {
                            if(isDefined(self.jumpStatsHUD["maxheight"]))
                                self.jumpStatsHUD["maxheight"] setValue(jumpHeight);
                            if(isDefined(self.jumpStatsHUD["startyaw"]))
                                self.jumpStatsHUD["startyaw"] setValue(jumpStartYaw);
                            if(isDefined(self.jumpStatsHUD["endyaw"]))
                                self.jumpStatsHUD["endyaw"] setValue(landingYaw);
                            if(isDefined(self.jumpStatsHUD["yawdiff"]))
                                self.jumpStatsHUD["yawdiff"] setValue(yawDiff);
                            if(isDefined(self.jumpStatsHUD["startx"]))
                                self.jumpStatsHUD["startx"] setValue(jumpStartPosition[0]);
                            if(isDefined(self.jumpStatsHUD["starty"]))
                                self.jumpStatsHUD["starty"] setValue(jumpStartPosition[1]);
                            if(isDefined(self.jumpStatsHUD["endx"]))
                                self.jumpStatsHUD["endx"] setValue(landingPosition[0]);
                            if(isDefined(self.jumpStatsHUD["endy"]))
                                self.jumpStatsHUD["endy"] setValue(landingPosition[1]);
                            if(isDefined(self.jumpStatsHUD["distance"]))
                                self.jumpStatsHUD["distance"] setValue(jumpDistance);
                            
                            if(isDefined(self.measurePoint1) && isDefined(self.measurePoint2) && self.dominantAxis != "")
                            {
                                if(isDefined(self.jumpStatsHUD["edgedist_start"]) && isDefined(self.edgeDistanceStart))
                                    self.jumpStatsHUD["edgedist_start"] setValue(self.edgeDistanceStart);
                                if(isDefined(self.jumpStatsHUD["edgedist_end"]) && isDefined(self.edgeDistanceEnd))
                                    self.jumpStatsHUD["edgedist_end"] setValue(self.edgeDistanceEnd);
                            }
                        }

                        self iprintln(&"HUD_POST_JUMP_SPEED", int(self.lastDisplayedSpeed * 100) / 100);
                        self iprintln(&"CJ_MAXHEIGHT", int(jumpHeight * 100) / 100);
                        self iprintln(&"CJ_JUMP_DIST", int(jumpDistance * 100) / 100);
                        
                        // Store jump data in our tracking variables for HTML
                        self.jumpData["prestrafe"] = self.jumpStartSpeed;
                        self.jumpData["poststrafe"] = self.lastDisplayedSpeed;
                        self.jumpData["maxheight"] = jumpHeight;
                        self.jumpData["startyaw"] = jumpStartYaw;
                        self.jumpData["endyaw"] = landingYaw;
                        self.jumpData["yawdiff"] = yawDiff;
                        self.jumpData["startx"] = jumpStartPosition[0];
                        self.jumpData["starty"] = jumpStartPosition[1];
                        self.jumpData["endx"] = landingPosition[0];
                        self.jumpData["endy"] = landingPosition[1];
                        self.jumpData["distance"] = jumpDistance;
                        
                        self.lastJumpTracked = true;
                        
                        // Check if we should save the jump to the HTML file
                        if (self.isRecordingEnabled) {
                            // Save jump data to HTML file
                            self thread saveJumpToHTML();
                        } 
                        
                        // Calculate edge distances if measurement points exist
                        if(isDefined(self.measurePoint1) && isDefined(self.measurePoint2) && self.dominantAxis != "")
                        {
                            // Update edge distances for the current jump
                            self thread calculateEdgeDistances();
                        }
                        
                        self.maxSpeedDuringJump = 0;  // Only reset after a real jump
                        self.lastDisplayedSpeed = 0;  // Reset the displayed speed tracker
                        jumpInProgress = false;
                    }
                }
                
                wasOnGround = true;
                
                // Handle LoadedPosition reset in a separate thread to avoid timing issues
                if (self.LoadedPosition && (!isDefined(self.loadPosResetStarted) || !self.loadPosResetStarted))
                {
                    self.loadPosResetStarted = true;
                    self thread resetLoadedPositionAfterDelay();
                }
            }
            else
            {
                if (wasOnGround && speed > MIN_SPEED_ON_GROUND && !jumpInProgress)
                {
                    jumpStartPosition = lastGroundPos;
                    jumpStartYaw = self.angles[1];
                    jumpMaxZ = previousZ;
                    jumpInProgress = true;
                    
                    self.lastJumpTracked = false;
                    self.jumpStartSpeed = speed;

                    if(isDefined(self.jumpStatsHUD) && isDefined(self.jumpStatsHUD["prestrafe"]))
                        self.jumpStatsHUD["prestrafe"] setValue(speed);
                    
                    self iprintln(&"HUD_PRE_JUMP_SPEED", int(speed * 100) / 100);
                }

                if (wasOnGround)
                {
                    jumpMaxZ = platformBaseZ;
                }
                
                previousZ = self.origin[2];  // Update previous Z position
                if (self.origin[2] > jumpMaxZ)
                    jumpMaxZ = self.origin[2];
                if (speed > self.maxSpeedDuringJump && speed <= MAX_SPEED_JUMP)
                    self.maxSpeedDuringJump = speed;
                wasOnGround = false;
            }
        }
    }
}

updateSpeedHUD(speedValue)
{
    if (!isdefined(self.speedHUD))
    {
        self.speedHUD = newClientHudElem(self);
        self.speedHUD.alignX = "center";
        self.speedHUD.alignY = "middle";
        self.speedHUD.horzAlign = "center_safearea";
        self.speedHUD.vertAlign = "center_safearea";
        self.speedHUD.x = 0;
        self.speedHUD.y = 50;
        self.speedHUD.fontScale = 1.5;
        self.speedHUD.archived = false;
        self.speedHUD.sort = 1;
    }
    
    self.speedHUD.alpha = 1;
    if (speedValue > 5)
        self.speedHUD.color = (0, 1, 0);
    else
        self.speedHUD.color = (1, 1, 1);
    
    displaySpeed = int(speedValue * 10) / 10;
    self.speedHUD setValue(displaySpeed);
}
sqrt(x)
{
    if (x < 0)
    {
        return undefined;
    }
    if (x == 0 || x == 1)
    {
        return x; 
    }
    
    guess = x / 2;
    epsilon = 0.00001; 
    
    for (i = 0; i < 20; i++)
    {
        if (abs((guess * guess) - x) <= epsilon)
        {
            break;
        }
        guess = (guess + (x / guess)) / 2;
    }
    
    return guess;
}

createKeyboardHUD()
{
    self.keyHUD = [];
    
    // Adjust these values to change the overall size and position of the keyboard
    baseX = 0;
    baseY = 150;
    keySize = 25; // Size of each key square
    gap = 2; // Gap between keys
     
    // Create individual keys with backgrounds
    createKeyWithBackground("W", baseX, baseY - keySize - gap, keySize, keySize);
    createKeyWithBackground("A", baseX - keySize - gap, baseY, keySize, keySize);
    createKeyWithBackground("S", baseX, baseY, keySize, keySize);
    createKeyWithBackground("D", baseX + keySize + gap, baseY, keySize, keySize);
    createKeyWithBackground("SPACE", baseX, baseY + keySize + gap, keySize * 3 + gap * 2, keySize);

    // Create jump stats HUD elements
    self.jumpStatsHUD = [];
    
    // Prestrafe
    self.jumpStatsHUD["prestrafe"] = createJumpStatsHUDElement(20, -155, 100, 20);
    self.jumpStatsHUD["prestrafe"].label = &"CJ_PRESTRAFE";
    self.jumpStatsHUD["prestrafe"] setValue(0);
    
    // Poststrafe
    self.jumpStatsHUD["poststrafe"] = createJumpStatsHUDElement(20, -144, 100, 20);
    self.jumpStatsHUD["poststrafe"].label = &"CJ_POSTSTRAFE";
    self.jumpStatsHUD["poststrafe"] setValue(0);
    
    // Max Height
    self.jumpStatsHUD["maxheight"] = createJumpStatsHUDElement(20, -133, 100, 20);
    self.jumpStatsHUD["maxheight"].label = &"CJ_MAXHEIGHT";
    self.jumpStatsHUD["maxheight"] setValue(0);

    // Start Yaw
    self.jumpStatsHUD["startyaw"] = createJumpStatsHUDElement(20, -122, 100, 20);
    self.jumpStatsHUD["startyaw"].label = &"CJ_STARTYAW";
    self.jumpStatsHUD["startyaw"] setValue(0);

    // End Yaw
    self.jumpStatsHUD["endyaw"] = createJumpStatsHUDElement(20, -111, 100, 20);
    self.jumpStatsHUD["endyaw"].label = &"CJ_ENDYAW";
    self.jumpStatsHUD["endyaw"] setValue(0);

    // Yaw Difference
    self.jumpStatsHUD["yawdiff"] = createJumpStatsHUDElement(20, -100, 100, 20);
    self.jumpStatsHUD["yawdiff"].label = &"CJ_YAWDIFF";
    self.jumpStatsHUD["yawdiff"] setValue(0);

    // Start Position X
    self.jumpStatsHUD["startx"] = createJumpStatsHUDElement(20, -89, 100, 20);
    self.jumpStatsHUD["startx"].label = &"CJ_FIRST_POS_X";
    self.jumpStatsHUD["startx"] setValue(0);

    // Start Position Y
    self.jumpStatsHUD["starty"] = createJumpStatsHUDElement(20, -78, 100, 20);
    self.jumpStatsHUD["starty"].label = &"CJ_FIRST_POS_Y";
    self.jumpStatsHUD["starty"] setValue(0);

    // End Position X
    self.jumpStatsHUD["endx"] = createJumpStatsHUDElement(20, -67, 100, 20);
    self.jumpStatsHUD["endx"].label = &"CJ_FINAL_POS_X";
    self.jumpStatsHUD["endx"] setValue(0);

    // End Position Y
    self.jumpStatsHUD["endy"] = createJumpStatsHUDElement(20, -56, 100, 20);
    self.jumpStatsHUD["endy"].label = &"CJ_FINAL_POS_Y";
    self.jumpStatsHUD["endy"] setValue(0);

    // Jump Distance
    self.jumpStatsHUD["distance"] = createJumpStatsHUDElement(20, -45, 100, 20);
    self.jumpStatsHUD["distance"].label = &"CJ_JUMP_DIST";
    self.jumpStatsHUD["distance"] setValue(0);

    // Edge Distance Start
    self.jumpStatsHUD["edgedist_start"] = createJumpStatsHUDElement(20, -34, 100, 20);
    self.jumpStatsHUD["edgedist_start"].label = &"CJ_EDGE_DIST_START";
    self.jumpStatsHUD["edgedist_start"] setValue(0);
    
    // Edge Distance End
    self.jumpStatsHUD["edgedist_end"] = createJumpStatsHUDElement(20, -23, 100, 20);
    self.jumpStatsHUD["edgedist_end"].label = &"CJ_EDGE_DIST_END";
    self.jumpStatsHUD["edgedist_end"] setValue(0);
    
    // Total Distance (edge start + edge end + raw distance + 0.25 offset)
    self.jumpStatsHUD["total_distance"] = createJumpStatsHUDElement(20, -12, 100, 20);
    self.jumpStatsHUD["total_distance"].label = &"CJ_TOTAL_DISTANCE";
    self.jumpStatsHUD["total_distance"] setValue(0);
}

createKeyWithBackground(key, xPos, yPos, width, height)
{
    // Create background for the key
    self.keyHUD[key + "_bg"] = createKeyHUDElement(xPos, yPos, width, height);
    self.keyHUD[key + "_bg"] setShader("black", width, height);
    self.keyHUD[key + "_bg"].alpha = 0.5;
    self.keyHUD[key + "_bg"].sort = 1;
    
    // Create the key text
    self.keyHUD[key] = createKeyHUDElement(xPos, yPos, width, height);
    self.keyHUD[key] setText(getKeyText(key));
    self.keyHUD[key].color = (1, 1, 1);
    self.keyHUD[key].sort = 2;
}

getKeyText(key)
{
    switch(key)
    {
        case "W":
            return &"CJ_WKEY";
        case "A":
            return &"CJ_AKEY";
        case "S":
            return &"CJ_SKEY";
        case "D":
            return &"CJ_DKEY";
        case "SPACE":
            return &"CJ_SPACEKEY";
        default:
            return &"CJ_WKEY"; 
    }
}

createKeyHUDElement(xPos, yPos, width, height)
{
    elem = newClientHudElem(self);
    elem.alignX = "center";
    elem.alignY = "middle";
    elem.horzAlign = "center_safearea";
    elem.vertAlign = "center_safearea";
    elem.x = xPos;
    elem.y = yPos;
    elem.width = width;
    elem.height = height;
    elem.alpha = 1;
    elem.archived = false;
    return elem;
}

createJumpStatsHUDElement(xPos, yPos, width, height)
{
    elem = newClientHudElem(self);
    elem.alignX = "left";
    elem.alignY = "middle";
    elem.horzAlign = "left";
    elem.vertAlign = "center_safearea";
    elem.x = xPos;
    elem.y = yPos;
    elem.width = width;
    elem.height = height;
    elem.alpha = 1;
    elem.archived = false;
    return elem;
}

updateKeyboardHUD()
{
    if (isDefined(self.posHUD) && !self.posHUD)
    {
        hideJumpStatsHUD();
    }
    else if (isDefined(self.jumpStatsHUD))
    {
        showJumpStatsHUD();
    }

    spacePressed = self jumpButtonPressed();
    
    updateKeyShader("W", self forwardButtonPressed());
    updateKeyShader("S", self backButtonPressed());
    updateKeyShader("A", self leftButtonPressed());
    updateKeyShader("D", self rightButtonPressed());
    updateKeyShader("SPACE", spacePressed);
}

updateKeyShader(key, isPressed)
{
    if (isPressed)
    {
        self.keyHUD[key + "_bg"] setShader("white", self.keyHUD[key + "_bg"].width, self.keyHUD[key + "_bg"].height);
        self.keyHUD[key + "_bg"].alpha = 1;
        self.keyHUD[key].color = (0, 0, 0);
    }
    else
    {
        self.keyHUD[key + "_bg"] setShader("black", self.keyHUD[key + "_bg"].width, self.keyHUD[key + "_bg"].height);
        self.keyHUD[key + "_bg"].alpha = 0.5;
        self.keyHUD[key].color = (1, 1, 1);
    }
}

destroyHUD()
{
    if (isdefined(self.speedHUD))
    {
        self.speedHUD destroy();
        self.speedHUD = undefined;
    }
    if (isdefined(self.keyHUD))
    {
        keys = [];
        keys[0] = "W";
        keys[1] = "A"; 
        keys[2] = "S";
        keys[3] = "D";
        keys[4] = "SPACE";
        for(i = 0; i < keys.size; i++)
        {
            key = keys[i];
            if (isdefined(self.keyHUD[key + "_bg"]))
            {
                self.keyHUD[key + "_bg"] destroy();
            }
            if (isdefined(self.keyHUD[key]))
            {
                self.keyHUD[key] destroy();
            }
        }
        self.keyHUD = undefined; 
    }
    
    // Destroy jump stats HUD elements
    if (isdefined(self.jumpStatsHUD))
    {
        if (isdefined(self.jumpStatsHUD["prestrafe"]))
            self.jumpStatsHUD["prestrafe"] destroy();
        if (isdefined(self.jumpStatsHUD["poststrafe"]))
            self.jumpStatsHUD["poststrafe"] destroy();
        if (isdefined(self.jumpStatsHUD["maxheight"]))
            self.jumpStatsHUD["maxheight"] destroy();
        if (isdefined(self.jumpStatsHUD["startyaw"]))
            self.jumpStatsHUD["startyaw"] destroy();
        if (isdefined(self.jumpStatsHUD["endyaw"]))
            self.jumpStatsHUD["endyaw"] destroy();
        if (isdefined(self.jumpStatsHUD["yawdiff"]))
            self.jumpStatsHUD["yawdiff"] destroy();
        if (isdefined(self.jumpStatsHUD["startx"]))
            self.jumpStatsHUD["startx"] destroy();
        if (isdefined(self.jumpStatsHUD["starty"]))
            self.jumpStatsHUD["starty"] destroy();
        if (isdefined(self.jumpStatsHUD["endx"]))
            self.jumpStatsHUD["endx"] destroy();
        if (isdefined(self.jumpStatsHUD["endy"]))
            self.jumpStatsHUD["endy"] destroy();
        if (isdefined(self.jumpStatsHUD["distance"]))
            self.jumpStatsHUD["distance"] destroy();
        if (isdefined(self.jumpStatsHUD["edgedist_start"]))
            self.jumpStatsHUD["edgedist_start"] destroy();
        if (isdefined(self.jumpStatsHUD["edgedist_end"]))
            self.jumpStatsHUD["edgedist_end"] destroy();
        if (isdefined(self.jumpStatsHUD["total_distance"]))
            self.jumpStatsHUD["total_distance"] destroy();
        self.jumpStatsHUD = undefined;
    }
}

turnOffAllFPS()
{
	self.fpsone = false;
	self.fpstwo = false;
	self.fpsthree = false;
	self.fpsfour = false;
	self.fpsfive = false;

	self notify("stop_fps_display");
	self notify("stop_fpsHUD_125");
	self notify("stop_fpsHUD_250");
	self notify("stop_fpsHUD_333");
	self notify("stop_fpsHUD_76");
	self notify("stop_fpsHUD_43");
}

switchFPS(fpsValue)
{
    // Store the HTML recording state before destroying HUD
    isRecordingWasEnabled = self.isRecordingEnabled;
    fileName = self.FileName;
    jumpNumber = self.jumpNumber;
    successfulJumps = self.successfulJumps;
    totalJumps = self.totalJumps;
    firstSuccessRecorded = self.firstSuccessRecorded;
    reference_z_worldpos = self.reference_z_worldpos;
    isTrackingJumps = self.isTrackingJumps;
    
    // Store measurement points data to ensure they're preserved
    hasMeasurePoints = false;
    measurePoint1 = undefined;
    measurePoint2 = undefined;
    dominantAxis = "";
    
    if(isDefined(self.measurePoint1) && isDefined(self.measurePoint2) && isDefined(self.dominantAxis) && self.dominantAxis != "")
    {
        hasMeasurePoints = true;
        measurePoint1 = self.measurePoint1;
        measurePoint2 = self.measurePoint2;
        dominantAxis = self.dominantAxis;
    }
    
    // Store recording reference points if they exist
    hasRecordingPoints = false;
    recordingReferencePoint1 = undefined;
    recordingReferencePoint2 = undefined;
    recordingDominantAxis = "";
    
    if(isDefined(self.recordingReferencePoint1) && isDefined(self.recordingReferencePoint2) && isDefined(self.recordingDominantAxis) && self.recordingDominantAxis != "")
    {
        hasRecordingPoints = true;
        recordingReferencePoint1 = self.recordingReferencePoint1;
        recordingReferencePoint2 = self.recordingReferencePoint2;
        recordingDominantAxis = self.recordingDominantAxis;
    }
    
    self destroyHUD();
    
    self notify("stop_fps_display"); 

	switch(fpsValue)
	{
		case 125:
			self.fpsone = true;
			self.fpstwo = false;
			self.fpsthree = false;
			self.fpsfour = false;
			self.fpsfive = false;
		break;
		case 250:
			self.fpsone = false;
			self.fpstwo = true;
			self.fpsthree = false;
			self.fpsfour = false;
			self.fpsfive = false;
		break;
		case 333:
			self.fpsone = false;
			self.fpstwo = false;
			self.fpsthree = true;
			self.fpsfour = false;
			self.fpsfive = false;
		break;
		case 76:
			self.fpsone = false;
			self.fpstwo = false;
			self.fpsthree = false;
			self.fpsfour = true;
			self.fpsfive = false;
		break;
		case 43:
			self.fpsone = false;
			self.fpstwo = false;
			self.fpsthree = false;
			self.fpsfour = false;
			self.fpsfive = true;
		break;
	}
    
    self thread initializeHUD(fpsValue);
    
    wait 0.1;   
    
    self.isRecordingEnabled = isRecordingWasEnabled;
    self.FileName = fileName;
    self.jumpNumber = jumpNumber;
    self.successfulJumps = successfulJumps;
    self.totalJumps = totalJumps;
    self.firstSuccessRecorded = firstSuccessRecorded;
    self.reference_z_worldpos = reference_z_worldpos;
    self.isTrackingJumps = isTrackingJumps;
    
    // Restore measurement points
    if(hasMeasurePoints)
    {
        self.measurePoint1 = measurePoint1;
        self.measurePoint2 = measurePoint2;
        self.dominantAxis = dominantAxis;
        self.hasmeasure = true;
    }
    
    // Restore recording reference points if they exist
    if(hasRecordingPoints)
    {
        self.recordingReferencePoint1 = recordingReferencePoint1;
        self.recordingReferencePoint2 = recordingReferencePoint2; 
        self.recordingDominantAxis = recordingDominantAxis;
        
        // If we're in a recording session, re-apply the recording points to the measurement points as well
        if(self.isRecordingEnabled)
        {
            self.measurePoint1 = recordingReferencePoint1;
            self.measurePoint2 = recordingReferencePoint2;
            self.dominantAxis = recordingDominantAxis;
            self.hasmeasure = true;
        }
    }
    
}

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
MeasureDist()
{
    fireTime = 0.33;  // Duration of firing animation for kar98k
    rechamberTime = 1.0;  // Rechamber time for kar98k

    self notify("stop_measureDist");
    self endon("stop_measureDist");
    self endon("disconnect");

    while(1)
    {
        if (self.sessionstate != "spectator" && (self getcurrentweapon() == "kar98k_sniper_mp") && self attackButtonPressed())
        {
            vec = anglestoforward(self getplayerangles());
            trace = bullettrace(self geteye() + (0, 0, 18), self geteye() + (5000 * vec[0], 5000 * vec[1], 5000 * vec[2] + 18), false, self);

            if (!self.hasmeasure)
            {
                self.hasmeasure = true;
                self.measureorigin = trace["position"];
                self iprintlnbold(&"CJ_POINT1_X", self.measureorigin[0]);
                self iprintlnbold(&"CJ_POINT1_Y", self.measureorigin[1]);
                
                // Store first measure point for edge distance calculation
                self.measurePoint1 = (self.measureorigin[0], self.measureorigin[1], self.measureorigin[2]);
            }
            else
            {
                self.hasmeasure = false;

                // Create flattened points (same z-coordinates)
                point1_flattened = (trace["position"][0], trace["position"][1], 0);
                point2_flattened = (self.measureorigin[0], self.measureorigin[1], 0);

                // Calculate total distance using only x and y axes
                totalDistance = Distance(point1_flattened, point2_flattened) + 0.25;

                // Calculate height difference
                heightDifference = trace["position"][2] - self.measureorigin[2];

                self iprintlnbold(&"CJ_POINT2_X", trace["position"][0]);
                self iprintlnbold(&"CJ_POINT2_Y", trace["position"][1]);
                self iprintlnbold(&"CJ_DIST", totalDistance, &"CJ_HDIST", heightDifference);
                
                // Store second measure point for edge distance calculation
                self.measurePoint2 = (trace["position"][0], trace["position"][1], trace["position"][2]);
                
                // Calculate dominant axis (X or Y)
                xDiff = abs(self.measurePoint2[0] - self.measurePoint1[0]);
                yDiff = abs(self.measurePoint2[1] - self.measurePoint1[1]);
                
                if(xDiff > yDiff)
                {
                    self.dominantAxis = "X";
                    self iPrintLnBold(&"CJ_DOMINANT_AXIS_X");
                }
                else
                {
                    self.dominantAxis = "Y";
                    self iPrintLnBold(&"CJ_DOMINANT_AXIS_Y");
                }
                
                // Calculate edge distances if a jump is being tracked
                if(isDefined(self.jumpData) && self.dominantAxis != "")
                {
                    // Recalculate edge distances based on the most recent jump positions
                    self thread calculateEdgeDistances();
                }
            }

            wait(fireTime + rechamberTime);  // Wait for the duration of firing and rechambering
            
            while(self attackButtonPressed()) 
                wait 0.05; 
        }

        wait 0.05;  
    }
}

calculateEdgeDistances()
{
    self notify("stop_calculateEdgeDistances");
    self endon("stop_calculateEdgeDistances");
    self endon("disconnect");
    
    if(!isDefined(self.measurePoint1) || !isDefined(self.measurePoint2) || self.dominantAxis == "")
    {
        return;
    }
    
    // Get current jump start and end positions
    startPos = (self.jumpData["startx"], self.jumpData["starty"], 0);
    endPos = (self.jumpData["endx"], self.jumpData["endy"], 0);
    
    edgeStart = (self.measurePoint1[0], self.measurePoint1[1], 0);
    edgeEnd = (self.measurePoint2[0], self.measurePoint2[1], 0);
    
    // Calculate edge distances based on dominant axis
    startDistance = 0;
    endDistance = 0;
    
    if(self.dominantAxis == "X")
    {
        // For X-axis, explicitly calculate the absolute differences
        startDistance = abs(startPos[0] - edgeStart[0]);
        endDistance = abs(endPos[0] - edgeEnd[0]);
    }
    else // Y axis
    {
        // For Y-axis, explicitly calculate the absolute differences
        startDistance = abs(startPos[1] - edgeStart[1]);
        endDistance = abs(endPos[1] - edgeEnd[1]);
    }
    
    startDistance = int(startDistance * 100) / 100;
    endDistance = int(endDistance * 100) / 100;
    
    // Calculate total distance (edge start + edge end + raw distance + 0.25 offset)
    rawDistance = self.jumpData["distance"];
    totalDistance = startDistance + endDistance + rawDistance + 0.25;
    totalDistance = int(totalDistance * 100) / 100;
    
    // Update HUD with new values
    if(isDefined(self.jumpStatsHUD) && isDefined(self.jumpStatsHUD["edgedist_start"]))
    {
        self.jumpStatsHUD["edgedist_start"] setValue(startDistance);
        self.jumpStatsHUD["edgedist_end"] setValue(endDistance);
        self.jumpStatsHUD["total_distance"] setValue(totalDistance);
    }
    
    // Store edge distance values for use in saveJumpToHTML
    self.edgeDistanceStart = startDistance;
    self.edgeDistanceEnd = endDistance;
    self.totalDistance = totalDistance;
    
    // Explicitly set these in jumpData for HTML saving
    self.jumpData["edgedistance_start"] = startDistance;
    self.jumpData["edgedistance_end"] = endDistance;
    self.jumpData["total_distance"] = totalDistance;
}

initJumpHTMLFile()
{
    self endon("disconnect");
    self endon("stop_fps_display");
    
    playerName = self.name;
    
    playerName = replaceChar(playerName, " ", "_");
    playerName = replaceChar(playerName, "/", "-");
    playerName = replaceChar(playerName, "\\", "-");
    playerName = replaceChar(playerName, ":", "-");
    playerName = replaceChar(playerName, "*", "-");
    playerName = replaceChar(playerName, "?", "-");
    playerName = replaceChar(playerName, "\"", "-");
    playerName = replaceChar(playerName, "<", "-");
    playerName = replaceChar(playerName, ">", "-");
    playerName = replaceChar(playerName, "|", "-");
    
    currentMap = GetCvar("mapname");
    
    timestamp = GetTime();
    randomSuffix = randomInt(1000); 
    
    baseFilename = "jumps_" + playerName + "_" + currentMap + "_" + timestamp + "_" + randomSuffix;
    self.FileName = baseFilename + ".html";
    
    referenceInfo = "";
    if (isDefined(self.reference_z_worldpos))
    {
        // Determine measurement point status
        point1Info = "not set";
        point2Info = "not set";
        axisInfo = "not set";
        
        if (isDefined(self.measurePoint1))
        {
            point1Info = "X: " + formatDecimal(self.measurePoint1[0]) + ", Y: " + formatDecimal(self.measurePoint1[1]);
        }
        
        if (isDefined(self.measurePoint2))
        {
            point2Info = "X: " + formatDecimal(self.measurePoint2[0]) + ", Y: " + formatDecimal(self.measurePoint2[1]);
        }
        
        if (isDefined(self.dominantAxis) && self.dominantAxis != "")
        {
            axisInfo = self.dominantAxis + "-axis";
        }
        
        referenceInfo = "<div style='background-color: #e6f7ff; padding: 10px; margin-bottom: 15px; border-left: 5px solid #0099cc;'>\n" +
                        "<h3>Reference Jump Information</h3>\n" +
                        "<p>Reference Height: " + formatDecimal(self.reference_z_worldpos) + " units</p>\n" +
                        "<h4>Measurement Points</h4>\n" +
                        "<p>Point 1: " + point1Info + "</p>\n" +
                        "<p>Point 2: " + point2Info + "</p>\n" +
                        "<p>Dominant Axis: " + axisInfo + "</p>\n" +
                        "</div>\n";
    }
    
    htmlHeader = "<html>\n" +
                 "<head>\n" +
                 "<title>Jump Data</title>\n" +
                 "<style>\n" +
                 "table { border-collapse: collapse; width: 100%; table-layout: auto; }\n" +
                 "th, td { border: 1px solid #dddddd; text-align: left; padding: 12px 15px; white-space: nowrap; }\n" +
                 "tr:nth-child(even) { background-color: #f2f2f2; }\n" +
                 "th { background-color: #4CAF50; color: white; font-weight: bold; }\n" +
                 ".success { color: green; font-weight: bold; }\n" +
                 ".failure { color: red; font-weight: bold; }\n" +
                 "</style>\n" +
                 "</head>\n" +
                 "<body>\n" +
                 "<h2>Jump Data for " + playerName + " on " + currentMap + "</h2>\n" +
                 referenceInfo +
                 "<div style='overflow-x: auto;'>\n" +
                 "<table>\n" +
                 "<tr><th>Jump #</th><th>FPS</th><th>Prestrafe</th><th>Poststrafe</th><th>Max Height</th><th>Start Yaw</th><th>End Yaw</th><th>Yaw Diff</th><th>Start X</th><th>Start Y</th><th>End X</th><th>End Y</th><th>Distance</th><th>Edge Start</th><th>Edge End</th><th>Total Distance</th><th>Status</th></tr>\n";
    
    if(!safeFileWrite(self.FileName, htmlHeader, "write"))
    {
        self.FileName = "jumps_player_" + timestamp + "_" + randomSuffix + ".html";
        
        if(!safeFileWrite(self.FileName, htmlHeader, "write"))
        {
            self.FileName = "jumps_" + randomInt(10000) + ".html";
            
            if(!safeFileWrite(self.FileName, htmlHeader, "write"))
            {
                self iPrintLnBold(&"CJ_ERROR_OPEN_FILE");
                return;
            }
        }
    }
    
    self.jumpNumber = 0;
    
    self iPrintLnBold("Jump data will be saved to: " + self.FileName);
}

// Helper function to replace characters in a string
replaceChar(str, find, replace)
{
    result = "";
    for(i = 0; i < str.size; i++)
    {
        if(str[i] == find)
            result += replace;
        else
            result += str[i];
    }
    return result;
}

// Helper function to get jump data with null check
getJumpDataValue(key)
{
    if(isDefined(self.jumpData[key]))
        return self.jumpData[key];
    return 0;
}

// Helper function to format decimal values consistently
formatDecimal(value)
{
    return int(value * 100) / 100;
}

// Helper function to safely write to a file and handle errors
safeFileWrite(filename, content, mode)
{
    fileHandle = openfile(filename, mode);
    if(fileHandle == -1)
        return false;
    
    fprintln(fileHandle, content);
    closefile(fileHandle);
    return true;
}

saveJumpToHTML()
{
    self endon("disconnect");
    self endon("stop_fps_display");
    
    // Use helper functions to get and format jump data values
    prestrafeValue = formatDecimal(getJumpDataValue("prestrafe"));
    poststrafe = formatDecimal(getJumpDataValue("poststrafe"));
    maxHeight = formatDecimal(getJumpDataValue("maxheight"));
    startYaw = formatDecimal(getJumpDataValue("startyaw"));
    endYaw = formatDecimal(getJumpDataValue("endyaw"));
    yawDiff = formatDecimal(getJumpDataValue("yawdiff"));
    startX = formatDecimal(getJumpDataValue("startx"));
    startY = formatDecimal(getJumpDataValue("starty"));
    endX = formatDecimal(getJumpDataValue("endx"));
    endY = formatDecimal(getJumpDataValue("endy"));
    distance = formatDecimal(getJumpDataValue("distance"));
    
    edgeDistanceStart = 0;
    edgeDistanceEnd = 0;
    
    if(isDefined(self.recordingReferencePoint1) && isDefined(self.recordingReferencePoint2) && isDefined(self.recordingDominantAxis) && self.recordingDominantAxis != "")
    {
        // Get current jump positions from jumpData
        jumpStartPos = (startX, startY, 0);
        jumpEndPos = (endX, endY, 0);
        
        edgeStart = (self.recordingReferencePoint1[0], self.recordingReferencePoint1[1], 0);
        edgeEnd = (self.recordingReferencePoint2[0], self.recordingReferencePoint2[1], 0);
        
        // Calculate edge distances based on recording dominant axis
        if(self.recordingDominantAxis == "X")
        {
            edgeDistanceStart = abs(jumpStartPos[0] - edgeStart[0]);
            edgeDistanceEnd = abs(jumpEndPos[0] - edgeEnd[0]);
        }
        else // Y axis
        {
            edgeDistanceStart = abs(jumpStartPos[1] - edgeStart[1]);
            edgeDistanceEnd = abs(jumpEndPos[1] - edgeEnd[1]);
        }
    }
    else if(isDefined(self.measurePoint1) && isDefined(self.measurePoint2) && isDefined(self.dominantAxis) && self.dominantAxis != "")
    {
        // Get current jump positions from jumpData
        jumpStartPos = (startX, startY, 0);
        jumpEndPos = (endX, endY, 0);
        
        edgeStart = (self.measurePoint1[0], self.measurePoint1[1], 0);
        edgeEnd = (self.measurePoint2[0], self.measurePoint2[1], 0);
        
        // Calculate edge distances based on dominant axis
        if(self.dominantAxis == "X")
        {
            edgeDistanceStart = abs(jumpStartPos[0] - edgeStart[0]);
            edgeDistanceEnd = abs(jumpEndPos[0] - edgeEnd[0]);
        }
        else // Y axis
        {
            edgeDistanceStart = abs(jumpStartPos[1] - edgeStart[1]);
            edgeDistanceEnd = abs(jumpEndPos[1] - edgeEnd[1]);
        }
    }
    
    // Apply sanity checks and rounding
    edgeDistanceStart = formatDecimal(edgeDistanceStart);
    edgeDistanceEnd = formatDecimal(edgeDistanceEnd);
    
    // Calculate total distance with fresh values
    totalDist = formatDecimal(edgeDistanceStart + edgeDistanceEnd + distance + 0.25);
    
    // Store these values for reference
    self.edgeDistanceStart = edgeDistanceStart;
    self.edgeDistanceEnd = edgeDistanceEnd;
    self.totalDistance = totalDist;
    
    // Store in jumpData for consistency
    self.jumpData["edgedistance_start"] = edgeDistanceStart;
    self.jumpData["edgedistance_end"] = edgeDistanceEnd;
    self.jumpData["total_distance"] = totalDist;
    
    // Determine jump success status
    self.jumpData["success"] = self determineJumpSuccess();
    
    if (prestrafeValue == 0 || poststrafe == 0 || (!self.jumpData["success"] && poststrafe < 300))
    {
        return;
    }
    
    self.jumpNumber++;
    self.totalJumps++;
    
    if (self.jumpData["success"])
    {
        self.successfulJumps++;
    }
    
    currentFPS = 0;
    if(self.fpsone)
        currentFPS = 125;
    else if(self.fpstwo)
        currentFPS = 250;
    else if(self.fpsthree)
        currentFPS = 333;
    else if(self.fpsfour)
        currentFPS = 76;
    else if(self.fpsfive)
        currentFPS = 43;
    
    // Calculate success rate
    successRate = int((self.successfulJumps / self.totalJumps) * 100);
    
    if (self.jumpData["success"])
    {
        successClass = "class='success'";
        successText = "Success";
    }
    else
    {
        successClass = "class='failure'";
        successText = "Failure";
    }
    
    // Format the edge distances to ensure consistency
    edgeDistanceStart = formatDecimal(edgeDistanceStart);
    edgeDistanceEnd = formatDecimal(edgeDistanceEnd);
    totalDist = formatDecimal(totalDist);
    
    htmlRow = "<tr><td>" + self.jumpNumber + "</td><td>" + 
              currentFPS + "</td><td>" + 
              prestrafeValue + "</td><td>" + 
              poststrafe + "</td><td>" + 
              maxHeight + "</td><td>" + 
              startYaw + "</td><td>" + 
              endYaw + "</td><td>" + 
              yawDiff + "</td><td>" + 
              startX + "</td><td>" + 
              startY + "</td><td>" + 
              endX + "</td><td>" + 
              endY + "</td><td>" + 
              distance + "</td><td>" + 
              edgeDistanceStart + "</td><td>" + 
              edgeDistanceEnd + "</td><td>" + 
              totalDist + "</td><td " + successClass + ">" + 
              successText + "</td></tr>\n";
    
    // Write data to file
    if(!safeFileWrite(self.FileName, htmlRow, "append"))
    {
        self iPrintLn(&"CJ_ERROR_OPEN_FILE");
        self thread initJumpHTMLFile();
        return;
    }
}

closeJumpHTMLFile()
{
    if(self.jumpNumber > 0)
    {
        successRate = int((self.successfulJumps / self.totalJumps) * 100);
        
        htmlFooter = "</table>\n" +
                    "</div>\n" +
                    "<div style='margin-top: 20px; padding: 10px; background-color: #f0f0f0; border-radius: 5px;'>\n" +
                    "<h3>Jump Session Statistics</h3>\n" +
                    "<p>Total Jumps: " + self.totalJumps + "</p>\n" +
                    "<p>Successful Jumps: " + self.successfulJumps + "</p>\n" +
                    "<p>Failed Jumps: " + (self.totalJumps - self.successfulJumps) + "</p>\n" +
                    "<p>Success Rate: " + successRate + "%</p>\n" +
                    "</div>\n" +
                    "</body>\n" +
                    "</html>";
        
        if(!safeFileWrite(self.FileName, htmlFooter, "append"))
        {
            self iPrintLn(&"CJ_ERROR_CLOSE_FILE");
        }
        else
        {
            self iPrintLn("Jump data saved to: " + self.FileName);
        }
    }
}

onPlayerDisconnect()
{
    self waittill("disconnect");
    self closeJumpHTMLFile();
}

monitorRecordingCvar()
{
    self endon("disconnect");
    self endon("stop_fps_display");
    
    wait 0.5;
    
    while(1)
    {
        recordingControlValue = getcvar("stat");
        
        if (recordingControlValue == "record" || recordingControlValue == "RECORD")
        {
            if (!self.isRecordingEnabled)
            {
                self markReferenceJump();
            }
            else
            {
                if (!isDefined(self.lastReferenceMessageTime) || (GetTime() - self.lastReferenceMessageTime > 3000))
                {
                    self iPrintLnBold("Recording already active. Set stat to 'stop' first.");
                    self.lastReferenceMessageTime = GetTime();
                }
            }
            
            setcvar("stat", "idle");
        }
        else if (recordingControlValue == "stop" || recordingControlValue == "STOP")
        {
            // Only stop recording if currently recording
            if (self.isRecordingEnabled)
            {
                self stopRecordingSession();
            }
            else
            {
                self iPrintLnBold("No active recording to stop.");
            }
            
            setcvar("stat", "idle");
        }
        
        wait 0.5; 
    }
}

markReferenceJump()
{
    // First set the reference values
    self.z_worldpos = self.origin[2];
    self.firstSuccessRecorded = true;
    self.isTrackingJumps = true;
    self.reference_z_worldpos = self.origin[2]; // Set directly from origin
    
    // Store current measurement points as permanent reference points if they exist
    if(isDefined(self.measurePoint1) && isDefined(self.measurePoint2) && isDefined(self.dominantAxis) && self.dominantAxis != "")
    {
        // Save these as recording reference points that won't be changed during FPS switches
        self.recordingReferencePoint1 = self.measurePoint1;
        self.recordingReferencePoint2 = self.measurePoint2;
        self.recordingDominantAxis = self.dominantAxis;
    }
    
    self thread initJumpHTMLFile();
    
    // Only after HTML is initialized, enable recording
    wait 0.1; 
    self.isRecordingEnabled = true;
    
    self iPrintLnBold("Recording enabled. Set stat to 'stop' to end recording");
    
    self.lastJumpTracked = false;
}

// Function to stop recording and reset reference jumps
stopRecordingSession()
{
    // Handle normal close operations
    self closeJumpHTMLFile();
    
    // Reset tracking variables
    self.referenceJumpsCount = 0;
    self.isRecordingEnabled = false;
    self.isTrackingJumps = false;
    self.reference_z_worldpos = 0;
    self.jumpNumber = 0;
    self.successfulJumps = 0;
    self.totalJumps = 0;
    
    // Clear recording reference points
    self.recordingReferencePoint1 = undefined;
    self.recordingReferencePoint2 = undefined;
    self.recordingDominantAxis = "";
    
    self iPrintLnBold("Recording stopped");
}

determineJumpSuccess()
{
    // Only determine success/failure if we have reference jumps
    if (!self.firstSuccessRecorded)
    {
        return true; 
    }
    
    // Check if player's current Z position is within 5 units of reference Z position
    zDeviation = abs(self.origin[2] - self.z_worldpos);
    
    if (zDeviation > 5) 
    {
        return false;
    }
    return true;
}

// Helper function to hide all keyboard HUD elements
hideKeyboardHUD()
{
    if (!isDefined(self.keyHUD))
        return;
        
    keys = [];
    keys[0] = "W";
    keys[1] = "A"; 
    keys[2] = "S";
    keys[3] = "D";
    keys[4] = "SPACE";
    
    for(i = 0; i < keys.size; i++)
    {
        key = keys[i];
        if (isdefined(self.keyHUD[key + "_bg"]))
            self.keyHUD[key + "_bg"].alpha = 0;
        if (isdefined(self.keyHUD[key]))
            self.keyHUD[key].alpha = 0;
    }
}

// Helper function to hide all jump stats HUD elements
hideJumpStatsHUD()
{
    if (!isDefined(self.jumpStatsHUD))
        return;
        
    if (isdefined(self.jumpStatsHUD["prestrafe"]))
        self.jumpStatsHUD["prestrafe"].alpha = 0;
    if (isdefined(self.jumpStatsHUD["poststrafe"]))
        self.jumpStatsHUD["poststrafe"].alpha = 0;
    if (isdefined(self.jumpStatsHUD["maxheight"]))
        self.jumpStatsHUD["maxheight"].alpha = 0;
    if (isdefined(self.jumpStatsHUD["startyaw"]))
        self.jumpStatsHUD["startyaw"].alpha = 0;
    if (isdefined(self.jumpStatsHUD["endyaw"]))
        self.jumpStatsHUD["endyaw"].alpha = 0;
    if (isdefined(self.jumpStatsHUD["yawdiff"]))
        self.jumpStatsHUD["yawdiff"].alpha = 0;
    if (isdefined(self.jumpStatsHUD["startx"]))
        self.jumpStatsHUD["startx"].alpha = 0;
    if (isdefined(self.jumpStatsHUD["starty"]))
        self.jumpStatsHUD["starty"].alpha = 0;
    if (isdefined(self.jumpStatsHUD["endx"]))
        self.jumpStatsHUD["endx"].alpha = 0;
    if (isdefined(self.jumpStatsHUD["endy"]))
        self.jumpStatsHUD["endy"].alpha = 0;
    if (isdefined(self.jumpStatsHUD["distance"]))
        self.jumpStatsHUD["distance"].alpha = 0;
    if (isdefined(self.jumpStatsHUD["edgedist_start"]))
        self.jumpStatsHUD["edgedist_start"].alpha = 0;
    if (isdefined(self.jumpStatsHUD["edgedist_end"]))
        self.jumpStatsHUD["edgedist_end"].alpha = 0;
    if (isdefined(self.jumpStatsHUD["total_distance"]))
        self.jumpStatsHUD["total_distance"].alpha = 0;
}

// Helper function to show all jump stats HUD elements
showJumpStatsHUD()
{
    if (!isdefined(self.jumpStatsHUD))
        return;
        
    if (isdefined(self.jumpStatsHUD["prestrafe"]))
        self.jumpStatsHUD["prestrafe"].alpha = 1;
    if (isdefined(self.jumpStatsHUD["poststrafe"]))
        self.jumpStatsHUD["poststrafe"].alpha = 1;
    if (isdefined(self.jumpStatsHUD["maxheight"]))
        self.jumpStatsHUD["maxheight"].alpha = 1;
    if (isdefined(self.jumpStatsHUD["startyaw"]))
        self.jumpStatsHUD["startyaw"].alpha = 1;
    if (isdefined(self.jumpStatsHUD["endyaw"]))
        self.jumpStatsHUD["endyaw"].alpha = 1;
    if (isdefined(self.jumpStatsHUD["yawdiff"]))
        self.jumpStatsHUD["yawdiff"].alpha = 1;
    if (isdefined(self.jumpStatsHUD["startx"]))
        self.jumpStatsHUD["startx"].alpha = 1;
    if (isdefined(self.jumpStatsHUD["starty"]))
        self.jumpStatsHUD["starty"].alpha = 1;
    if (isdefined(self.jumpStatsHUD["endx"]))
        self.jumpStatsHUD["endx"].alpha = 1;
    if (isdefined(self.jumpStatsHUD["endy"]))
        self.jumpStatsHUD["endy"].alpha = 1;
    if (isdefined(self.jumpStatsHUD["distance"]))
        self.jumpStatsHUD["distance"].alpha = 1;
    if (isdefined(self.jumpStatsHUD["edgedist_start"]))
        self.jumpStatsHUD["edgedist_start"].alpha = 1;
    if (isdefined(self.jumpStatsHUD["edgedist_end"]))
        self.jumpStatsHUD["edgedist_end"].alpha = 1;
    if (isdefined(self.jumpStatsHUD["total_distance"]))
        self.jumpStatsHUD["total_distance"].alpha = 1;
}
