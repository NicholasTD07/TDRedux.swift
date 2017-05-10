import TDRedux

typealias ToDo = String

struct ToDoState: Equatable {
    enum Action: TDRedux.Action {
        case addToDo(ToDo)
        case filter(with: Filter)
    }
    enum Filter {
        case all
        case done
    }

    let todos: [ToDo]
    let filter: Filter

    static let initial = ToDoState(todos: [], filter: .all)

    static func == (rhs: ToDoState, lhs: ToDoState) -> Bool {
        return rhs.todos == lhs.todos && rhs.filter == lhs.filter
    }
}

let todoReducer = Reducer(initialState: ToDoState.initial) {
    (state, action: ToDoState.Action) -> ToDoState in
    switch action {
    case let .addToDo(todo): return ToDoState(todos: state.todos + [todo], filter: state.filter)
    case let .filter(filter): return ToDoState(todos: state.todos, filter: filter)
    }
}
