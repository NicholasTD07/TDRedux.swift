//
//  Store+Subscribe.swift
//  TDRedux
//
//  Created by Nicholas Tian on 18/10/2016.
//  Copyright © 2016 nicktd. All rights reserved.
//

extension Store {
    typealias StateSubscriber = (_ state: State) -> ()

    func subscribe(with subscriber: @escaping StateSubscriber) {
        self.subscribe { store in
            subscriber(store.state)
        }
    }

    func subscribe<SpecificState>(
        with convertor: @escaping (State) -> SpecificState,
        subscriber: @escaping (SpecificState) -> ()
    ) {
        self.subscribe { state in
            subscriber(convertor(state))
        }
    }
}
