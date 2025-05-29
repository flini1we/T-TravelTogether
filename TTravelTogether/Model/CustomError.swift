import Foundation

struct CustomError: Error, Decodable {

    let message: String

    static func hiddenError(_ string: String) -> Self {
        CustomError(message: string)
    }

    static func errorToDecodeTokens() -> Self {
        CustomError(message: .AppStrings.Errors.tokensDecoderError)
    }

    static func accessTokenIsNil() -> Self {
        CustomError(message: .AppStrings.Errors.accessTokenInNil)
    }

    static func errorToSaveTokens() -> Self {
        CustomError(message: .AppStrings.Errors.saveTokensError)
    }

    static func errorToParseData() -> Self {
        CustomError(message: .AppStrings.Errors.dataIsNil)
    }

    static func errorToEditTrip() -> Self {
        CustomError(message: .AppStrings.Errors.editTrip)
    }

    static func editedTripIdIsNil() -> Self {
        CustomError(message: .AppStrings.Errors.editedIdIsNil)
    }

    static func errorToAccassTripData() -> Self {
        CustomError(message: .AppStrings.Errors.errorToAccessTripData)
    }
}
