/*==============================================================================


	Southclaws' Scavenge and Survive

		Copyright (C) 2017 Barnaby "Southclaws" Keene

		This program is free software: you can redistribute it and/or modify it
		under the terms of the GNU General Public License as published by the
		Free Software Foundation, either version 3 of the License, or (at your
		option) any later version.

		This program is distributed in the hope that it will be useful, but
		WITHOUT ANY WARRANTY; without even the implied warranty of
		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
		See the GNU General Public License for more details.

		You should have received a copy of the GNU General Public License along
		with this program.  If not, see <http://www.gnu.org/licenses/>.


==============================================================================*/


#include <YSI\y_hooks>





forward OnAccountResponse(data[]);
forward OnAccountCacheUpdate(name[]);




stock AccountIO_Create(name[], pass[], ipv4[], regdate, lastlog, hash[], callback[])
{
	if(isnull(name))
	{
		err("name is null");
		return 1;
	}

	return 0;
}

stock AccountIO_Load(playerid, callback[])
{
	if(!IsPlayerConnected(playerid))
	{
		err("player not connected");
		return 1;
	}

	if(isnull(callback))
	{
		err("callback is null");
		return 1;
	}

	ret += Redis_GetHashValue(gRedis, key, FIELD_PLAYER_PASS, passhash);
	ret += Redis_GetHashValue(gRedis, key, FIELD_PLAYER_ALIVE, alive_str);
	ret += Redis_GetHashValue(gRedis, key, FIELD_PLAYER_REGDATE, regdate_str);
	ret += Redis_GetHashValue(gRedis, key, FIELD_PLAYER_LASTLOG, lastlog_str);
	ret += Redis_GetHashValue(gRedis, key, FIELD_PLAYER_SPAWNTIME, spawntime_str);
	ret += Redis_GetHashValue(gRedis, key, FIELD_PLAYER_TOTALSPAWNS, spawns_str);
	ret += Redis_GetHashValue(gRedis, key, FIELD_PLAYER_WARNINGS, warnings_str);
	ret += Redis_GetHashValue(gRedis, key, FIELD_PLAYER_GPCI, gpci_str);
	ret += Redis_GetHashValue(gRedis, key, FIELD_PLAYER_ACTIVE, active_str);

	alive = !!strval(alive_str);
	regdate = strval(regdate_str);
	lastlog = strval(lastlog_str);
	spawntime = strval(spawntime_str);
	spawns = strval(spawns_str);
	warnings = strval(warnings_str);

	if(active_str[0] == '0')
	{
		log("[LoadAccount] %p (account inactive) Last login: %T", playerid, lastlog);
		CallLocalFunction(callback, "dd", playerid, ACCOUNT_LOAD_RESULT_EXIST_DA);
		return 2;
	}

	if(IsWhitelistActive())
	{
		ChatMsgLang(playerid, YELLOW, "WHITELISTAC");

		if(!IsPlayerInWhitelist(playerid))
		{
			ChatMsgLang(playerid, YELLOW, "WHITELISTNO");
			log("[LoadAccount] %p (account not whitelisted) Alive: %d Last login: %T", playerid, alive, lastlog);
			CallLocalFunction(callback, "dd", playerid, ACCOUNT_LOAD_RESULT_EXIST_WL);
			return 2;
		}
	}

	SetPlayerAliveState(playerid, alive);
	SetPlayerPassHash(playerid, passhash);
	SetPlayerRegTimestamp(playerid, regdate);
	SetPlayerLastLogin(playerid, lastlog);
	SetPlayerCreationTimestamp(playerid, spawntime);
	SetPlayerTotalSpawns(playerid, spawns);
	SetPlayerWarnings(playerid, warnings);

	log("[LoadAccount] %p (account exists, prompting login) Alive: %d Last login: %T", playerid, alive, lastlog);

	CallLocalFunction(callback, "dd", playerid, ACCOUNT_LOAD_RESULT_EXIST);

	return 0;
}

stock AccountIO_Get(name[], pass[], ipv4[], &alive, &regdate, &lastlog, &spawntime, &totalspawns, &warnings, hash[], &active, &banned, &admin, &whitelist, &reported)
{
	new
		key[MAX_PLAYER_NAME + 32],
		ret,
		str_alive[2],
		str_regdate[12],
		str_lastlog[12],
		str_spawntime[12],
		str_totalspawns[12],
		str_warnings[12],
		str_active[2],
		str_banned[2],
		str_admin[2],
		str_whitelist[2],
		str_reported[2];

	format(key, sizeof(key), REDIS_DOMAIN_ROOT"."REDIS_DOMAIN_ACCOUNTS".%s", name);

	ret = Redis_GetHashValue(gRedis, key, FIELD_PLAYER_PASS, pass, 128);
	ret = Redis_GetHashValue(gRedis, key, FIELD_PLAYER_IPV4, ipv4, 16);
	ret = Redis_GetHashValue(gRedis, key, FIELD_PLAYER_ALIVE, str_alive, sizeof(str_alive));
	ret = Redis_GetHashValue(gRedis, key, FIELD_PLAYER_REGDATE, str_regdate, sizeof(str_regdate));
	ret = Redis_GetHashValue(gRedis, key, FIELD_PLAYER_LASTLOG, str_lastlog, sizeof(str_lastlog));
	ret = Redis_GetHashValue(gRedis, key, FIELD_PLAYER_SPAWNTIME, str_spawntime, sizeof(str_spawntime));
	ret = Redis_GetHashValue(gRedis, key, FIELD_PLAYER_TOTALSPAWNS, str_totalspawns, sizeof(str_totalspawns));
	ret = Redis_GetHashValue(gRedis, key, FIELD_PLAYER_WARNINGS, str_warnings, sizeof(str_warnings));
	ret = Redis_GetHashValue(gRedis, key, FIELD_PLAYER_GPCI, hash, MAX_GPCI_LEN);
	ret = Redis_GetHashValue(gRedis, key, FIELD_PLAYER_ACTIVE, str_active, sizeof(str_active));
	ret = Redis_GetHashValue(gRedis, key, FIELD_PLAYER_BANNED, str_banned, sizeof(str_banned));
	ret = Redis_GetHashValue(gRedis, key, FIELD_PLAYER_ADMIN, str_admin, sizeof(str_admin));
	ret = Redis_GetHashValue(gRedis, key, FIELD_PLAYER_WHITELIST, str_whitelist, sizeof(str_whitelist));
	ret = Redis_GetHashValue(gRedis, key, FIELD_PLAYER_REPORTED, str_reported, sizeof(str_reported));

	alive = strval(str_alive);
	regdate = strval(str_regdate);
	lastlog = strval(str_lastlog);
	spawntime = strval(str_spawntime);
	totalspawns = strval(str_totalspawns);
	warnings = strval(str_warnings);
	active = strval(str_active);
	banned = strval(str_banned);
	admin = strval(str_admin);
	whitelist = strval(str_whitelist);
	reported = strval(str_reported);

	return ret;
}
