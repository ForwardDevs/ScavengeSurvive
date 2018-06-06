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


static
Timer:	WelcomeMessageTimer[MAX_PLAYERS],
		WelcomeMessageCount[MAX_PLAYERS],
		CanLeaveWelcomeMessage[MAX_PLAYERS];


hook OnPlayerConnect(playerid) {
	CanLeaveWelcomeMessage[playerid] = true;
	return 1;
}

timer ShowWelcomeMessage[1000](playerid, count) {
	new
		str[509],
		button[7];

	strcat(str, "\n\n\n"C_WHITE"You have to fight to survive in an apocalyptic wasteland.\n\nYou will have a better chance in a group, but be careful who you trust.\n\nSupplies can be found scattered around, weapons are rare though.\n\n");
	strcat(str, "Avoid attacking unarmed players, they frighten easily but will return, and in greater numbers...\n\n\n\n\n"C_TEAL"Please take some time to look at the "C_BLUE"/rules "C_TEAL"and "C_BLUE"/help "C_TEAL"before diving into the game.\n\n\nVisit "C_YELLOW"scavenge-survive.wikia.com "C_TEAL"for more information.\n\n\n");

	if(count == 0) {
		button = "Accept";

		CanLeaveWelcomeMessage[playerid] = true;
	} else {
		valstr(button, count);
		count--;

		stop WelcomeMessageTimer[playerid];
		WelcomeMessageTimer[playerid] = defer ShowWelcomeMessage(playerid, count);

		CanLeaveWelcomeMessage[playerid] = false;
	}

	WelcomeMessageCount[playerid] = count;
	Dialog_Show(playerid, WelcomeMessage, DIALOG_STYLE_MSGBOX, "Welcome to the Server", str, button, "");

	return 1;
}

Dialog:WelcomeMessage(playerid, response, listitem, inputtext[]) {
	if(!CanLeaveWelcomeMessage[playerid]) {
		ShowWelcomeMessage(playerid, WelcomeMessageCount[playerid] + 1);
	}
}

stock CanPlayerLeaveWelcomeMessage(playerid) {
	if(!IsPlayerConnected(playerid)) {
		return 0;
	}

	return CanLeaveWelcomeMessage[playerid];
}
