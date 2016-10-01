//
//  MiddlewareSpec.swift
//  TDRedux
//
//  Created by Nicholas Tian on 1/10/2016.
//  Copyright © 2016 nicktd. All rights reserved.
//

import Quick
import Nimble

import TDRedux

private typealias Store = TDRedux.Store<Int>
private struct SomeAction: Action { }

class MiddlewareSpec: QuickSpec {
    override func spec() {
        describe("Middleware") {
            var store: Store!

            context("when a store is created") {
                var reducedState: Int!
                var dispatchedAction: Action!

                let recoder: Store.Middleware = { dispatcher in
                    return { store, action in
                        dispatchedAction = action
                        dispatcher(store, action)
                        reducedState = store.state
                    }
                }

                beforeEach {
                    store = Store.init(
                        with: Reducer(initialState: 0) { (_, _: SomeAction) in
                            return 100
                        },
                        middlewares: [recoder]
                    )
                }

                it("gets the initial action") {
                    // swiftlint:disable force_cast
                    expect(dispatchedAction as! InitialAction).toNot(beNil())
                    // swiftlint:enable force_cast
                }

                context("when dispatched an action") {
                    beforeEach {
                        store.dispatch(SomeAction())
                    }

                    it("gets the action") {
                        // swiftlint:disable force_cast
                        expect(dispatchedAction as! SomeAction).toNot(beNil())
                        // swiftlint:enable force_cast
                    }

                    it("gets the reduced state") {
                        expect(reducedState) == 100
                    }
                }
            }


            context("when dispatched an action") {
                var middlewares = [String]()

                func record(with identifier: String) -> Store.Middleware {
                    return { dispatch in
                        return { store, action in
                            middlewares.append(identifier)
                            dispatch(store, action)
                        }
                    }
                }

                store = Store.init(
                    with: Reducer(initialState: 0) { (state, action: Action) in return state },
                    middlewares: [
                        record(with: "a"),
                        record(with: "b"),
                        record(with: "c"),
                    ]
                )

                // Why no setup code / beforeEach?
                // Because the store will dispatch the InitialAction when created.

                it("middlewares are called in order") {
                    expect(middlewares).to(equal(["a", "b", "c"]))
                }
            }
        }
    }
}
