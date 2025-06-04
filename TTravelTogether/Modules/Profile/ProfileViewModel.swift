import Foundation

final class ProfileViewModel: IProfileViewModel {

    private static let sharedCache: NSCache<NSString, NSData> = .init()

    private var cache: NSCache<NSString, NSData> {
        return ProfileViewModel.sharedCache
    }

    private var networkService: INetworkService
    var onErrorDidAppear: ((CustomError) -> Void)?

    init(networkService: INetworkService) {
        self.networkService = networkService
    }

    @Published var isLoadingData: Bool = false
    var isLoadingDataPublisher: Published<Bool>.Publisher {
        $isLoadingData
    }
    @Published var user: User?
    var userPublisher: Published<User?>.Publisher {
        $user
    }

    private lazy var decoder: JSONDecoder = { JSONDecoder() }()
    private lazy var encoder: JSONEncoder = { JSONEncoder() }()

    func loadData() {
        if let user = loadUser() {
            self.user = user
            return
        }

        isLoadingData = true
        networkService.getUserProfile { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let loadedUser):
                isLoadingData = false
                user = loadedUser
                saveUserData()
            case .failure(let error):
                onErrorDidAppear?(error)
            }
        }
    }
}

private extension ProfileViewModel {

    func loadUser() -> User? {
        if let userData = cache.object(forKey: NSString(string: .AppStrings.Cache.userKey)) {
            do {
                return try decoder.decode(User.self, from: userData as Data)
            } catch {
                onErrorDidAppear?(.hiddenError(error.localizedDescription))
            }
        }
        return nil
    }

    func saveUserData() {
        do {
            let userData = try encoder.encode(user) as NSData
            cache.setObject(
                userData,
                forKey: NSString(string: .AppStrings.Cache.userKey)
            )
        } catch {
            onErrorDidAppear?(.hiddenError(error.localizedDescription))
        }
    }
}
