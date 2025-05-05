import Foundation

protocol ICreateTripViewModel: AnyObject {

    var isCreateButtonEnable: Bool { get }
    var isCreateButtonEnablePublisher: Published<Bool>.Publisher { get }

    var tripTitleText: String { get set }
    var tripTitleTextPublisher: Published<String>.Publisher { get }

    var tripDescriptionText: String { get set }
    var tripDescriptionTextPublisher: Published<String>.Publisher { get }
}
