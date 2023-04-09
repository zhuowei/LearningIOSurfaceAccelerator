Learning IOSurfaceAccelerator's comm output API.

Doesn't work yet: gets this error in kernel log:

```
mapAPIParams System error: Failure to prepare comm API outbound data memory descriptor: 0xe00002de
```

# Notes

```
M2ScalerScalingASEControl::collectASEApiOutput_gatedContext
-> AppleM2ScalerCSCDriver::completeRequest_gatedContext

The length (0xa60 in 13.3.1) is written in __ZN18M2ScalerCSCRequest28validateAndInitializeCommAPIEPK19AppleM2ScalerCSCHal

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
