import Foundation
import UIKit

class ContactsViewController: UIViewController {
	
	// MARK: - Outlets
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var searchBar: UISearchBar!
	
	// MARK: - Dependence
	
	private let preloader: IPreLoader = inject()
	private lazy var design: IDesignChats = inject()
	private lazy var interactor: IContactsInteractor = inject()
	
	// MARK: - Properties
	
	private let contactsDirector = ContactsDirector()
	
	// MARK: - Life cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		design.applyDesign(to: self)
		
		configureContactDirector()
		confugureTableView()
		configureSearchBar()
		
		fetchContacts()
	}
	
	private func configureContactDirector() {
		contactsDirector.interactor = interactor
	}
	
	private func confugureTableView() {
		contactsDirector.manage(tableView: tableView)
		tableView.register(
			UINib(nibName: "ContactsActionFooterView", bundle: nil),
			forHeaderFooterViewReuseIdentifier: ContactsActionFooterView.reuseIdentifier
		)
		tableView.register(
			ContactsActionCorneredFooterView.classForCoder(),
			forHeaderFooterViewReuseIdentifier: ContactsActionCorneredFooterView.reuseIdentifier
		)
	}
	
	private func configureSearchBar() {
		contactsDirector.manage(searchBar: searchBar)
		searchBar.placeholder = LS(key: "Contacts.SearchPlaceholder")
	}
	
	// MARK: - Working with data
	
	private func fetchContacts() {
		preloader.presentLoader()
		interactor.fetch { [weak self] result in
			guard let `self` = self else { return }
			
			self.preloader.hideLoader()
			
			switch result {
			case .success(let contacts): self.showContacts(contacts)
			case .failed(let error): self.showAlert(with: error)
			}
		}
	}
	
	private func showContacts(_ contacts: [Contacts]) {
		let contactsPresentations = contactsPresentation(from: contacts)
		contactsDirector.setDataSource(contacts: contactsPresentations)
	}
	
	private func showAlert(with error: Error) {
		let alertController = AlertController.createAlert(with: error)
		present(alertController, animated: true, completion: nil)
	}
	
	// MARK: - Mapping
	
	private func contactsPresentation(from contacts: [Contact]) -> [ContactCellViewPresentation] {
		return contacts.map { contact in
			return ContactCellViewPresentation(
				id: contact.id,
				name: contact.name,
				status: contactPresentationStatus(from: contact.status)
			)
		}
	}
	
	private func contactPresentationStatus(from status: Contact.Status) -> ContactCellViewPresentation.Status {
		switch status {
		case .online: return .online
		case .offline: return .offline
		}
	}
}
