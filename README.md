# [Simple-Reeducks 🦆🦆](https://ms-jpq.github.io/simple-reeducks/)

## An unceremonious, minimalist, and idiomatic Redux port

Reeducks 🦆🦆 is *[stupidly simple](https://github.com/crymetothemoon/simple-reeducks/blob/master/core/simple-redux.swift)*: It uses 3 things -- Functions, Closures, and Queues.

It's also classless ☭☭☭

## Trivial Example

Run `./demo.sh`: contains the following code

```swift
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


_ = store.subscribe(.main) { state in
  print("New State : \(state)")}
```

## Why not [ReSwift](https://github.com/ReSwift/ReSwift)?

1. Complexity & Ceremony: **Redux is stupidly simple**, ReSwift adds [unnecessary ceremony](https://github.com/ReSwift/ReSwift/tree/master/ReSwift/CoreTypes), with protocols and open classes.

2. Concurrency: ReSwift [Raises a `FatalError`](https://github.com/ReSwift/ReSwift/blob/master/ReSwift/CoreTypes/Store.swift) for concurrent modification. This should never happen when `Grand Central Dispatch` exists.

## Honest Opinion: Should you use Redux with Swift Apps?

Answer: Maybe?

I wrote about 10,000 lines of iOS / MacOS code with **Reeducks 🦆🦆**, and although Unidirectional Dataflow is very neat, it takes quite a bit of ceremony and discipline to keep the `Views` and `ViewControllers` stateless, especially with `TableViews` that uses `NSFetchedResultsController`.

Honestly I'd say its probably not worth it until the more declarative [SwiftUI](https://developer.apple.com/xcode/swiftui/) becomes the thing, and I will give **Reeducks 🦆🦆** another shot.

Swift's pattern match syntax also quite verbose compared to say `F#`, which has its own Unidirectional framework, and can be used to build both iOS and MacOS apps.
