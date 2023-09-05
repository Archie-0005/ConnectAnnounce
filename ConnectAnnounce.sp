#pragma semicolon 1

#include <sourcemod>
#include <geoip>

#pragma newdecls required

public Plugin myinfo =
{
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
			PrintToChatAll("\x07FFFFFFAdmin \x04%N [\x03%s\x04] connected from \x03%s\x04.", client, sAuth, sCountry);
		else	
			PrintToChatAll("\x07FFFFFFAdmin \x04%N [\x03%s\x04] connected\x04.", client, sAuth);
	}
	else if(CheckCommandAccess(client, "Vip_connect", ADMFLAG_CUSTOM1, true))
	{
		if(GetClientIP(client, sIP, sizeof(sIP)) && GeoipCountry(sIP, sCountry, sizeof(sCountry)))
			PrintToChatAll("\x07FFFFFFVIP \x04%N [\x03%s\x04] connected from \x03%s\x04.", client, sAuth, sCountry);
		else	
			PrintToChatAll("\x07FFFFFFVIP \x04%N [\x03%s\x04] connected\x04.", client, sAuth);
	}
	else
	{
		if(GetClientIP(client, sIP, sizeof(sIP)) && GeoipCountry(sIP, sCountry, sizeof(sCountry)))
			PrintToChatAll("\x07FFFFFFPlayer \x04%N [\x03%s\x04] connected from \x03%s\x04.", client, sAuth, sCountry);
		else	
			PrintToChatAll("\x07FFFFFFPlayer \x04%N [\x03%s\x04] connected\x04.", client, sAuth);
	}
}

stock void Custom_PrintToChatAll(const char[] format, any ...) {
    Handle handle = StartMessageAll("SayText2");

    if (handle == null) return;
    if (GetUserMessageType() == UM_Protobuf) return;

    BfWrite bfWrite = UserMessageToBfWrite(handle);

    char buffer[512];
    VFormat(buffer, sizeof(buffer), format, 2);

    bfWrite.WriteByte(0);
    bfWrite.WriteByte(true);
    bfWrite.WriteString(buffer);
}
