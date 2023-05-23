#pragma semicolon 1

#include <sourcemod>
#include <geoip>
#include <multicolors>

#pragma newdecls required

public Plugin myinfo = {
	name = "Connect Announce",
	author = "Archie",
	description = "Simple connect announce management",
	version = "1.0",
	url = "https://sourcemod.net/"
}

public void OnClientPostAdminCheck(int client)
{
	if(IsFakeClient(client))
		return;

	static char sAuth[32];
	static char sIP[16];
	static char sCountry[32];

	GetClientAuthId(client, AuthId_Steam2, sAuth, sizeof(sAuth));

	if(CheckCommandAccess(client, "Admin_connect", ADMFLAG_GENERIC, true))
	{
		if(GetClientIP(client, sIP, sizeof(sIP)) && GeoipCountry(sIP, sCountry, sizeof(sCountry)))
			CPrintToChatAll("{cyan}Admin {green}%N [{lightgreen}%s{green}] connected from {lightgreen)%s{green}.", client, sAuth, sCountry);
		else	
			CPrintToChatAll("{cyan}Admin {green}%N [{lightgreen}%s{green}] connected{green}.", client, sAuth);
	}
	if(CheckCommandAccess(client, "Vip_connect", ADMFLAG_CUSTOM1, true))
	{
		if(GetClientIP(client, sIP, sizeof(sIP)) && GeoipCountry(sIP, sCountry, sizeof(sCountry)))
			CPrintToChatAll("{cyan}VIP {green}%N [{lightgreen}%s{green}] connected from {lightgreen)%s{green}.", client, sAuth, sCountry);
		else	
			CPrintToChatAll("{cyan}VIP {green}%N [{lightgreen}%s{green}] connected{green}.", client, sAuth);
	}
	else
	{
		if(GetClientIP(client, sIP, sizeof(sIP)) && GeoipCountry(sIP, sCountry, sizeof(sCountry)))
			CPrintToChatAll("{cyan}Player {green}%N [{lightgreen}%s{green}] connected from {lightgreen)%s{green}.", client, sAuth, sCountry);
		else	
			CPrintToChatAll("{cyan}Player {green}%N [{lightgreen}%s{green}] connected{green}.", client, sAuth);
	}
}
