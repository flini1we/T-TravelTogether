import Foundation
import Combine

final class CreateTripViewModel: ICreateTripViewModel {

    @Published private(set) var isCreateButtonEnable: Bool = false
    @Published var tripTitleText: String = ""
    @Published var tripDescriptionText: String = ""

    var isCreateButtonEnablePublisher: Published<Bool>.Publisher { $isCreateButtonEnable }
    var tripTitleTextPublisher: Published<String>.Publisher { $tripTitleText }
    var tripDescriptionTextPublisher: Published<String>.Publisher { $tripDescriptionText }

    private var cancellables = Set<AnyCancellable>()

    init() {
        setupBindings()
    }
}

private extension CreateTripViewModel {

    func setupBindings() {
        Publishers.CombineLatest($tripTitleText, $tripDescriptionText)
            .map { !$0.isEmpty && !$1.isEmpty }
            .assign(to: \.isCreateButtonEnable, on: self)
            .store(in: &cancellables)
    }
}
