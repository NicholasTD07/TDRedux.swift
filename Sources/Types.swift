//
//  Types.swift
//  TDRedux
//
//  Created by Nicholas Tian on 21/10/2016.
//  Copyright © 2016 nicktd. All rights reserved.
//

// MARK: - Reducer
extension Store {

    /// Returns a new *State* based on the given *State* and *Action*
    ///
    /// - parameter state:  the current State of a Store
    /// - parameter action: an Action dispatched to the Store
    ///
    /// - returns: A new State
    public typealias Reducer = (_ state: State?, _ action: Action) -> State
}

// MARK: - Subscribers
extension Store {

    /// Subscribes to changes of a *Store*'s *State*
    ///
    /// It can subscribe to a *Store* by calling `store.subscribe`.
    ///
    /// When a Store's State changes, the Store will notify the change to all of its *Subscribers*.
    ///
    /// - parameter store: A Store
    ///
    /// - returns: Void
    public typealias Subscriber = (_ store: Store) -> ()

    /// Subscribe to changes of a *Store*'s *State*
    ///
    /// - parameter state:  A State
    ///
    /// - returns: Void
    public typealias StateSubscriber = (_ state: State) -> ()


    /// Gets called every time when the *State* of a *Store* changes
    public typealias UpdateSubscriber = () -> ()
}

// MARK: - Dispatcher, Dispatch, Middleware and AsyncAction
extension Store {

    /// Dispatches the given *Action* to the given *Store*
    ///
    /// - parameter store:  A Store
    /// - parameter action: an Action dispatched to the Store
    ///
    /// - returns: Void
    public typealias Dispatcher = (_ store: Store, _ action: Action) -> Void


    /// It provides a third-party extension point between dispatching an action,
    /// and the moment it reaches the reducer.
    public typealias Middleware = (@escaping Dispatcher) -> Dispatcher

    /// Dispatches the given *Action* to the binded *Store*
    ///
    /// - parameter action: An Action will be dispatched to the binded Store
    ///
    /// - returns: Void
    public typealias Dispatch = (_ action: Action) -> ()

    /// Async actions can call the dispatch function
    ///
    /// - parameter dispatch: a Dispatch function
    ///
    /// - returns: Void
    public typealias AsyncAction = (_ dispath: @escaping Store.Dispatch) -> ()
}
