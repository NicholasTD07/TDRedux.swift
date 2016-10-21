//
//  Store+Dispatch.swift
//  TDRedux
//
//  Created by Nicholas Tian on 20/10/2016.
//  Copyright © 2016 nicktd. All rights reserved.
//

extension Store {

    /// Dispatches *AsyncActions*
    ///
    /// - parameter action: An AsyncAction
    public func dispatch(asyncAction action: AsyncAction) {
        action(dispatch)
    }
}
