import Foundation
import UIKit

class ContactsViewCell: UITableViewCell {
	
	// MARK: - Outlets
	
	@IBOutlet weak var checkImageIcon: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var actionsStackView: UIStackView!
	@IBOutlet weak var separatorView: UIView!
	
	// MARK: - Types
	
	enum ActionType {
		case call
		case videoCall
		case sendMessage
	}
	
	// MARL: - Static
	
	static let reuseIdentifier = "ContactsViewCell"
	static let height: CGFloat = 76
	
	// MARK: - Properties
	
	private var contactIdentifier: String?
	private var action: ((_ actionType: ActionType, _ contactIdentifier: String) -> ())?
	
	// MARK: - Public 
	
	func configure(with contact: ContactCellViewPresentation, action: ((_ actionType: ActionType, _ contactIdentifier: String) -> ())? = nil) {
		self.contactIdentifier = contact.id
		self.action = action
		
		self.checkImageIcon.image = #imageLiteral(resourceName: "ContactsDeselectedIcon")
		self.nameLabel.text = contact.name
	}
	
	func showSeparationLine() {
		separatorView.isHidden = false
	}
	
	func hideSeparationLine() {
		separatorView.isHidden = true
	}
	
	// MARK: - Actions
	
	@IBAction func callButtonTouchUpInside(_ sender: Any) {
		guard let contactIdentifier = contactIdentifier else {
			return
		}
		
		action?(.call, contactIdentifier)
	}
	
	@IBAction func videoCallButtonTouchUpInside(_ sender: Any) {
		guard let contactIdentifier = contactIdentifier else {
			return
		}
		
		action?(.videoCall, contactIdentifier)
	}
	
	@IBAction func sendMessageButtonTouchUpInside(_ sender: Any) {
		guard let contactIdentifier = contactIdentifier else {
			return
		}
		
		action?(.sendMessage, contactIdentifier)
	}
	
	// MARK: - Override
	
	override func prepareForReuse() {
		super.prepareForReuse()
		
		contactIdentifier = nil
		action = nil
		
		checkImageIcon.image = #imageLiteral(resourceName: "ContactsDeselectedIcon")
		nameLabel.text = nil
		actionsStackView.isHidden = false
		separatorView.isHidden = true
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		if selected {
			checkImageIcon.image = #imageLiteral(resourceName: "ContactsSelectedIcon")
		} else {
			checkImageIcon.image = #imageLiteral(resourceName: "ContactsDeselectedIcon")
		}
	}
}
