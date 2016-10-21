# TDRedux

[![CocoaPods](https://img.shields.io/cocoapods/v/TDRedux.swift.svg?maxAge=3600)](http://cocoadocs.org/docsets/TDRedux.swift/)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-brightgreen.svg)](https://github.com/Carthage/Carthage)
[![Swift Package Manager](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://swift.org/package-manager/)

[![Travis](https://img.shields.io/travis/NicholasTD07/TDRedux.swift/master.svg?maxAge=3600)](https://travis-ci.org/NicholasTD07/TDRedux.swift)
[![Codecov](https://img.shields.io/codecov/c/github/NicholasTD07/TDRedux.swift/master.svg?maxAge=3600)](https://codecov.io/gh/NicholasTD07/TDRedux.swift)
[![CocoaPods](https://img.shields.io/cocoapods/p/TDRedux.swift.svg?maxAge=3600)](http://cocoadocs.org/docsets/TDRedux.swift/)
[![License](https://img.shields.io/github/license/NicholasTD07/TDRedux.swift.svg)](./LICENSE)


Yet another Redux written in Swift

## Installation

### [Swift Package Manager](https://swift.org/package-manager/)

Add this repo as a dependency in your `Package.swift` file, for example:

```swift
import PackageDescription

let package = Package(
    name: "Example",
    dependencies: [
        .Package(url: "https://github.com/NicholasTD07/TDRedux.swift.git",
                 majorVersion: 1),
    ]
)

```

### [Carthage](https://github.com/Carthage/Carthage)

```
github "NicholasTD07/TDRedux.swift" ~> 1.0
```

### [CocoaPods](https://cocoapods.org/)

```ruby
pod 'TDRedux.swift', '~> 1.0'
```

## TDRedux

### *Store*

A *Store* holds a *State*. A *State* is the entire internal state of an application, which could be anything.

You can

- create a `Store` with a *Reducer*
- dispatch *Actions* to change a *Store*'s *State*
- subscribe to changes happens to the *State* of a *Store*

[Read more: Redux in Swift Part 1 - Store and State](https://github.com/NicholasTD07/blog-posts/blob/master/swift/redux-in-swift-pt-1.md#store-and-its-state)


### *Reducer* Type

A Reducer is a function which takes an optional *State* and an *Action* and returns a new *State*, defined as the following:

```swift
class Store<State> {
    typealias Reducer = (State?, Action) -> State
}
```

[Read more: Redux in Swift Part 1 - Reducer and Action](https://github.com/NicholasTD07/blog-posts/blob/master/swift/redux-in-swift-pt-1.md#reducer-and-action)

### *Action*

An *Action* describes what happen**ed** while it may carry some data, e.g. `AddTodo(text: "buy milk")` or `ToggleTodo(atIndex: 1)`

`Action` type is defined as

```swift
typealias Action = Any
```

[Read more: Redux in Swift Part 1 - Reducer and Action](https://github.com/NicholasTD07/blog-posts/blob/master/swift/redux-in-swift-pt-1.md#reducer-and-action)

### `Reducer` function

A helper function which wraps *Reducers* that take non-optional `State` and specific type of `Action`, so that: No more type-casting in hand written *Reducers* anymore. For example:

```swift
typealias CounterState = Int

enum CounterActions {
  case increase
  case decrease
}

let counterReducer: (CounterState, CounterActions) = /* ... */
let wrappedReducer: (CounterState?, Any) = Reducer(initialState: 0, reducer: counterReducer)

let counterStore = Store<CounterState>.init(with: wrappedReducer)
```

### `combineReducers`

A helper function which combines an array of *Reducers* into one. For example:

```swift
typealias State = /* ... */
let arranOfReducers: [(State?, Any)] = [ /* ... */ ]
let combinedReducers: (State?, Any) = combineReducers(arranOfReducers)
```

### *Middleware*

> It provides a third-party extension point between dispatching an action, and the moment it reaches the reducer.

[Redux doc: Middleware](http://redux.js.org/docs/advanced/Middleware.html)


## What's Experimental?

### Everything in `Store` is `final`

`Store` and every property and methods in `Store` are defined as `final`.

Let me know if you think the `Store` need to be subclassed and overridden.

### Middleware

I am not too familiar with this concept in Redux and also I am not sure whether there are potential issues in my implementation or not.

## License

TDRedux is released under the MIT license. See LICENSE for details.

## Read More

- [How I built TDRedux Part 1](https://github.com/NicholasTD07/blog-posts/blob/master/swift/redux-in-swift-pt-1.md)
- [Introduction to Redux (JS)](http://redux.js.org)
- [Getting Started with Redux (30 free videos, 2 minutes each)](https://egghead.io/series/getting-started-with-redux)
