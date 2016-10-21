//
//  Store.swift
//  TDRedux
//
//  Created by Nicholas Tian on 24/09/2016.
//  Copyright © 2016 nicktd. All rights reserved.
//

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

    private final var dispatcher: Dispatcher

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
    public final func dispatch(_ action: Action) {
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
