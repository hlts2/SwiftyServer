# SwiftyServer
SwiftyServer is a simple lightweight library for writing HTTP web server with Swift

## How to use

```swift
import SwiftyServer

let http = HTTPServer.instance

http.get("/") { resp, req in
    resp.write("hello world")
}

do {
    try http.serveHTTP(port: 1234)
} catch {
    print("\(error)")
}
```

### Optional
For html output.

```swift
http.get("/") { resp, req in
    resp.write("<h1>hello world</h1>")
}
```

## Installation

SwiftyServer is available through [Carthage](https://github.com/Carthage/Carthage) or
[Swift Package Manager](https://github.com/apple/swift-package-manager).

### Carthage

```
github "hlts2/SwiftyServer"
```

for detail, please follow the [Carthage Instruction](https://github.com/Carthage/Carthage#if-youre-building-for-ios-tvos-or-watchos)

### Swift Package Manager

```
dependencies: [
    .Package(url: "https://github.com/hlts2/SwiftyServer.git", majorVersion: 1)
]
```

for detail, please follow the [Swift Package Manager Instruction](https://github.com/apple/swift-package-manager/blob/master/Documentation/Usage.md)

### Inspiration
- [EchoServer.Swift](https://gist.github.com/satoshiam/65f74106f5c69697314f)
- [SwiftSocket](https://github.com/swiftsocket/SwiftSocket)
- [martini](https://github.com/go-martini/martini)
