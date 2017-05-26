import UIKit

class ContactsActionCorneredFooterView: UITableViewHeaderFooterView {

	// MARK: - Properties
	
	static let reuseIdentifier = "ContactsActionCorneredFooterView"
	static let height: CGFloat = 15
	
	// MARK: - Memory managment
	
	override init(reuseIdentifier: String?) {
		super.init(reuseIdentifier: reuseIdentifier)
		initialConfigure()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		initialConfigure()
	}
	
	private func initialConfigure() {
		contentView.backgroundColor = .white
	}
	
	// MARK: - Override
	
	override public func layoutSubviews() {
		super.layoutSubviews()
		roundCorners([.bottomLeft, .bottomRight], radius: 10)
	}
}
