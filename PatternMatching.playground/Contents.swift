import UIKit

struct Message{
    var isMarked: Bool
}

struct Database{
    func delete(_ message: Message){
        print("delete message")
    }
}

struct Player{
    var name: String
}

//MARK: - for where
let messages = [Message]()
let database = Database()

func deleteMarkedMessages() {
    for message in messages where message.isMarked {
        database.delete(message)
    }
}

//MARK: - for case let
struct Match {
    var startDate: Date
    var players: [Player?]
}
func makePlayerListView(for players: [Player?]) -> UIView {
    let view = UIView()
    for case let player? in players {
        print(player.name)
    }
    return view
}


//MARK: - Switching on optionals
struct ViewModel{
    var view: UIView
    var model: String
}

enum LoadingState {
    case loading
    case failed(Error)
}

func viewModel(_ viewModel: ViewModel,
               loadingStateDidChangeTo state: LoadingState?) {
    switch state {
    case nil:
        print("Case is nil")
    case .loading?:
        print("Case is loading")
    case .failed(let error)?:
        print("Case is error", error.localizedDescription)
    }
}

//MARK: Declarative error handling
enum HTTPError: Error{
    case unauthorized
    case other
}

func handle(_ error: Error) {
    switch error {
    // Matching against a group of offline-related errors:
    case URLError.notConnectedToInternet,
         URLError.networkConnectionLost,
         URLError.cannotLoadFromNetwork:
        print("Show offline error")
    // Matching against a specific error:
    case let error as HTTPError where error == .unauthorized:
        print("Logout from application")
    // Matching against our networking error type:
    case is HTTPError:
        print("Show default network error")
    // Fallback for other kinds of errors:
    default:
        print("Show generic network error")
    }
}

//Swift uses various overloads of the ~= operator to do pattern matching
func ~=<E: Error & Equatable>(rhs: E, lhs: Error) -> Bool {
    return (lhs as? E) == rhs
}

func handleMoreElegant(_ error: Error) {
    switch error {
    // Matching against a group of offline-related errors:
    case URLError.notConnectedToInternet,
         URLError.networkConnectionLost,
         URLError.cannotLoadFromNetwork:
        print("Show offline error")
    // Matching against a specific error:
    case HTTPError.unauthorized:
        print("Logout from application")
    // Matching against our networking error type:
    case is HTTPError:
        print("Show default network error")
    // Fallback for other kinds of errors:
    default:
        print("Show generic network error")
    }
}

let error = HTTPError.unauthorized
handleMoreElegant(error)
