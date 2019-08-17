import Foundation

public func LoggerMiddleware <State>(_ fetch: @escaping Fetch<State>,
                                     dispatch: @escaping Dispatch)
  -> Dispatch {
    let format = { format -> DateFormatter in
      format.timeStyle = .medium
      return format
    }(DateFormatter())
    
    let log = { (action: Any) in
      let txt =
      """
      
      -- Action \(format.string(from: Date())) --
      \(action)
      
      """
      print(txt) }
    
    return { action in
      log(action)
      dispatch(action) }}
