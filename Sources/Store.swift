//
//  Store.swift
//  TDRedux
//
//  Created by Nicholas Tian on 24/09/2016.
//  Copyright © 2016 nicktd. All rights reserved.
//

// MARK: - Types
extension Store {
    public typealias Dispatcher = (Store, Action) -> Void
    public typealias Middleware = (@escaping Dispatcher) -> Dispatcher
    public typealias Subscriber = (Store) -> ()
    public typealias Reducer = (State?, Action) -> State
}

// MARK: - Store
public final class Store<State> {
    public fileprivate(set) final var state: State
    public final var subscribers = [Subscriber]()

    private var dispatcher: Dispatcher

    public init(with reducer: @escaping Reducer, middlewares: [Middleware] = []) {
        self.state = reducer(nil, InitialAction())

        self.dispatcher = Store.combine(middlewares: middlewares, with: reducer)

        // NOTE: Dispatching `InitialAction` the second time
        //          to update middlewares with this action and initial state.
        //          Because no reducers **should** handle `InitialAction`,
        //          This should have no effect on the state and store.
        self.dispatch(InitialAction())
    }

    public func dispatch(_ action: Action) {
        dispatcher(self, action)
    }

    public final func subscribe(with subscriber: @escaping Subscriber) {
        subscribers.append(subscriber)
        subscriber(self)
    }
}

// MARK: - Combining Middlewares
extension Store {
    public static func combine(middlewares: [Middleware], with reducer: @escaping Reducer) -> Dispatcher {
        return self.combine(
            middlewares: middlewares,
            with: self.defaultDispatcher(with: reducer)
        )
    }

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
    public static func defaultDispatcher(with reducer: @escaping Reducer) -> Dispatcher {
        return { (store: Store, action: Action) in
            store.state = reducer(store.state, action)
            store.subscribers.forEach {
                $0(store)
            }
        }
    }
}