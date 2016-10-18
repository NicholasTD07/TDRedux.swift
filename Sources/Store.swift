//
//  Store.swift
//  TDRedux
//
//  Created by Nicholas Tian on 24/09/2016.
//  Copyright © 2016 nicktd. All rights reserved.
//

// MARK: - Types
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

    /// Returns a new *State* based on the given *State* and *Action*
    ///
    /// - parameter state:  the current State of a Store
    /// - parameter action: an Action dispatched to the Store
    ///
    /// - returns: A new State
    public typealias Reducer = (_ state: State?, _ action: Action) -> State
}

// MARK: - Store

/// Holds a *State* in its `state`.
///
/// You can
///  - create a `Store` with a *Reducer*
///  - dispatch *Actions* to change a *Store*'s *State*
///  - subscribe to changes happens to the *State* of a *Store* using *Subscribers*
public final class Store<State> {

    /// the entire internal state of an application
    public fileprivate(set) final var state: State

    /// An array of *Subscribers*
    public final var subscribers = [Subscriber]()

    private var dispatcher: Dispatcher

    /// The `init` method for a *Store*
    ///
    /// - parameter reducer:     A Reducer function
    /// - parameter middlewares: An array of Middlewares
    ///
    /// - returns: A Store
    public init(with reducer: @escaping Reducer, middlewares: [Middleware] = []) {
        self.state = reducer(nil, InitialAction())

        self.dispatcher = Store.combine(middlewares: middlewares, with: reducer)

        // NOTE: Dispatching `InitialAction` the second time
        //          to update middlewares with this action and initial state.
        //          Because no reducers **should** handle `InitialAction`,
        //          This should have no effect on the state and store.
        self.dispatch(InitialAction())
    }

    /// Dispatches an *Action* to a *Store*'s *Reducer(s)*
    ///
    /// - parameter action: An Action
    public func dispatch(_ action: Action) {
        dispatcher(self, action)
    }

    /// Subcribes a *Subscriber* to the changes of a *Store*'s *State*
    ///
    /// - parameter subscriber: A Subscriber function
    public final func subscribe(with subscriber: @escaping Subscriber) {
        subscribers.append(subscriber)
        subscriber(self)
    }
}

// MARK: - Combining Middlewares
extension Store {

    /// Combines *Middlewares* with a *Reducer*
    ///
    /// - parameter middlewares: An array of Middlewares
    /// - parameter reducer:     A Reducer function
    ///
    /// - returns: A Dispatcher built with the default dispatcher and the given Middlewares
    public static func combine(middlewares: [Middleware], with reducer: @escaping Reducer) -> Dispatcher {
        return self.combine(
            middlewares: middlewares,
            with: self.defaultDispatcher(with: reducer)
        )
    }

    /// Combines *Middlewares* with a *Reducer*
    ///
    /// - parameter middlewares: An array of Middlewares
    /// - parameter dispatcher:  A Dispatcher
    ///
    /// - returns: A Dispatcher with the given dispatcher and the Middlewares
    public static func combine(middlewares: [Middleware], with dispatcher: @escaping Dispatcher) -> Dispatcher {
        return middlewares
            .reversed()
            .reduce(dispatcher) { dispatcher, middleware in
                middleware(dispatcher)
        }
    }
}

// MARK: - Default Dispatcher
extension Store {

    /// The default dispatcher factory method
    /// It will use the given *Reducer* to reduce new states and
    /// also notify subscirbers the new states.
    ///
    /// - parameter reducer: A Reducer function
    ///
    /// - returns: A Dispatcher
    public static func defaultDispatcher(with reducer: @escaping Reducer) -> Dispatcher {
        return { (store: Store, action: Action) in
            store.state = reducer(store.state, action)
            store.subscribers.forEach {
                $0(store)
            }
        }
    }
}
