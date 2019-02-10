--parseusbids.lua
--[[
	This file parses the usb.ids file, which contains various
	ids related to usb, and turns it into a vendor table.

	The origin data comes from:
	http://www.linux-usb.org/usb.ids

	So, download that file.  Then manually cut out the part that
	contains vendor id/product id, and put that into a separate file,
	such as vendor.ids

	NOTE:  There is a single '\' which throws the whole thing off.
	Somewhere around line 20498, you will see 'CD\RW'.  This needs
	to be changed to 'CD/RW' and then you can run it through the script.
	
	Then run this script:

	$ luajit parseusbids.lua vendor.ids > usbvendordb.lua

	At this point, you'll have the vendor/product ids in a convenient
	Lua table form, which can be incorporated into your program.
--]]

assert(arg[1]);

local function closeVendor()
	print("\t\t}\n\t},")
end

local invendor = false;

print("return {")
for line in io.lines(arg[1]) do
	if line == "" then
		--print("BLANK")
	else
		local isComment = string.match(line, "^#")
		if (isComment) then
			--print(line);
		else
			local vid, name = string.match(line, "^(%x%x%x%x)%s%s(.*)")
			if vid then
				if invendor then
					closeVendor();
				end

				invendor = true;

				io.write(string.format([[
	[0x%04x] = { 
		name = "%s",
		products = {
]],
					tonumber(vid,16), 
					name));
			else
				-- Get the product ID and name
				local pid, name = string.match(line, "^%c(%x%x%x%x)%s+(.*)")
				if name then
					name = name:gsub('\"', '\\"'):gsub("\\", '\\')
					print(string.format('\t\t\t[0x%04x] = "%s",', tonumber(pid,16), name))
				end
			end
		end
	end
end
closeVendor();
print("}")
