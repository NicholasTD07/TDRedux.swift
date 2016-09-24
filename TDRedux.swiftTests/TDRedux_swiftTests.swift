//
//  TDRedux_swiftTests.swift
//  TDRedux.swiftTests
//
//  Created by Nicholas Tian on 24/09/2016.
//  Copyright © 2016 nicktd. All rights reserved.
//

import XCTest
import TDRedux

class TDRedux_swiftTests: XCTestCase {
    enum CounterActions: Action {
        case Increase
        case Decrease
    }

    let counterReducer = Reducer(initialState: 0) { (state: Int, action: CounterActions) -> Int in
        print("counter reducer")

        switch action {
        case .Increase:
            return state + 1
        case .Decrease:
            return state - 1
        }
    }

    var counterStore: Store<Int>!

    override func setUp() {
        counterStore = Store<Int>.init(with: counterReducer)
    }

    func testBasics() {
        _test()
    }

    func testNoopCombineReducers() {
        struct SomeAction: Action { }

        // This will never be executed because of its SomeAction type.
        let someReducer = Reducer(initialState: 0) { (state: Int, action: SomeAction) -> Int in
            return -1
        }

        let combinedReducers = combineReducers([counterReducer, someReducer])

        self.counterStore = Store<Int>.init(with: combinedReducers)

        _test()
    }

    func _test() {
        // initial state is 0
        XCTAssert(counterStore.state == 0)

        // dispatch unknown actions does not affect the state
        counterStore.dispatch(InitialAction())
        XCTAssert(counterStore.state == 0)

        // dispatch Increase will increase the state
        counterStore.dispatch(CounterActions.Increase)
        XCTAssert(counterStore.state == 1)

        // dispatch Decrease will increase the state
        counterStore.dispatch(CounterActions.Decrease)
        XCTAssert(counterStore.state == 0)

        var counter: Int = -1000
        counterStore.subscribe { (store: Store<Int>) in
            counter = store.state
        }
        XCTAssert(counter == counterStore.state)

        // when state is updated, subscirbers will get notified of the new state
        counterStore.dispatch(CounterActions.Increase)
        XCTAssert(counter == counterStore.state)
    }
}
