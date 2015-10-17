--usb_errors.lua

local ErrorStrings = {
	[0] = "Success";
	[1] = "Input/Output Error";
	[2] = "Invalid parameter";
	[3] = "Access denied";
	[4] = "No such device";
	[5] = "Entity not found";
	[6] = "Resource busy";
	[7] = "Operation timed out";
	[8] = "Overflow";
	[9] = "Pipe error";
	[10] = "System call interrupted";
	[11] = "Insufficient memory";
	[12] = "Operation not supported or not implemented";
	[13] = "Other error";
}

return ErrorStrings
