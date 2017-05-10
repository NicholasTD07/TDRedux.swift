import XCTest
import spec

import TDRedux

func storeSpec() {
    describe("Store") {
        var store: Store<ToDoState>!

        $0.context("when created") {
            $0.before { store = Store<ToDoState>.init(with: todoReducer) }

            $0.it("has the initial state") { expect(store.state) == ToDoState.initial }

            $0.context("when dispatched action to add a todo") {
                $0.before { store.dispatch(ToDoState.Action.addToDo("get milk")) }

                $0.it("has the todo") { expect(store.state.todos).to.contain("get milk") }
            }
        }
    }
}

func subscriberSpec() {
    describe("Subscriber") {
        var store: Store<ToDoState>!

        $0.before { store = Store<ToDoState>.init(with: todoReducer) }

        // There is a few ways to subscribe to a store, e.g. when there is a change
        // 1. subscribe to get a store
        // 2. subscribe to get a store's state
        // 3. subscribe with a converter to get a converted state
        // 4. subscribe with a block takes no param

        $0.context("when subscribes to get a store") {
            var state: ToDoState?

            $0.before { state = nil }
            $0.before { store.subscribe { state = $0.state } }

            $0.it("gets store's state") { expect(state) == store.state }

            $0.context("when state changes") {
                $0.before { store.dispatch(ToDoState.Action.addToDo("get milk")) }

                $0.it("gets the change") { expect(state!.todos).toNot.beEmpty() }
            }
        }

        $0.context("when subscribes to get a store's state") {
            var state: ToDoState?

            $0.before { state = nil }
            $0.before { store.subscribe { state = $0 } }

            $0.it("gets store's state") { expect(state) == store.state }

            $0.context("when state changes") {
                $0.before { store.dispatch(ToDoState.Action.addToDo("get milk")) }

                $0.it("gets the change") { expect(state!.todos).toNot.beEmpty() }
            }
        }

        $0.context("when subscribes to get todos") {
            var todos: [ToDo]?

            $0.before { todos = nil }
            $0.before { store.subscribe(withConverter: { $0.todos }) { todos = $0 } }

            $0.it("gets store's state") { expect(todos) == store.state.todos }

            $0.context("when state changes") {
                $0.before { store.dispatch(ToDoState.Action.addToDo("get milk")) }

                $0.it("gets the change") { expect(todos!).toNot.beEmpty() }
            }
        }

        $0.context("when subscribes with a block") {
            var called: Int!

            $0.before { called = 0 }
            $0.before { store.subscribe { called! += 1 } }

            $0.it("gets store's state") { expect(called) == 1 }

            $0.context("when state changes") {
                $0.before { store.dispatch(ToDoState.Action.addToDo("get milk")) }

                $0.it("gets the change") { expect(called) == 2 }
            }
        }
    }
}

class TDReduxTests: XCTestCase {
    func testStore() {
        storeSpec()
        subscriberSpec()
    }
}
