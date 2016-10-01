//
//  CombineReducersSpec.swift
//  TDRedux
//
//  Created by Nicholas Tian on 1/10/2016.
//  Copyright © 2016 nicktd. All rights reserved.
//

import Quick
import Nimble

import TDRedux

class CombineReducersSpec: QuickSpec {
    // swiftlint:disable function_body_length
    override func spec() {
        // swiftlint:disable nesting
        enum Reducers: String {
            case a
            case b
            case anotherA
        }

        struct ActionA: Action { }
        struct ActionB: Action { }
        // swiftlint:enable nesting

        describe("combineReducers") {
            var calledReducers: [Reducers]!

            let aReducer = Reducer(initialState: 0) {
                (state, action: ActionA) in
                calledReducers.append(.a)
                return state
            }

            let bReducer = Reducer(initialState: 0) {
                (state, action: ActionB) in
                calledReducers.append(.b)
                return state
            }

            let anotherAReducer = Reducer(initialState: 0) {
                (state, action: ActionA) in
                calledReducers.append(.anotherA)
                return state
            }

            let store = Store<Int>.init(with: combineReducers(
            [
                aReducer,
                bReducer,
                anotherAReducer,
            ]))

            beforeEach {
                calledReducers = []
            }

            context("when dispatched ActionA to a store") {
                beforeEach {
                    store.dispatch(ActionA())
                }

                it("aReducer is called") {
                    expect(calledReducers).to(contain(Reducers.a))
                }

                it("bReducer is not called") {
                    expect(calledReducers).toNot(contain(Reducers.b))
                }

                it("anotherAReducer is called") {
                    expect(calledReducers).to(contain(Reducers.anotherA))
                }
            }

            context("when dispatched ActionB to a store") {
                beforeEach {
                    store.dispatch(ActionB())
                }

                it("aReducer is not called") {
                    expect(calledReducers).toNot(contain(Reducers.a))
                }

                it("bReducer is called") {
                    expect(calledReducers).to(contain(Reducers.b))
                }

                it("anotherAReducer is not called") {
                    expect(calledReducers).toNot(contain(Reducers.anotherA))
                }
            }
        }
    }
    // swiftlint:enable function_body_length
}
