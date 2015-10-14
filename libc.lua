-- libc.lua
local ffi = require("ffi")
local bit = require("bit")
local lshift, rshift = bit.lshift, bit.rshift;

ffi.cdef[[
typedef long ssize_t;


typedef struct timeval {
  long tv_sec;
  long tv_usec;
} timeval;
]]

-- const uint16_t x
local function bswap_16(x)
	x = band(x, 0xffff);
	return bor(lshift(x, 8), rshift(x, 8));
end

local function libusb_cpu_to_le16(x)
	return bswap_16(x);
end


local function libusb_cpu_to_le16(x)
	if ffi.abi("le") then
		return x;
	end

	return bswap_16(x);
end

local function safestring(str, default)
	if str == nil then 
		return default;
	end

	return ffi.string(str)
end


local exports = {
	libusb_le16_to_cpu = libusb_cpu_to_le16;	

	safestring = safestring;
}

return exports
