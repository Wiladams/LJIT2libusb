-- USBDevice.lua
--[[
	USBDevice represents an active USB device, it is obtained by calling
	libusb_open() on a device reference.  Therefore, it will actually be 
	active at the time of construction.

	But, as USB devices can be unplugged, this status may not stay true
	through the duration of the life of this object.
--]]

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

	return obj;
end

function USBDevice.new(self, handle)
	return self:init(handle);
end

function USBDevice.reset(self)
	return usb.libusb_reset_device(self.Handle) == 0;
end


return USBDevice;

