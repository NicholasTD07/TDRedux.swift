//
//  Store.swift
//  TDRedux
//
//  Created by Nicholas Tian on 24/09/2016.
//  Copyright © 2016 nicktd. All rights reserved.
//

public final class Store<State> {
    public final var state: State
    public final let reducer: Reducer
    public final var subscribers = [Subscriber]()

    public init(with reducer: @escaping Reducer) {
        self.state = reducer(nil, InitialAction())
        self.reducer = reducer
    }


    public final func dispatch(_ action: Action) {
        self.state = reducer(state, action)
        subscribers.forEach {
            $0(self)
        }
    }

    public final func subscribe(with subscriber: @escaping Subscriber) {
        subscribers.append(subscriber)
        subscriber(self)
    }

    public typealias Subscriber = (Store) -> ()
    public typealias Reducer = (State?, Action) -> State
}
