
if ( SERVER_DLL )
	return;

local Entities = Entities, EntIndexToHScript = EntIndexToHScript;

local m_nRefs = 0;
local m_CombineBalls = [];

local Think = function(_)
{
	foreach ( i in m_CombineBalls )
	{
		local entity = EntIndexToHScript(i);
		if ( entity )
		{
			effects.DynamicLight( 0x10000000+i, entity.GetOrigin(), 0xbb, 0xfa, 0xfa, 2, 256.0, 0.1, 1024.0, 0, 0 );
		}
	}
	return 0.0;
}

Hooks.Add( this, "OnEntityCreated", function(entity)
{
	if ( entity.GetClassname() == PROP_COMBINEBALL_CLASSNAME )
	{
		m_CombineBalls.push( entity.entindex() );

		if ( ++m_nRefs == 1 )
		{
			Entities.First().SetContextThink( "CombineBall_DLight", Think, 0.01 );
		}
	}
}, "CombineBall_DLight" )

Hooks.Add( this, "OnEntityDeleted", function(entity)
{
	local x = m_CombineBalls.find( entity.entindex() );
	if ( x != null )
	{
		if ( --m_nRefs == 0 )
		{
			Entities.First().SetContextThink( "CombineBall_DLight", null, 0.0 );
			m_CombineBalls.clear();
		}
		else
		{
			m_CombineBalls[x] = -1;
		}
	}
}, "CombineBall_DLight" )

Entities.EnableEntityListening();
