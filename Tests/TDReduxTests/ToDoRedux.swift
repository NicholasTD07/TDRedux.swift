import TDRedux

typealias ToDo = String

struct ToDoState: Equatable {
    enum Action: TDRedux.Action {
        case addToDo(ToDo)
        case filter(with: Filter)
    }
    enum AsyncAction: TDRedux.Action {
        case startedFetching
        case fetched(todos: [ToDo])
        case failed
    }
    enum Filter {
        case all
        case done
    }
    enum FetchState {
        case initial
        case started
        case fetched
        case failed
    }

    let todos: [ToDo]
    let filter: Filter
    let fetchStates: [FetchState]

    static let initial = ToDoState(todos: [], filter: .all, fetchStates: [.initial])

    static func == (rhs: ToDoState, lhs: ToDoState) -> Bool {
        return rhs.todos == lhs.todos && rhs.filter == lhs.filter
    }
}

let reducer = combine(reducers: [todoReducer, ayncReducer])

private let todoReducer = Reducer(initialState: ToDoState.initial) {
    (state, action: ToDoState.Action) -> ToDoState in
    switch action {
    case let .addToDo(todo):
        return ToDoState(
            todos: state.todos + [todo],
            filter: state.filter,
            fetchStates: state.fetchStates
        )
    case let .filter(filter):
        return ToDoState(
            todos: state.todos,
            filter: filter,
            fetchStates: state.fetchStates
        )
    }
}

private let ayncReducer = Reducer(initialState: ToDoState.initial) {
    (state, action: ToDoState.AsyncAction) -> ToDoState in
    switch action {
    case .startedFetching:
        return ToDoState(
            todos: state.todos,
            filter: state.filter,
            fetchStates: state.fetchStates + [.started]
        )
    case let .fetched(todos):
        return ToDoState(
            todos: state.todos + todos,
            filter: state.filter,
            fetchStates: state.fetchStates + [.fetched]
        )
    case .failed:
        return ToDoState(
            todos: state.todos,
            filter: state.filter,
            fetchStates: state.fetchStates + [.failed]
        )
    }
}

func fetchToDosRemotely(_ dispatch: @escaping Store<ToDoState>.Dispatch) {
    dispatch(ToDoState.AsyncAction.startedFetching)

    let remoteFetching = {
        dispatch(ToDoState.AsyncAction.fetched(todos: ["remote todo"]))
    }

    remoteFetching()
}
