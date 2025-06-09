import UIKit

extension String {

    func addCurrency(_ currency: Currency) -> Self {
        self + " \(currency.rawValue)"
    }

    func eraseToCategory() -> TransactionCategory {
        let lowercasedSelf = self.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        switch lowercasedSelf {
        case "транспорт":
            return .transport
        case "проживание":
            return .accommodation
        case "питание":
            return .food
        case "развлечения":
            return .entertainment
        case "покупки":
            return .shopping
        case "здоровье":
            return .health
        case "связь", "связь и интернет":
            return .communication
        case "виза", "виза и документы":
            return .visaAndDocuments
        default:
            return .other
        }
    }

    enum AppStrings {

        enum Notification {

            static let changeTheme = "Change_Theme"
            static let updatedThemeKey = "updatedTheme"
            static let clearScreend = "clear_screen"
            static let grantedForNotifications = "Для отправки уведомлений разрешите их в настройках"
            static let reminderNotification = "reminder"
        }

        enum Auth {

            static let phonePrefix89 = "89"
            static let phonePrefixPlus79 = "+79"
            static let invalidUserName = "Имя не должно быть пустым"
            static let invalidStartUserName = "Имя должно начинаться с загловной буквы"
            static let invalidUserNameSymbols = "Имя содержит недопустимые символы"
            static let invalidUserLastName = "Фамилия не должна быть пустой"
            static let invalidStartUserLastName = "Фамилия должна начинаться с загловной буквы"
            static let invalidUserLastNameSymbols = "Фамилия содержит недопустимые символы"
            static let invalidPhoneStartsWith = "Введите номер в формате 89... или +79..."
            static let invalidPhoneLenght = "Номер слишком длинный"
            static let invalidPasswordData = "Хотя бы 1 заглавная буква и 1 цифра"
            static let invalidPasswordLengthMin = "Слишком короткий пароль"
            static let invalidPasswordLengthMax = "Слишком длинный пароль"
            static let invalidPasswordConfirmed = "Пароли должны совпадать"
            static let phoneNumber = "Номер телефона"
            static let password = "Пароль"
            static let confirmPassword = "Повторите пароль"
            static let enter = "Войти"
            static let toRegistration = "Регистрация"
            static let registerAction = "Зарегистрироваться"
            static let loginTitle = "Авторизация"
            static let registerTitle = "Регистрация"
            static let userNameFieldPlaceholder = "Имя"
            static let userLastNameFieldPlaceholder = "Фамилия"
        }

        enum Alert {

            static let ok = "Ок"
            static let error = "Ошибка"
            static let confirm = "Подтвердить"
            static let settings = "Настройки"
            static let cancel = "Отмена"
            static let accessToContactsTitle = "Доступ к списку контактов"
            static let accessToContactsMessage = "Пожалуйста предоставьте доступ к контактам для добавления в поездку"
            static let leaveTripTitle = "Покинуть поездку"
            static let deleteTripTitle = "Удалить поездку"
            static let leaveTripAdminTitle = "Админ не может покинуть поездку."
            static let leaveTripMessage = "Вы уверены что хотете покинуть данное путешествие?"
            static let deleteTripMessage = "Вы уверены что хотете удалить данное путешествие?"
            static let editTripTitle = "Только админ может редактировать поездку"
            static let noSuchUser = "Пользователь не найден"
            static let noSuchUserDescription = "Повторите попытку снова"
            static let incorrectTripPriceTitle = "Некорректная стоимость поездки"
            static let incorrectTripPriceMessage = "Стоимость поездки должна быть целым числом."
            static let leaveProfileTitle = "Покинуть профиль"
            static let leaveProfileMessage = "Вы уверены что хотите выйти из профиля?"
            static let leaveProfile = "Покинуть"
            static let successTitle = "Успешно!"
            static let notificateDebtorsMessage = "Уведомление о долгах отправлено всем пользователям"
            static let transactionEditingNotAllowed = "Кто-то из участников выплатил долг. Редактирование транзакции невозможно"
        }

        enum AppTitles {

            static let myTravellingsTitle = "Мои путешествия"
            static let searchBar = "Найти путешествие"
            static let tripDetailTitle = "Placeholder"
            static let tripDetailPrice = "200.000"
        }

        enum CreateTrip {

            static let tripMembers = "Участники"
            static let transactionsButton = "Транзакции"
            static let createTripTitle = "Название путешествия"
            static let createTripPrice = "Начальная стоимость"
            static let tripDateTitle = "Даты"
            static let addMemberTitle = "Добавить контакты"
            static let tripStartsAtTitle = "Начало:"
            static let tripEndsAtTitle = "Конец:"
            static let create = "Создать"
        }

        enum Contacts {

            static let iCloudTitle = "iCloud"
            static let contactsSearchBarTitle = "Поиск контактов"
        }

        enum UserDefaults {

            static let originUserKey = "current_user"
        }

        enum Transactions {

            static let screenTitle = "История транзакций"
            static let titlePlaceholder = "Transaction"
            static let descriptionPlaceholder = "Something about current transaction"
            static let pricePlaceholder = "777.777"
            static let emptyTableTitle = "Здесь будут ваши транзакции"
            static let selectedCategoryHint = "Выберите категорию"
            static let descriptionTextFieldPlaceholder = "Добавьте описание к транзакции"
            static let priceTextFieldPlaceholder = "Введите стоимость"
            static let paymentOption = "Заплатить"
            static let paymentPriceTextFieldPlaceholder = "Сумма"
            static let createTransactionButtonTitle = "Создать"

            enum Errors {

                static let emptyDescription = "Описание транзакции не может быть пустым"
                static let priceInvalid = "Цена транзакции должна быть числом"
                static let missingPrice = "При выборе опции \"Сплит между участниками\" сумма долгов должна быть равна сумме транзакции"
            }

            enum Detail {

                static let screenTitle = "Детали транзакции"
                static let debtTitle = "Данные о долгах"
                static let payDebtTitle = "Оплатит свой долг"
                static let creatorTitle = "Создатель транзакции"
                static let payDebt = "Оплатить долг"
                static let notificateDebtors = "Напомнить о долге"
                static let deletingAdminRequired = "Удалить транзакцию может только ее создатель"
                static let editingAdminRequired = "Редактировать транзакцию может только ее создатель"
                static let confirmDeletingTitle = "Вы уверены что хотите удалить транзакцию?"
                static let confirmDelegingMessage = "Действие невозможно будет отменить. Данные очистятся"
                static let noTransaction = "Транзакции не сущесвует. Попробуйте снова позже"
            }

            enum Create {

                static let updateButtonTitle = "Сохранить"
                static let editedTransactionIsNil = "Ошибка. Редактируемой транзакции не существует, попробуйте повторить похже"
            }
        }

        enum Errors {

            static let hiddenMessage = "Неизвестная ошибка"
            static let registerError = "Ошибка регистрации"
            static let tokensDecoderError = "Ошибка при раскодировании токенов"
            static let accessTokenInNil = "Доступ ограничен, перейдите к регистрации"
            static let saveTokensError = "Доступ ограничен, попробуйте еще раз"
            static let dataIsNil = "Данные о датах поездки отстуствуют."
            static let editTrip = "Доступ к реадктированию запрещен."
            static let editedIdIsNil = "Реадктируемая поездка не валидна."
            static let errorToAccessTripData = "Даты редактируемой поездки не валидны. Попробуйте снова позже"
            static let errorToConvertData = "Ошибка в преобразовании данных. Попробуйте снова"
        }

        enum KeyChain {

            static let storage = "keychain.TokenStorage"
            static let accessId = ".access"
            static let refreshId = ".refresh"
            static let refreshTokenHeader = "refreshToken"
        }

        enum Network {

            static let accessTokenHeder = "Authorization"
            static let tripIdRequestParam = "travelId"
        }

        enum Cache {

            static let userKey = "Loaded.User"
        }

        enum Profile {

            static let screenTitle = "Профиль"
            static let namePlaceholder = "Ivan Ivanov"
            static let phonePlaceholder = RussianValidationService.shared.validate(phone: "89999999999")
            static let archiveTitle = "Архив поездок"
            static let changeLanguageTitle = "Сменить язык"
            static let changeThemeTitle = "Сменить тему"
            static let leaveTitle = "Выйти из профиля"
        }

        enum WhiteSpaces {

            static let s = Array(repeating: " ", count: 18).joined()
            static let m = Array(repeating: " ", count: 36).joined()
            static let l = Array(repeating: " ", count: 54).joined()
            static let xl = Array(repeating: " ", count: 72).joined()
        }
    }
}
