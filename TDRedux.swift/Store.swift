//
//  Store.swift
//  TDRedux.swift
//
//  Created by Nicholas Tian on 24/09/2016.
//  Copyright © 2016 nicktd. All rights reserved.
//

class Store<State> {
    var state: State
    typealias Reducer = (State?, Action) -> State
    final let reducer: Reducer

    init(with reducer: @escaping Reducer) {
        self.state = reducer(nil, InitialAction())
        self.reducer = reducer
    }

    typealias Subscriber = (Store) -> ()
    final var subscribers = [Subscriber]()

    final func dispatch(_ action: Action) {
        self.state = reducer(state, action)
        subscribers.forEach {
            $0(self)
        }
    }

    final func subscribe(with subscriber: @escaping Subscriber) {
        subscribers.append(subscriber)
        subscriber(self)
    }
}
