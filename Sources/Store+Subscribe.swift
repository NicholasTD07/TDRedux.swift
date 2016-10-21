//
//  Store+Subscribe.swift
//  TDRedux
//
//  Created by Nicholas Tian on 18/10/2016.
//  Copyright © 2016 nicktd. All rights reserved.
//

extension Store {

    /// Subcribes a *StateSubscriber* (takes a *State* rather than a *Store*)
    /// to the changes of a *Store*'s *State*
    ///
    /// - parameter subscriber: A StateSubscriber function
    public final func subscribe(with subscriber: @escaping StateSubscriber) {
        self.subscribe { store in
            subscriber(store.state)
        }
    }


    /// The given *UpdateSubscriber* will be called
    /// when the *State* of a *Store* changes
    ///
    /// - parameter subscriber: An UpdateSubscriber
    public final func subscribe(with subscriber: @escaping UpdateSubscriber) {
        self.subscribe { (_: Store) in
            subscriber()
        }
    }

    /// Subcribes a *SpecificStateSubscriber* (takes a *SpecificState*)
    /// to the changes of a *Store*'s *State*
    /// with the help of a `Converter`
    ///
    /// - parameter converter:  A function converts State to SpecificState
    /// - parameter subscriber: A SpecificStateSubscriber function
    public final func subscribe<SpecificState>(
        withConverter converter: @escaping (State) -> SpecificState,
        subscriber: @escaping (SpecificState) -> ()
    ) {
        self.subscribe { state in
            subscriber(converter(state))
        }
    }
}
