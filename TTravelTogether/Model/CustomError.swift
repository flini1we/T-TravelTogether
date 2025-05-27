import Foundation

struct CustomError: Error, Decodable {

    let message: String

    static func hiddenError(_ string: String) -> Self {
        CustomError(message: string)
    }

    static func errorToDecodeTokens() -> Self {
        CustomError(message: .AppStrings.Errors.tokensDecoderError)
    }
}
