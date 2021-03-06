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


// ParseStatus extracts success and message from SSC success responses:
//
// {
//     "result": {...},
//     "success": false,
//     "message": "error message"
// }
//
Error:ParseStatus(Node:node, &bool:success, &Node:result, message[], len = sizeof message) {
	new ret;

	ret = JsonGetBool(node, "success", success);
	if(ret) {
		return Error(1, "failed to access key 'success' in status node");
	}

	ret = JsonGetString(node, "message", message, len);
	// if(ret) {
	//     err("failed to access key 'message' in status node");
	//     return ret;
	// }

	ret = JsonGetObject(node, "result", result);
	if(ret) {
		result = Node:-1;
	}

	return NoError();
}
