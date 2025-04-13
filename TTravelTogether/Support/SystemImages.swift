import UIKit

enum SystemImages {

    case slashedEye(Bool)

    var image: UIImage {
        switch self {
        case .slashedEye(let isSlashed):
            UIImage(systemName: isSlashed ? "eye.slash" : "eye")!
        }
    }
}
