//
//  Store+Subscribe.swift
//  TDRedux
//
//  Created by Nicholas Tian on 18/10/2016.
//  Copyright © 2016 nicktd. All rights reserved.
//

extension Store {
    public typealias StateSubscriber = (_ state: State) -> ()

    public func subscribe(with subscriber: @escaping StateSubscriber) {
        self.subscribe { store in
            subscriber(store.state)
        }
    }

    public func subscribe<SpecificState>(
        with convertor: @escaping (State) -> SpecificState,
        subscriber: @escaping (SpecificState) -> ()
    ) {
        self.subscribe { state in
            subscriber(convertor(state))
        }
    }
}
