//
//  SubscribeExtensionSpecs.swift
//  TDRedux
//
//  Created by Nicholas Tian on 18/10/2016.
//  Copyright © 2016 nicktd. All rights reserved.
//

import Quick
import Nimble

import TDRedux

class SubscribeExtensionSpecs: QuickSpec {
    override func spec() {
        describe("Subscriber") {
            var store: Store<ToDoState>!

            beforeEach {
                store = Store<ToDoState>.init(with: reducer)
            }

            context("when subscribed with a converter") {
                var todos: [ToDoState.ToDo]!

                beforeEach {
                    store.subscribe(withConverter: { $0.todos }) { storesToDos in
                        todos = storesToDos
                    }
                }

                context("when the store's state changed") {
                    beforeEach {
                        store.dispatch(ToDoActions.addToDo(title: "go buy me milk"))
                    }

                    it("gets the change") {
                        expect(todos).to(contain("go buy me milk"))
                    }
                }

            }

            context("when subscribed to a store's state") {
                var state: ToDoState!

                beforeEach {
                    store.subscribe { storesState in
                        state = storesState
                    }
                }

                context("when the store's state changed") {
                    beforeEach {
                        store.dispatch(ToDoActions.addToDo(title: "go buy me milk"))
                    }

                    it("gets the change") {
                        expect(state.todos).to(contain("go buy me milk"))
                    }
                }
            }

            context("when subscribed to a store's state") {
                var called: Bool!

                beforeEach {
                    called = false
                    store.subscribe {
                        called = true
                    }
                }

                context("when the store's state changed") {
                    beforeEach {
                        store.dispatch(ToDoActions.addToDo(title: "go buy me milk"))
                    }

                    it("gets the change") {
                        expect(called).to(beTrue())
                    }
                }
            }

        }
    }
}

private let reducer = Reducer(initialState: ToDoState.initial) {
    (state, action: ToDoActions) -> ToDoState in
    switch action {
    case .addToDo(let todo):
        return ToDoState(todos: state.todos + [todo], filter: state.filter)
    case .filter(let filter):
        return ToDoState(todos: state.todos, filter: filter)
    }
}

private enum ToDoActions {
    case addToDo(title: String)
    case filter(with: Filter)
}

private enum Filter {
    case todo
    case all
    case done
    case archived
}

private struct ToDoState {
    typealias ToDo = String

    let todos: [ToDo]
    let filter: Filter

    static let initialToDos = [ToDo]()
    static let initial = ToDoState(todos: initialToDos, filter: .all)
}
