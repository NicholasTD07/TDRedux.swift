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

class StoreTests: XCTestCase {
    func testStore() {
        storeSpec()
    }
}
