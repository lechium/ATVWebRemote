/*
 *
 * @APPLE_LICENSE_HEADER_START@
 * 
 * Copyright (c) 1999-2003 Apple Computer, Inc.  All Rights Reserved.
 * 
 * This file contains Original Code and/or Modifications of Original Code
 * as defined in and that are subject to the Apple Public Source License
 * Version 2.0 (the 'License'). You may not use this file except in
 * compliance with the License. Please obtain a copy of the License at
 * http://www.opensource.apple.com/apsl/ and read it before using this
 * file.
 * 
 * The Original Code and all software distributed under the License are
 * distributed on an 'AS IS' basis, WITHOUT WARRANTY OF ANY KIND, EITHER
 * EXPRESS OR IMPLIED, AND APPLE HEREBY DISCLAIMS ALL SUCH WARRANTIES,
 * INCLUDING WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE, QUIET ENJOYMENT OR NON-INFRINGEMENT.
 * Please see the License for the specific language governing rights and
 * limitations under the License.
 * 
 * @APPLE_LICENSE_HEADER_END@
 */

#ifndef _IOKIT_HID_IOHIDEVENTDATA_H
#define _IOKIT_HID_IOHIDEVENTDATA_H

#include <IOKit/IOTypes.h>
#include <IOKit/hid/IOHIDEventTypes.h>

#ifdef KERNEL
    #include <IOKit/IOLib.h>

    #define IOHIDEventRef IOHIDEvent *
#else
    #include <IOKit/hid/IOHIDEvent.h>

    typedef struct IOHIDEventData IOHIDEventData;
#endif

//==============================================================================
// IOHIDEventData Declarations
//==============================================================================

#define IOHIDEVENT_BASE             \
    uint32_t            size;       \
    IOHIDEventType      type;       \
    uint64_t            timestamp;  \
    uint32_t            options;    \
    uint8_t             depth;      \
    uint8_t             reserved[3];\
    uint64_t            deviceID;

/*!
    @typedef    IOHIDEventData
    @abstract   
    @discussion 
    @field      size        Size, in bytes, of the memory detailing this
                            particular event
    @field      type        Type of this particular event
    @field      options     Event specific options
    @field      deviceID    ID of the sending device
*/

struct IOHIDEventData{
    IOHIDEVENT_BASE;
};

typedef struct _IOHIDVendorDefinedEventData {
    IOHIDEVENT_BASE;
    uint16_t        usagePage;
    uint16_t        usage;
    uint32_t        version;
    uint32_t        length;
    uint8_t         data[0];
} IOHIDVendorDefinedEventData;

enum {
    kIOHID
