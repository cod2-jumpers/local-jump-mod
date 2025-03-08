#include maps\mp\gametypes\_utility;

doHUDMessages()
{
		self thread doCounter();
		self thread doNade();
		self thread positionHUD();	
		self thread monitorJumpAndLoad();
}

// Initialize and create the speedometer HUD element
initSpeedHUD()
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
	
	if (!isdefined(self.previousSpeed))
	{
		self.previousSpeed = 0;
	}
}

// Update the speedometer HUD with current speed
updateSpeedHUD(speedValue)
{
	if (!isdefined(self.speedHUD))
	{
		self initSpeedHUD();
	}
	
	if (!isdefined(self.previousSpeed))
	{
		self.previousSpeed = speedValue;
	}
	
	self.speedHUD.alpha = 1;
	
	// Change color based on speed change: 
	// Green when increasing, Red when decreasing, White when very low speed
	if (speedValue < 5)
	{
		self.speedHUD.color = (1, 1, 1);
	}
	else if (speedValue >= self.previousSpeed)
	{
		self.speedHUD.color = (0, 1, 0);
	}
	else
	{
		self.speedHUD.color = (1, 0, 0);
	}
	
	displaySpeed = int(speedValue * 10) / 10;
	self.speedHUD setValue(displaySpeed);
	
	self.previousSpeed = speedValue;
}

destroySpeedHUD()
{
	if (isdefined(self.speedHUD))
	{
		self.speedHUD destroy();
		self.speedHUD = undefined;
	}
}

positionHUD()
{
	for(;;)
	{
		removepositionHUD();
		if(self.posHUD) 
		{
			// X-Axis Label HUD
			self.labelX = newClientHudElem(self);
			self.labelX.alignx = "left";
			self.labelX.x = 5;
			self.labelX.y = 5;
			self.labelX.label = &"CJ_XAXIS";
			self.labelX.archived = true;

			self.posHUDX = newClientHudElem(self);
			self.posHUDX.alignx = "left";
			self.posHUDX.x = 5;
			self.posHUDX.y = 20;  
			self.posHUDX.label = &"CJ_XFAC";
			self.posHUDX setvalue(self.origin[0]);
			self.posHUDX.archived = true;
			
			// Y-Axis Label HUD
			self.labelY = newClientHudElem(self);
			self.labelY.alignx = "left";
			self.labelY.x = 55;
			self.labelY.y = 5;
			self.labelY.label = &"CJ_YAXIS";
			self.labelY.archived = true;

			self.posHUDY = newClientHudElem(self);
			self.posHUDY.alignx = "left";
			self.posHUDY.x = 55;
			self.posHUDY.y = 20; 
			self.posHUDY.label = &"CJ_XFAC";
			self.posHUDY setvalue(self.origin[1]);
			self.posHUDY.archived = true;

			// Z-Axis Label HUD
			self.labelZ = newClientHudElem(self);
			self.labelZ.alignx = "left";
			self.labelZ.x = 110;
			self.labelZ.y = 5;
			self.labelZ.label = &"CJ_ZAXIS";
			self.labelZ.archived = true;

			self.posHUDZ = newClientHudElem(self);
			self.posHUDZ.alignx = "left";
			self.posHUDZ.x = 110;
			self.posHUDZ.y = 20;  
			self.posHUDZ.label = &"CJ_XFAC";
			self.posHUDZ setvalue(self.origin[2]);
			self.posHUDZ.archived = true;

			self.angless = self getplayerangles();

			// Pitch Label HUD
			self.labelPitch = newClientHudElem(self);
			self.labelPitch.alignx = "left";
			self.labelPitch.x = 5;
			self.labelPitch.y = 40; 
			self.labelPitch.label = &"CJ_PITCH";
			self.labelPitch.archived = true;

			self.angleHUD_Pitch = newClientHudElem(self);
			self.angleHUD_Pitch.alignx = "left";
			self.angleHUD_Pitch.x = 5;
			self.angleHUD_Pitch.y = 55;  
			self.angleHUD_Pitch.label = &"CJ_XFAC";
			self.angleHUD_Pitch setvalue(self.angless[0]);
			self.angleHUD_Pitch.archived = true;
			
			// Yaw Label HUD
			self.labelYaw = newClientHudElem(self);
			self.labelYaw.alignx = "left";
			self.labelYaw.aligny = "top";
			self.labelYaw.x = 55;
			self.labelYaw.y = 40;
			self.labelYaw.fontScale = 1;
			self.labelYaw.archived = true;
			self.labelYaw.alpha = 1;
			self.labelYaw.label = &"CJ_YAW";

			self.angleHUD_Yaw = newClientHudElem(self);
			self.angleHUD_Yaw.alignx = "left";
			self.angleHUD_Yaw.aligny = "top";
			self.angleHUD_Yaw.x = 55;
			self.angleHUD_Yaw.y = 55;
			self.angleHUD_Yaw.fontScale = 1;
			self.angleHUD_Yaw.archived = true;
			self.angleHUD_Yaw.alpha = 1;
			self.angleHUD_Yaw.label = &"CJ_XFAC";
			self.angleHUD_Yaw setvalue(self.angless[1]);
		}

		// Update position values
		if(isDefined(self.posHUDX)) self.posHUDX setvalue(self.origin[0]);
		if(isDefined(self.posHUDY)) self.posHUDY setvalue(self.origin[1]);
		if(isDefined(self.posHUDZ)) self.posHUDZ setvalue(self.origin[2]);
		
		// Update angles
		self.angless = self getplayerangles();
		if(isDefined(self.angleHUD_Pitch)) self.angleHUD_Pitch setvalue(self.angless[0]);
		if(isDefined(self.angleHUD_Yaw)) self.angleHUD_Yaw setvalue(self.angless[1]);

		wait 0.05;
	}
}

removepositionHUD()
{
	if(isdefined(self.posHUDX)) 
	self.posHUDX destroy();
	
	if(isdefined(self.labelX)) 
	self.labelX destroy();

	if(isdefined(self.posHUDY)) 
	self.posHUDY destroy();
	
	if(isdefined(self.labelY)) 
	self.labelY destroy();

	if(isdefined(self.posHUDZ)) 
	self.posHUDZ destroy();
	
	if(isdefined(self.labelZ)) 
	self.labelZ destroy();

	if(isdefined(self.angleHUD_Pitch)) 
	self.angleHUD_Pitch destroy();
	
	if(isdefined(self.labelPitch)) 
	self.labelPitch destroy();

	if(isdefined(self.angleHUD_Yaw)) 
	self.angleHUD_Yaw destroy();
	
	if(isdefined(self.labelYaw)) 
	self.labelYaw destroy();
}

doCounter()
{
	self endon("disconnect");
	self endon("killed_player");

	for(;;)
	{
		if(self.pers["team"]!="spectator" && self.afk<5) 
		{
			self.time++;
			if(!isalive(self)) self.afk++; 
			else self.afk=0;
		}
		if(self.pers["team"]!="spectator" ) 
		{
			if(self.grenade=="1") 
			{
				if(self.time%5==0) self setWeaponClipAmmo("frag_grenade_american_mp",self getammocount("frag_grenade_american_mp")+1);
			}
			else if(self.grenade=="2") 
			{
				if(self.time%5==0) self setWeaponClipAmmo("frag_grenade_british_mp",self getammocount("frag_grenade_british_mp")+1);
			}
			else if(self.grenade=="3") 
			{
				if(self.time%5==0) self setWeaponClipAmmo("frag_grenade_russian_mp",self getammocount("frag_grenade_russian_mp")+1);
			}
			else if(self.grenade=="4") 
			{
				if(self.time%5==0) self setWeaponClipAmmo("frag_grenade_german_mp",self getammocount("frag_grenade_german_mp")+1);
			}
		}
		wait 0.5;
	}
}

doNade()
{
	self endon("killed_player");
	self endon("disconnect");
	
	self.nadec=0;
	self.nadechange=-1;
	self.nades=0;
	
	for(;;)
	{
		if(self.grenade=="1")
		{
			if(self.nadechange > self getammocount("frag_grenade_american_mp") && !self.nonade && isalive(self)) 
			{
				self.nades++;					
				self.maybenade=1;
				self.hurt=false;
				self.pos=self.origin;
				self thread doNadeCounter();
			}
			self.nadechange=self getammocount("frag_grenade_american_mp");
		}
		else if(self.grenade=="2")
		{
			if(self.nadechange > self getammocount("frag_grenade_british_mp") && !self.nonade && isalive(self)) 
			{
				self.nades++;					
				self.maybenade=1;
				self.hurt=false;
				self.pos=self.origin;
				self thread doNadeCounter();
			}
			self.nadechange=self getammocount("frag_grenade_british_mp");
		}
		else if(self.grenade=="3")
		{
			if(self.nadechange > self getammocount("frag_grenade_russian_mp") && !self.nonade && isalive(self)) 
			{
				self.nades++;					
				self.maybenade=1;
				self.hurt=false;
				self.pos=self.origin;
				self thread doNadeCounter();
			}
			self.nadechange=self getammocount("frag_grenade_russian_mp");
		}
		else if(self.grenade=="4") 
		{
			if(self.nadechange > self getammocount("frag_grenade_german_mp") && !self.nonade && isalive(self)) 
			{
				self.nades++;					
				self.maybenade=1;
				self.hurt=false;
				self.pos=self.origin;
				self thread doNadeCounter();
			}
			self.nadechange=self getammocount("frag_grenade_german_mp");
		}
		wait 0.05;
	}
}

doNadeCounter()
{
	self endon("killed_player");

	self.nadec++;
	
	if(isdefined(self.nadecounter)) 
	self.nadecounter destroy();

	self.nadecounter = newClientHudElem(self);
	self.nadecounter.horzAlign = "center";
	self.nadecounter.vertAlign = "middle";
	self.nadecounter.x = -25; 
	self.nadecounter.y = -50; 
	self.nadecounter.fontscale = 1.6;
	self.nadecounter.archived = true;
	self.nadecounter settenthsTimer(3.4);
	self.nadecounter.color = (1, 1, 0);

	wait 3.4;
	
	self.nadec--;
	
	if(self.nadec==0 && isDefined(self.nadecounter))
    {
        self.nadecounter destroy();
        self.nadecounter = undefined;
    }
}

// Monitors player jump activity and triggers the jump timer
monitorJumpAndLoad()
{
    self endon("disconnect");
    self endon("death");
    
    if(!isDefined(self.wasOnGroundPrev))
        self.wasOnGroundPrev = true;
    
    if(!isDefined(self.jumped))
        self.jumped = false; 
    
    spaceWasPressed = false;
    spaceWasHeld = false; 
    
    for(;;)
    {
        isOnGroundNow = self isOnGround();
        isSpaceDown = self jumpButtonPressed();
        
        if(isSpaceDown && !spaceWasHeld)
        {
            spaceWasPressed = true;
            self notify("stop_timer");
        }
        
        if(isOnGroundNow && !self.wasOnGroundPrev && spaceWasPressed && !self.jumped)
        {
            self thread displayJumpTimer();
            spaceWasPressed = false; 
        }
        
        self.wasOnGroundPrev = isOnGroundNow;
        spaceWasHeld = isSpaceDown; 
        
        wait 0.05;  
    }
}

displayJumpTimer()
{
    self endon("disconnect");
    self endon("death");
    self endon("stop_timer");
    
    if(!isDefined(self.timer))
        self.timer = 0;
    
    self.timer++;

    if(isDefined(self.jumpTimer))
    {
        self.jumpTimer destroy();
        self.jumpTimer = undefined;
    }
    
    self.jumpTimer = newClientHudElem(self);
    self.jumpTimer.horzAlign = "center";
    self.jumpTimer.vertAlign = "middle";
    self.jumpTimer.x = -25;
    self.jumpTimer.y = 200;
    self.jumpTimer.fontscale = 1.6;
    self.jumpTimer.archived = false;
    self.jumpTimer.color = (1, 1, 0);
    self.jumpTimer settenthsTimer(1.8);
    
    wait 1.8;  	
    
    self.timer--;
    
    if(isDefined(self.jumpTimer))
    {
        self.jumpTimer destroy();
        self.jumpTimer = undefined;
    }
}

// Create keyboard and jump stats HUD elements
createKeyboardHUD()
{
    self.keyHUD = [];
    
    // Base layout configuration
    baseX = 0;
    baseY = 150;
    keySize = 25;
    gap = 2;
     
    createKeyWithBackground("W", baseX, baseY - keySize - gap, keySize, keySize);
    createKeyWithBackground("A", baseX - keySize - gap, baseY, keySize, keySize);
    createKeyWithBackground("S", baseX, baseY, keySize, keySize);
    createKeyWithBackground("D", baseX + keySize + gap, baseY, keySize, keySize);
    createKeyWithBackground("SPACE", baseX, baseY + keySize + gap, keySize * 3 + gap * 2, keySize);

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
            self.keyHUD[key + "_bg"].alpha = 0.5;
        if (isdefined(self.keyHUD[key]))
            self.keyHUD[key].alpha = 1;
    }

    // Create jump stats HUD elements
    self.jumpStatsHUD = [];
    
    self.jumpStatsHUD["prestrafe"] = createJumpStatsHUDElement(20, -155, 100, 20);
    self.jumpStatsHUD["prestrafe"].label = &"CJ_PRESTRAFE";
    self.jumpStatsHUD["prestrafe"] setValue(0);
    
    self.jumpStatsHUD["poststrafe"] = createJumpStatsHUDElement(20, -144, 100, 20);
    self.jumpStatsHUD["poststrafe"].label = &"CJ_POSTSTRAFE";
    self.jumpStatsHUD["poststrafe"] setValue(0);
    
    self.jumpStatsHUD["maxheight"] = createJumpStatsHUDElement(20, -133, 100, 20);
    self.jumpStatsHUD["maxheight"].label = &"CJ_MAXHEIGHT";
    self.jumpStatsHUD["maxheight"] setValue(0);

    self.jumpStatsHUD["startyaw"] = createJumpStatsHUDElement(20, -122, 100, 20);
    self.jumpStatsHUD["startyaw"].label = &"CJ_STARTYAW";
    self.jumpStatsHUD["startyaw"] setValue(0);

    self.jumpStatsHUD["endyaw"] = createJumpStatsHUDElement(20, -111, 100, 20);
    self.jumpStatsHUD["endyaw"].label = &"CJ_ENDYAW";
    self.jumpStatsHUD["endyaw"] setValue(0);

    self.jumpStatsHUD["yawdiff"] = createJumpStatsHUDElement(20, -100, 100, 20);
    self.jumpStatsHUD["yawdiff"].label = &"CJ_YAWDIFF";
    self.jumpStatsHUD["yawdiff"] setValue(0);

    self.jumpStatsHUD["startx"] = createJumpStatsHUDElement(20, -89, 100, 20);
    self.jumpStatsHUD["startx"].label = &"CJ_FIRST_POS_X";
    self.jumpStatsHUD["startx"] setValue(0);

    self.jumpStatsHUD["starty"] = createJumpStatsHUDElement(20, -78, 100, 20);
    self.jumpStatsHUD["starty"].label = &"CJ_FIRST_POS_Y";
    self.jumpStatsHUD["starty"] setValue(0);

    self.jumpStatsHUD["endx"] = createJumpStatsHUDElement(20, -67, 100, 20);
    self.jumpStatsHUD["endx"].label = &"CJ_FINAL_POS_X";
    self.jumpStatsHUD["endx"] setValue(0);

    self.jumpStatsHUD["endy"] = createJumpStatsHUDElement(20, -56, 100, 20);
    self.jumpStatsHUD["endy"].label = &"CJ_FINAL_POS_Y";
    self.jumpStatsHUD["endy"] setValue(0);

    self.jumpStatsHUD["distance"] = createJumpStatsHUDElement(20, -45, 100, 20);
    self.jumpStatsHUD["distance"].label = &"CJ_JUMP_DIST";
    self.jumpStatsHUD["distance"] setValue(0);

    self.jumpStatsHUD["edgedist_start"] = createJumpStatsHUDElement(20, -34, 100, 20);
    self.jumpStatsHUD["edgedist_start"].label = &"CJ_EDGE_DIST_START";
    self.jumpStatsHUD["edgedist_start"] setValue(0);
    
    self.jumpStatsHUD["edgedist_end"] = createJumpStatsHUDElement(20, -23, 100, 20);
    self.jumpStatsHUD["edgedist_end"].label = &"CJ_EDGE_DIST_END";
    self.jumpStatsHUD["edgedist_end"] setValue(0);
    
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

// Complete HUD destruction function
destroyAllHUD()
{
    // Destroy speed HUD
    self destroySpeedHUD();
    
    // Destroy keyboard HUD
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

// Updates jump statistics HUD with current values
updateJumpStatsHUD(jumpHeight, jumpStartYaw, landingYaw, yawDiff, jumpStartPosition, landingPosition, jumpDistance)
{
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
}

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
