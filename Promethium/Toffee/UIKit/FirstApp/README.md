# First iOS App

Open `FirstApp.elements` in Fire and run it on an iPhone or iPad simulator.
Use an Elements build that supports Promethium's `@selector` and `cast[T](value)`.

The scene delegate declares UIKit's callback with `@selector`. UIKit passes a
`UIScene`, which the delegate casts to `UIWindowScene` before creating the
window and displaying a native label.
