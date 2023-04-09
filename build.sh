#!/bin/sh
exec swiftc -target arm64-apple-macos13 -o snakes -import-objc-header snakes_bridging.h snakes.swift \
	/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/PrivateFrameworks/IOSurfaceAccelerator.framework/IOSurfaceAccelerator.tbd
