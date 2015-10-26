local libc = require("libc")
local bit = require("bit")
local lshift, rshift = bit.lshift, bit.rshift;
local bor, band = bit.bor, bit.band;

-- async I/O
local function libusb_control_transfer_get_data(transfer)
	return transfer.buffer + LIBUSB_CONTROL_SETUP_SIZE;
end

local function libusb_control_transfer_get_setup(transfer)

	return (struct libusb_control_setup *)(void *) transfer.buffer;
end

local function libusb_fill_control_setup(buffer,
	uint8_t bmRequestType, uint8_t bRequest, uint16_t wValue, uint16_t wIndex,
	uint16_t wLength)

	struct libusb_control_setup *setup = (struct libusb_control_setup *)(void *) buffer;
	setup.bmRequestType = bmRequestType;
	setup.bRequest = bRequest;
	setup.wValue = libusb_cpu_to_le16(wValue);
	setup.wIndex = libusb_cpu_to_le16(wIndex);
	setup.wLength = libusb_cpu_to_le16(wLength);
end



local function libusb_fill_control_transfer(
	transfer, dev_handle,
	buffer, libusb_transfer_cb_fn callback, user_data,
	timeout)

	struct libusb_control_setup *setup = (struct libusb_control_setup *)(void *) buffer;
	transfer.dev_handle = dev_handle;
	transfer.endpoint = 0;
	transfer.type = LIBUSB_TRANSFER_TYPE_CONTROL;
	transfer.timeout = timeout;
	transfer.buffer = buffer;
	if (setup) then
		transfer.length = (int) (LIBUSB_CONTROL_SETUP_SIZE
			+ libusb_le16_to_cpu(setup.wLength));
	end

	transfer.user_data = user_data;
	transfer.callback = callback;
end


local function libusb_fill_bulk_transfer(transfer,
	dev_handle, unsigned char endpoint,
	unsigned char *buffer, int length, libusb_transfer_cb_fn callback,
	void *user_data, unsigned int timeout)

	transfer.dev_handle = dev_handle;
	transfer.endpoint = endpoint;
	transfer.type = LIBUSB_TRANSFER_TYPE_BULK;
	transfer.timeout = timeout;
	transfer.buffer = buffer;
	transfer.length = length;
	transfer.user_data = user_data;
	transfer.callback = callback;
end


local function libusb_fill_bulk_stream_transfer(
	struct libusb_transfer *transfer, libusb_device_handle *dev_handle,
	unsigned char endpoint, uint32_t stream_id,
	unsigned char *buffer, int length, libusb_transfer_cb_fn callback,
	void *user_data, unsigned int timeout)

	libusb_fill_bulk_transfer(transfer, dev_handle, endpoint, buffer,
				  length, callback, user_data, timeout);
	transfer.type = LIBUSB_TRANSFER_TYPE_BULK_STREAM;
	libusb_transfer_set_stream_id(transfer, stream_id);
end


local function libusb_fill_interrupt_transfer(transfer, libusb_device_handle *dev_handle,
	unsigned char endpoint, unsigned char *buffer, int length,
	libusb_transfer_cb_fn callback, void *user_data, unsigned int timeout)

	transfer.dev_handle = dev_handle;
	transfer.endpoint = endpoint;
	transfer.type = LIBUSB_TRANSFER_TYPE_INTERRUPT;
	transfer.timeout = timeout;
	transfer.buffer = buffer;
	transfer.length = length;
	transfer.user_data = user_data;
	transfer.callback = callback;
end


local function libusb_fill_iso_transfer(transfer,
	libusb_device_handle *dev_handle, unsigned char endpoint,
	unsigned char *buffer, int length, int num_iso_packets,
	libusb_transfer_cb_fn callback, void *user_data, unsigned int timeout)

	transfer.dev_handle = dev_handle;
	transfer.endpoint = endpoint;
	transfer.type = LIBUSB_TRANSFER_TYPE_ISOCHRONOUS;
	transfer.timeout = timeout;
	transfer.buffer = buffer;
	transfer.length = length;
	transfer.num_iso_packets = num_iso_packets;
	transfer.user_data = user_data;
	transfer.callback = callback;
end


local function libusb_set_iso_packet_lengths(transfer, length)

	int i;
	for (i = 0; i < transfer.num_iso_packets; i++)
		transfer.iso_packet_desc[i].length = length;
end


local function libusb_get_iso_packet_buffer(transfer, packet)

	int i;
	size_t offset = 0;
	int _packet;

	--[[ oops..slight bug in the API. packet is an unsigned int, but we use
	 * signed integers almost everywhere else. range-check and convert to
	 * signed to avoid compiler warnings. FIXME for libusb-2. --]]
	if (packet > INT_MAX) then
		return nil;
	end

	_packet = (int) packet;

	if (_packet >= transfer.num_iso_packets) then
		return nil;
	end

	for (i = 0; i < _packet; i++)
		offset += transfer.iso_packet_desc[i].length;

	return transfer.buffer + offset;
end


local function libusb_get_iso_packet_buffer_simple(transfer, packet)

	--[[ oops..slight bug in the API. packet is an unsigned int, but we use
	 * signed integers almost everywhere else. range-check and convert to
	 * signed to avoid compiler warnings. FIXME for libusb-2. --]]
	if (packet > INT_MAX) then
		return nil;
	end

	local _packet = packet;

	if (_packet >= transfer.num_iso_packets) then
		return nil;
	end

	return transfer.buffer + ((int) transfer.iso_packet_desc[0].length * _packet);
end



local function libusb_get_descriptor(dev,
	uint8_t desc_type, uint8_t desc_index, unsigned char *data, int length)

	return libusb_control_transfer(dev, LIBUSB_ENDPOINT_IN,
		LIBUSB_REQUEST_GET_DESCRIPTOR, (uint16_t) (lshift(desc_type, 8) | desc_index),
		0, data, (uint16_t) length, 1000);
end


local function int libusb_get_string_descriptor(dev,
	uint8_t desc_index, uint16_t langid, unsigned char *data, int length)

	return libusb_control_transfer(dev, LIBUSB_ENDPOINT_IN,
		LIBUSB_REQUEST_GET_DESCRIPTOR, (uint16_t)(lshift(LIBUSB_DT_STRING, 8) | desc_index),
		langid, data, (uint16_t) length, 1000);
end

