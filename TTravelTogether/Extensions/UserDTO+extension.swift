import Foundation

extension UserDTO {

    func convertToRegisterParams() -> [String: String] {
        [
            "phoneNumber": phoneNumber,
            "firstName": name,
            "lastName": lastName,
            "password": password,
            "confirmPassword": passwordConfirmation
        ]
    }
}
