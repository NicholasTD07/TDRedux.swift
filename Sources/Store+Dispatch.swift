//
//  Store+Dispatch.swift
//  TDRedux
//
//  Created by Nicholas Tian on 20/10/2016.
//  Copyright © 2016 nicktd. All rights reserved.
//

extension Store {

    /// Dispatches the given *Action* to its binded *Store*
    ///
    /// - parameter action: An Action dispatched to the Store
    ///
    /// - returns: Void
    public typealias Dispatch = (_ action: Action) -> ()

    /// Async actions which will call the dispatch function
    ///
    /// - parameter dispatch: a Dispatch function
    ///
    /// - returns: Void
    public typealias AsyncAction = (_ dispath: @escaping Store.Dispatch) -> ()


    /// Dispatches *AsyncActions*
    ///
    /// - parameter action: An AsyncAction
    public func dispatch(asyncAction action: AsyncAction) {
        action(dispatch)
    }
}
