package.path = package.path..";../?.lua"

local ffi = require("ffi")

local libusb = require("libusb")()
local int = ffi.typeof("int")
local write = io.write;

local function print_devs(devs)

	--libusb_device *dev;
	--int j = 0;
	local path = ffi.new("uint8_t[8]"); 

	local i = 0;
	local dev = devs[i];
	while dev ~= nil do
		local desc = ffi.new("struct libusb_device_descriptor");
		local r = libusb_get_device_descriptor(dev, desc);
		if (r < 0) then
			io.stderr:write("failed to get device descriptor");
			return false;
		end

		io.write(string.format("%04x:%04x (bus %d, device %d)",
			desc.idVendor, desc.idProduct,
			libusb_get_bus_number(dev), libusb_get_device_address(dev)));

		r = libusb_get_port_numbers(dev, path, ffi.sizeof(path));
		if r > 0 then
			write(string.format(" path: %d", path[0]));
			for j = 1, r-1 do
				write(string.format(".%d", path[j]));
			end
		end
		print("");
	
		i = i + 1;
		dev = devs[i];
	end
end

local function main()

	local r = libusb.libusb_init(NULL);
	if (r < 0) then
		return r;
	end

	local devs = ffi.new("libusb_device **[1]")
	local cnt = libusb_get_device_list(NULL, devs);

	if (cnt < 0) then
		return int(cnt);
	end

	print_devs(devs[0]);
	libusb_free_device_list(devs[0], 1);

	libusb_exit(NULL);

	return true;
end

main();

