import UIKit

class ContactsActionFooterView: UITableViewHeaderFooterView {

	// MARK: - Static
	
	enum ActionType {
		case call
		case videoCall
		case sendMessage
	}
	
	static let reuseIdentifier = "ContactsActionFooterView"
	static let height: CGFloat = 54
	
	// MARK: - Properties
	
	private var action: ((_ actionType: ActionType) -> ())?
	
	// MARK: - Outlest
	
	@IBOutlet weak var callLabel: UILabel?
	@IBOutlet weak var videoCallLabel: UILabel?
	@IBOutlet weak var sendMessageLabel: UILabel?
	
	// MARK: - Initialize
	
	override init(reuseIdentifier: String?) {
		super.init(reuseIdentifier: reuseIdentifier)
		configure()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		configure()
	}
	
	private func configure() {
		callLabel?.text = LS(key: "Contacts.Call")
		videoCallLabel?.text = LS(key: "Contacts.VideoCall")
		sendMessageLabel?.text = LS(key: "Contacts.SendMessage")
	}
	
	// MARK: - Public
	
	func configure(with action: @escaping ((_ actionType: ActionType) -> ())) {
		self.action = action
	}
	
	// MARK: - Actions
	
	@IBAction func callButtonTouchUpInside(_ sender: Any) {
		action?(.call)
	}
	
	@IBAction func videoCallButtonTouchUpInside(_ sender: Any) {
		action?(.videoCall)
	}

	@IBAction func sendMessageButtonTouchUpInside(_ sender: Any) {
		action?(.sendMessage)
	}
	
	// MARK: - Override
	
	override func prepareForReuse() {
		super.prepareForReuse()
		
		action = nil
	}
	
	override public func layoutSubviews() {
		super.layoutSubviews()
		roundCorners([.bottomLeft, .bottomRight], radius: 10)
	}

}
