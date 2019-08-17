import Foundation


/*
 * Classic Redux Example
 * of a simple up / down counter
 *
 * Except instead of a webpage with buttons
 * You get a basic console app.
 */


struct State {
  var counter: Int }


enum Action {

  case up(_ value: Int)   // Inc by <value>
  case down(_ value: Int) // Dec by <value>

  // Inc by 10 after 1 sec :: Async ThunkAction
  static let asyncUp: ThunkAction<State> = { _, dispatch in
    DispatchQueue.global().asyncAfter(deadline: .now() + 1) { dispatch(Action.up(10)) }}

  // Dec by 10 after 1 sec :: Async ThunkAction
  static let asyncDown: ThunkAction<State> = { _, dispatch in
    DispatchQueue.global().asyncAfter(deadline: .now() + 1) { dispatch(Action.down(10)) }}}


let reducer: Reducer<State> = { _state, action in
  var state = _state
  switch (action as? Action) {
  case let .up(value)?:
    state.counter += value
  case let .down(value)?:
    state.counter -= value
  default: () }
  return state }


let store = NewStore(
  initial: State(counter: 0),
  reducer: reducer,
  middleware: ApplyMiddlewares(LoggerMiddleware, ThunkMiddleware))


/*
  * The subscription queue has to be something other than main queue
  * for console app.
  *
  * For iOS apps, this does not matter.
  */
_ = store.subscribe(.global()) { state in
  print("New State : \(state)")}


let tooltip =
"""
-- Options --
1 ⏎ to increment by 1 synchronously
2 ⏎ to decrement by 1 synchronously
3 ⏎ to increment by 10 asynchronously after 1 second
4 ⏎ to decrement by 10 asynchronously after 1 second
** Any other keys ⏎ to exit **
"""

func next (_ dispatch: Dispatch)
  -> Void {
    switch (Int(readLine() ?? "")) {
    case 1: dispatch(Action.up(1))
    case 2: dispatch(Action.down(1))
    case 3: dispatch(Action.asyncUp)
    case 4: dispatch(Action.asyncDown)
    default: return }
    next(dispatch) }


print(tooltip)
next(store.dispatch)
