#include maps\mp\gametypes\_utility;

/*
	Deathmatch
	Objective: 	Score points by eliminating other players
	Map ends:	When one player reaches the score limit, or time limit is reached
	Respawning:	No wait / Away from other players

	Level requirements
	------------------
		Spawnpoints:
			classname		mp_dm_spawn
			All players spawn from these. The spawnpoint chosen is dependent on the current locations of enemies at the time of spawn.
			Players generally spawn away from enemies.

		Spectator Spawnpoints:
			classname		mp_global_intermission
			Spectators spawn from these and intermission is viewed from these positions.
			Atleast one is required, any more and they are randomly chosen between.

	Level script requirements
	-------------------------
		Team Definitions:
			game["allies"] = "american";
			game["axis"] = "german";
			Because Deathmatch doesn't have teams with regard to gameplay or scoring, this effectively sets the available weapons.

		If using minefields or exploders:
			maps\mp\_load::main();

	Optional level script settings
	------------------------------
		Soldier Type and Variation:
			game["american_soldiertype"] = "normandy";
			game["german_soldiertype"] = "normandy";
			This sets what character models are used for each nationality on a particular map.

			Valid settings:
				american_soldiertype	normandy
				british_soldiertype		normandy, africa
				russian_soldiertype		coats, padded
				german_soldiertype		normandy, africa, winterlight, winterdark
*/

/*QUAKED mp_dm_spawn (1.0 0.5 0.0) (-16 -16 0) (16 16 72)
Players spawn away from enemies at one of these positions.*/

main()
{
	level.callbackStartGameType = ::Callback_StartGameType;
	level.callbackPlayerConnect = ::Callback_PlayerConnect;
	level.callbackPlayerDisconnect = ::Callback_PlayerDisconnect;
	level.callbackPlayerDamage = ::Callback_PlayerDamage;
	level.callbackPlayerKilled = ::Callback_PlayerKilled;
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();

	level.autoassign = ::menuAutoAssign;
	level.allies = ::menuAllies;
	level.axis = ::menuAxis;
	level.spectator = ::menuSpectator;
	level.weapon = ::menuWeapon;
	level.endgameconfirmed = ::endMap;
	
}

Callback_StartGameType()
{
	level.splitscreen = isSplitScreen();

	// Initialize level.xenon here, before _menus::init() is called.
	level.xenon = (getCvar("xenonGame") == "true");

	// defaults if not defined in level script
	if(!isdefined(game["allies"]))
		game["allies"] = "american";
	if(!isdefined(game["axis"]))
		game["axis"] = "german";

	// server cvar overrides
	if(getCvar("scr_allies") != "")
		game["allies"] = getCvar("scr_allies");
	if(getCvar("scr_axis") != "")
		game["axis"] = getCvar("scr_axis");
	setCvar("scr_dm_timelimit", "1440");
	
	if (!isDefined(getCvar("nc")))
	{
		setCvar("nc", "off"); 
	}

	precacheStatusIcon("hud_status_dead");
	precacheStatusIcon("hud_status_connecting");
	precacheRumble("damage_heavy");
	precacheString(&"PLATFORM_PRESS_TO_SPAWN");
	precacheString(&"HUD_PRE_JUMP_SPEED");
	precacheString(&"HUD_POST_JUMP_SPEED");
	precacheString(&"HUD_JUMP_DISTANCE");
	precacheString(&"HUD_JUMP_YAW");
	precacheString(&"HUD_JUMP_MAX_Z");
	precacheString(&"HUD_JUMP_DIST");
	precacheString(&"HUD_POSITION_LOAD");
	precacheString(&"HUD_POSITION_SAVE");
	precacheString(&"HUD_NOPOSITION_LOAD");
	precacheString(&"HUD_POSITION_OLD");
	precacheString(&"HUD_GROUND_SAVE");
	precacheString(&"HUD_NADEDMG");
	precacheString(&"CJ_XAXIS");
	precacheString(&"CJ_YAXIS"); 
	precacheString(&"CJ_ZAXIS");
	precacheString(&"CJ_PITCH");
	precacheString(&"CJ_YAW");
	precacheString(&"CJ_PRINT");
	precacheString(&"CJ_CYANCOLOR");
	precacheString(&"CJ_XFAC");
	precacheString(&"CJ_PREV_DISABLE");
	precacheString(&"CJ_ENABLE_125");
	precacheString(&"CJ_ENABLE_250");
	precacheString(&"CJ_ENABLE_333");
	precacheString(&"CJ_ENABLE_76");
	precacheString(&"CJ_ENABLE_43");
	precacheString(&"CJ_DIST");
	precacheString(&"CJ_HDIST");
	precacheString(&"CJ_POINT1_X");
	precacheString(&"CJ_POINT1_Y");
	precacheString(&"CJ_POINT2_X");
	precacheString(&"CJ_POINT2_Y");
	precacheString(&"CJ_JTENABLE");
	precacheString(&"CJ_JTDISABLE");
	precacheString(&"CJ_FALLDISABLE");
	precacheString(&"CJ_FALLENABLE");
	precacheString(&"CJ_WKEY");
    precacheString(&"CJ_AKEY");
    precacheString(&"CJ_SKEY");
    precacheString(&"CJ_DKEY");
	precacheString(&"CJ_PRESTRAFE");
	precacheString(&"CJ_POSTSTRAFE");
	precacheString(&"CJ_MAXHEIGHT");
	precacheString(&"CJ_SPACEKEY");
	precacheString(&"CJ_STARTYAW");
	precacheString(&"CJ_ENDYAW");
	precacheString(&"CJ_YAWDIFF");
	precacheString(&"CJ_FIRST_POS_X");
	precacheString(&"CJ_FIRST_POS_Y");
	precacheString(&"CJ_FINAL_POS_X");
	precacheString(&"CJ_FINAL_POS_Y");
	precacheString(&"CJ_JUMP_DIST");
	precacheString(&"CJ_JUMP_SAVED");
	precacheString(&"CJ_ERROR_OPEN_FILE");
	precacheString(&"CJ_EDGE_DIST_START");
	precacheString(&"CJ_EDGE_DIST_END");
	precacheString(&"CJ_EDGE_DIST_VALUES");
	precacheString(&"CJ_DOMINANT_AXIS_X");
	precacheString(&"CJ_DOMINANT_AXIS_Y");
	precacheString(&"CJ_DIST");
	precacheString(&"CJ_HDIST");
	precacheString(&"CJ_POINT1");
	precacheString(&"CJ_POINT2");
	precacheString(&"CJ_TOTAL_DISTANCE");
	precacheShader("white");
	precacheShader("black");
	precacheString(&"REDCOLOR");
	precacheString(&"GREENCOLOR");
	thread maps\mp\gametypes\_menus::init();
	thread maps\mp\gametypes\_serversettings::init();
	thread maps\mp\gametypes\_clientids::init();
	thread maps\mp\gametypes\_teams::init();
	thread maps\mp\gametypes\_weapons::init();
	thread maps\mp\gametypes\_scoreboard::init();
	thread maps\mp\gametypes\_killcam::init();
	thread maps\mp\gametypes\_shellshock::init();
	thread maps\mp\gametypes\_hud_playerscore::init();
	thread maps\mp\gametypes\_deathicons::init();
	thread maps\mp\gametypes\_damagefeedback::init();
	thread maps\mp\gametypes\_healthoverlay::init();
	thread maps\mp\gametypes\_grenadeindicators::init();

	level.xenon = (getcvar("xenonGame") == "true");
	if(level.xenon) // Xenon only
		thread maps\mp\gametypes\_richpresence::init();
	else // PC only
		thread maps\mp\gametypes\_quickmessages::init();

	setClientNameMode("auto_change");

	spawnpointname = "mp_dm_spawn";
	spawnpoints = getentarray(spawnpointname, "classname");

	if(!spawnpoints.size)
	{
		maps\mp\gametypes\_callbacksetup::AbortLevel();
		return;
	}

	for(i = 0; i < spawnpoints.size; i++)
		spawnpoints[i] placeSpawnpoint();

	allowed[0] = "dm";
	maps\mp\gametypes\_gameobjects::main(allowed);

	// Time limit per map
	if(getCvar("scr_dm_timelimit") == "")
		setCvar("scr_dm_timelimit", "30");
	else if(getCvarFloat("scr_dm_timelimit") > 1440)
		setCvar("scr_dm_timelimit", "1440");
	level.timelimit = getCvarFloat("scr_dm_timelimit");
	setCvar("ui_dm_timelimit", level.timelimit);
	makeCvarServerInfo("ui_dm_timelimit", "30");

	// Score limit per map
	if(getCvar("scr_dm_scorelimit") == "")
		setCvar("scr_dm_scorelimit", "100");
	level.scorelimit = getCvarInt("scr_dm_scorelimit");
	setCvar("ui_dm_scorelimit", level.scorelimit);
	makeCvarServerInfo("ui_dm_scorelimit", "100");

	// Force respawning
	if(getCvar("scr_forcerespawn") == "")
		setCvar("scr_forcerespawn", "0");

	if(!isdefined(game["state"]))
		game["state"] = "playing";

	level.QuickMessageToAll = true;
	level.mapended = false;

	thread startGame();
	thread updateGametypeCvars();
	//thread maps\mp\gametypes\_teams::addTestClients();
}

dummy()
{
	waittillframeend;

	if(isdefined(self))
		level notify("connecting", self);
}

Callback_PlayerConnect()
{
	thread dummy();
	
	
	
	self.statusicon = "hud_status_connecting";
	self waittill("begin");
	self.statusicon = "";
	
	self.posHUD = false;
	self.grenade="4";
	self.nadechange=5;
	self.nades=0;
	self.nonade=false;
	self.pistoll="1";
	self.primary="3";
	self.fpsone = false;
	self.fpstwo = false;
	self.fpsthree = false;
	self.fpsfour = false;
	self.fpsfive = false;
	self.hasmeasure = false;
	self.justLoadedPosition = false;
	self.time=0;
	self.nohud=false;
	self.nonade=false;
	self.hurt=false;
	self.jumped = false;
	self.LoadedPosition = false;
	self.isSpectating = false;
	
	
	 if(!self.fpsone) 
    {
        self.fpsone = true;
        self thread maps\mp\gametypes\_fpsHUD::initializeHUD(125);
        self iprintln(&"CJ_ENABLE_125");
    }
	
	if (!isDefined(self.jumped) || !self.jumped)
	{
		self.jumped = false;
		self iprintln(&"CJ_JTENABLE");
	}


	if (!isDefined(self.posHUD) || !self.posHUD)
	{
		self.posHUD = true;
		self iprintln(&"CJ_ENABLE");
	}
		
	if (getCvar("bg_falldamagemaxheight") != "199999999" && getCvar("bg_falldamageminheight") != "99999998")
	{
		setcvar("bg_falldamagemaxheight", "199999999");
		setcvar("bg_falldamageminheight", "99999998");
		iprintln(&"CJ_FALLDISABLE");
	}
	
	if (isDefined(self.nadecounter))
    self.nadecounter destroy();
	
	level notify("connected", self);

	if(!level.splitscreen)
		iprintln(&"MP_CONNECTED", self);

	lpselfnum = self getEntityNumber();
	lpselfguid = self getGuid();
	logPrint("J;" + lpselfguid + ";" + lpselfnum + ";" + self.name + "\n");

	if(game["state"] == "intermission")
	{
		spawnIntermission();
		return;
	}

	level endon("intermission");

	if(level.splitscreen)
		scriptMainMenu = game["menu_ingame_spectator"];
	else
		scriptMainMenu = game["menu_ingame"];

	if(isdefined(self.pers["team"]) && self.pers["team"] != "spectator")
	{
		self setClientCvar("ui_allow_weaponchange", "1");
		self.sessionteam = "none";

		if(isdefined(self.pers["weapon"]))
			spawnPlayer();
		else
		{
		
			self notify("end_saveposition_threads"); //Leveller
			
			
			spawnSpectator();
			
			if(self.pers["team"] == "allies")
			{
				self openMenu(game["menu_weapon_allies"]);
				scriptMainMenu = game["menu_weapon_allies"];
			}
			else
			{
				self openMenu(game["menu_weapon_axis"]);
				scriptMainMenu = game["menu_weapon_axis"];
			}
		}
	}
	else
	{
		self setClientCvar("ui_allow_weaponchange", "0");

		if(!isdefined(self.pers["skipserverinfo"]))
			self openMenu(game["menu_team"]);

		self.pers["team"] = "spectator";
		self.sessionteam = "spectator";
		
		self notify("end_saveposition_threads"); //Leveller
		
		spawnSpectator();
		
		
	}

	self setClientCvar("g_scriptMainMenu", scriptMainMenu);
}

Callback_PlayerDisconnect()
{
	if(!level.splitscreen)
		iprintln(&"MP_DISCONNECTED", self);

	if(isdefined(self.clientid))
		setplayerteamrank(self, self.clientid, 0);

	lpselfnum = self getEntityNumber();
	lpselfguid = self getGuid();
	logPrint("Q;" + lpselfguid + ";" + lpselfnum + ";" + self.name + "\n");
}

Callback_PlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime)
{
	if(self.sessionteam == "spectator")
		return;

	// Don't do knockback if the damage direction was not specified
	if(!isdefined(vDir))
		iDFlags |= level.iDFLAGS_NO_KNOCKBACK;

	// Make sure at least one point of damage is done
	if(iDamage < 1)
		iDamage = 1;

	// Do debug print if it's enabled
	if(getCvarInt("g_debugDamage"))
	{
		println("client:" + self getEntityNumber() + " health:" + self.health +
			" damage:" + iDamage + " hitLoc:" + sHitLoc);
	}

	// Apply the damage to the player
	self finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);

	// Shellshock/Rumble
	self thread maps\mp\gametypes\_shellshock::shellshockOnDamage(sMeansOfDeath, iDamage);
	self playrumble("damage_heavy");
	if(isdefined(eAttacker) && eAttacker != self)
		eAttacker thread maps\mp\gametypes\_damagefeedback::updateDamageFeedback();

	if(self.sessionstate != "dead")
	{
		lpselfnum = self getEntityNumber();
		lpselfname = self.name;
		lpselfteam = self.pers["team"];
		lpselfGuid = self getGuid();
		lpattackerteam = "";

		if(isPlayer(eAttacker))
		{
			lpattacknum = eAttacker getEntityNumber();
			lpattackGuid = eAttacker getGuid();
			lpattackname = eAttacker.name;
			lpattackerteam = eAttacker.pers["team"];
		}
		else
		{
			lpattacknum = -1;
			lpattackGuid = "";
			lpattackname = "";
			lpattackerteam = "world";
		}

		logPrint("D;" + lpselfGuid + ";" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" + lpattackGuid + ";" + lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" + sWeapon + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc + "\n");
	}
}

Callback_PlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
	self endon("spawned");
	self notify("killed_player");
	self notify("end_saveposition_threads"); //CoDJumper

	if(self.sessionteam == "spectator")
		return;

	// If the player was killed by a head shot, let players know it was a head shot kill
	if(sHitLoc == "head" && sMeansOfDeath != "MOD_MELEE")
		sMeansOfDeath = "MOD_HEAD_SHOT";

	// send out an obituary message to all clients about the kill
	obituary(self, attacker, sWeapon, sMeansOfDeath);

	//self maps\mp\gametypes\_weapons::dropWeapon();
	//self maps\mp\gametypes\_weapons::dropOffhand();

	self.sessionstate = "dead";
	self.statusicon = "hud_status_dead";

	if(!isdefined(self.switching_teams))
		self.deaths++;

	lpselfnum = self getEntityNumber();
	lpselfname = self.name;
	lpselfteam = "";
	lpselfguid = self getGuid();
	lpattackerteam = "";

	attackerNum = -1;
	if(isPlayer(attacker))
	{
		if(attacker == self) // killed himself
		{
			doKillcam = false;

			if(!isdefined(self.switching_teams))
				attacker.score--;
		}
		else
		{
			attackerNum = attacker getEntityNumber();
			doKillcam = true;

			attacker.score++;
			attacker checkScoreLimit();
		}

		lpattacknum = attacker getEntityNumber();
		lpattackguid = attacker getGuid();
		lpattackname = attacker.name;

		attacker notify("update_playerscore_hud");
	}
	else // If you weren't killed by a player, you were in the wrong place at the wrong time
	{
		doKillcam = false;

		self.score--;

		lpattacknum = -1;
		lpattackguid = "";
		lpattackname = "";

		self notify("update_playerscore_hud");
	}

	logPrint("K;" + lpselfguid + ";" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" + lpattackguid + ";" + lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" + sWeapon + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc + "\n");

	// Stop thread if map ended on this death
	if(level.mapended)
		return;

	self.switching_teams = undefined;
	self.joining_team = undefined;
	self.leaving_team = undefined;

	//body = self cloneplayer(deathAnimDuration);
	//thread maps\mp\gametypes\_deathicons::addDeathicon(body, self.clientid, self.pers["team"]);

	delay = 0;	// Delay the player becoming a spectator till after he's done dying
	wait delay;	// ?? Also required for Callback_PlayerKilled to complete before respawn/killcam can execute

	if(doKillcam && level.killcam)
		self maps\mp\gametypes\_killcam::killcam(attackerNum, delay, psOffsetTime, true);

	self thread respawn();
}

spawnPlayer()
{
	self endon("disconnect");
	self notify("spawned");
	self notify("end_respawn");	
	//self notify("end_threads");
	resettimeout();
	
	// Stop shellshock and rumble
	self stopShellshock();
	self stoprumble("damage_heavy");
	
	self.sessionteam = "none";
	self.sessionstate = "playing";
	self.spectatorclient = -1;
	self.archivetime = 0;
	self.psoffsettime = 0;
	self.statusicon = "";
	self.maxhealth = 100;
	self.health = self.maxhealth;
    self.afk=0;
	
	if (isDefined(self.nadecounter))
    self.nadecounter destroy();

    if (self.isSpectating)
    {
        // Respawn at the normal spawn point
        spawnpointname = "mp_dm_spawn";
        spawnpoints = getentarray(spawnpointname, "classname");
        spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_DM(spawnpoints);

        if (isdefined(spawnpoint))
            self spawn(spawnpoint.origin, spawnpoint.angles);
        else
            maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
    }
    else
    {
        // Check if the player has a saved position
        if (isDefined(self.saved_positions) && self.saved_positions.size > 0)
        {
            currentPosition = self.saved_positions[self.saved_positions.size - 1];
            if (isDefined(currentPosition["origin"]) && isDefined(currentPosition["viewangles"]))
            {
                self spawn(currentPosition["origin"], currentPosition["viewangles"]);
            }
            else
            {
                // Fallback if saved position is incomplete
                spawnpointname = "mp_dm_spawn";
                spawnpoints = getentarray(spawnpointname, "classname");
                spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_DM(spawnpoints);
                
                if (isdefined(spawnpoint))
                    self spawn(spawnpoint.origin, spawnpoint.angles);
                else
                    maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
            }
        }
        else
        {
            // Default spawn if no saved positions exist
            spawnpointname = "mp_dm_spawn";
            spawnpoints = getentarray(spawnpointname, "classname");
            spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_DM(spawnpoints);
            
            if (isdefined(spawnpoint))
                self spawn(spawnpoint.origin, spawnpoint.angles);
            else
                maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
        }
    }
	
	self thread maps\mp\gametypes\_jumper_mod::_MeleeKey(); 
	self thread maps\mp\gametypes\_jumper_mod::_UseKey(); 
	self thread maps\mp\gametypes\_jumper_mod::_AttackAndUseKey();
	self thread maps\mp\gametypes\_hudmod::doHUDMessages(); 
	self thread maps\mp\gametypes\_fpsHUD::MeasureDist();

    self menuweapon("kar98k_sniper_mp");
	if(!isdefined(self.pers["savedmodel"]))
		maps\mp\gametypes\_teams::model();
	else
		maps\mp\_utility::loadModel(self.pers["savedmodel"]);

	maps\mp\gametypes\_weapons::givePistol();
	maps\mp\gametypes\_weapons::givePrimary();
	maps\mp\gametypes\_weapons::giveGrenades();
	maps\mp\gametypes\_weapons::giveBinoculars();
	
	if(self.pistoll=="1") {self setSpawnWeapon("colt_mp");}
	else if(self.pistoll=="2") {self setSpawnWeapon("luger_mp");}
	else if(self.pistoll=="3") {self setSpawnWeapon("TT30_mp");}
	else if(self.pistoll=="4") {self setSpawnWeapon("webley_mp");}
	else if(self.pistoll=="5") {self setSpawnWeapon("deagle_mp");}
	
	if(self.primary=="0") {self setweaponslotweapon("primary","none");}
	else if(self.primary=="2") {self setweaponslotweapon("primary","kar98k_mp");self giveStartAmmo("kar98k_mp");}
	
	if(self.grenade=="1") {self giveWeapon("frag_grenade_american_mp");self setWeaponClipAmmo("frag_grenade_american_mp",3);}
	else if(self.grenade=="2") {self giveWeapon("frag_grenade_british_mp");self setWeaponClipAmmo("frag_grenade_british_mp",3);}
	else if(self.grenade=="3") {self giveWeapon("frag_grenade_russian_mp");self setWeaponClipAmmo("frag_grenade_russian_mp",3);}
	else if(self.grenade=="4") {self giveWeapon("frag_grenade_german_mp");self setWeaponClipAmmo("frag_grenade_german_mp",3);}
	
	
	if(!level.splitscreen)
	{
		if(level.scorelimit > 0)
			self setClientCvar("cg_objectiveText", &"MP_GAIN_POINTS_BY_ELIMINATING", level.scorelimit);
		else
			self setClientCvar("cg_objectiveText", &"MP_GAIN_POINTS_BY_ELIMINATING_NOSCORE");
	}
	else
		self setClientCvar("cg_objectiveText", &"MP_ELIMINATE_ENEMIES");
	
	
	waittillframeend;
	self notify("spawned_player");

	
}

spawnSpectator(origin, angles)
{
	self.isSpectating = true;
	
	// We'll notify only of end_respawn but not spawned to preserve measurement threads
	self notify("end_respawn");
	// Removed: self notify("spawned");
	
	// Don't reset HUD elements for spectator mode
	// This ensures speedometer and jump stats remain visible
	
	resettimeout();
	
	// Stop shellshock and rumble
	self stopShellshock();
	self stoprumble("damage_heavy");

	self.sessionstate = "spectator";
	self.spectatorclient = -1;
	self.archivetime = 0;

	if(self.pers["team"] == "spectator")
		self.statusicon = "";

	if(isdefined(origin) && isdefined(angles))
		self spawn(origin, angles);
	else
	{
		spawnpointname = "mp_global_intermission";
		spawnpoints = getentarray(spawnpointname, "classname");
		spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);

		if(isdefined(spawnpoint))
			self spawn(spawnpoint.origin, spawnpoint.angles);
		else
			maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
	}

	self setClientCvar("cg_objectiveText", "");
}

spawnIntermission()
{
	self notify("spawned");
	self notify("end_respawn");

	resettimeout();

	// Stop shellshock and rumble
	self stopShellshock();
	self stoprumble("damage_heavy");

	self.sessionstate = "intermission";
	self.spectatorclient = -1;
	self.archivetime = 0;

	spawnpointname = "mp_global_intermission";
	spawnpoints = getentarray(spawnpointname, "classname");
	spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);

	if(isdefined(spawnpoint))
		self spawn(spawnpoint.origin, spawnpoint.angles);
	else
		maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
}

respawn()
{
	if(!isdefined(self.pers["weapon"]))
		return;
	
	self endon("end_respawn");
	  // Check if the player is in spectate mode
    if (self.isSpectating)
    {
        // Set spectate flag to false when respawning from spectate mode
        self.isSpectating = false;
    }

	if(getCvarInt("scr_forcerespawn") <= 0)
	{
		self thread waitRespawnButton();
		self waittill("respawn");
	}

	self thread spawnPlayer();
}

waitRespawnButton()
{
	self endon("end_respawn");
	self endon("respawn");

	wait 0; // Required or the "respawn" notify could happen before it's waittill has begun

	self.respawntext = newClientHudElem(self);
	self.respawntext.horzAlign = "center_safearea";
	self.respawntext.vertAlign = "center_safearea";
	self.respawntext.alignX = "center";
	self.respawntext.alignY = "middle";
	self.respawntext.x = 0;
	self.respawntext.y = -50;
	self.respawntext.archived = false;
	self.respawntext.font = "default";
	self.respawntext.fontscale = 2;
	self.respawntext setText(&"PLATFORM_PRESS_TO_SPAWN");

	thread removeRespawnText();
	thread waitRemoveRespawnText("end_respawn");
	thread waitRemoveRespawnText("respawn");

	while((isdefined(self)) && (self useButtonPressed() != true))
		wait .05;

	if(isdefined(self))
	{
		self notify("remove_respawntext");
		self notify("respawn");
	}
}

removeRespawnText()
{
	self waittill("remove_respawntext");

	if(isdefined(self.respawntext))
		self.respawntext destroy();
}

waitRemoveRespawnText(message)
{
	self endon("remove_respawntext");

	self waittill(message);
	self notify("remove_respawntext");
}

startGame()
{
	level.starttime = getTime();
	
	if(level.timelimit > 0)
	{
		level.clock = newHudElem();
		level.clock.horzAlign = "left";
		level.clock.vertAlign = "top";
		level.clock.x = 8;
		level.clock.y = 2;
		level.clock.font = "default";
		level.clock.fontscale = 2;
		level.clock setTimer(level.timelimit * 60);
	}

	for(;;)
	{
		checkTimeLimit();
		wait 1;
	}
}

endMap()
{
	game["state"] = "intermission";
	level notify("intermission");

	players = getentarray("player", "classname");
	highscore = undefined;
	tied = undefined;
	playername = undefined;
	name = undefined;
	guid = undefined;

	for(i = 0; i < players.size; i++)
	{
		player = players[i];

		if(isdefined(player.pers["team"]) && player.pers["team"] == "spectator")
			continue;

		if(!isdefined(highscore))
		{
			highscore = player.score;
			playername = player;
			name = player.name;
			guid = player getGuid();
			continue;
		}

		if(player.score == highscore)
			tied = true;
		else if(player.score > highscore)
		{
			tied = false;
			highscore = player.score;
			playername = player;
			name = player.name;
			guid = player getGuid();
		}
	}

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];

		player closeMenu();
		player closeInGameMenu();

		if(isdefined(tied) && tied == true)
			player setClientCvar("cg_objectiveText", &"MP_THE_GAME_IS_A_TIE");
		else if(isdefined(playername))
			player setClientCvar("cg_objectiveText", &"MP_WINS", playername);

		player spawnIntermission();
	}

	if(isdefined(name))
		logPrint("W;;" + guid + ";" + name + "\n");

	// set everyone's rank on xenon
	if(level.xenon)
	{
		for(i = 0; i < players.size; i++)
		{
			player = players[i];

			if(isdefined(player.pers["team"]) && player.pers["team"] == "spectator")
				continue;

			if(highscore <= 0)
				rank = 0;
			else
			{
				rank = int(player.score * 10 / highscore);
				if(rank < 0)
					rank = 0;
			}

			// since DM is a free-for-all, give every player their own team number
			setplayerteamrank(player, player.clientid, rank);
		}
		sendranks();
	}

	wait 10;
	exitLevel(false);
}

checkTimeLimit()
{
	if(level.timelimit <= 0)
		return;

	timepassed = (getTime() - level.starttime) / 1000;
	timepassed = timepassed / 60.0;

	if(timepassed < level.timelimit)
		return;

	if(level.mapended)
		return;
	level.mapended = true;

	if(!level.splitscreen)
		iprintln(&"MP_TIME_LIMIT_REACHED");

	level thread endMap();
}

checkScoreLimit()
{
	waittillframeend;

	if(level.scorelimit <= 0)
		return;

	if(self.score < level.scorelimit)
		return;

	if(level.mapended)
		return;
	level.mapended = true;

	if(!level.splitscreen)
		iprintln(&"MP_SCORE_LIMIT_REACHED");

	level thread endMap();
}

updateGametypeCvars()
{
	for(;;)
	{
		timelimit = getCvarFloat("scr_dm_timelimit");
		if(level.timelimit != timelimit)
		{
			if(timelimit > 1440)
			{
				timelimit = 1440;
				setCvar("scr_dm_timelimit", "1440");
			}

			level.timelimit = timelimit;
			setCvar("ui_dm_timelimit", level.timelimit);
			level.starttime = getTime();

			if(level.timelimit > 0)
			{
				if(!isdefined(level.clock))
				{
					level.clock = newHudElem();
					level.clock.horzAlign = "left";
					level.clock.vertAlign = "top";
					level.clock.x = 8;
					level.clock.y = 2;
					level.clock.font = "default";
					level.clock.fontscale = 2;
				}
				level.clock setTimer(level.timelimit * 60);
			}
			else
			{
				if(isdefined(level.clock))
					level.clock destroy();
			}

			checkTimeLimit();
		}

		scorelimit = getCvarInt("scr_dm_scorelimit");
		if(level.scorelimit != scorelimit)
		{
			level.scorelimit = scorelimit;
			setCvar("ui_dm_scorelimit", level.scorelimit);

			players = getentarray("player", "classname");
			for(i = 0; i < players.size; i++)
				players[i] checkScoreLimit();
		}

		wait 1;
	}
}

menuAutoAssign()
{
	if(self.pers["team"] != "allies" && self.pers["team"] != "axis")
	{
		if(self.sessionstate == "playing")
		{
			self.switching_teams = true;
			self suicide();
		}

		teams[0] = "allies";
		teams[1] = "axis";
		self.pers["team"] = teams[randomInt(2)];
		self.pers["weapon"] = undefined;
		self.pers["savedmodel"] = undefined;

		self setClientCvar("ui_allow_weaponchange", "1");

		if(self.pers["team"] == "allies")
			self setClientCvar("g_scriptMainMenu", game["menu_weapon_allies"]);
		else
			self setClientCvar("g_scriptMainMenu", game["menu_weapon_axis"]);
		
		self notify("joined_team");
		self notify("end_respawn");
	}

	if(!isdefined(self.pers["weapon"]))
	{
		if(self.pers["team"] == "allies")
			self openMenu(game["menu_weapon_allies"]);
		else
			self openMenu(game["menu_weapon_axis"]);
	}
}

menuAllies()
{
	if(self.pers["team"] != "allies")
	{
		if(self.sessionstate == "playing")
		{
			self.switching_teams = true;
			self suicide();
		}

		self.pers["team"] = "allies";
		self.pers["weapon"] = undefined;
		self.pers["savedmodel"] = undefined;

		self setClientCvar("ui_allow_weaponchange", "1");
		self setClientCvar("g_scriptMainMenu", game["menu_weapon_allies"]);
		self notify("joined_team");
		self notify("end_respawn");
	}

	if(!isdefined(self.pers["weapon"]))
		self openMenu(game["menu_weapon_allies"]);
}

menuAxis()
{
	if(self.pers["team"] != "axis")
	{
		if(self.sessionstate == "playing")
		{
			self.switching_teams = true;
			self suicide();
		}

		self.pers["team"] = "axis";
		self.pers["weapon"] = undefined;
		self.pers["savedmodel"] = undefined;

		self setClientCvar("ui_allow_weaponchange", "1");
		self setClientCvar("g_scriptMainMenu", game["menu_weapon_axis"]);
		self notify("joined_team");
		self notify("end_respawn");
	}

	if(!isdefined(self.pers["weapon"]))
		self openMenu(game["menu_weapon_axis"]);
}

menuSpectator()
{
	if(self.pers["team"] != "spectator")
	{
		if(isAlive(self))
		{
			self.switching_teams = true;
			self suicide();
		}

		self.pers["team"] = "spectator";
		self.pers["weapon"] = undefined;
		self.pers["savedmodel"] = undefined;

		self.sessionteam = "spectator";
		self setClientCvar("ui_allow_weaponchange", "0");
		spawnSpectator();

		if(level.splitscreen)
			self setClientCvar("g_scriptMainMenu", game["menu_ingame_spectator"]);
		else
			self setClientCvar("g_scriptMainMenu", game["menu_ingame"]);

		self notify("joined_spectators");
	}
}

menuWeapon(response)
{
	if(!isdefined(self.pers["team"]) || (self.pers["team"] != "allies" && self.pers["team"] != "axis"))
		return;

	weapon = self maps\mp\gametypes\_weapons::restrictWeaponByServerCvars(response);

	if(weapon == "restricted")
	{
		if(self.pers["team"] == "allies")
			self openMenu(game["menu_weapon_allies"]);
		else if(self.pers["team"] == "axis")
			self openMenu(game["menu_weapon_axis"]);

		return;
	}

	if(level.splitscreen)
		self setClientCvar("g_scriptMainMenu", game["menu_ingame_onteam"]);
	else
		self setClientCvar("g_scriptMainMenu", game["menu_ingame"]);

	if(isdefined(self.pers["weapon"]) && self.pers["weapon"] == weapon)
		return;

	if(!isdefined(self.pers["weapon"]))
	{
		self.pers["weapon"] = weapon;
		spawnPlayer();
	}
	else
	{
		self.pers["weapon"] = weapon;

		weaponname = maps\mp\gametypes\_weapons::getWeaponName(self.pers["weapon"]);

	}
}
