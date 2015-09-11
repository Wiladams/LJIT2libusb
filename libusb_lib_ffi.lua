local ffi = require("ffi")
local bit = require("bit")
local lshift, rshift = bit.lshift, bit.rshift

local libc = require("libc")



--[[

#if defined(__linux) || defined(__APPLE__) || defined(__CYGWIN__)
#include <sys/time.h>
#endif

#include <time.h>
#include <limits.h>
--]]



#if defined(_WIN32) || defined(__CYGWIN__) || defined(_WIN32_WCE)
	LIBUSB_CALL WINAPI
#else
	LIBUSB_CALL
#endif


local LIBUSB_API_VERSION = 0x01000103;

local Enums = 

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

	libusb_request_type ={
		LIBUSB_REQUEST_TYPE_STANDARD = (0x00 << 5),
		LIBUSB_REQUEST_TYPE_CLASS = (0x01 << 5),
		LIBUSB_REQUEST_TYPE_VENDOR = (0x02 << 5),
		LIBUSB_REQUEST_TYPE_RESERVED = (0x03 << 5)
	};

	libusb_request_recipient ={
		LIBUSB_RECIPIENT_DEVICE = 0x00,
		LIBUSB_RECIPIENT_INTERFACE = 0x01,
		LIBUSB_RECIPIENT_ENDPOINT = 0x02,
		LIBUSB_RECIPIENT_OTHER = 0x03,
	};

	libusb_iso_sync_type ={
		LIBUSB_ISO_SYNC_TYPE_NONE = 0,
		LIBUSB_ISO_SYNC_TYPE_ASYNC = 1,
		LIBUSB_ISO_SYNC_TYPE_ADAPTIVE = 2,
		LIBUSB_ISO_SYNC_TYPE_SYNC = 3
	};



	libusb_iso_usage_type ={
		LIBUSB_ISO_USAGE_TYPE_DATA = 0,
		LIBUSB_ISO_USAGE_TYPE_FEEDBACK = 1,
		LIBUSB_ISO_USAGE_TYPE_IMPLICIT = 2,
	};


	libusb_speed ={
		LIBUSB_SPEED_UNKNOWN = 0,
		LIBUSB_SPEED_LOW = 1,
		LIBUSB_SPEED_FULL = 2,
		LIBUSB_SPEED_HIGH = 3,
		LIBUSB_SPEED_SUPER = 4,
	};

	--* \ingroup dev
 * Supported speeds (wSpeedSupported) bitfield. Indicates what
 * speeds the device supports.
 
	libusb_supported_speed ={
	--* Low speed operation supported (1.5MBit/s). 
	LIBUSB_LOW_SPEED_OPERATION   = 1,

	--* Full speed operation supported (12MBit/s). 
	LIBUSB_FULL_SPEED_OPERATION  = 2,

	--* High speed operation supported (480MBit/s). 
	LIBUSB_HIGH_SPEED_OPERATION  = 4,

	--* Superspeed operation supported (5000MBit/s). 
	LIBUSB_SUPER_SPEED_OPERATION = 8,
	};

--* \ingroup dev
 * Masks for the bits of the
 * \ref libusb_usb_2_0_extension_descriptor::bmAttributes "bmAttributes" field
 * of the USB 2.0 Extension descriptor.
 
	libusb_usb_2_0_extension_attributes {
	--* Supports Link Power Management (LPM) 
	LIBUSB_BM_LPM_SUPPORT = 2,
	};

--* \ingroup dev
 * Masks for the bits of the
 * \ref libusb_ss_usb_device_capability_descriptor::bmAttributes "bmAttributes" field
 * field of the SuperSpeed USB Device Capability descriptor.
 
	libusb_ss_usb_device_capability_attributes {
	--* Supports Latency Tolerance Messages (LTM) 
	LIBUSB_BM_LTM_SUPPORT = 2,
	};

--* \ingroup dev
 * USB capability types
 
	libusb_bos_type {
	--* Wireless USB device capability 
	LIBUSB_BT_WIRELESS_USB_DEVICE_CAPABILITY	= 1,

	--* USB 2.0 extensions 
	LIBUSB_BT_USB_2_0_EXTENSION			= 2,

	--* SuperSpeed USB device capability 
	LIBUSB_BT_SS_USB_DEVICE_CAPABILITY		= 3,

	--* Container ID type 
	LIBUSB_BT_CONTAINER_ID				= 4,
	};

 
	libusb_error ={
	--* Success (no error) 
	LIBUSB_SUCCESS = 0,

	--* Input/output error 
	LIBUSB_ERROR_IO = -1,

	--* Invalid parameter 
	LIBUSB_ERROR_INVALID_PARAM = -2,

	--* Access denied (insufficient permissions) 
	LIBUSB_ERROR_ACCESS = -3,

	--* No such device (it may have been disconnected) 
	LIBUSB_ERROR_NO_DEVICE = -4,

	--* Entity not found 
	LIBUSB_ERROR_NOT_FOUND = -5,

	--* Resource busy 
	LIBUSB_ERROR_BUSY = -6,

	--* Operation timed out 
	LIBUSB_ERROR_TIMEOUT = -7,

	--* Overflow 
	LIBUSB_ERROR_OVERFLOW = -8,

	--* Pipe error 
	LIBUSB_ERROR_PIPE = -9,

	--* System call interrupted (perhaps due to signal) 
	LIBUSB_ERROR_INTERRUPTED = -10,

	--* Insufficient memory 
	LIBUSB_ERROR_NO_MEM = -11,

	--* Operation not supported or unimplemented on this platform 
	LIBUSB_ERROR_NOT_SUPPORTED = -12,

	-- NB: Remember to update LIBUSB_ERROR_COUNT below as well as the
	   message strings in strerror.c when adding new error codes here. 

	--* Other error 
	LIBUSB_ERROR_OTHER = -99,
	};

	libusb_transfer_status ={
	LIBUSB_TRANSFER_COMPLETED,

	LIBUSB_TRANSFER_ERROR,

	LIBUSB_TRANSFER_TIMED_OUT,

	LIBUSB_TRANSFER_CANCELLED,

	LIBUSB_TRANSFER_STALL,

	LIBUSB_TRANSFER_NO_DEVICE,

	LIBUSB_TRANSFER_OVERFLOW,

};

	libusb_transfer_flags {
	LIBUSB_TRANSFER_SHORT_NOT_OK = 1<<0,

	LIBUSB_TRANSFER_FREE_BUFFER = 1<<1,

	LIBUSB_TRANSFER_FREE_TRANSFER = 1<<2,

	LIBUSB_TRANSFER_ADD_ZERO_PACKET = 1 << 3,
};

--* \ingroup misc
 * Capabilities supported by an instance of libusb on the current running
 * platform. Test if the loaded library supports a given capability by calling
 * \ref libusb_has_capability().
 
	libusb_capability {
	LIBUSB_CAP_HAS_CAPABILITY = 0x0000,
	LIBUSB_CAP_HAS_HOTPLUG = 0x0001,
	LIBUSB_CAP_HAS_HID_ACCESS = 0x0100,
	LIBUSB_CAP_SUPPORTS_DETACH_KERNEL_DRIVER = 0x0101
};


 
	libusb_log_level {
	LIBUSB_LOG_LEVEL_NONE = 0,
	LIBUSB_LOG_LEVEL_ERROR,
	LIBUSB_LOG_LEVEL_WARNING,
	LIBUSB_LOG_LEVEL_INFO,
	LIBUSB_LOG_LEVEL_DEBUG,
};
}


local Constants = {
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

-- We unwrap the BOS => define its max size 
	LIBUSB_DT_BOS_MAX_SIZE		= ((LIBUSB_DT_BOS_SIZE)     +
					(LIBUSB_BT_USB_2_0_EXTENSION_SIZE)       +
					(LIBUSB_BT_SS_USB_DEVICE_CAPABILITY_SIZE) +
					(LIBUSB_BT_CONTAINER_ID_SIZE));

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









ffi.cdef[[
struct libusb_device_descriptor {
	--* Size of this descriptor (in bytes) 
	uint8_t  bLength;

	--* Descriptor type. Will have value
	 * \ref libusb_descriptor_type::LIBUSB_DT_DEVICE LIBUSB_DT_DEVICE in this
	 * context. 
	uint8_t  bDescriptorType;

	--* USB specification release number in binary-coded decimal. A value of
	 * 0x0200 indicates USB 2.0, 0x0110 indicates USB 1.1, etc. 
	uint16_t bcdUSB;

	--* USB-IF class code for the device. See \ref libusb_class_code. 
	uint8_t  bDeviceClass;

	--* USB-IF subclass code for the device, qualified by the bDeviceClass
	 * value 
	uint8_t  bDeviceSubClass;

	--* USB-IF protocol code for the device, qualified by the bDeviceClass and
	 * bDeviceSubClass values 
	uint8_t  bDeviceProtocol;

	--* Maximum packet size for endpoint 0 
	uint8_t  bMaxPacketSize0;

	--* USB-IF vendor ID 
	uint16_t idVendor;

	--* USB-IF product ID 
	uint16_t idProduct;

	--* Device release number in binary-coded decimal 
	uint16_t bcdDevice;

	--* Index of string descriptor describing manufacturer 
	uint8_t  iManufacturer;

	--* Index of string descriptor describing product 
	uint8_t  iProduct;

	--* Index of string descriptor containing device serial number 
	uint8_t  iSerialNumber;

	--* Number of possible configurations 
	uint8_t  bNumConfigurations;
};
]]

ffi.cdef[[
--* \ingroup desc
 * A structure representing the standard USB endpoint descriptor. This
 * descriptor is documented in section 9.6.6 of the USB 3.0 specification.
 * All multiple-byte fields are represented in host-endian format.
 
struct libusb_endpoint_descriptor {
	--* Size of this descriptor (in bytes) 
	uint8_t  bLength;

	--* Descriptor type. Will have value
	 * \ref libusb_descriptor_type::LIBUSB_DT_ENDPOINT LIBUSB_DT_ENDPOINT in
	 * this context. 
	uint8_t  bDescriptorType;

	--* The address of the endpoint described by this descriptor. Bits 0:3 are
	 * the endpoint number. Bits 4:6 are reserved. Bit 7 indicates direction,
	 * see \ref libusb_endpoint_direction.
	 
	uint8_t  bEndpointAddress;

	--* Attributes which apply to the endpoint when it is configured using
	 * the bConfigurationValue. Bits 0:1 determine the transfer type and
	 * correspond to \ref libusb_transfer_type. Bits 2:3 are only used for
	 * isochronous endpoints and correspond to \ref libusb_iso_sync_type.
	 * Bits 4:5 are also only used for isochronous endpoints and correspond to
	 * \ref libusb_iso_usage_type. Bits 6:7 are reserved.
	 
	uint8_t  bmAttributes;

	--* Maximum packet size this endpoint is capable of sending/receiving. 
	uint16_t wMaxPacketSize;

	--* Interval for polling endpoint for data transfers. 
	uint8_t  bInterval;

	--* For audio devices only: the rate at which synchronization feedback
	 * is provided. 
	uint8_t  bRefresh;

	--* For audio devices only: the address if the synch endpoint 
	uint8_t  bSynchAddress;

	--* Extra descriptors. If libusb encounters unknown endpoint descriptors,
	 * it will store them here, should you wish to parse them. 
	const unsigned char *extra;

	--* Length of the extra descriptors, in bytes. 
	int extra_length;
};
]]

ffi.cdef[[
--* \ingroup desc
 * A structure representing the standard USB interface descriptor. This
 * descriptor is documented in section 9.6.5 of the USB 3.0 specification.
 * All multiple-byte fields are represented in host-endian format.
 
struct libusb_interface_descriptor {
	--* Size of this descriptor (in bytes) 
	uint8_t  bLength;

	--* Descriptor type. Will have value
	 * \ref libusb_descriptor_type::LIBUSB_DT_INTERFACE LIBUSB_DT_INTERFACE
	 * in this context. 
	uint8_t  bDescriptorType;

	--* Number of this interface 
	uint8_t  bInterfaceNumber;

	--* Value used to select this alternate setting for this interface 
	uint8_t  bAlternateSetting;

	--* Number of endpoints used by this interface (excluding the control
	 * endpoint). 
	uint8_t  bNumEndpoints;

	--* USB-IF class code for this interface. See \ref libusb_class_code. 
	uint8_t  bInterfaceClass;

	--* USB-IF subclass code for this interface, qualified by the
	 * bInterfaceClass value 
	uint8_t  bInterfaceSubClass;

	--* USB-IF protocol code for this interface, qualified by the
	 * bInterfaceClass and bInterfaceSubClass values 
	uint8_t  bInterfaceProtocol;

	--* Index of string descriptor describing this interface 
	uint8_t  iInterface;

	--* Array of endpoint descriptors. This length of this array is determined
	 * by the bNumEndpoints field. 
	const struct libusb_endpoint_descriptor *endpoint;

	--* Extra descriptors. If libusb encounters unknown interface descriptors,
	 * it will store them here, should you wish to parse them. 
	const unsigned char *extra;

	--* Length of the extra descriptors, in bytes. 
	int extra_length;
};
]]

ffi.cdef[[
--* \ingroup desc
 * A collection of alternate settings for a particular USB interface.
 
struct libusb_interface {
	--* Array of interface descriptors. The length of this array is determined
	 * by the num_altsetting field. 
	const struct libusb_interface_descriptor *altsetting;

	--* The number of alternate settings that belong to this interface 
	int num_altsetting;
};
]]

ffi.cdef[[
--* \ingroup desc
 * A structure representing the standard USB configuration descriptor. This
 * descriptor is documented in section 9.6.3 of the USB 3.0 specification.
 * All multiple-byte fields are represented in host-endian format.
 
struct libusb_config_descriptor {
	--* Size of this descriptor (in bytes) 
	uint8_t  bLength;

	--* Descriptor type. Will have value
	 * \ref libusb_descriptor_type::LIBUSB_DT_CONFIG LIBUSB_DT_CONFIG
	 * in this context. 
	uint8_t  bDescriptorType;

	--* Total length of data returned for this configuration 
	uint16_t wTotalLength;

	--* Number of interfaces supported by this configuration 
	uint8_t  bNumInterfaces;

	--* Identifier value for this configuration 
	uint8_t  bConfigurationValue;

	--* Index of string descriptor describing this configuration 
	uint8_t  iConfiguration;

	--* Configuration characteristics 
	uint8_t  bmAttributes;

	--* Maximum power consumption of the USB device from this bus in this
	 * configuration when the device is fully opreation. Expressed in units
	 * of 2 mA. 
	uint8_t  MaxPower;

	--* Array of interfaces supported by this configuration. The length of
	 * this array is determined by the bNumInterfaces field. 
	const struct libusb_interface *interface;

	--* Extra descriptors. If libusb encounters unknown configuration
	 * descriptors, it will store them here, should you wish to parse them. 
	const unsigned char *extra;

	--* Length of the extra descriptors, in bytes. 
	int extra_length;
};
]]

ffi.cdef[[

 
struct libusb_ss_endpoint_companion_descriptor {
	uint8_t  bLength;
	uint8_t  bDescriptorType;
	uint8_t  bMaxBurst;
	uint8_t  bmAttributes;
	uint16_t wBytesPerInterval;
};
]]

ffi.cdef[[
 
struct libusb_bos_dev_capability_descriptor {
	uint8_t bLength;
	uint8_t bDescriptorType;
	uint8_t bDevCapabilityType;
	uint8_t dev_capability_data [];
};
]]

ffi.cdef[[
 
struct libusb_bos_descriptor {
	uint8_t  bLength;
	uint8_t  bDescriptorType;
	uint16_t wTotalLength;
	uint8_t  bNumDeviceCaps;
	struct libusb_bos_dev_capability_descriptor *dev_capability[];
};
]]

ffi.cdef[[
 
struct libusb_usb_2_0_extension_descriptor {
	uint8_t  bLength;
	uint8_t  bDescriptorType;
	uint8_t  bDevCapabilityType;
	uint32_t  bmAttributes;
};
]]

ffi.cdef[[
 
struct libusb_ss_usb_device_capability_descriptor {
	uint8_t  bLength;
	uint8_t  bDescriptorType;
	uint8_t  bDevCapabilityType;
	uint8_t  bmAttributes;
	uint16_t wSpeedSupported;
	uint8_t  bFunctionalitySupport;
	uint8_t  bU1DevExitLat;
	uint16_t bU2DevExitLat;
};
]]

ffi.cdef[[
 
struct libusb_container_id_descriptor {
	uint8_t  bLength;
	uint8_t  bDescriptorType;
	uint8_t  bDevCapabilityType;
	uint8_t bReserved;
	uint8_t  ContainerID[16];
};
]]

ffi.cdef[[
struct libusb_control_setup {
	uint8_t  bmRequestType;
	uint8_t  bRequest;
	uint16_t wValue;
	uint16_t wIndex;
	uint16_t wLength;
};
]]


ffi.cdef[[

struct libusb_context;
struct libusb_device;
struct libusb_device_handle;
struct libusb_hotplug_callback;

 
struct libusb_version {
	const uint16_t major;

	const uint16_t minor;

	const uint16_t micro;

	const uint16_t nano;

	const char *rc;

	const char* describe;
};
]]

ffi.cdef[[
typedef struct libusb_context libusb_context;
typedef struct libusb_device libusb_device;
typedef struct libusb_device_handle libusb_device_handle;
]]







ffi.cdef[[
struct libusb_iso_packet_descriptor {
	--* Length of data to request in this packet 
	unsigned int length;

	--* Amount of data that was actually transferred 
	unsigned int actual_length;

	--* Status code for this packet 
		libusb_transfer_status status;
};
]]

ffi.cdef[[
struct libusb_transfer;

typedef void (LIBUSB_CALL *libusb_transfer_cb_fn)(struct libusb_transfer *transfer);


struct libusb_transfer {
	libusb_device_handle *dev_handle;

	uint8_t flags;
	unsigned char endpoint;
	unsigned char type;
	unsigned int timeout;
		libusb_transfer_status status;
	int length;
	int actual_length;
	libusb_transfer_cb_fn callback;
	void *user_data;
	unsigned char *buffer;


	int num_iso_packets;

	struct libusb_iso_packet_descriptor iso_packet_desc[];
};
]]



ffi.cdef[[
int LIBUSB_CALL libusb_init(libusb_context **ctx);
void LIBUSB_CALL libusb_exit(libusb_context *ctx);
void LIBUSB_CALL libusb_set_debug(libusb_context *ctx, int level);
const struct libusb_version * LIBUSB_CALL libusb_get_version(void);
int LIBUSB_CALL libusb_has_capability(uint32_t capability);
const char * LIBUSB_CALL libusb_error_name(int errcode);
int LIBUSB_CALL libusb_setlocale(const char *locale);
const char * LIBUSB_CALL libusb_strerror(	libusb_error errcode);

ssize_t LIBUSB_CALL libusb_get_device_list(libusb_context *ctx,
	libusb_device ***list);
void LIBUSB_CALL libusb_free_device_list(libusb_device **list,
	int unref_devices);
libusb_device * LIBUSB_CALL libusb_ref_device(libusb_device *dev);
void LIBUSB_CALL libusb_unref_device(libusb_device *dev);

int LIBUSB_CALL libusb_get_configuration(libusb_device_handle *dev,
	int *config);
int LIBUSB_CALL libusb_get_device_descriptor(libusb_device *dev,
	struct libusb_device_descriptor *desc);
int LIBUSB_CALL libusb_get_active_config_descriptor(libusb_device *dev,
	struct libusb_config_descriptor **config);
int LIBUSB_CALL libusb_get_config_descriptor(libusb_device *dev,
	uint8_t config_index, struct libusb_config_descriptor **config);
int LIBUSB_CALL libusb_get_config_descriptor_by_value(libusb_device *dev,
	uint8_t bConfigurationValue, struct libusb_config_descriptor **config);
void LIBUSB_CALL libusb_free_config_descriptor(
	struct libusb_config_descriptor *config);
int LIBUSB_CALL libusb_get_ss_endpoint_companion_descriptor(
	struct libusb_context *ctx,
	const struct libusb_endpoint_descriptor *endpoint,
	struct libusb_ss_endpoint_companion_descriptor **ep_comp);
void LIBUSB_CALL libusb_free_ss_endpoint_companion_descriptor(
	struct libusb_ss_endpoint_companion_descriptor *ep_comp);
int LIBUSB_CALL libusb_get_bos_descriptor(libusb_device_handle *handle,
	struct libusb_bos_descriptor **bos);
void LIBUSB_CALL libusb_free_bos_descriptor(struct libusb_bos_descriptor *bos);
int LIBUSB_CALL libusb_get_usb_2_0_extension_descriptor(
	struct libusb_context *ctx,
	struct libusb_bos_dev_capability_descriptor *dev_cap,
	struct libusb_usb_2_0_extension_descriptor **usb_2_0_extension);
void LIBUSB_CALL libusb_free_usb_2_0_extension_descriptor(
	struct libusb_usb_2_0_extension_descriptor *usb_2_0_extension);
int LIBUSB_CALL libusb_get_ss_usb_device_capability_descriptor(
	struct libusb_context *ctx,
	struct libusb_bos_dev_capability_descriptor *dev_cap,
	struct libusb_ss_usb_device_capability_descriptor **ss_usb_device_cap);
void LIBUSB_CALL libusb_free_ss_usb_device_capability_descriptor(
	struct libusb_ss_usb_device_capability_descriptor *ss_usb_device_cap);
int LIBUSB_CALL libusb_get_container_id_descriptor(struct libusb_context *ctx,
	struct libusb_bos_dev_capability_descriptor *dev_cap,
	struct libusb_container_id_descriptor **container_id);
void LIBUSB_CALL libusb_free_container_id_descriptor(
	struct libusb_container_id_descriptor *container_id);
uint8_t LIBUSB_CALL libusb_get_bus_number(libusb_device *dev);
uint8_t LIBUSB_CALL libusb_get_port_number(libusb_device *dev);
int LIBUSB_CALL libusb_get_port_numbers(libusb_device *dev, uint8_t* port_numbers, int port_numbers_len);
LIBUSB_DEPRECATED_FOR(libusb_get_port_numbers)
int LIBUSB_CALL libusb_get_port_path(libusb_context *ctx, libusb_device *dev, uint8_t* path, uint8_t path_length);
libusb_device * LIBUSB_CALL libusb_get_parent(libusb_device *dev);
uint8_t LIBUSB_CALL libusb_get_device_address(libusb_device *dev);
int LIBUSB_CALL libusb_get_device_speed(libusb_device *dev);
int LIBUSB_CALL libusb_get_max_packet_size(libusb_device *dev,
	unsigned char endpoint);
int LIBUSB_CALL libusb_get_max_iso_packet_size(libusb_device *dev,
	unsigned char endpoint);

int LIBUSB_CALL libusb_open(libusb_device *dev, libusb_device_handle **handle);
void LIBUSB_CALL libusb_close(libusb_device_handle *dev_handle);
libusb_device * LIBUSB_CALL libusb_get_device(libusb_device_handle *dev_handle);

int LIBUSB_CALL libusb_set_configuration(libusb_device_handle *dev,
	int configuration);
int LIBUSB_CALL libusb_claim_interface(libusb_device_handle *dev,
	int interface_number);
int LIBUSB_CALL libusb_release_interface(libusb_device_handle *dev,
	int interface_number);

libusb_device_handle * LIBUSB_CALL libusb_open_device_with_vid_pid(
	libusb_context *ctx, uint16_t vendor_id, uint16_t product_id);

int LIBUSB_CALL libusb_set_interface_alt_setting(libusb_device_handle *dev,
	int interface_number, int alternate_setting);
int LIBUSB_CALL libusb_clear_halt(libusb_device_handle *dev,
	unsigned char endpoint);
int LIBUSB_CALL libusb_reset_device(libusb_device_handle *dev);

int LIBUSB_CALL libusb_alloc_streams(libusb_device_handle *dev,
	uint32_t num_streams, unsigned char *endpoints, int num_endpoints);
int LIBUSB_CALL libusb_free_streams(libusb_device_handle *dev,
	unsigned char *endpoints, int num_endpoints);

int LIBUSB_CALL libusb_kernel_driver_active(libusb_device_handle *dev,
	int interface_number);
int LIBUSB_CALL libusb_detach_kernel_driver(libusb_device_handle *dev,
	int interface_number);
int LIBUSB_CALL libusb_attach_kernel_driver(libusb_device_handle *dev,
	int interface_number);
int LIBUSB_CALL libusb_set_auto_detach_kernel_driver(
	libusb_device_handle *dev, int enable);
]]



ffi.cdef[[
struct libusb_transfer * LIBUSB_CALL libusb_alloc_transfer(int iso_packets);
int LIBUSB_CALL libusb_submit_transfer(struct libusb_transfer *transfer);
int LIBUSB_CALL libusb_cancel_transfer(struct libusb_transfer *transfer);
void LIBUSB_CALL libusb_free_transfer(struct libusb_transfer *transfer);
void LIBUSB_CALL libusb_transfer_set_stream_id(
	struct libusb_transfer *transfer, uint32_t stream_id);
uint32_t LIBUSB_CALL libusb_transfer_get_stream_id(
	struct libusb_transfer *transfer);
]]


ffi.cdef[[
int LIBUSB_CALL libusb_control_transfer(libusb_device_handle *dev_handle,
	uint8_t request_type, uint8_t bRequest, uint16_t wValue, uint16_t wIndex,
	unsigned char *data, uint16_t wLength, unsigned int timeout);

int LIBUSB_CALL libusb_bulk_transfer(libusb_device_handle *dev_handle,
	unsigned char endpoint, unsigned char *data, int length,
	int *actual_length, unsigned int timeout);

int LIBUSB_CALL libusb_interrupt_transfer(libusb_device_handle *dev_handle,
	unsigned char endpoint, unsigned char *data, int length,
	int *actual_length, unsigned int timeout);
]]

ffi.cdef[[
int LIBUSB_CALL libusb_get_string_descriptor_ascii(libusb_device_handle *dev,
	uint8_t desc_index, unsigned char *data, int length);
]]

ffi.cdef[[

int LIBUSB_CALL libusb_try_lock_events(libusb_context *ctx);
void LIBUSB_CALL libusb_lock_events(libusb_context *ctx);
void LIBUSB_CALL libusb_unlock_events(libusb_context *ctx);
int LIBUSB_CALL libusb_event_handling_ok(libusb_context *ctx);
int LIBUSB_CALL libusb_event_handler_active(libusb_context *ctx);
void LIBUSB_CALL libusb_lock_event_waiters(libusb_context *ctx);
void LIBUSB_CALL libusb_unlock_event_waiters(libusb_context *ctx);
int LIBUSB_CALL libusb_wait_for_event(libusb_context *ctx, struct timeval *tv);

int LIBUSB_CALL libusb_handle_events_timeout(libusb_context *ctx,
	struct timeval *tv);
int LIBUSB_CALL libusb_handle_events_timeout_completed(libusb_context *ctx,
	struct timeval *tv, int *completed);
int LIBUSB_CALL libusb_handle_events(libusb_context *ctx);
int LIBUSB_CALL libusb_handle_events_completed(libusb_context *ctx, int *completed);
int LIBUSB_CALL libusb_handle_events_locked(libusb_context *ctx,
	struct timeval *tv);
int LIBUSB_CALL libusb_pollfds_handle_timeouts(libusb_context *ctx);
int LIBUSB_CALL libusb_get_next_timeout(libusb_context *ctx,
	struct timeval *tv);
]]

ffi.cdef[[
struct libusb_pollfd {
	int fd;
	short events;
};


typedef void (LIBUSB_CALL *libusb_pollfd_added_cb)(int fd, short events,
	void *user_data);


typedef void (LIBUSB_CALL *libusb_pollfd_removed_cb)(int fd, void *user_data);

const struct libusb_pollfd ** LIBUSB_CALL libusb_get_pollfds(
	libusb_context *ctx);
void LIBUSB_CALL libusb_set_pollfd_notifiers(libusb_context *ctx,
	libusb_pollfd_added_cb added_cb, libusb_pollfd_removed_cb removed_cb,
	void *user_data);
]]

ffi.cdef[[
typedef int libusb_hotplug_callback_handle;

typedef 	{
	LIBUSB_HOTPLUG_EVENT_DEVICE_ARRIVED = 0x01,
	LIBUSB_HOTPLUG_EVENT_DEVICE_LEFT    = 0x02,
} libusb_hotplug_event;


typedef 	{
	LIBUSB_HOTPLUG_ENUMERATE = 1,
} libusb_hotplug_flag;

typedef int (LIBUSB_CALL *libusb_hotplug_callback_fn)(libusb_context *ctx,
						libusb_device *device,
						libusb_hotplug_event event,
						void *user_data);


int LIBUSB_CALL libusb_hotplug_register_callback(libusb_context *ctx,
						libusb_hotplug_event events,
						libusb_hotplug_flag flags,
						int vendor_id, int product_id,
						int dev_class,
						libusb_hotplug_callback_fn cb_fn,
						void *user_data,
						libusb_hotplug_callback_handle *handle);


void LIBUSB_CALL libusb_hotplug_deregister_callback(libusb_context *ctx,
						libusb_hotplug_callback_handle handle);
]]

