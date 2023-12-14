if (CLIENT_DLL) {printl("[VScript]Dynamic Light for Weapons & NPCs (by Hds46) initialized")}
if ( CLIENT_DLL )
{
	local nnumber = 0
	local nnumber2 = 0
	NetMsg.Receive( "CLMuzzleflash", function()
	{
		local ply = NetMsg.ReadEntity()
		local pos = NetMsg.ReadVec3Coord()
		local size = NetMsg.ReadFloat()
		local dltime = NetMsg.ReadFloat()
		local fade = NetMsg.ReadFloat()
		local brightness = NetMsg.ReadInt(32)
		nnumber = nnumber + 1
		effects.DynamicLight( 1512987542 + nnumber, pos, 255, 192, 64, brightness, size, dltime, fade, 0, 0 );
	} )
	
	NetMsg.Receive( "CLMuzzleflashAR2", function()
	{
		local ply = NetMsg.ReadEntity()
		local pos = NetMsg.ReadVec3Coord()
		local size = NetMsg.ReadFloat()
		local dltime = NetMsg.ReadFloat()
		local fade = NetMsg.ReadFloat()
		local brightness = NetMsg.ReadInt(32)
		nnumber2 = nnumber2 + 1
		effects.DynamicLight( 1112987542 + nnumber2, pos, 95, 125, 212, brightness, size, dltime, fade, 0, 0 );
	} )
	
}

local canmuzzle = true
local canmuzzlenpc = true
local nextattackmuzzle = 0
local WeaponsWhiteList = function(ent)
{
	if (ent.GetClassname() == "weapon_pistol" ||
	ent.GetClassname() == "weapon_357" ||
	ent.GetClassname() == "weapon_alyxgun" ||
	ent.GetClassname() == "weapon_smg1" ||
	ent.GetClassname() == "weapon_shotgun" ||
	ent.GetClassname() == "weapon_arbeit_pistol" ||
	ent.GetClassname() == "weapon_arbeit_shotgun" ||
	ent.GetClassname() == "weapon_annabelle" ||
	ent.GetClassname() == "weapon_smg2" ||
	ent.GetClassname() == "weapon_rpg")
	{
	return true
	}
}

local WeaponsWhiteListAR2 = function(ent)
{
	if (ent.GetClassname() == "weapon_ar2" ||
	ent.GetClassname() == "weapon_ar2_proto" ||
	ent.GetClassname() == "weapon_pulsepistol" ||
	ent.GetClassname() == "weapon_sniperrifle")
	{
	return true
	}
}


local GetActAnim = function(ent)
{
	if (ent.GetSequenceActivityName(ent.GetSequence()) == "ACT_VM_PRIMARYATTACK" ||
	ent.GetSequenceActivityName(ent.GetSequence()) == "ACT_VM_SECONDARYATTACK" ||
	ent.GetSequenceActivityName(ent.GetSequence()) == "ACT_VM_RECOIL1" ||
	ent.GetSequenceActivityName(ent.GetSequence()) == "ACT_VM_RECOIL2" ||
	ent.GetSequenceActivityName(ent.GetSequence()) == "ACT_VM_RECOIL3")
	{
	return true
	}
}

local DetectWeaponFire = function(ent)
{
	if (ent == null)
	{
	return false
	}
	local findent3
	while ((findent3 = Entities.FindByClassname(findent3,"prop_vehicle_drivable_apc")))
	if (findent3 != null && findent3.GetScriptScope() == null)
	{
	printl("scope retrieved")
	findent3.GetOrCreatePrivateScriptScope()
	}
	if (ent.GetActiveWeapon() != null && GetActAnim(ent.GetActiveWeapon()) && !(ent.GetActiveWeapon().NextPrimaryAttack() <= Time()) && canmuzzle)
	{
	if (WeaponsWhiteList(ent.GetActiveWeapon()))
	{
	NetMsg.Start("CLMuzzleflash")
	NetMsg.WriteEntity( ent )
	if (ent.GetActiveWeapon().GetClassname() == "weapon_357")
	{
	NetMsg.WriteVec3Coord( ent.ShootPosition() + ent.GetAutoaimVector(AUTOAIM_SCALE_DEFAULT)*20 )
	NetMsg.WriteFloat( 500.0 )
	NetMsg.WriteFloat( 0.2 )
	NetMsg.WriteFloat( 3000.0 )
	NetMsg.WriteInt( 4, 32 )
	}
	else if (ent.GetActiveWeapon().GetClassname() == "weapon_shotgun")
	{
	NetMsg.WriteVec3Coord( ent.ShootPosition() + ent.GetAutoaimVector(AUTOAIM_SCALE_DEFAULT)*23 )
	NetMsg.WriteFloat( 500.0 )
	NetMsg.WriteFloat( 0.2 )
	NetMsg.WriteFloat( 3000.0 )
	NetMsg.WriteInt( 4, 32 )
	}
	else if (ent.GetActiveWeapon().GetClassname() == "weapon_annabelle")
	{
	NetMsg.WriteVec3Coord( ent.ShootPosition() + ent.GetAutoaimVector(AUTOAIM_SCALE_DEFAULT)*26 )
	NetMsg.WriteFloat( 500.0 )
	NetMsg.WriteFloat( 0.2 )
	NetMsg.WriteFloat( 3000.0 )
	NetMsg.WriteInt( 4, 32 )
	}
	else if (ent.GetActiveWeapon().GetClassname() == "weapon_rpg")
	{
	NetMsg.WriteVec3Coord( ent.ShootPosition() + ent.GetAutoaimVector(AUTOAIM_SCALE_DEFAULT)*26 )
	NetMsg.WriteFloat( 600.0 )
	NetMsg.WriteFloat( 0.2 )
	NetMsg.WriteFloat( 3000.0 )
	NetMsg.WriteInt( 5, 32 )
	}
	else
	{
	NetMsg.WriteVec3Coord( ent.ShootPosition() + ent.GetAutoaimVector(AUTOAIM_SCALE_DEFAULT)*23 )
	NetMsg.WriteFloat( 400.0 )
	NetMsg.WriteFloat( 0.2 )
	NetMsg.WriteFloat( 2500.0 )
	NetMsg.WriteInt( 3, 32 )
	}
	NetMsg.Send( ent, false )
	}
	if (WeaponsWhiteListAR2(ent.GetActiveWeapon()))
	{
	NetMsg.Start("CLMuzzleflashAR2")
	NetMsg.WriteEntity( ent )
	if (ent.GetActiveWeapon().GetClassname() == "weapon_sniperrifle")
	{
	NetMsg.WriteVec3Coord( ent.ShootPosition() + ent.GetAutoaimVector(AUTOAIM_SCALE_DEFAULT)*26 )
	NetMsg.WriteFloat( 500.0 )
	NetMsg.WriteFloat( 0.2 )
	NetMsg.WriteFloat( 3000.0 )
	NetMsg.WriteInt( 3, 32 )
	}
	else
	{
	NetMsg.WriteVec3Coord( ent.ShootPosition() + ent.GetAutoaimVector(AUTOAIM_SCALE_DEFAULT)*20 )
	NetMsg.WriteFloat( 400.0 )
	NetMsg.WriteFloat( 0.2 )
	NetMsg.WriteFloat( 2500.0 )
	NetMsg.WriteInt( 3, 32 )
	}
	NetMsg.Send( player, false )
	}
	canmuzzle = false
	}
	if (ent.GetActiveWeapon() != null && (GetActAnim(ent.GetActiveWeapon()) != true || ent.GetActiveWeapon().NextPrimaryAttack() <= Time()) && !canmuzzle)
	{
	canmuzzle = true
	}

	return 0
}

local WeaponsWhiteListNPC = function(ent)
{
	if (ent.GetClassname() == "weapon_pistol" ||
	ent.GetClassname() == "weapon_alyxgun" ||
	ent.GetClassname() == "weapon_smg1" ||
	ent.GetClassname() == "weapon_smg2" ||
	ent.GetClassname() == "weapon_357" ||
	ent.GetClassname() == "weapon_arbeit_pistol" ||
	ent.GetClassname() == "weapon_arbeit_shotgun" ||
	ent.GetClassname() == "weapon_shotgun" ||
	ent.GetClassname() == "weapon_annabelle" ||
	ent.GetClassname() == "weapon_rpg" ||
	ent.GetClassname() == "weapon_css_glock")
	{
	return true
	}
}

local GetActAnimNPC = function(ent)
{
	if (ent.GetSequenceActivityName(ent.GetSequence()) == "ACT_RANGE_ATTACK_PISTOL" ||
	ent.GetSequenceActivityName(ent.GetSequence()) == "ACT_RANGE_ATTACK_SMG1" ||
	ent.GetSequenceActivityName(ent.GetSequence()) == "ACT_RANGE_ATTACK_SHOTGUN")
	{
	return true
	}
}
local idxarray = []
idxarray.resize(99999)
local DetectWeaponFireNPC = function(ent)
{
	if (ent == null)
	{
	return false
	}
	if (ent.GetClassname() == "prop_dynamic" && ent.GetSequenceName(ent.GetSequence())=="fire" && ent.GetCycle() == 0)
	{
	NetMsg.Start("CLMuzzleflashAR2")
	NetMsg.WriteEntity( ent )
	NetMsg.WriteVec3Coord( ent.GetAttachmentOrigin(1) )
	NetMsg.WriteFloat( 500.0 )
	NetMsg.WriteFloat( 0.2 )
	NetMsg.WriteFloat( 2500.0 )
	NetMsg.WriteInt( 3, 32 )
	NetMsg.Send( player, false )
	}
	if (ent.IsNPC())
	{
	if (!(ent.GetLastAttackTime() < Time() - 0.05) && ent.GetSequenceActivityName(ent.GetSequence()) != "ACT_IDLE_MANNEDGUN" && ent.GetSequenceActivityName(ent.GetSequence()) != "ACT_MELEE_ATTACK1" && ent.GetSequenceActivityName(ent.GetSequence()) != "ACT_TRANSITION")
	{
	if (ent.GetActiveWeapon() != null && WeaponsWhiteListNPC(ent.GetActiveWeapon()))
	{
	NetMsg.Start("CLMuzzleflash")
	NetMsg.WriteEntity( ent )
	NetMsg.WriteVec3Coord( ent.GetActiveWeapon().GetAttachmentOrigin(1) )
	NetMsg.WriteFloat( 400.0 )
	NetMsg.WriteFloat( 0.2 )
	NetMsg.WriteFloat( 2500.0 )
	NetMsg.WriteInt( 3, 32 )
	NetMsg.Send( player, false )
	printl(ent.GetSequenceActivityName(ent.GetSequence()))
	}
	else if (ent.GetActiveWeapon() != null && WeaponsWhiteListAR2(ent.GetActiveWeapon()))
	{
	NetMsg.Start("CLMuzzleflashAR2")
	NetMsg.WriteEntity( ent )
	NetMsg.WriteVec3Coord( ent.GetActiveWeapon().GetAttachmentOrigin(1) )
	NetMsg.WriteFloat( 400.0 )
	NetMsg.WriteFloat( 0.2 )
	NetMsg.WriteFloat( 2500.0 )
	NetMsg.WriteInt( 3, 32 )
	NetMsg.Send( player, false )
	}
	}
	if (ent.GetClassname() == "npc_turret_floor")
	{
	if (idxarray[ent.entindex()] == null)
	{
	idxarray.insert(ent.entindex(), 0)
	}
	}
	if ((ent.GetClassname() == "npc_turret_floor" || ent.GetClassname() == "npc_arbeit_turret_floor") && ent.GetSequenceActivityName(ent.GetSequence())=="ACT_FLOOR_TURRET_FIRE" && (ent.GetCycle() == 0 && idxarray[ent.entindex()] < Time()) && canmuzzlenpc)
	{
	NetMsg.Start("CLMuzzleflashAR2")
	NetMsg.WriteEntity( ent )
	NetMsg.WriteVec3Coord( ent.GetAttachmentOrigin(1) )
	NetMsg.WriteFloat( 400.0 )
	NetMsg.WriteFloat( 0.2 )
	NetMsg.WriteFloat( 2500.0 )
	NetMsg.WriteInt( 3, 32 )
	NetMsg.Send( player, false )
	canmuzzlenpc = false
	idxarray[ent.entindex()] = Time() + 0.1
	}
	if ((ent.GetClassname() == "npc_turret_floor" || ent.GetClassname() == "npc_arbeit_turret_floor") && (ent.GetSequenceActivityName(ent.GetSequence())!="ACT_FLOOR_TURRET_FIRE" || !(ent.GetCycle() == 0 && idxarray[ent.entindex()] < Time())) && !canmuzzlenpc)
	{
	canmuzzlenpc = true
	}
	}
	
	return 0
}

local ScriptInit = function(ent)
{
	player.SetContextThink( "UpdateThink", DetectWeaponFire, 0 )
	SendToConsole("muzzleflash_light  0")
}

ListenToGameEvent( "player_spawn", ScriptInit, "" );

Hooks.Add( this, "OnEntitySpawned", function(ent)
{
	if (ent.IsNPC() || (ent.GetClassname() == "prop_dynamic" && ent.GetModelName() == "models/props_combine/bunker_gun01.mdl"))
	{
	ent.SetContextThink( "UpdateThink", DetectWeaponFireNPC, 0 )
	}
	if (ent.GetClassname() == "npc_hunter" || ent.GetClassname() == "prop_vehicle_drivable_apc")
	{
	ent.GetOrCreatePrivateScriptScope()
	}
}, "FP_HookSpawn" );

function ModifyEmitSoundParams()
{
	if (SERVER_DLL && self.GetClassname() == "prop_vehicle_drivable_apc" && params.GetSoundName() == "Weapon_AR2.Single")
	{
	NetMsg.Start("CLMuzzleflashAR2")
	NetMsg.WriteEntity( self )
	NetMsg.WriteVec3Coord( self.GetAttachmentOrigin(self.LookupAttachment("muzzle")) )
	NetMsg.WriteFloat( 400.0 )
	NetMsg.WriteFloat( 0.17 )
	NetMsg.WriteFloat( 1500.0 )
	NetMsg.WriteInt( 4, 32 )
	NetMsg.Send( player, false )
	}
	if (SERVER_DLL && self.GetClassname() == "prop_vehicle_drivable_apc" && params.GetSoundName() == "PropAPC.FireRocket")
	{
	NetMsg.Start("CLMuzzleflash")
	NetMsg.WriteEntity( self )
	NetMsg.WriteVec3Coord( self.GetAttachmentOrigin(self.LookupAttachment("cannon_muzzle")) )
	NetMsg.WriteFloat( 500.0 )
	NetMsg.WriteFloat( 0.2 )
	NetMsg.WriteFloat( 2000.0 )
	NetMsg.WriteInt( 5, 32 )
	NetMsg.Send( player, false )
	}
	if (SERVER_DLL && self.GetClassname() == "npc_hunter" && params.GetSoundName() == "NPC_Hunter.FlechetteShoot")
	{
	NetMsg.Start("CLMuzzleflashAR2")
	NetMsg.WriteEntity( self )
	NetMsg.WriteVec3Coord( self.EyePosition() + self.EyeDirection3D()*30 )
	NetMsg.WriteFloat( 600.0 )
	NetMsg.WriteFloat( 0.2 )
	NetMsg.WriteFloat( 2500.0 )
	NetMsg.WriteInt( 3, 32 )
	NetMsg.Send( player, false )
	}
}

Hooks.Add( this, "OnRestore", function()
{
	player.SetContextThink( "UpdateThink", DetectWeaponFire, 0 )
	local findent
	while ((findent = Entities.FindByClassname(findent,"npc_*")))
	if (findent != null && findent.IsNPC())
	{
	findent.SetContextThink( "UpdateThink", DetectWeaponFireNPC, 0 )
	if (findent.GetClassname() == "npc_hunter")
	{
	findent.GetOrCreatePrivateScriptScope()
	}
	}
	local findent2
	while ((findent2 = Entities.FindByClassname(findent2,"prop_dynamic")))
	if (findent2 != null && findent2.GetModelName() == "models/props_combine/bunker_gun01.mdl")
	{
	findent.SetContextThink( "UpdateThink", DetectWeaponFireNPC, 0 )
	}
	local findent3
	while ((findent3 = Entities.FindByClassname(findent3,"prop_vehicle_drivable_apc")))
	if (findent3 != null)
	{
	findent3.GetOrCreatePrivateScriptScope()
	}
}, "FP_HookRestoreWD" );
