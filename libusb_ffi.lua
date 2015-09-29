--[[
	This file contains the basic ffi interface to libusb-1.0.so
	With it, you can access all the functions.  All the required
	enums are in this file, but all the constants are in the 
	libusb.lua file, along with several of the enums
--]]
local ffi = require("ffi")
local libc = require("libc") -- ssize_t and other stuff



ffi.cdef[[
typedef struct libusb_context libusb_context;
typedef struct libusb_device libusb_device;
typedef struct libusb_device_handle libusb_device_handle;
]]

ffi.cdef[[
struct libusb_device_descriptor {
	uint8_t  bLength;
	uint8_t  bDescriptorType;
	uint16_t bcdUSB;
	uint8_t  bDeviceClass;
	uint8_t  bDeviceSubClass;
	uint8_t  bDeviceProtocol;
	uint8_t  bMaxPacketSize0;
	uint16_t idVendor;
	uint16_t idProduct;
	uint16_t bcdDevice;
	uint8_t  iManufacturer;
	uint8_t  iProduct;
	uint8_t  iSerialNumber;
	uint8_t  bNumConfigurations;
};
]]

ffi.cdef[[ 
struct libusb_endpoint_descriptor {
	uint8_t  bLength;
	uint8_t  bDescriptorType;	 
	uint8_t  bEndpointAddress;
	uint8_t  bmAttributes;
	uint16_t wMaxPacketSize;
	uint8_t  bInterval;
	uint8_t  bRefresh;
	uint8_t  bSynchAddress;
	const unsigned char *extra;
	int extra_length;
};
]]

ffi.cdef[[ 
struct libusb_interface_descriptor {
	uint8_t  bLength;
	uint8_t  bDescriptorType;
	uint8_t  bInterfaceNumber;
	uint8_t  bAlternateSetting;
	uint8_t  bNumEndpoints;
	uint8_t  bInterfaceClass;
	uint8_t  bInterfaceSubClass;
	uint8_t  bInterfaceProtocol;
	uint8_t  iInterface;
	const struct libusb_endpoint_descriptor *endpoint;
	const unsigned char *extra;
	int extra_length;
};
]]

ffi.cdef[[ 
struct libusb_interface {
	const struct libusb_interface_descriptor *altsetting;
	int num_altsetting;
};
]]

ffi.cdef[[
 
struct libusb_config_descriptor {
	uint8_t  bLength;
	uint8_t  bDescriptorType;
	uint16_t wTotalLength;
	uint8_t  bNumInterfaces;
	uint8_t  bConfigurationValue;
	uint8_t  iConfiguration;
	uint8_t  bmAttributes;
	uint8_t  MaxPower;
	const struct libusb_interface *interface;
	const unsigned char *extra;
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
enum	libusb_transfer_status {
	LIBUSB_TRANSFER_COMPLETED =0,
	LIBUSB_TRANSFER_ERROR=1,
	LIBUSB_TRANSFER_TIMED_OUT=2,
	LIBUSB_TRANSFER_CANCELLED=3,
	LIBUSB_TRANSFER_STALL=4,
	LIBUSB_TRANSFER_NO_DEVICE=5,
	LIBUSB_TRANSFER_OVERFLOW=6
};

struct libusb_iso_packet_descriptor {
	unsigned int length;
	unsigned int actual_length;
	enum libusb_transfer_status status;
};
]]

-- Callbacks
ffi.cdef[[
struct libusb_transfer;

struct libusb_pollfd {
	int fd;
	short events;
};

typedef void (* libusb_transfer_cb_fn)(struct libusb_transfer *transfer);
typedef void (* libusb_pollfd_added_cb)(int fd, short events, void *user_data);
typedef void (* libusb_pollfd_removed_cb)(int fd, void *user_data);
]]




ffi.cdef[[
struct libusb_transfer {
	libusb_device_handle *dev_handle;

	uint8_t flags;
	unsigned char endpoint;
	unsigned char type;
	unsigned int timeout;
	enum	libusb_transfer_status status;
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
enum	libusb_error {
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
		LIBUSB_ERROR_OTHER = -99
};
]]

ffi.cdef[[
int libusb_init(libusb_context **ctx);
void libusb_exit(libusb_context *ctx);
void libusb_set_debug(libusb_context *ctx, int level);
const struct libusb_version * libusb_get_version(void);
int libusb_has_capability(uint32_t capability);
const char * libusb_error_name(int errcode);
int libusb_setlocale(const char *locale);
const char * libusb_strerror(enum	libusb_error errcode);

ssize_t libusb_get_device_list(libusb_context *ctx,
	libusb_device ***list);
void libusb_free_device_list(libusb_device **list,
	int unref_devices);
libusb_device * libusb_ref_device(libusb_device *dev);
void libusb_unref_device(libusb_device *dev);

int libusb_get_configuration(libusb_device_handle *dev,
	int *config);
int libusb_get_device_descriptor(libusb_device *dev,
	struct libusb_device_descriptor *desc);
int libusb_get_active_config_descriptor(libusb_device *dev,
	struct libusb_config_descriptor **config);
int libusb_get_config_descriptor(libusb_device *dev,
	uint8_t config_index, struct libusb_config_descriptor **config);
int libusb_get_config_descriptor_by_value(libusb_device *dev,
	uint8_t bConfigurationValue, struct libusb_config_descriptor **config);
void libusb_free_config_descriptor(
	struct libusb_config_descriptor *config);
int libusb_get_ss_endpoint_companion_descriptor(
	struct libusb_context *ctx,
	const struct libusb_endpoint_descriptor *endpoint,
	struct libusb_ss_endpoint_companion_descriptor **ep_comp);
void libusb_free_ss_endpoint_companion_descriptor(
	struct libusb_ss_endpoint_companion_descriptor *ep_comp);
int libusb_get_bos_descriptor(libusb_device_handle *handle,
	struct libusb_bos_descriptor **bos);
void libusb_free_bos_descriptor(struct libusb_bos_descriptor *bos);
int libusb_get_usb_2_0_extension_descriptor(
	struct libusb_context *ctx,
	struct libusb_bos_dev_capability_descriptor *dev_cap,
	struct libusb_usb_2_0_extension_descriptor **usb_2_0_extension);
void libusb_free_usb_2_0_extension_descriptor(
	struct libusb_usb_2_0_extension_descriptor *usb_2_0_extension);
int libusb_get_ss_usb_device_capability_descriptor(
	struct libusb_context *ctx,
	struct libusb_bos_dev_capability_descriptor *dev_cap,
	struct libusb_ss_usb_device_capability_descriptor **ss_usb_device_cap);
void libusb_free_ss_usb_device_capability_descriptor(
	struct libusb_ss_usb_device_capability_descriptor *ss_usb_device_cap);
int libusb_get_container_id_descriptor(struct libusb_context *ctx,
	struct libusb_bos_dev_capability_descriptor *dev_cap,
	struct libusb_container_id_descriptor **container_id);
void libusb_free_container_id_descriptor(
	struct libusb_container_id_descriptor *container_id);
uint8_t libusb_get_bus_number(libusb_device *dev);
uint8_t libusb_get_port_number(libusb_device *dev);
int libusb_get_port_numbers(libusb_device *dev, uint8_t* port_numbers, int port_numbers_len);
//LIBUSB_DEPRECATED_FOR(libusb_get_port_numbers)
int libusb_get_port_path(libusb_context *ctx, libusb_device *dev, uint8_t* path, uint8_t path_length);
libusb_device * libusb_get_parent(libusb_device *dev);
uint8_t libusb_get_device_address(libusb_device *dev);
int libusb_get_device_speed(libusb_device *dev);
int libusb_get_max_packet_size(libusb_device *dev,
	unsigned char endpoint);
int libusb_get_max_iso_packet_size(libusb_device *dev,
	unsigned char endpoint);

int libusb_open(libusb_device *dev, libusb_device_handle **handle);
void libusb_close(libusb_device_handle *dev_handle);
libusb_device * libusb_get_device(libusb_device_handle *dev_handle);

int libusb_set_configuration(libusb_device_handle *dev,
	int configuration);
int libusb_claim_interface(libusb_device_handle *dev,
	int interface_number);
int libusb_release_interface(libusb_device_handle *dev,
	int interface_number);

libusb_device_handle * libusb_open_device_with_vid_pid(
	libusb_context *ctx, uint16_t vendor_id, uint16_t product_id);

int libusb_set_interface_alt_setting(libusb_device_handle *dev,
	int interface_number, int alternate_setting);
int libusb_clear_halt(libusb_device_handle *dev,
	unsigned char endpoint);
int libusb_reset_device(libusb_device_handle *dev);

int libusb_alloc_streams(libusb_device_handle *dev,
	uint32_t num_streams, unsigned char *endpoints, int num_endpoints);
int libusb_free_streams(libusb_device_handle *dev,
	unsigned char *endpoints, int num_endpoints);

int libusb_kernel_driver_active(libusb_device_handle *dev,
	int interface_number);
int libusb_detach_kernel_driver(libusb_device_handle *dev,
	int interface_number);
int libusb_attach_kernel_driver(libusb_device_handle *dev,
	int interface_number);
int libusb_set_auto_detach_kernel_driver(
	libusb_device_handle *dev, int enable);
]]



ffi.cdef[[
struct libusb_transfer * libusb_alloc_transfer(int iso_packets);
int libusb_submit_transfer(struct libusb_transfer *transfer);
int libusb_cancel_transfer(struct libusb_transfer *transfer);
void libusb_free_transfer(struct libusb_transfer *transfer);
void libusb_transfer_set_stream_id(
	struct libusb_transfer *transfer, uint32_t stream_id);
uint32_t libusb_transfer_get_stream_id(
	struct libusb_transfer *transfer);
]]


ffi.cdef[[
int libusb_control_transfer(libusb_device_handle *dev_handle,
	uint8_t request_type, uint8_t bRequest, uint16_t wValue, uint16_t wIndex,
	unsigned char *data, uint16_t wLength, unsigned int timeout);

int libusb_bulk_transfer(libusb_device_handle *dev_handle,
	unsigned char endpoint, unsigned char *data, int length,
	int *actual_length, unsigned int timeout);

int libusb_interrupt_transfer(libusb_device_handle *dev_handle,
	unsigned char endpoint, unsigned char *data, int length,
	int *actual_length, unsigned int timeout);
]]

ffi.cdef[[
int  libusb_get_string_descriptor_ascii(libusb_device_handle *dev,
	uint8_t desc_index, unsigned char *data, int length);
]]

ffi.cdef[[

int libusb_try_lock_events(libusb_context *ctx);
void libusb_lock_events(libusb_context *ctx);
void libusb_unlock_events(libusb_context *ctx);
int libusb_event_handling_ok(libusb_context *ctx);
int libusb_event_handler_active(libusb_context *ctx);
void libusb_lock_event_waiters(libusb_context *ctx);
void libusb_unlock_event_waiters(libusb_context *ctx);
int libusb_wait_for_event(libusb_context *ctx, struct timeval *tv);

int libusb_handle_events_timeout(libusb_context *ctx,
	struct timeval *tv);
int libusb_handle_events_timeout_completed(libusb_context *ctx,
	struct timeval *tv, int *completed);
int libusb_handle_events(libusb_context *ctx);
int libusb_handle_events_completed(libusb_context *ctx, int *completed);
int libusb_handle_events_locked(libusb_context *ctx,
	struct timeval *tv);
int libusb_pollfds_handle_timeouts(libusb_context *ctx);
int libusb_get_next_timeout(libusb_context *ctx,
	struct timeval *tv);
]]



ffi.cdef[[
const struct libusb_pollfd **  libusb_get_pollfds(
	libusb_context *ctx);
void  libusb_set_pollfd_notifiers(libusb_context *ctx,
	libusb_pollfd_added_cb added_cb, libusb_pollfd_removed_cb removed_cb,
	void *user_data);
]]

ffi.cdef[[
typedef enum	{
	LIBUSB_HOTPLUG_EVENT_DEVICE_ARRIVED = 0x01,
	LIBUSB_HOTPLUG_EVENT_DEVICE_LEFT    = 0x02,
} libusb_hotplug_event;
]]

ffi.cdef[[
typedef int libusb_hotplug_callback_handle;




enum libusb_hotplug_flag {
	LIBUSB_HOTPLUG_ENUMERATE = 1,
} libusb_hotplug_flag;

typedef int (* libusb_hotplug_callback_fn)(libusb_context *ctx,
						libusb_device *device,
						libusb_hotplug_event event,
						void *user_data);


int libusb_hotplug_register_callback(libusb_context *ctx,
						libusb_hotplug_event events,
						enum libusb_hotplug_flag flags,
						int vendor_id, int product_id,
						int dev_class,
						libusb_hotplug_callback_fn cb_fn,
						void *user_data,
						libusb_hotplug_callback_handle *handle);


void libusb_hotplug_deregister_callback(libusb_context *ctx,
						libusb_hotplug_callback_handle handle);
]]

local lib = ffi.load("libusb-1.0.so")

return lib
