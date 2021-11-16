
// Gamemodes
const int GM_NONE = 0;				// If our gamemode wasn't found, or just dev_ maps
const int GM_ESCAPE = 1;			// Escape maps (ce_)
const int GM_EXTRACTION = 2;		// Extraction maps (cx_)
const int GM_FLATLINE = 3;			// Flatline maps (cf_)
const int GM_HUNTED = 4;			// Hunted maps (ch_)
const int GM_PANIC_OBJECTIVE = 5;	// Hunted maps (cpo_)
const int GM_PANIC_CLASSIC = 6;		// Hunted maps (cpc_)

// Our survivor team ID
const int TEAM_SURVIVORS = 2;

CBaseEntity@ ToBaseEntity( CTerrorPlayer@ pPlayer )
{
	CBasePlayer@ pBasePlayer = pPlayer.opCast();
	CBaseEntity@ pEntityPlayer = pBasePlayer.opCast();
	return pEntityPlayer;
}

void OnPluginInit()
{
	PluginData::SetVersion( "1.0" );
	PluginData::SetAuthor( "JonnyBoy0719" );
	PluginData::SetName( "Respawn System" );

	Events::ThePresident::OnNoSurvivorsRemaining.Hook( @OnNoSurvivorsRemaining_Respawn );
	Events::Player::OnPlayerKilledPost.Hook( @OnPlayerKilledPost_Respawn );
}

HookReturnCode OnNoSurvivorsRemaining_Respawn( int iCandidate )
{
	// If objective, then no game over
	if ( iCandidate == GM_ESCAPE ) return HOOK_HANDLED;
	return HOOK_CONTINUE;
}

HookReturnCode OnPlayerKilledPost_Respawn( CTerrorPlayer@ pPlayer )
{
	if ( pPlayer is null ) return HOOK_HANDLED;
	// Make sure our team is on survivors, and nothing else
	CBaseEntity @pBase = ToBaseEntity( pPlayer );
	pBase.ChangeTeam( TEAM_SURVIVORS );
	// Respawn the player
	pPlayer.Respawn();
	return HOOK_CONTINUE;
}