#include maps\mp\gametypes\_utility;

doHUDMessages()
{
		self thread doCounter();
		self thread doNade();
		self thread positionHUD();	
		self thread monitorJumpAndLoad();
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

			// X Position HUD
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

			// Y Position HUD
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

			// Z Position HUD
			self.posHUDZ = newClientHudElem(self);
			self.posHUDZ.alignx = "left";
			self.posHUDZ.x = 110;
			self.posHUDZ.y = 20;  
			self.posHUDZ.label = &"CJ_XFAC";
			self.posHUDZ setvalue(self.origin[2]);
			self.posHUDZ.archived = true;

			// Angles HUD
			self.angless = self getplayerangles();

			// Pitch Label HUD
			self.labelPitch = newClientHudElem(self);
			self.labelPitch.alignx = "left";
			self.labelPitch.x = 5;
			self.labelPitch.y = 40; 
			self.labelPitch.label = &"CJ_PITCH";
			self.labelPitch.archived = true;

			// Pitch Angle HUD
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

			// Yaw Angle HUD
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
    self endon("stop_timer");  // 	
    
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
