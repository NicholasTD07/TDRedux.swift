//
//  ReducerHelpers.swift
//  TDRedux
//
//  Created by Nicholas Tian on 24/09/2016.
//  Copyright © 2016 nicktd. All rights reserved.
//

/// Wraps reducers taking non-optional `State` and `SpecificActionType`
/// to take optional `State` and `Any` as its `action` param
///
/// The returned reducer function will return
///   - `initialState` when `state` is nil
///   - current `state` when `action` is not of type `SpecificActionType`
///   - return value of the wrapped reducer function when both `state` is not nil
///     AND `action` is of type `SpecificActionType`
///
/// - parameter initialState: the initial State for the Reducer passed in
/// - parameter reducer:      the Reducer function being wrapped
///
/// - returns: A reducer function
public func Reducer<State, SpecificActionType>(
    initialState: State,
    reducer: @escaping (State, SpecificActionType) -> State
    ) -> (State?, Any) -> State {
    return { (state: State?, action: Any) -> State in
        guard let state = state else { return initialState }
        guard let action = action as? SpecificActionType else { return state }

        return reducer(state, action)
    }
}

/// Takes an array of `Reducer`s and combine them into one
///
/// - parameter reducers: an array of `Reducer`s who takes and returns the same type of `State`
///
/// - returns: A Reducer function
public func combineReducers<State>(
    _ reducers: [(State?, Any) -> State]) -> (State?, Any
    ) -> State {
    return { (state: State?, action: Any) -> State in
        return reducers.reduce(state) { (state, reducer) -> State! in
            return reducer(state, action)
        }
    }
}
