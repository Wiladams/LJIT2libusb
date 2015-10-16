package.path = package.path..";../?.lua"

local libc = require("libc")
local usb = require("libusb")
local USBContext = require("USBContext")

local function printVersion(ver)
	if not ver then return false; end

	print(string.format([[
    Version: %d.%d.%d.%d%s
Description: %s
]],
	ver.Major,
	ver.Minor,
	ver.Micro,
	ver.Nano,
	ver.Rc,
	ver.Description));
end

local function printDeviceReference(devRef)
	print(string.format([[
== USB Device Reference ==
  Class: %s
    Bus: %d 
   Port: %d 
Address: %d
Negotiated Speed: %s [%d]
Configurations: %d
    Interfaces: %d
]],
	devRef.ClassDescription,
	devRef:getBusNumber(),
	devRef:getPortNumber(),
	devRef:getAddress(),
	libc.getNameOfValue(devRef:getNegotiatedSpeed(), usb.Enums.libusb_speed),
	devRef:getNegotiatedSpeed(),
	devRef.Description.bNumConfigurations,
	devRef.ActiveConfig.bNumInterfaces))
	print(string.format([[
-- Interface --
	Num Alt Setting: %d
	Class: %s
]],
	devRef.ActiveConfig.interface.num_altsetting,
	usb.lookupClassDescriptor(devRef.ActiveConfig.interface.altsetting.bInterfaceClass,
		devRef.ActiveConfig.interface.altsetting.bInterfaceSubClass,
		devRef.ActiveConfig.interface.altsetting.bInterfaceProtocol)
	));
end


local function test_version(ctxt)
	local ver = ctxt:getLibraryVersion();

	printVersion(ver)
end

local function test_enumDevices(ctxt)
	for _, dref in ctxt:devices() do 
		printDeviceReference(dref);
	end
end

local function test_hotplug(ctxt)
	ctxt:registerHotplugCallback();

	while true do
		local buf = io.read();
	end
end

local function main()
	local ctxt = USBContext();
	test_version(ctxt);
	test_enumDevices(ctxt);

	--test_hotplug();
end

main()
