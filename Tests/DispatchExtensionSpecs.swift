//
//  DispatchExtensionSpecs.swift
//  TDRedux
//
//  Created by Nicholas Tian on 20/10/2016.
//  Copyright © 2016 nicktd. All rights reserved.
//

import Quick
import Nimble

import TDRedux

var started: Bool = false

class DispatchExtensionSpecs: QuickSpec {
    override func spec() {
        describe("Dispatching async actions") {
            var store: Store!

            beforeEach {
                store = Store.init(with: reducer)
                started = false
            }

            context("when dispatched fetchPosts successfully") {
                beforeEach {
                    store.dispatch(asyncAction: fetchPosts)
                }

                it("starts immediately") {
                    expect(started).to(beTrue())
                }

                it("success after 0.1 seconds") {
                    expect(store.state.posts).to(beEmpty())
                    expect(store.state.posts).toEventually(
                        equal([
                            "post 1",
                            "post 2",
                            "post 3",
                            ]),
                        timeout: 0.1
                    )
                }
            }
        }
    }
}

private typealias Store = TDRedux.Store<State>

private let reducer = TDRedux.Reducer(initialState: State.initial) {
    (state, action: Actions) in
    switch action {
    case let .fetchPosts(action):
        switch action {
        case .start:
            started = true

            return state
        case let .success(posts):
            return State(posts: posts, error: nil)
        case let .failed(error):
            return State(posts: [], error: error)
        }
    }
}

private func fetchPosts(dispatch: @escaping Store.Dispatch) {
    dispatch(Actions.fetchPosts(.start))

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        dispatch(Actions.fetchPosts(.success(posts: [
            "post 1",
            "post 2",
            "post 3",
        ])))
    }
}

private struct State {
    static let initial = State(posts: [], error: nil)

    let posts: [String]
    let error: String?
}

private enum Actions {
    enum FetchPosts {
        case start
        case success(posts: [String])
        case failed(error: String)
    }

    case fetchPosts(FetchPosts)
}
