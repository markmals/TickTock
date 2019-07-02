# TickTock

TickTock is a wrapper for Disney's private Theme Parks data API, providing attraction and wait time information and park schedules. If you know of any more data provided by Disney's private API and would like me to add it to TickTock, please open an issue and let me know.

## Installation

Coming soon...

<!---
#### Swift Package Manager

Simply add this line to your `Package.swift` as an element in your package's dependencies:

```swift
.package(url: "https://github.com/markmals/TickTock", from: "1.0.0"),
```

Or, if you want to use this framework in an Apple-platform app, you can go to `File > New` in Xcode and select `Swift Package`. More info on that approach can be found at [WWDC by Sundell](https://wwdcbysundell.com/2019/xcode-swiftpm-first-look/).
-->

## Usage

You can see an example of how to fetch the data in [the TickTock tests](/Tests/TickTockTests/TickTockTests.swift):

```swift
import SwiftUI
import Combine
import TickTock

struct ContentView : View {
    let park = Park()
    @ObjectBinding var user = Resource(endpoint: park.schedule(for: "disneylandIDNumber"))

    var body: some View {
        Group {
            if user.value == nil {
                Text("Loading...")
            } else {
                VStack {
                    Text(user.value!.startTime).bold()
                    Text(user.value!.endTime)
                }
            }
        }
    }
}

```

## Attribution

Discovery of this API, it's various endpoints, and authentication methods originated with [cubehouse](https://github.com/cubehouse/)'s excellent [`themeparks`](https://github.com/cubehouse/themeparks) JavaScript library.
