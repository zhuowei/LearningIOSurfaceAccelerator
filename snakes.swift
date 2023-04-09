import IOSurface

func snakesOnAPlane() {
  guard let sourceSurface = IOSurface(properties: [.width: 16, .height: 16]) else {
    print("source surface is null")
    return
  }
  guard let destinationSurface = IOSurface(properties: [.width: 16, .height: 16]) else {
    print("dest surface is null")
    return
  }
  // https://github.com/WebKit/WebKit/commit/5e7ebb4f4f0592ad2911b8eb84da81ba900b0f4a
  var accelerator: IOSurfaceAcceleratorRef? = nil
  var err = IOSurfaceAcceleratorCreate(nil, nil, &accelerator)
  guard err == kIOReturnSuccess else {
    print("accelerator fail: \(err)")
    return
  }
  guard let accelerator = accelerator else {
    print("accelerator null")
    return
  }
  err = IOSurfaceAcceleratorTransformSurface(
    accelerator, sourceSurface, destinationSurface, /*options=*/ nil, /*pCropRectangles=*/
    nil, /*pCompletion=*/ nil, /*pSwap=*/ nil, /*pCommandID=*/ nil)
  guard err == kIOReturnSuccess else {
    print("transform fail: \(err)")
    return
  }
}

snakesOnAPlane()
