import Foundation

enum NetworkErrors: Error {

    case detailTripFetchRequest

    var description: String {
        switch self {
        case .detailTripFetchRequest:
            return "Error during fetching requesr"
        }
    }
}
