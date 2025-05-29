import Alamofire

extension HTTPHeaders {
    
    static func getAccessHeader(for token: String) -> HTTPHeaders {
        [.AppStrings.Network.accessTokenHeder: Network.accessTokenSeq(for: token)]
    }
}
