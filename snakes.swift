func snakesOnAPlane() {
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

}

snakesOnAPlane()
