# LJIT2libusb
LuaJIT binding to libusb

This binding can onbly be classified as "experimental" at the moment.

There already exists a complete lua/libusb binding here: https://github.com/radioflash/ljusb

If you actually want to be productive with lua and libusb, I would recommend using the radioflash binding.

There are two parts to using libusb.  One part of it has to do with object discovery and enumeration.  For example, listing all the usb devices on a machine.  The second part of it has to do with control.  Transferring data into and out of devices.

For the former, on Linux, the libudev module might be a better choice.  In particular, when donig this from Lua, the LJIT2lubudev module makes is easy to gain access to all the devices, and easily apply filters to queries to zero in on exactly which device is desired.

Once a device is in hand though, libusb does a great job of making it relatively easy to read and write that device.