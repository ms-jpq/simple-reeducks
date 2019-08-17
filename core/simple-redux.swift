import Dispatch


public typealias Reducer<State> =
  (State, Any) -> State

public typealias Fetch<State> =
  () -> State

public typealias Dispatch =
  (Any) -> Void

public typealias Middleware<State> =
  (@escaping Fetch<State>, @escaping Dispatch) -> Dispatch

public typealias Subscribe<State> =
  (DispatchQueue, @escaping (State) -> Void) -> () -> Void


public typealias Store<State> = (
  fetch: Fetch<State>,
  dispatch: Dispatch,
  subscribe: Subscribe<State>)

/*
 * Creates a bonafide Classless Redux Store ☭ ☭ ☭
 *
 * -- NOTE -- Cannot use initialize with main queue, or global queue
 */

public func NewStore <State>(
  initial: State,
  reducer: @escaping Reducer<State>,
  middleware: Middleware<State> = { _, dispatch in dispatch },
  queue: DispatchQueue = DispatchQueue(label: "redux-queue", qos: .userInteractive))
  -> Store<State> {
    
    var (state, subs) = (initial, [(id: Int, q: DispatchQueue, callback: (State) -> Void)]())
    
    let fetch: Fetch<State> = { queue.sync { state }}
    
    let dispatch: Dispatch = middleware(fetch) { action in
      queue.async {
        state = reducer(state, action)
        subs.forEach { (_, q, callback) in
          q.async { callback(state) }}}}
    
    let subscribe: Subscribe<State> = { q, sub in
      queue.sync {
        let id = (subs.max { $0.id < $1.id }?.id ?? 0) + 1
        subs += [(id, q, sub)]
        return { queue.sync { subs.removeAll { $0.id == id }}}}}
    
    return (fetch, dispatch, subscribe)}


/*
 * Combine reducer1, reducer2, reducer3... and so on
 * into a single reducer
 */

public func ApplyReducers <State>(_ reducers: Reducer<State>...)
  -> Reducer<State> {
    return { prevState, action in
      reducers.reduce(prevState) { state, reducer in
        reducer(state, action) }}}


/*
 * Combine middleware1, middleware2, middleware3... and so on
 * into a single middleware
 */

public func ApplyMiddlewares <State>(_ fst: @escaping Middleware<State>,
                                     _ rest: Middleware<State>...)
  -> Middleware<State> {
    let middlewares = rest.reversed() + [fst]
    let m1 = middlewares.last ?? fst
    let m = middlewares.dropLast()
    return { fetch, dispatch in
      m.reduce(m1(fetch, dispatch)) { $1(fetch, $0) }}}
