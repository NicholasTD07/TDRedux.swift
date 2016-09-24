//
//  Store.swift
//  TDRedux.swift
//
//  Created by Nicholas Tian on 24/09/2016.
//  Copyright © 2016 nicktd. All rights reserved.
//

public class Store<State> {
    public var state: State
    public typealias Reducer = (State?, Action) -> State
    public final let reducer: Reducer

    public init(with reducer: @escaping Reducer) {
        self.state = reducer(nil, InitialAction())
        self.reducer = reducer
    }

    public typealias Subscriber = (Store) -> ()
    public final var subscribers = [Subscriber]()

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
}
