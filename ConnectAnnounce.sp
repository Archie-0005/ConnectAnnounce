#include <sourcemod>
#include <geoip>
#include <multicolors>

#pragma newdecls required

ConVar h_connectmsg;
ConVar h_countrymsg;
ConVar h_admintagmsg;

public Plugin myinfo = 
{
	name = "Connect Announce Manager", 
	author = "Archie", 
	description = "Player connect announce management", 
	version = "1.0", 
	url = ""
}

public void OnPluginStart()
{
	h_connectmsg = CreateConVar("sm_connectmsg", "1", "Shows connecting messages", FCVAR_DONTRECORD, true, 0.0, true, 1.0);
	h_countrymsg = CreateConVar("sm_countrymsg", "1", "Shows the country  messages", FCVAR_DONTRECORD, true, 0.0, true, 1.0);
	h_admintagmsg = CreateConVar("sm_admintagmsg", "1", "Shows admin/vip messages", FCVAR_DONTRECORD, true, 0.0, true, 1.0);
}

public void OnClientPostAdminCheck(int client)
{
	if (h_connectmsg.BoolValue)
	{
		char authid[64], IP[16], Country[46];
		GetClientAuthId(client, AuthId_Steam2, authid, sizeof(authid));
		
		GetClientIP(client, IP, sizeof(IP), true);
		
		if(GetClientIP(client, IP, sizeof(IP)) && GeoipCountry(IP, Country, sizeof(Country)))
		
		{
			if (h_admintagmsg.IntValue == 1)
			{
				if (IsPlayerGenericAdmin(client))
				{
					if (h_countrymsg.IntValue == 1)
					CPrintToChatAll("{white}Admin {green}%N [{lightgreen}%s{green}] connected from %s.", client, authid, Country);
					else CPrintToChatAll("{white}Admin %N {green}[{lightgreen}%s{green}] connected.", client, authid);
				}
				else if (IsPlayerCustom1Admin(client))
				{
					if (h_countrymsg.IntValue == 1)
					CPrintToChatAll("{white}VIP {green}%N [{lightgreen}%s{green}] connected from %s.", client, authid, Country);
					else CPrintToChatAll("{white}VIP {green}%N [{lightgreen}%s{green}] connected.", client, authid);
				}
				else
				{
					if (h_countrymsg.IntValue == 1)
					CPrintToChatAll("{white}Player {green}%N [{lightgreen}%s{green}] connected from %s.", client, authid, Country);
					else CPrintToChatAll("{white}Player {green}%N [{lightgreen}%s{green}] connected.", client, authid);
				}
			}
		}
	}
}

bool IsPlayerGenericAdmin(int client)
{
	return ((GetUserFlagBits(client) & ADMFLAG_GENERIC) > 0);
}

bool IsPlayerCustom1Admin(int client)
{
	return ((GetUserFlagBits(client) & ADMFLAG_CUSTOM1) > 0);
} 