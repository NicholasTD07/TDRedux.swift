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

class DispatchExtensionSpecs: QuickSpec {
    override func spec() {
        describe("Dispatching async actions") {
            var store: Store!

            beforeEach {
                store = Store.init(with: reducer)
            }

            context("when dispatched fetchPosts successfully") {
                beforeEach {
                    store.dispatch(asyncAction: fetchPostsSuccessfully)
                }

                it("starts immediately") {
                    expect(store.state.started).to(beTrue())
                }

                it("success after 0.1 seconds") {
                    expect(store.state.posts).to(beEmpty())
                    expect(store.state.posts).toEventually(
                        equal([
                            "post 1",
                            "post 2",
                            "post 3",
                            ]),
                        timeout: 0.15
                    )
                }
            }

            context("when dispatched fetchPosts but failed") {
                beforeEach {
                    store.dispatch(asyncAction: fetchPostsFailed)
                }

                it("starts immediately") {
                    expect(store.state.started).to(beTrue())
                }

                it("success after 0.1 seconds") {
                    expect(store.state.error).to(beNil())
                    expect(store.state.error).toNotEventually(
                        beNil(),
                        timeout: 0.15
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
            return State(started: true, posts: [], error: nil)
        case let .success(posts):
            return State(started: false, posts: posts, error: nil)
        case let .failed(error):
            return State(started: false, posts: [], error: error)
        }
    }
}

private func fetchPostsSuccessfully(dispatch: @escaping Store.Dispatch) {
    dispatch(Actions.fetchPosts(.start))

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        dispatch(Actions.fetchPosts(.success(posts: [
            "post 1",
            "post 2",
            "post 3",
        ])))
    }
}

private func fetchPostsFailed(dispatch: @escaping Store.Dispatch) {
    dispatch(Actions.fetchPosts(.start))

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        dispatch(Actions.fetchPosts(.failed(error: "ooops")))
    }
}

private struct State {
    static let initial = State(started: false, posts: [], error: nil)

    let started: Bool
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
