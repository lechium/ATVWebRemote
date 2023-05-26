//
//  external.h
//  vncforios
//
//  Created by ethanarbuckle.
//  Copyright © ethanarbuckle. All rights reserved.
//

#ifndef external_h
#define external_h

#include <IOKit/hidsystem/IOHIDEventSystemClient.h>
#include <IOKit/hid/IOHIDUsageTables.h>
#include <IOKit/hid/IOHIDEventTypes.h>
#include <IOKit/hid/IOHIDEvent.h>
#include <IOKit/IOKitLib.h>
#include <mach/mach_port.h>
#include <UIKit/UIKit.h>

// For events
typedef struct __IOHIDEvent *IOHIDEventRef;
//IOHIDEventSystemClientRef IOHIDEventSystemClientCreate(CFAllocatorRef allocator);
//void IOHIDEventSetIntegerValue(IOHIDEventRef event, IOHIDEventField field, int value);
//void IOHIDEventSetSenderID(IOHIDEventRef event, uint64_t sender);
//void IOHIDEventSystemClientDispatchEvent(IOHIDEventSystemClientRef client, IOHIDEventRef event);
//extern kern_return_t IOServiceGetBusyStateAndTime(io_service_t service, uint64_t *state, uint32_t *busy_state, uint64_t *accumulated_busy_time);
enum {
    kIOServiceInactiveState    = 0x00000001,
    kIOServiceRegisteredState    = 0x00000002,
    kIOServiceMatchedState    = 0x00000004,
    kIOServiceFirstPublishState    = 0x00000008,
    kIOServiceFirstMatchState    = 0x00000010
};

#endif /* external_h */
