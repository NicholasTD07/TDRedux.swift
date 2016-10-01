//
//  Store.swift
//  TDRedux
//
//  Created by Nicholas Tian on 24/09/2016.
//  Copyright © 2016 nicktd. All rights reserved.
//

public final class Store<State> {
    public private(set) final var state: State
    public final var subscribers = [Subscriber]()

    private var dispatcher: Dispatcher

    public init(with reducer: @escaping Reducer, middlewares: [Middleware] = []) {
        self.state = reducer(nil, InitialAction())

        let dispatcher = { (store: Store, action: Action) in
            store.state = reducer(store.state, action)
            store.subscribers.forEach {
                $0(store)
            }
        }

        self.dispatcher = middlewares
            .reversed()
            .reduce(dispatcher) { dispatcher, middleware in
                middleware(dispatcher)
            }
    }


    public func dispatch(_ action: Action) {
        dispatcher(self, action)
    }

    public final func subscribe(with subscriber: @escaping Subscriber) {
        subscribers.append(subscriber)
        subscriber(self)
    }

    public typealias Dispatcher = (Store, Action) -> Void
    public typealias Middleware = (Dispatcher) -> Dispatcher
    public typealias Subscriber = (Store) -> ()
    public typealias Reducer = (State?, Action) -> State
}
