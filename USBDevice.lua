-- USBDevice.lua
--[[
	USBDevice represents an active USB device, it is obtained by calling
	libusb_open() on a device reference.  Therefore, it will actually be 
	active at the time of construction.

	But, as USB devices can be unplugged, this status may not stay true
	through the duration of the life of this object.
--]]

local ffi = require("ffi")
local libc = require("libc")
local usb = require("libusb")


local USBDevice = {}
setmetatable(USBDevice, {
	__call = function(self, ...)
		return self:new(...);
	end,
})
local USBDevice_mt = {
	__index = USBDevice;
}

function USBDevice.init(self, handle)
	local obj = {
		Handle = handle;
	}
	setmetatable(obj, USBDevice_mt)



	local devref = usb.libusb_get_device(handle);
	ffi.gc(devref, usb.libusb_unref_device);

	-- get configuration
	local desc = ffi.new("struct libusb_device_descriptor");
	local res = usb.libusb_get_device_descriptor(devref, desc);

	local data = ffi.new("unsigned char[256]")
	-- manufacturer
	local res = usb.libusb_get_string_descriptor_ascii(handle,	desc.iManufacturer, data, 256);
	obj.Manufacturer = libc.safestring(data)

	-- product
	data[0] = 0;
	local res = usb.libusb_get_string_descriptor_ascii(handle,	desc.iProduct, data, 256);
	obj.Product = libc.safestring(data)

	-- serial number
	data[0] = 0;
	local res = usb.libusb_get_string_descriptor_ascii(handle,	desc.iSerialNumber, data, 256);
	obj.SerialNumber = libc.safestring(data)


	return obj;
end

function USBDevice.new(self, handle)
	return self:init(handle);
end

function USBDevice.reset(self)
	return usb.libusb_reset_device(self.Handle) == 0;
end


return USBDevice;

