@import CoreFoundation;
@import IOKit;
@import IOSurface;

// https://github.com/WebKit/WebKit/blob/main/Source/WTF/wtf/spi/cocoa/IOSurfaceSPI.h

typedef struct __IOSurfaceAccelerator *IOSurfaceAcceleratorRef;

extern const CFStringRef kIOSurfaceAcceleratorUnwireSurfaceKey;

IOReturn IOSurfaceAcceleratorCreate(CFAllocatorRef, CFDictionaryRef properties, IOSurfaceAcceleratorRef* acceleratorOut);
CFRunLoopSourceRef IOSurfaceAcceleratorGetRunLoopSource(IOSurfaceAcceleratorRef);

typedef void (*IOSurfaceAcceleratorCompletionCallback)(void* completionRefCon, IOReturn status, void* completionRefCon2);

typedef struct IOSurfaceAcceleratorCompletion {
    IOSurfaceAcceleratorCompletionCallback completionCallback;
    void* completionRefCon;
    void* completionRefCon2;
} IOSurfaceAcceleratorCompletion;

IOReturn IOSurfaceAcceleratorTransformSurface(IOSurfaceAcceleratorRef, IOSurfaceRef sourceBuffer, IOSurfaceRef destinationBuffer, CFDictionaryRef options, void* pCropRectangles, IOSurfaceAcceleratorCompletion* pCompletion, void* pSwap, uint32_t* pCommandID);

