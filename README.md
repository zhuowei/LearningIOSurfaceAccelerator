Learning IOSurfaceAccelerator's comm output API.

Currently crashes with a (non-exploitable) null pointer dereference with ASE (Apple Scaling Engine???) enabled, since I don't know how to use ASEProcessing to generate a set of valid ASE inbound params.

This calls the userspace IOSurfaceAccelerator framework instead of calling the userclient directly: I didn't want to figure out the layout of the userclient's TransformSurfaceData argument.

# Notes

Other documentation about the IOSurfaceAccelerator framework and AppleM2ScalerCSC driver:

- https://iphonedevwiki.net/index.php/IOSurfaceAccelerator
- https://github.com/WebKit/WebKit/commit/5e7ebb4f4f0592ad2911b8eb84da81ba900b0f4a
- https://muirey03.blogspot.com/2020/09/cve-2020-9964-ios-infoleak.html?m=1
- https://i.blackhat.com/us-18/Wed-August-8/us-18-Chen-KeenLab-iOS-Jailbreak-Internals-wp.pdf


Notes about how the comm output api works:

```
M2ScalerScalingASEControl::collectASEApiOutput_gatedContext
-> AppleM2ScalerCSCDriver::completeRequest_gatedContext

The length (0xa60 in 13.3.1) is written in __ZN18M2ScalerCSCRequest28validateAndInitializeCommAPIEPK19AppleM2ScalerCSCHal

also written in
__ZN30M2ScalerScalingASEControlMSR1024getASEStats_gatedContextEP18M2ScalerCSCRequest

length read in
__ZN25M2ScalerScalingASEControl24getASEStats_gatedContextEP18M2ScalerCSCRequest

-> __ZN22AppleM2ScalerCSCDriver24perfControllerWorkSubmitEP18M2ScalerCSCRequest might also write to it??

For getting the memory used by the ASE/HDR APIs:
Probably M2ScalerCSCRequest::mapAPIParams since this mentions "HDR/ASE API ERROR" -> reads from 0x910, etc to make memory descriptors
-> M2ScalerCSCRequest::validateAndInitializeCommAPI
--> AppleM2ScalerCSCDriver::transformGeneral
---> AppleM2ScalerCSCDriver::prepareTransform -> writes to 0x910, etc from TransformSurfaceData 0xd8, etc
----> AppleM2ScalerCSCDriver::transform_surface
-----> IOSurfaceAcceleratorClient::transformSurface_asynchronous/synchronous
-> IOSurfaceAcceleratorClient::user_transform_surface
-> sizeof TransformSurfaceData = 170
```
