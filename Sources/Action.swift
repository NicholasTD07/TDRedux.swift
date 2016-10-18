//
//  Action.swift
//  TDRedux
//
//  Created by Nicholas Tian on 24/09/2016.
//  Copyright © 2016 nicktd. All rights reserved.
//

/// An *Action* describes what happen**ed**
/// while it may carry some data, e.g.
/// `AddTodo(text: "buy milk")` or `ToggleTodo(atIndex: 1)`
public typealias Action = Any

/// The `InitialAction` is the action a *Store* will dispatch
/// while initializing so that the *Store* can get its initial
/// state from its *Reducer(s)*.
public struct InitialAction: Action {
    /// The `init` method for the `InitialAction`
    public init() { }
}
