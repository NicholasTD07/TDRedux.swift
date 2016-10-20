//
//  Store+Subscribe.swift
//  TDRedux
//
//  Created by Nicholas Tian on 18/10/2016.
//  Copyright © 2016 nicktd. All rights reserved.
//

extension Store {

    /// Subscribe to changes of a *Store*'s *State*
    ///
    /// - parameter state:  A State
    ///
    /// - returns: Void
    public typealias StateSubscriber = (_ state: State) -> ()

    /// Subcribes a *StateSubscriber* (takes a *State* rather than a *Store*)
    /// to the changes of a *Store*'s *State*
    ///
    /// - parameter subscriber: A StateSubscriber function
    public func subscribe(with subscriber: @escaping StateSubscriber) {
        self.subscribe { store in
            subscriber(store.state)
        }
    }

    /// Subcribes a *SpecificStateSubscriber* (takes a *SpecificState*)
    /// to the changes of a *Store*'s *State*
    /// with the help of a `Converter`
    ///
    /// - parameter converter:  A function converts State to SpecificState
    /// - parameter subscriber: A SpecificStateSubscriber function
    public func subscribe<SpecificState>(
        withConverter converter: @escaping (State) -> SpecificState,
        subscriber: @escaping (SpecificState) -> ()
    ) {
        self.subscribe { state in
            subscriber(converter(state))
        }
    }
}
