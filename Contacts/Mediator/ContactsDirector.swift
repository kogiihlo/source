import Foundation
import UIKit

typealias ItemIdentifier = String

class ContactsDirector: IContactsTableViewDirector, IContactsSearchBarDirector {
	
	// MARK: - Properties
	
	weak var interactor: IContactsInteractor?
	
	private var tableViewColleague: ContactsTableViewColleague?
	private var searchBarColleague: ContactsSearchBarColleague?
	
	private var contacts: [ContactCellViewPresentation]?
	private var selectedContactIdentifiers = [ItemIdentifier]()
	
	// MARK: - Public
	
	func manage(tableView: UITableView) {
		tableViewColleague = ContactsTableViewColleague(tableView: tableView, director: self)
		tableView.delegate = tableViewColleague
		tableView.dataSource = tableViewColleague
	}
	
	func manage(searchBar: UISearchBar) {
		searchBarColleague = ContactsSearchBarColleague(director: self)
		searchBar.delegate = searchBarColleague
	}
	
	func setDataSource(contacts: [ContactCellViewPresentation]) {
		self.contacts = contacts
		self.selectedContactIdentifiers.removeAll()
		
		tableViewColleague?.setDataSource(items: contacts.map({ $0.id }))
	}
	
	// MARK: - IContactsTableViewDirector implementation
	
	func selectItem(by identifier: ItemIdentifier) {
		selectedContactIdentifiers.append(identifier)
	}
	
	func delesectItem(by identifier: ItemIdentifier) {
		if let index = selectedContactIdentifiers.index(of: identifier) {
			selectedContactIdentifiers.remove(at: index)
		}
	}
	
	func confugure(cell contactsViewCell: ContactsViewCell, by itemIdentifier: String) {
		guard let contact = contact(by: itemIdentifier) else {
			assert(false, "Can't call handler for cell.")
			return
		}
		
		contactsViewCell.configure(with: contact) { [weak self] actionType, contactIdentifier in
			switch actionType {
			case .call: self?.interactor?.shouldMakeCall(by: contactIdentifier)
			case .videoCall: self?.interactor?.shouldMakeVideoCall(by: contactIdentifier)
			case .sendMessage: self?.interactor?.shouldSendMessage(by: contactIdentifier)
			}
		}
	}
	
	func confugure(view contactsViewCell: ContactsActionFooterView) {
		contactsViewCell.configure(with: { [weak self] actionType in
			guard let `self` = self else {
				assert(false, "Can't call handler for cell.")
				return
			}
			
			switch actionType {
			case .call: self.interactor?.shouldMakeCall(by: self.selectedContactIdentifiers)
			case .videoCall: self.interactor?.shouldMakeVideoCall(by: self.selectedContactIdentifiers)
			case .sendMessage: self.interactor?.shouldSendMessage(by: self.selectedContactIdentifiers)
			}
		})
	}
	
	private func contact(by identifier: ItemIdentifier) -> ContactCellViewPresentation? {
		return contacts?.first(where: { $0.id == identifier })
	}
	
	// MARK: - IContactsSearchBarDirector implementation
	
	func filter(by searchText: String) {
		guard let contacts = contacts else { return }
		
		let items: [ContactCellViewPresentation]
		if !searchText.isEmpty {
			let lowercasedSearchText = searchText.lowercased()
			items = contacts.filter { $0.name.lowercased().range(of: lowercasedSearchText) != nil }
		} else {
			items = contacts
		}
		
		let itemIdentifiers = items.map({ $0.id }).subtracting(selectedContactIdentifiers)
		tableViewColleague?.updateItems(by: itemIdentifiers)
	}
	
}
