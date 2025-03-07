#include maps\mp\_utility;

init()
{
	precacheItem("colt_mp");
	precacheItem("luger_mp");
	precacheItem("TT30_mp");
	precacheItem("webley_mp");
	precacheItem("deagle_mp");
	precacheItem("bren_mp");
	precacheItem("kar98k_mp");
	precacheItem("kar98k_sniper_mp");
	precacheItem("mp44_mp");
	precacheItem("ppsh_mp");
	precacheItem("shotgun_mp");
	precacheItem("springfield_mp");
	precacheItem("greasegun_mp");
	precacheItem("m1carbine_mp");
	precacheItem("m1garand_mp");
	precacheItem("thompson_mp");
	precacheItem("bar_mp");
	precacheItem("sten_mp");
	precacheItem("enfield_mp");
	precacheItem("enfield_scope_mp");
	precacheItem("PPS42_mp");
	precacheItem("mosin_nagant_mp");
	precacheItem("SVT40_mp");
	precacheItem("mosin_nagant_sniper_mp");
	precacheItem("mp40_mp");
	precacheItem("g43_mp");
	precacheItem("frag_grenade_american_mp");
	precacheItem("frag_grenade_british_mp");
	precacheItem("frag_grenade_russian_mp");
	precacheItem("frag_grenade_german_mp");
	
	precacheItem("binoculars_mp");

	level.weaponnames=[];
	level.weaponnames[0]="greasegun_mp";
	level.weaponnames[1]="m1carbine_mp";
	level.weaponnames[2]="m1garand_mp";
	level.weaponnames[3]="springfield_mp";
	level.weaponnames[4]="thompson_mp";
	level.weaponnames[5]="bar_mp";
	level.weaponnames[6]="sten_mp";
	level.weaponnames[7]="enfield_mp";
	level.weaponnames[8]="enfield_scope_mp";
	level.weaponnames[9]="bren_mp";
	level.weaponnames[10]="PPS42_mp";
	level.weaponnames[11]="mosin_nagant_mp";
	level.weaponnames[12]="SVT40_mp";
	level.weaponnames[13]="mosin_nagant_sniper_mp";
	level.weaponnames[14]="ppsh_mp";
	level.weaponnames[15]="mp40_mp";
	level.weaponnames[16]="kar98k_mp";
	level.weaponnames[17]="g43_mp";
	level.weaponnames[18]="kar98k_sniper_mp";
	level.weaponnames[19]="mp44_mp";
	level.weaponnames[20]="shotgun_mp";
	level.weaponnames[21]="fraggrenade";
	level.weaponnames[22]="smokegrenade";

	level.weapons=[];
	level.weapons["greasegun_mp"]=spawnstruct();
	level.weapons["greasegun_mp"].server_allowcvar="scr_allow_greasegun";
	level.weapons["greasegun_mp"].client_allowcvar="ui_allow_greasegun";
	level.weapons["greasegun_mp"].allow_default=1;

	level.weapons["m1carbine_mp"]=spawnstruct();
	level.weapons["m1carbine_mp"].server_allowcvar="scr_allow_m1carbine";
	level.weapons["m1carbine_mp"].client_allowcvar="ui_allow_m1carbine";
	level.weapons["m1carbine_mp"].allow_default=1;

	level.weapons["m1garand_mp"]=spawnstruct();
	level.weapons["m1garand_mp"].server_allowcvar="scr_allow_m1garand";
	level.weapons["m1garand_mp"].client_allowcvar="ui_allow_m1garand";
	level.weapons["m1garand_mp"].allow_default=1;

	level.weapons["springfield_mp"]=spawnstruct();
	level.weapons["springfield_mp"].server_allowcvar="scr_allow_springfield";
	level.weapons["springfield_mp"].client_allowcvar="ui_allow_springfield";
	level.weapons["springfield_mp"].allow_default=1;

	level.weapons["thompson_mp"]=spawnstruct();
	level.weapons["thompson_mp"].server_allowcvar="scr_allow_thompson";
	level.weapons["thompson_mp"].client_allowcvar="ui_allow_thompson";
	level.weapons["thompson_mp"].allow_default=1;

	level.weapons["bar_mp"]=spawnstruct();
	level.weapons["bar_mp"].server_allowcvar="scr_allow_bar";
	level.weapons["bar_mp"].client_allowcvar="ui_allow_bar";
	level.weapons["bar_mp"].allow_default=1;

	level.weapons["sten_mp"]=spawnstruct();
	level.weapons["sten_mp"].server_allowcvar="scr_allow_sten";
	level.weapons["sten_mp"].client_allowcvar="ui_allow_sten";
	level.weapons["sten_mp"].allow_default=1;

	level.weapons["enfield_mp"]=spawnstruct();
	level.weapons["enfield_mp"].server_allowcvar="scr_allow_enfield";
	level.weapons["enfield_mp"].client_allowcvar="ui_allow_enfield";
	level.weapons["enfield_mp"].allow_default=1;

	level.weapons["enfield_scope_mp"]=spawnstruct();
	level.weapons["enfield_scope_mp"].server_allowcvar="scr_allow_enfieldsniper";
	level.weapons["enfield_scope_mp"].client_allowcvar="ui_allow_enfieldsniper";
	level.weapons["enfield_scope_mp"].allow_default=1;

	level.weapons["bren_mp"]=spawnstruct();
	level.weapons["bren_mp"].server_allowcvar="scr_allow_bren";
	level.weapons["bren_mp"].client_allowcvar="ui_allow_bren";
	level.weapons["bren_mp"].allow_default=1;

	level.weapons["PPS42_mp"]=spawnstruct();
	level.weapons["PPS42_mp"].server_allowcvar="scr_allow_pps42";
	level.weapons["PPS42_mp"].client_allowcvar="ui_allow_pps42";
	level.weapons["PPS42_mp"].allow_default=1;

	level.weapons["mosin_nagant_mp"]=spawnstruct();
	level.weapons["mosin_nagant_mp"].server_allowcvar="scr_allow_nagant";
	level.weapons["mosin_nagant_mp"].client_allowcvar="ui_allow_nagant";
	level.weapons["mosin_nagant_mp"].allow_default=1;

	level.weapons["SVT40_mp"]=spawnstruct();
	level.weapons["SVT40_mp"].server_allowcvar="scr_allow_svt40";
	level.weapons["SVT40_mp"].client_allowcvar="ui_allow_svt40";
	level.weapons["SVT40_mp"].allow_default=1;

	level.weapons["mosin_nagant_sniper_mp"]=spawnstruct();
	level.weapons["mosin_nagant_sniper_mp"].server_allowcvar="scr_allow_nagantsniper";
	level.weapons["mosin_nagant_sniper_mp"].client_allowcvar="ui_allow_nagantsniper";
	level.weapons["mosin_nagant_sniper_mp"].allow_default=1;

	level.weapons["ppsh_mp"]=spawnstruct();
	level.weapons["ppsh_mp"].server_allowcvar="scr_allow_ppsh";
	level.weapons["ppsh_mp"].client_allowcvar="ui_allow_ppsh";
	level.weapons["ppsh_mp"].allow_default=1;

	level.weapons["mp40_mp"]=spawnstruct();
	level.weapons["mp40_mp"].server_allowcvar="scr_allow_mp40";
	level.weapons["mp40_mp"].client_allowcvar="ui_allow_mp40";
	level.weapons["mp40_mp"].allow_default=1;

	level.weapons["kar98k_mp"]=spawnstruct();
	level.weapons["kar98k_mp"].server_allowcvar="scr_allow_kar98k";
	level.weapons["kar98k_mp"].client_allowcvar="ui_allow_kar98k";
	level.weapons["kar98k_mp"].allow_default=1;

	level.weapons["g43_mp"]=spawnstruct();
	level.weapons["g43_mp"].server_allowcvar="scr_allow_g43";
	level.weapons["g43_mp"].client_allowcvar="ui_allow_g43";
	level.weapons["g43_mp"].allow_default=1;

	level.weapons["kar98k_sniper_mp"]=spawnstruct();
	level.weapons["kar98k_sniper_mp"].server_allowcvar="scr_allow_kar98ksniper";
	level.weapons["kar98k_sniper_mp"].client_allowcvar="ui_allow_kar98ksniper";
	level.weapons["kar98k_sniper_mp"].allow_default=1;

	level.weapons["mp44_mp"]=spawnstruct();
	level.weapons["mp44_mp"].server_allowcvar="scr_allow_mp44";
	level.weapons["mp44_mp"].client_allowcvar="ui_allow_mp44";
	level.weapons["mp44_mp"].allow_default=1;

	level.weapons["shotgun_mp"]=spawnstruct();
	level.weapons["shotgun_mp"].server_allowcvar="scr_allow_shotgun";
	level.weapons["shotgun_mp"].client_allowcvar="ui_allow_shotgun";
	level.weapons["shotgun_mp"].allow_default=1;

	level.weapons["fraggrenade"]=spawnstruct();
	level.weapons["fraggrenade"].server_allowcvar="scr_allow_fraggrenades";
	level.weapons["fraggrenade"].client_allowcvar="ui_allow_fraggrenades";
	level.weapons["fraggrenade"].allow_default=1;

	level.weapons["smokegrenade"]=spawnstruct();
	level.weapons["smokegrenade"].server_allowcvar="scr_allow_smokegrenades";
	level.weapons["smokegrenade"].client_allowcvar="ui_allow_smokegrenades";
	level.weapons["smokegrenade"].allow_default=1;

	for(i=0; i < level.weaponnames.size; i++)
	{
		weaponname=level.weaponnames[i];

		if(getCvar(level.weapons[weaponname].server_allowcvar)=="")
		{
			level.weapons[weaponname].allow=level.weapons[weaponname].allow_default;
			setCvar(level.weapons[weaponname].server_allowcvar, level.weapons[weaponname].allow);
		}
		else
			level.weapons[weaponname].allow=getCvarInt(level.weapons[weaponname].server_allowcvar);
	}

	level thread deleteRestrictedWeapons();
	level thread onPlayerConnect();

	for(;;)
	{
		updateAllowed();
		wait 5;
	}
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);

		player.usedweapons=false;

		player thread updateAllAllowedSingleClient();
		player thread onPlayerSpawned();
	}
}

onPlayerSpawned()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("spawned_player");

		self thread watchWeaponUsage();
	}
}

deleteRestrictedWeapons()
{
	for(i=0; i < level.weaponnames.size; i++)
	{
		weaponname=level.weaponnames[i];

		//if(level.weapons[weaponname].allow!=1)
			//deletePlacedEntity(level.weapons[weaponname].radiant_name);
	}

	// Need to not automatically give these to players if I allow restricting them
	// knife_mp
	// deagle_mp
	// colt_mp
	// webley_mp
	// TT30_mp
	// luger_mp
	// fraggrenade_mp
	// mk1britishfrag_mp
	// rgd-33russianfrag_mp
	// stielhandgranate_mp
}

givePistol()
{
	self takeWeapon("colt_mp");
	self takeWeapon("luger_mp");
	self takeWeapon("TT30_mp");
	self takeWeapon("webley_mp");
	self takeWeapon("deagle_mp");
	
	pistoltype="";
	switch(self.pistoll)
	{
		case "1": {pistoltype="colt_mp";break;}
		case "2": {pistoltype="luger_mp";break;}
		case "3": {pistoltype="TT30_mp";break;}
		case "4": {pistoltype="webley_mp";break;}
		case "5": {pistoltype="deagle_mp";break;}
	}
	self setWeaponSlotWeapon("primaryb", pistoltype);
	self giveStartAmmo(pistoltype);
}

givePrimary()
{
	self takeWeapon("bren_mp");
	self takeWeapon("kar98k_mp");
	self takeWeapon("kar98k_sniper_mp");
	self takeWeapon("mp44_mp");
	self takeWeapon("ppsh_mp");
	self takeWeapon("shotgun_mp");
	self takeWeapon("springfield_mp");
	self takeWeapon("greasegun_mp");
	self takeWeapon("m1carbine_mp");
	self takeWeapon("m1garand_mp");
	self takeWeapon("thompson_mp");
	self takeWeapon("bar_mp");
	self takeWeapon("sten_mp");
	self takeWeapon("enfield_mp");
	self takeWeapon("enfield_scope_mp");
	self takeWeapon("PPS42_mp");
	self takeWeapon("mosin_nagant_mp");
	self takeWeapon("SVT40_mp");
	self takeWeapon("mosin_nagant_sniper_mp");
	self takeWeapon("mp40_mp");
	self takeWeapon("g43_mp");
	primarytype="";
	switch(self.primary)
	{
		case "1": {primarytype="bren_mp";break;}
		case "2": {primarytype="kar98k_mp";break;}
		case "3": {primarytype="kar98k_sniper_mp";break;}
		case "4": {primarytype="mp44_mp";break;}
		case "5": {primarytype="ppsh_mp";break;}
		case "6": {primarytype="shotgun_mp";break;}
		case "7": {primarytype="springfield_mp";break;}
		case "8": {primarytype="greasegun_mp";break;}
		case "9": {primarytype="m1carbine_mp";break;}
		case "10": {primarytype="m1garand_mp";break;}
		case "11": {primarytype="thompson_mp";break;}
		case "12": {primarytype="bar_mp";break;}
		case "13": {primarytype="sten_mp";break;}
		case "14": {primarytype="enfield_mp";break;}
		case "15": {primarytype="enfield_scope_mp";break;}
		case "16": {primarytype="PPS42_mp";break;}
		case "17": {primarytype="mosin_nagant_mp";break;}
		case "18": {primarytype="SVT40_mp";break;}
		case "19": {primarytype="mosin_nagant_sniper_mp";break;}
		case "20": {primarytype="mp40_mp";break;}
		case "21": {primarytype="g43_mp";break;}
	}
	self setWeaponSlotWeapon("primary", primarytype);
	self giveStartAmmo(primarytype);
}

giveGrenades()
{
	self takeWeapon("frag_grenade_american_mp");
	self takeWeapon("frag_grenade_british_mp");
	self takeWeapon("frag_grenade_russian_mp");
	self takeWeapon("frag_grenade_german_mp");
	grenadetype="";
	switch(self.grenade)
	{
		case "1": {grenadetype="frag_grenade_american_mp";break;}
		case "2": {grenadetype="frag_grenade_british_mp";break;}
		case "3": {grenadetype="frag_grenade_russian_mp";break;}
		case "4": {grenadetype="frag_grenade_german_mp";break;}
	}
	
	if(getcvarint("scr_allow_fraggrenades"))
	{
		fraggrenadecount=getWeaponBasedGrenadeCount(self.pers["weapon"]);
		if(fraggrenadecount)
		{
			self giveWeapon(grenadetype);
			self setWeaponClipAmmo(grenadetype, fraggrenadecount);
		}
	}
	self switchtooffhand(grenadetype);
}

giveBinoculars()
{
	self giveWeapon("binoculars_mp");
}

dropWeapon()
{
	current=self getcurrentweapon();
	if(current!="none")
	{
		weapon1=self getweaponslotweapon("primary");
		weapon2=self getweaponslotweapon("primaryb");

		if(current==weapon1)
			currentslot="primary";
		else
		{
			assert(current==weapon2);
			currentslot="primaryb";
		}

		clipsize=self getweaponslotclipammo(currentslot);
		reservesize=self getweaponslotammo(currentslot);

		if(clipsize || reservesize)
			self dropItem(current);
	}
}

dropOffhand()
{
	current=self getcurrentoffhand();
	if(current!="none")
	{
		ammosize=self getammocount(current);

		if(ammosize)
			self dropItem(current);
	}
}

getWeaponBasedGrenadeCount(weapon)
{
	switch(weapon)
	{
	case "springfield_mp":
	case "enfield_scope_mp":
	case "mosin_nagant_sniper_mp":
	case "kar98k_sniper_mp":
	case "enfield_mp":
	case "mosin_nagant_mp":
	case "kar98k_mp":
		return 50;
	case "m1carbine_mp":
	case "m1garand_mp":
	case "SVT40_mp":
	case "g43_mp":
	case "bar_mp":
	case "bren_mp":
	case "mp44_mp":
		return 50;
	default:
	case "thompson_mp":
	case "sten_mp":
	case "ppsh_mp":
	case "mp40_mp":
	case "PPS42_mp":
	case "shotgun_mp":
	case "greasegun_mp":
		return 50;
	}
}

getWeaponBasedSmokeGrenadeCount(weapon)
{
	switch(weapon)
	{
	case "thompson_mp":
	case "sten_mp":
	case "ppsh_mp":
	case "mp40_mp":
	case "PPS42_mp":
	case "shotgun_mp":
	case "greasegun_mp":
		return 0;
	case "m1carbine_mp":
	case "m1garand_mp":
	case "enfield_mp":
	case "mosin_nagant_mp":
	case "SVT40_mp":
	case "kar98k_mp":
	case "g43_mp":
	case "bar_mp":
	case "bren_mp":
	case "mp44_mp":
	case "springfield_mp":
	case "enfield_scope_mp":
	case "mosin_nagant_sniper_mp":
	case "kar98k_sniper_mp":
	default:
		return 0;
	}
}

getFragGrenadeCount()
{
	if(self.pers["team"]=="allies")
		grenadetype="frag_grenade_" + game["allies"] + "_mp";
	else
	{
		assert(self.pers["team"]=="axis");
		grenadetype="frag_grenade_" + game["axis"] + "_mp";
	}

	count=self getammocount(grenadetype);
	return count;
}

getSmokeGrenadeCount()
{
	if(self.pers["team"]=="allies")
		grenadetype="smoke_grenade_" + game["allies"] + "_mp";
	else
	{
		assert(self.pers["team"]=="axis");
		grenadetype="smoke_grenade_" + game["axis"] + "_mp";
	}

	count=self getammocount(grenadetype);
	return count;
}

isPistol(weapon)
{
	switch(weapon)
	{
	case "colt_mp":
	case "luger_mp":
	case "TT30_mp":
	case "webley_mp":
	case "deagle_mp":
		return true;
	default:
		return false;
	}
}

isMainWeapon(weapon)
{
	// Include any main weapons that can be picked up

	switch(weapon)
	{
	case "greasegun_mp":
	case "m1carbine_mp":
	case "m1garand_mp":
	case "thompson_mp":
	case "bar_mp":
	case "springfield_mp":
	case "sten_mp":
	case "enfield_mp":
	case "bren_mp":
	case "enfield_scope_mp":
	case "mosin_nagant_mp":
	case "SVT40_mp":
	case "PPS42_mp":
	case "ppsh_mp":
	case "mosin_nagant_sniper_mp":
	case "kar98k_mp":
	case "g43_mp":
	case "mp40_mp":
	case "mp44_mp":
	case "kar98k_sniper_mp":
	case "shotgun_mp":
		return true;
	default:
		return false;
	}
}

restrictWeaponByServerCvars(response)
{
	switch(response)
	{
	// American
	case "m1carbine_mp":
		if(!getcvarint("scr_allow_m1carbine"))
		{
			//self iprintln(&"MP_M1A1_CARBINE_IS_A_RESTRICTED");
			response="restricted";
		}
		break;

	case "m1garand_mp":
		if(!getcvarint("scr_allow_m1garand"))
		{
			//self iprintln(&"MP_M1_GARAND_IS_A_RESTRICTED");
			response="restricted";
		}
		break;

	case "thompson_mp":
		if(!getcvarint("scr_allow_thompson"))
		{
			//self iprintln(&"MP_THOMPSON_IS_A_RESTRICTED");
			response="restricted";
		}
		break;

	case "bar_mp":
		if(!getcvarint("scr_allow_bar"))
		{
			//self iprintln(&"MP_BAR_IS_A_RESTRICTED_WEAPON");
			response="restricted";
		}
		break;

	case "springfield_mp":
		if(!getcvarint("scr_allow_springfield"))
		{
			//self iprintln(&"MP_SPRINGFIELD_IS_A_RESTRICTED");
			response="restricted";
		}
		break;

	case "greasegun_mp":
		if(!getcvarint("scr_allow_greasegun"))
		{
			//self iprintln(&"MP_GREASEGUN_IS_A_RESTRICTED");
			response="restricted";
		}
		break;

	case "shotgun_mp":
		if(!getcvarint("scr_allow_shotgun"))
		{
			//self iprintln(&"MP_SHOTGUN_IS_A_RESTRICTED");
			response="restricted";
		}
		break;

	// British
	case "enfield_mp":
		if(!getcvarint("scr_allow_enfield"))
		{
			//self iprintln(&"MP_LEEENFIELD_IS_A_RESTRICTED");
			response="restricted";
		}
		break;

	case "sten_mp":
		if(!getcvarint("scr_allow_sten"))
		{
			//self iprintln(&"MP_STEN_IS_A_RESTRICTED");
			response="restricted";
		}
		break;

	case "bren_mp":
		if(!getcvarint("scr_allow_bren"))
		{
			//self iprintln(&"MP_BREN_LMG_IS_A_RESTRICTED");
			response="restricted";
		}
		break;

	case "enfield_scope_mp":
		if(!getcvarint("scr_allow_enfieldsniper"))
		{
			//self iprintln(&"MP_BREN_LMG_IS_A_RESTRICTED");
			response="restricted";
		}
		break;

	// Russian
	case "mosin_nagant_mp":
		if(!getcvarint("scr_allow_nagant"))
		{
			//self iprintln(&"MP_MOSINNAGANT_IS_A_RESTRICTED");
			response="restricted";
		}
		break;

	case "SVT40_mp":
		if(!getcvarint("scr_allow_svt40"))
		{
			//self iprintln(&"MP_MOSINNAGANT_IS_A_RESTRICTED");
			response="restricted";
		}
		break;

	case "PPS42_mp":
		if(!getcvarint("scr_allow_pps42"))
		{
			//self iprintln(&"MP_PPSH_IS_A_RESTRICTED");
			response="restricted";
		}
		break;

	case "ppsh_mp":
		if(!getcvarint("scr_allow_ppsh"))
		{
			//self iprintln(&"MP_PPSH_IS_A_RESTRICTED");
			response="restricted";
		}
		break;

	case "mosin_nagant_sniper_mp":
		if(!getcvarint("scr_allow_nagantsniper"))
		{
			//self iprintln(&"MP_SCOPED_MOSINNAGANT_IS");
			response="restricted";
		}
		break;

	// German
	case "kar98k_mp":
		if(!getcvarint("scr_allow_kar98k"))
		{
			//self iprintln(&"MP_KAR98K_IS_A_RESTRICTED");
			response="restricted";
		}
		break;

	case "g43_mp":
		if(!getcvarint("scr_allow_g43"))
		{
			//self iprintln(&"MP_KAR98K_IS_A_RESTRICTED");
			response="restricted";
		}
		break;

	case "mp40_mp":
		if(!getcvarint("scr_allow_mp40"))
		{
			//self iprintln(&"MP_MP40_IS_A_RESTRICTED");
			response="restricted";
		}
		break;

	case "mp44_mp":
		if(!getcvarint("scr_allow_mp44"))
		{
			//self iprintln(&"MP_MP44_IS_A_RESTRICTED");
			response="restricted";
		}
		break;

	case "kar98k_sniper_mp":
		if(!getcvarint("scr_allow_kar98ksniper"))
		{
			//self iprintln(&"MP_SCOPED_KAR98K_IS_A_RESTRICTED");
			response="restricted";
		}
		break;

	case "fraggrenade":
		if(!getcvarint("scr_allow_fraggrenades"))
		{
			//self iprintln("Frag grenades are restricted");
			response="restricted";
		}
		break;

	case "smokegrenade":
		if(!getcvarint("scr_allow_smokegrenades"))
		{
			//self iprintln("Smoke grenades are restricted");
			response="restricted";
		}
		break;

	default:
		//self iprintln(&"MP_UNKNOWN_WEAPON_SELECTED");
		response="restricted";
		break;
	}

	return response;
}

// TODO: This doesn't handle offhands
watchWeaponUsage()
{
	self endon("spawned_player");
	self endon("disconnect");

	self.usedweapons=false;

	while(self attackButtonPressed())
		wait .05;

	while(!(self attackButtonPressed()))
		wait .05;

	self.usedweapons=true;
}

getWeaponName(weapon)
{
	switch(weapon)
	{
	// American
	case "m1carbine_mp":
		weaponname=&"WEAPON_M1A1CARBINE";
		break;

	case "m1garand_mp":
		weaponname=&"WEAPON_M1GARAND";
		break;

	case "thompson_mp":
		weaponname=&"WEAPON_THOMPSON";
		break;

	case "bar_mp":
		weaponname=&"WEAPON_BAR";
		break;

	case "springfield_mp":
		weaponname=&"WEAPON_SPRINGFIELD";
		break;

	case "greasegun_mp":
		weaponname=&"WEAPON_GREASEGUN";
		break;

	case "shotgun_mp":
		weaponname=&"WEAPON_SHOTGUN";
		break;

	// British
	case "enfield_mp":
		weaponname=&"WEAPON_LEEENFIELD";
		break;

	case "sten_mp":
		weaponname=&"WEAPON_STEN";
		break;

	case "bren_mp":
		weaponname=&"WEAPON_BREN";
		break;

	case "enfield_scope_mp":
		weaponname=&"WEAPON_SCOPEDLEEENFIELD";
		break;

	// Russian
	case "mosin_nagant_mp":
		weaponname=&"WEAPON_MOSINNAGANT";
		break;

	case "SVT40_mp":
		weaponname=&"WEAPON_SVT40";
		break;

	case "PPS42_mp":
		weaponname=&"WEAPON_PPS42";
		break;

	case "ppsh_mp":
		weaponname=&"WEAPON_PPSH";
		break;

	case "mosin_nagant_sniper_mp":
		weaponname=&"WEAPON_SCOPEDMOSINNAGANT";
		break;

	//German
	case "kar98k_mp":
		weaponname=&"WEAPON_KAR98K";
		break;

	case "g43_mp":
		weaponname=&"WEAPON_G43";
		break;

	case "mp40_mp":
		weaponname=&"WEAPON_MP40";
		break;

	case "mp44_mp":
		weaponname=&"WEAPON_MP44";
		break;

	case "kar98k_sniper_mp":
		weaponname=&"WEAPON_SCOPEDKAR98K";
		break;

	default:
		weaponname=&"WEAPON_UNKNOWNWEAPON";
		break;
	}

	return weaponname;
}

useAn(weapon)
{
	switch(weapon)
	{
	case "m1carbine_mp":
	case "m1garand_mp":
	case "mp40_mp":
	case "mp44_mp":
	case "shotgun_mp":
		result=true;
		break;

	default:
		result=false;
		break;
	}

	return result;
}

updateAllowed()
{
	for(i=0; i < level.weaponnames.size; i++)
	{
		weaponname=level.weaponnames[i];

		cvarvalue=getCvarInt(level.weapons[weaponname].server_allowcvar);
		if(level.weapons[weaponname].allow!=cvarvalue)
		{
			level.weapons[weaponname].allow=cvarvalue;

			thread updateAllowedAllClients(weaponname);
		}
	}
}

updateAllowedAllClients(weaponname)
{
	players=getentarray("player", "classname");
	for(i=0; i < players.size; i++)
		players[i] updateAllowedSingleClient(weaponname);
}

updateAllowedSingleClient(weaponname)
{
	self setClientCvar(level.weapons[weaponname].client_allowcvar, level.weapons[weaponname].allow);
}


updateAllAllowedSingleClient()
{
	for(i=0; i < level.weaponnames.size; i++)
	{
		weaponname=level.weaponnames[i];
		self updateAllowedSingleClient(weaponname);
	}
}
