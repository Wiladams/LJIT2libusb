local ffi = require("ffi")
local bit = require("bit")
local lshift, rshift = bit.lshift, bit.rshift


local Lib_libusb = require("libusb_ffi")

local Enums = {

-- Device and/or Interface Class codes
	libusb_class_code = {
		LIBUSB_CLASS_PER_INTERFACE = 0,
		LIBUSB_CLASS_AUDIO = 1,
		LIBUSB_CLASS_COMM = 2,
		LIBUSB_CLASS_HID = 3,
		LIBUSB_CLASS_PHYSICAL = 5,
		LIBUSB_CLASS_PRINTER = 7,
		LIBUSB_CLASS_IMAGE = 6,
		LIBUSB_CLASS_MASS_STORAGE = 8,
		LIBUSB_CLASS_HUB = 9,
		LIBUSB_CLASS_DATA = 10,
		LIBUSB_CLASS_SMART_CARD = 0x0b,
		LIBUSB_CLASS_CONTENT_SECURITY = 0x0d,
		LIBUSB_CLASS_VIDEO = 0x0e,
		LIBUSB_CLASS_PERSONAL_HEALTHCARE = 0x0f,
		LIBUSB_CLASS_DIAGNOSTIC_DEVICE = 0xdc,
		LIBUSB_CLASS_WIRELESS = 0xe0,
		LIBUSB_CLASS_APPLICATION = 0xfe,
		LIBUSB_CLASS_VENDOR_SPEC = 0xff
	};

-- Descriptor types as defined by the USB specification. 
	libusb_descriptor_type = {
		LIBUSB_DT_DEVICE = 0x01,
		LIBUSB_DT_CONFIG = 0x02,
		LIBUSB_DT_STRING = 0x03,
		LIBUSB_DT_INTERFACE = 0x04,
		LIBUSB_DT_ENDPOINT = 0x05,
		LIBUSB_DT_BOS = 0x0f,
		LIBUSB_DT_DEVICE_CAPABILITY = 0x10,
		LIBUSB_DT_HID = 0x21,
		LIBUSB_DT_REPORT = 0x22,
		LIBUSB_DT_PHYSICAL = 0x23,
		LIBUSB_DT_HUB = 0x29,
		LIBUSB_DT_SUPERSPEED_HUB = 0x2a,
		LIBUSB_DT_SS_ENDPOINT_COMPANION = 0x30
	};

	libusb_endpoint_direction ={
		LIBUSB_ENDPOINT_IN = 0x80,
		LIBUSB_ENDPOINT_OUT = 0x00
	};

	libusb_transfer_type ={
		LIBUSB_TRANSFER_TYPE_CONTROL = 0,
		LIBUSB_TRANSFER_TYPE_ISOCHRONOUS = 1,
		LIBUSB_TRANSFER_TYPE_BULK = 2,
		LIBUSB_TRANSFER_TYPE_INTERRUPT = 3,
		LIBUSB_TRANSFER_TYPE_BULK_STREAM = 4,
	};

	libusb_standard_request ={
	LIBUSB_REQUEST_GET_STATUS = 0x00,
	LIBUSB_REQUEST_CLEAR_FEATURE = 0x01,
	-- 0x02 is reserved
	LIBUSB_REQUEST_SET_FEATURE = 0x03,
	-- 0x04 is reserved
	LIBUSB_REQUEST_SET_ADDRESS = 0x05,
	LIBUSB_REQUEST_GET_DESCRIPTOR = 0x06,
	LIBUSB_REQUEST_SET_DESCRIPTOR = 0x07,
	LIBUSB_REQUEST_GET_CONFIGURATION = 0x08,
	LIBUSB_REQUEST_SET_CONFIGURATION = 0x09,
	LIBUSB_REQUEST_GET_INTERFACE = 0x0A,
	LIBUSB_REQUEST_SET_INTERFACE = 0x0B,
	LIBUSB_REQUEST_SYNCH_FRAME = 0x0C,
	LIBUSB_REQUEST_SET_SEL = 0x30,
	LIBUSB_SET_ISOCH_DELAY = 0x31,
	};

	libusb_request_type = {
		LIBUSB_REQUEST_TYPE_STANDARD = lshift(0x00, 5),
		LIBUSB_REQUEST_TYPE_CLASS = lshift(0x01, 5),
		LIBUSB_REQUEST_TYPE_VENDOR = lshift(0x02, 5),
		LIBUSB_REQUEST_TYPE_RESERVED = lshift(0x03, 5)
	};

	libusb_request_recipient = {
		LIBUSB_RECIPIENT_DEVICE = 0x00,
		LIBUSB_RECIPIENT_INTERFACE = 0x01,
		LIBUSB_RECIPIENT_ENDPOINT = 0x02,
		LIBUSB_RECIPIENT_OTHER = 0x03,
	};

	libusb_iso_sync_type = {
		LIBUSB_ISO_SYNC_TYPE_NONE = 0,
		LIBUSB_ISO_SYNC_TYPE_ASYNC = 1,
		LIBUSB_ISO_SYNC_TYPE_ADAPTIVE = 2,
		LIBUSB_ISO_SYNC_TYPE_SYNC = 3
	};



	libusb_iso_usage_type = {
		LIBUSB_ISO_USAGE_TYPE_DATA = 0,
		LIBUSB_ISO_USAGE_TYPE_FEEDBACK = 1,
		LIBUSB_ISO_USAGE_TYPE_IMPLICIT = 2,
	};


	libusb_speed = {
		LIBUSB_SPEED_UNKNOWN = 0,
		LIBUSB_SPEED_LOW = 1,
		LIBUSB_SPEED_FULL = 2,
		LIBUSB_SPEED_HIGH = 3,
		LIBUSB_SPEED_SUPER = 4,
	};


 
	libusb_supported_speed = {
		LIBUSB_LOW_SPEED_OPERATION   = 1,
		LIBUSB_FULL_SPEED_OPERATION  = 2,
		LIBUSB_HIGH_SPEED_OPERATION  = 4,
		LIBUSB_SUPER_SPEED_OPERATION = 8,
	};

 
	libusb_usb_2_0_extension_attributes = {
		LIBUSB_BM_LPM_SUPPORT = 2,
	};


 
	libusb_ss_usb_device_capability_attributes = {
		LIBUSB_BM_LTM_SUPPORT = 2,
	};

 
	libusb_bos_type = {
		LIBUSB_BT_WIRELESS_USB_DEVICE_CAPABILITY	= 1,
		LIBUSB_BT_USB_2_0_EXTENSION			= 2,
		LIBUSB_BT_SS_USB_DEVICE_CAPABILITY		= 3,
		LIBUSB_BT_CONTAINER_ID				= 4,
	};

 
	libusb_error = {
		LIBUSB_SUCCESS = 0,
		LIBUSB_ERROR_IO = -1,
		LIBUSB_ERROR_INVALID_PARAM = -2,
		LIBUSB_ERROR_ACCESS = -3,
		LIBUSB_ERROR_NO_DEVICE = -4,
		LIBUSB_ERROR_NOT_FOUND = -5,
		LIBUSB_ERROR_BUSY = -6,
		LIBUSB_ERROR_TIMEOUT = -7,
		LIBUSB_ERROR_OVERFLOW = -8,
		LIBUSB_ERROR_PIPE = -9,
		LIBUSB_ERROR_INTERRUPTED = -10,
		LIBUSB_ERROR_NO_MEM = -11,
		LIBUSB_ERROR_NOT_SUPPORTED = -12,
		LIBUSB_ERROR_OTHER = -99,
	};

	libusb_transfer_status ={
	LIBUSB_TRANSFER_COMPLETED =0,
	LIBUSB_TRANSFER_ERROR=1,
	LIBUSB_TRANSFER_TIMED_OUT=2,
	LIBUSB_TRANSFER_CANCELLED=3,
	LIBUSB_TRANSFER_STALL=4,
	LIBUSB_TRANSFER_NO_DEVICE=5,
	LIBUSB_TRANSFER_OVERFLOW=6,
	};

	libusb_transfer_flags = {
		LIBUSB_TRANSFER_SHORT_NOT_OK = lshift(1,0),
		LIBUSB_TRANSFER_FREE_BUFFER = lshift(1,1),
		LIBUSB_TRANSFER_FREE_TRANSFER = lshift(1,2),
		LIBUSB_TRANSFER_ADD_ZERO_PACKET = lshift(1, 3),
	};


 
	libusb_capability = {
		LIBUSB_CAP_HAS_CAPABILITY = 0x0000,
		LIBUSB_CAP_HAS_HOTPLUG = 0x0001,
		LIBUSB_CAP_HAS_HID_ACCESS = 0x0100,
		LIBUSB_CAP_SUPPORTS_DETACH_KERNEL_DRIVER = 0x0101
	};


 
	libusb_log_level = {
		LIBUSB_LOG_LEVEL_NONE = 0,
		LIBUSB_LOG_LEVEL_ERROR = 1,
		LIBUSB_LOG_LEVEL_WARNING = 2,
		LIBUSB_LOG_LEVEL_INFO = 3,
		LIBUSB_LOG_LEVEL_DEBUG = 4,
	};
}



local Constants = {
	LIBUSB_API_VERSION = 0x01000103;

-- Descriptor sizes per descriptor type 
	LIBUSB_DT_DEVICE_SIZE			= 18;
	LIBUSB_DT_CONFIG_SIZE			= 9;
	LIBUSB_DT_INTERFACE_SIZE		= 9;
	LIBUSB_DT_ENDPOINT_SIZE			= 7;
	LIBUSB_DT_ENDPOINT_AUDIO_SIZE	= 9;	-- Audio extension 
	LIBUSB_DT_HUB_NONVAR_SIZE		= 7;
	LIBUSB_DT_SS_ENDPOINT_COMPANION_SIZE	= 6;
	LIBUSB_DT_BOS_SIZE					= 5;
	LIBUSB_DT_DEVICE_CAPABILITY_SIZE	= 3;

-- BOS descriptor sizes 
	LIBUSB_BT_USB_2_0_EXTENSION_SIZE	= 7;
	LIBUSB_BT_SS_USB_DEVICE_CAPABILITY_SIZE	= 10;
	LIBUSB_BT_CONTAINER_ID_SIZE			= 20;


	LIBUSB_ENDPOINT_ADDRESS_MASK	= 0x0f;    	-- in bEndpointAddress 
	LIBUSB_ENDPOINT_DIR_MASK		= 0x80;
	LIBUSB_TRANSFER_TYPE_MASK		= 0x03;   -- in bmAttributes 

	LIBUSB_ISO_SYNC_TYPE_MASK		= 0x0C;
	LIBUSB_ISO_USAGE_TYPE_MASK = 0x30;
	LIBUSB_CONTROL_SETUP_SIZE = ffi.sizeof("struct libusb_control_setup");

-- Total number of error codes in 	libusb_error 
	LIBUSB_ERROR_COUNT =14;
	LIBUSB_HOTPLUG_MATCH_ANY =-1;

}

-- We unwrap the BOS => define its max size 
Constants.LIBUSB_DT_BOS_MAX_SIZE		= ((Constants.LIBUSB_DT_BOS_SIZE)     +
					(Constants.LIBUSB_BT_USB_2_0_EXTENSION_SIZE)       +
					(Constants.LIBUSB_BT_SS_USB_DEVICE_CAPABILITY_SIZE) +
					(Constants.LIBUSB_BT_CONTAINER_ID_SIZE));


-- Local Functions
-- In LuaJIT, callback functions are a scarce resource.  If you explicitly do a type
-- cast for the function, then you have a chance of freeing up the resources
-- that are utilizied to create the callback slot
local function callback(cbtypename, func)
	return ffi.cast(cbtypename, func)
end

local function usb_get_constant_value(name)
	return Constants[name];
end

local function usb_get_enum_value(name)
	for k,value in pairs(Enums) do 
		if value[name] then
			return value[name];
		end
	end
	return nil;
end


local exports = {
	Lib_libusb = Lib_libusb;

	-- callback functin wrappers
	libusb_hotplug_callback = function(cbfunc) return callback("libusb_hotplug_callback_fn", cbfunc) end;
	libusb_transfer_callback = function(cbfunc) return callback("libusb_transfer_cb_fn", cbfunc) end;
	libusb_pollfd_added_callback = function(cbfunc) return callback("libusb_pollfd_added_cb", cbfunc) end;
	libusb_pollfd_removed_callback = function(cbfunc) return callback("libusb_pollfd_removed_cb", cbfunc) end;

	-- Functions
	libusb_init = Lib_libusb.libusb_init;
	libusb_exit = Lib_libusb.libusb_exit;
	libusb_get_device_descriptor = Lib_libusb.libusb_get_device_descriptor;
	libusb_get_bus_number = Lib_libusb.libusb_get_bus_number;
	libusb_get_port_numbers = Lib_libusb.libusb_get_port_numbers;
	libusb_get_device_list = Lib_libusb.libusb_get_device_list;
	libusb_free_device_list = Lib_libusb.libusb_free_device_list;
	libusb_get_device_address = Lib_libusb.libusb_get_device_address;

	Constants = Constants;
	Enums = Enums;
}

setmetatable(exports, {
	__call = function(self, tbl)
		tbl = tbl or _G;
		for k,v in pairs(self) do
			tbl[k] = v;
		end

		for k,v in pairs(self.Constants) do
			tbl[k] = v;
		end

		for k,v in pairs(self.Enums) do
			tbl[k] = v;
		end

		return self;
	end,

	__index = function(self, key)
		-- first look for a function of the given name
		local success, value = pcall(function() return Lib_libusb[key] end)
		if success then
			rawset(self, key, value);
			return value;
		end

		-- next, look for an enum with the given name
		local value = usb_get_enum_value(key);

		if value ~= nil then
			rawset(self, key, value)
			return value;
		end

		-- finally, try the constants
		value = usb_get_constant_value(key);
		if value ~= nil then
			rawset(self, key, value)
			return value;
		end
		
		return value;
	end,

})

return exports
