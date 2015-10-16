-- USBDeviceReference.lua
--[[
	The USBDeviceReference represents a reference to a USB device...
	That is, the device was attached to the system at some point, but 
	whether or not is accessible at the moment is not assured.

	From the reference you can get some basic information, such as a 
	description of the device.

	Most importantly, you can get a handle on something you can actually
	use to read and write from using: getActiveDevice()
--]]
local ffi = require("ffi")
local usb = require("libusb")

local USBDevice = require("USBDevice")



local USBDeviceReference = {}
setmetatable(USBDeviceReference, {
	__call = function (self, ...)
		return self:new(...);
	end
})

local USBDeviceReference_mt = {
	__index = USBDeviceReference;
}

function USBDeviceReference.init(self, devHandle)
	-- get the device descriptor
	local desc = ffi.new("struct libusb_device_descriptor");
	local res = usb.libusb_get_device_descriptor(devHandle, desc);

	local configdesc = ffi.new("struct libusb_config_descriptor *[1]")
	local configres = usb.libusb_get_active_config_descriptor(devHandle, configdesc);
	if configres ~= 0 then
		return nil, "libusb_get_active_conifig_descriptor(), failed"
	end
	configdesc = configdesc[0];
	ffi.gc(configdesc, usb.libusb_free_config_descriptor);


	local obj = {
		Handle = devHandle;

		-- Some raw data structures
		Description = desc;
		ActiveConfig = configdesc;


		-- Device class information
		Class = tonumber(desc.bDeviceClass);
		Subclass = tonumber(desc.bDeviceSubClass);
		Protocol = tonumber(desc.bDeviceProtocol);
		ClassDescription = usb.lookupClassDescriptor(desc.bDeviceClass,
			desc.bDeviceSubClass,
			desc.bDeviceProtocol);

	}
	setmetatable(obj, USBDeviceReference_mt)


	return obj;
end

function USBDeviceReference.new(self, devHandle)
	usb.libusb_ref_device(devHandle);
	ffi.gc(devHandle, usb.libusb_unref_device);

	return self:init(devHandle);
end

function USBDeviceReference.getActive(self)
	-- get handle
	local handle = ffi.new("libusb_device_handle*[1]")
	local res = usb.libusb_open(self.Handle, handle);
	if res ~= 0 then
		return nil, string.format("failed to open device: [%d]", res);
	end

	-- construct a USBDevice from the handle
	-- return that
	handle = handle[0];
	ffi.gc(handle, usb.libusb_close)

	return USBDevice(handle)
end

function USBDeviceReference.getParent(self)
	local parentHandle = usb.libusb_get_parent(self.Handle);
	if parentHandle == nil then
		return nil;
	end

	return USBDeviceReference(parentHandle);
end

function USBDeviceReference.getAddress(self)
	local res = usb.libusb_get_device_address(self.Handle);
	return tonumber(res);
end

function USBDeviceReference.getBusNumber(self)
	local res = usb.libusb_get_bus_number(self.Handle);
	return tonumber(res);
end

function USBDeviceReference.getPortNumber(self)
	local res = usb.libusb_get_port_number(self.Handle);
	return res;
end

function USBDeviceReference.getNegotiatedSpeed(self)
	local res = usb.libusb_get_device_speed(self.Handle);
	return tonumber(res)
end


return USBDeviceReference;
