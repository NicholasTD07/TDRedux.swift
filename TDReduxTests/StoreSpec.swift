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
        // swiftlint:disable nesting
        // FIXME/DISCUSSION: Should I move these nested definitions elsewhere?
        //  Possible places:
        //      - Before StoreSpec
        //          - still takes a lot space before the actual tests
        //      - After StoreSpec:
        //          - clean but have to cmd-click to find out where they are
        //      - Another file
        //          - even harder to find/switch back and forth
        enum CounterActions: TDRedux.Action {
            case increase
            case decrease
        }

        typealias State = Int
        typealias IntStore = TDRedux.Store<State>

        let counterReducer = Reducer(initialState: 0) {
            (state: State, action: CounterActions) -> Int in
            switch action {
            case .increase:
                return state + 1
            case .decrease:
                return state - 1
            }
        }
        // swiftlint:enable nesting

        describe("Store") {
            var store: IntStore!

            beforeEach {
                store = IntStore.init(with: counterReducer)
            }

            context("when first created") {
                it("has a initial state") {
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

            context("when subscribed to a store") {
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
