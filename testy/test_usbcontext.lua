package.path = package.path..";../?.lua"

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

local ctxt = USBContext();

local function test_version()
local ver = ctxt:getLibraryVersion();

printVersion(ver)
end

local function test_enumDevices()
	for _, dref in ctxt:devices() do 
		print("Device: ", dref);
	end
end

local function test_hotplug()
	ctxt:registerHotplugCallback();

	while true do
		local buf = io.read();
	end
end

test_version();
test_enumDevices();

test_hotplug();

