local ffi = require("ffi")
local jit = require("jit")
local bit = require("bit")
local band, bor = bit.band, bit.bor

local libc = require("libc")
local usb = require("libusb")
local USBDeviceReference = require("USBDeviceReference")


local USBContext = {}
setmetatable(USBContext, {
	__call = function(self, ...)
		return self:new(...);
	end,
})

local USBContext_mt = {
	__index = USBContext;
}

function USBContext.init(self, ctx)
	local obj = {
		Handle = ctx;
	}
	setmetatable(obj, USBContext_mt)

	return obj;
end

function USBContext.new(self, ...)
	local ctx = ffi.new("libusb_context *[1]")
	local res = usb.libusb_init(ctx);

	if res ~= 0 then 
		return nil, "libusb_init() failed"
	end

	ctx = ctx[0];
	ffi.gc(ctx, usb.libusb_exit)

	return self:init(ctx)
end


function USBContext.getLibraryVersion(self)
	local ver = usb.libusb_get_version();
	if ver == nil then
		return nil;
	end

	return {
		Major = ver.major;
		Minor = ver.minor;
		Micro = ver.micro;
		Nano = ver.nano;
		Rc = libc.safestring(ver.rc);
		Description = libc.safestring(ver.describe);
	}
end

local function nil_gen()
	return nil;
end

local function freeDeviceList(devlist)
	usb.libusb_free_device_list(devlist, 1);
end

--[[
	Enumerate over currently attached devices.  If we had libuvdev,
	we could just enumerate the 'usb' subsystem.
--]]
function USBContext.devices(self)
	local devlist = ffi.new("libusb_device**[1]");
	local devcount = tonumber(usb.libusb_get_device_list(self.Handle, devlist));
	if devcount <0 then
		return nil_gen
	end

	devlist = devlist[0];
	ffi.gc(devlist, freeDeviceList);

	local function dev_gen(param, idx)
		if idx >= devcount then
			return nil;
		end

		return idx + 1, USBDeviceReference(param[idx]);
	end

	return dev_gen, devlist, 0;
end

local function hpcallback(ctx, device, event, user_data)
	print("hotplugcallback: ", ctx, device, event, user_data)
	io.write("hotplugcallback\n")
	io.flush();
end
jit.off(hpcallback)

function USBContext.registerHotplugCallback(self)
	jit.off(hpcallback)
	local cb = usb.libusb_hotplug_callback(hpcallback);
	local cbhandle = ffi.new("libusb_hotplug_callback_handle[1]")
print("cb: ",cb)
	local flags = bor(ffi.C.LIBUSB_HOTPLUG_EVENT_DEVICE_ARRIVED, ffi.C.LIBUSB_HOTPLUG_EVENT_DEVICE_LEFT)
	print("any: ", usb.LIBUSB_HOTPLUG_MATCH_ANY)

	local res = usb.libusb_hotplug_register_callback(
		self.Handle,
		flags,
		0,	-- or ffi.C.LIBUSB_HOTPLUG_ENUMERATE,
		usb.LIBUSB_HOTPLUG_MATCH_ANY,		-- vendor_id 
		usb.LIBUSB_HOTPLUG_MATCH_ANY,		-- product_id
		usb.LIBUSB_HOTPLUG_MATCH_ANY,		-- dev_class
		cb,			-- callback function
		nil,		-- userdata
		cbhandle 	-- a place for the handle
		)

	self.HotplugCallbackHandle = cbhandle[0];

	print("registration: ", res);
end

function USBContext.unregisterHotplugCallback(self)
	if not self.HotplugCallbackHandle then return end

	usb.libusb_hotplug_deregister_callback(self.Handle,	self.HotplugCallbackHandle);
end



return USBContext;
