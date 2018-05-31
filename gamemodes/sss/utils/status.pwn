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


ParseStatus(Node:node, &bool:success, message[], len = sizeof message) {
    new ret;

    ret = JsonGetBool(node, "success", success);
    if(ret) {
        err("failed to access key 'success' in status node");
        return ret;
    }

    ret = JsonGetString(node, "message", message, len);
    if(ret) {
        err("failed to access key 'success' in status node");
        return ret;
    }

    return 0;
}