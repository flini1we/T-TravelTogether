import UIKit

extension String {

    enum AppStrings {

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
            static let confirm = "Подтвердить"
            static let settings = "Настройки"
            static let cancel = "Отмена"
            static let accessToContactsTitle = "Доступ к списку контактов"
            static let accessToContactsMessage = "Пожалуйста предоставьте доступ к контактам для добавления в поездку"
            static let leaveTripTitle = "Покинуть поездку"
            static let leaveTripAdminTitle = "Админ не может покинуть поездку."
            static let leaveTripMessage = "Вы уверены что хотете покинуть данное путешествие?"
            static let editTripTitle = "Только админ может редактировать поездку"
            static let noSuchUser = "Пользователь не найден"
            static let noSuchUserDescription = "Повторите попытку снова"
            static let incorrectTripPriceTitle = "Некорректная стоимость поездки"
            static let incorrectTripPriceMessage = "Стоимость поездки должна быть целым числом."
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
    }
}
