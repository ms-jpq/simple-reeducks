public typealias ThunkAction<State> = (@escaping Fetch<State>, @escaping Dispatch) -> Void


/*
 * ThunkAction for handling basic side effects, ie. IO or Async
 */

public func ThunkMiddleware <State>(_ fetch: @escaping Fetch<State>,
                                    dispatch: @escaping Dispatch)
  -> Dispatch {
    return { action in
      (action as? ThunkAction<State>)
        .map { $0(fetch, dispatch) } ?? dispatch(action) }}
