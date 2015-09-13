package.path = package.path..";../?.lua"

local libusb = require("libusb")
local lib = libusb.Lib_libusb;

local function getversion()
  local v = lib.libusb_get_version()
  return v.major, v.minor, v.micro, v.nano
end

print("Version: ", getversion())

--local st, major = pcall(getversion)
--print(st, major)