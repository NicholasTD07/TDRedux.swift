//
//  ReducerSpec.swift
//  TDRedux
//
//  Created by Nicholas Tian on 1/10/2016.
//  Copyright © 2016 nicktd. All rights reserved.
//

import Quick
import Nimble

import TDRedux

class ReducerSpec: QuickSpec {
    override func spec() {
        // swiftlint:disable nesting
        struct SpecificAction: Action { }
        struct SomeOtherAction: Action { }
        // swiftlint:enable nesting

        describe("Reducer") {
            var called: Bool!

            let store = Store<Int>.init(with: Reducer(initialState: 0) {
                (state: Int, action: SpecificAction) in
                called = true

                return state
            })

            beforeEach {
                called = nil
            }

            context("when dispatched specific action") {
                beforeEach {
                    store.dispatch(SpecificAction())
                }

                it("does get called") {
                    expect(called) == true
                }
            }

            context("when dispatched unknown action") {
                beforeEach {
                    store.dispatch(SomeOtherAction())
                }

                it("does not get called") {
                    expect(called).to(beNil())
                }
            }
        }
    }
}
