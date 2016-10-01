//
//  StoreSpec.swift
//  TDRedux
//
//  Created by Nicholas Tian on 1/10/2016.
//  Copyright © 2016 nicktd. All rights reserved.
//

import Quick
import Nimble

import TDRedux

class StoreSpec: QuickSpec {
    // swiftlint:disable function_body_length
    override func spec() {
        // NOTE: IntStore, counterReducer and CounterActions
        //       are defined in the bottom of this file
        describe("Store") {
            var store: IntStore!

            beforeEach {
                store = IntStore.init(with: counterReducer)
            }

            context("when first created") {
                it("has zero as its initial state") {
                    expect(store.state) == 0
                }
            }

            context("when dispatched an increase action") {
                beforeEach {
                    store.dispatch(CounterActions.increase)
                }

                it("has one as its state") {
                    expect(store.state) == 1
                }
            }

            context("when dispatched an decrease action") {
                beforeEach {
                    store.dispatch(CounterActions.decrease)
                }

                it("has minus one as its state") {
                    expect(store.state) == -1
                }
            }
        }

        describe("Subscriber") {
            var store: IntStore!
            var state: State!

            beforeEach {
                state = -999
                store = IntStore.init(with: counterReducer)
                store.subscribe { store in
                    state = store.state
                }
            }

            context("when subscribs to a store") {
                it("gets the state in the store") {
                    expect(state) == store.state
                }
            }

            context("when dispatched an action to a store") {
                beforeEach {
                    store.dispatch(CounterActions.increase)
                }

                it("gets the state in the store") {
                    expect(state) == store.state
                }
            }
        }
    }
    // swiftlint:enable function_body_length
}

private enum CounterActions: TDRedux.Action {
    case increase
    case decrease
}

private typealias State = Int
private typealias IntStore = TDRedux.Store<State>

private let counterReducer = Reducer(initialState: 0) {
    (state: State, action: CounterActions) -> Int in
    switch action {
    case .increase:
        return state + 1
    case .decrease:
        return state - 1
    }
}
