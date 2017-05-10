import XCTest
import spec

import TDRedux

func storeSpec() {
    describe("Store") {
        var store: Store<ToDoState>!

        $0.context("when created") {
            $0.before { store = Store<ToDoState>.init(with: todoReducer) }
            $0.it("has the initial state") { expect(store.state) == ToDoState.initial }
        }
    }
}

class StoreTests: XCTestCase {
    func testStore() {
        storeSpec()
    }
}
