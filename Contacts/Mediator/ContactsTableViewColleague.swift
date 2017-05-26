import Foundation
import UIKit

protocol IContactsTableViewDirector: class {
	
	func selectItem(by identifier: ItemIdentifier)
	func delesectItem(by identifier: ItemIdentifier)
	
	func confugure(cell contactsViewCell: ContactsViewCell, by itemIdentifier: String)
	func confugure(view contactsViewCell: ContactsActionFooterView)
}

class ContactsTableViewColleague: NSObject, UITableViewDataSource, UITableViewDelegate {
	
	// MARK: - Types
	
	typealias ItemIdentifier = String
	
	private enum SectionType {
		case selectedContacts
		case contacts
	}
	
	private struct Section {
		let type: SectionType
		var items: [ItemIdentifier]
	}
	
	// MARK: - Properties
	
	private weak var director: IContactsTableViewDirector?
	private weak var tableView: UITableView?
	
	private var dataSource = [ItemIdentifier]()
	private var sections = [Section]()
	
	// MARK: Initialization
	
	init(tableView: UITableView, director: IContactsTableViewDirector) {
		self.tableView = tableView
		self.director = director
	}
	
	// MARK: - Public
	
	func setDataSource(items: [ItemIdentifier]) {
	
		sections.removeAll()
		let contactsSection = Section(type: .contacts, items: items)
		sections.append(contactsSection)
		
		tableView?.reloadData()
	}
	
	func updateItems(by items: [ItemIdentifier]) {
		if let indexOfContactsSection = sections.index(where: { $0.type == .contacts }) {
			sections[indexOfContactsSection].items = items
			
			tableView?.beginUpdates()
			tableView?.reloadSections(IndexSet(integer: indexOfContactsSection), with: .automatic)
			tableView?.endUpdates()
		}
	}
	
	// MARK: - Working with data source
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return sections.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return sections[section].items.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: ContactsViewCell.reuseIdentifier, for: indexPath)
		
		if let contactsViewCell = cell as? ContactsViewCell {
			let itemIdentifier = sections[indexPath.section].items[indexPath.row]
			director?.confugure(cell: contactsViewCell, by: itemIdentifier)
		}
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		let sectionType = sections[section].type
		
		var footerView: UIView?
		switch sectionType {
		case .contacts:
			if let section = sections.first(where: { $0.type == .contacts }), section.items.count > 0 {
				footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ContactsActionCorneredFooterView.reuseIdentifier)
			}

		case .selectedContacts:
			footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ContactsActionFooterView.reuseIdentifier)
		}
		
		if let contactsActionFooterView = footerView as? ContactsActionFooterView {
			director?.confugure(view: contactsActionFooterView)
		}
		
		return footerView
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if let contactsViewCell = cell as? ContactsViewCell {
			let sectionType = sections[indexPath.section].type
			switch sectionType {
			case .selectedContacts:
				contactsViewCell.hideSeparationLine()
			default:
				contactsViewCell.showSeparationLine()
			}
		}
	}
	
	// MARK: - Select / deselect contacts
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		var indexPathAfterUpdateSections = indexPath
		
		if !sectionForSelectedContactsIsCreated() {
			createSectionForSelectedContacts(in: tableView)
			indexPathAfterUpdateSections = IndexPath(row: indexPath.row, section: 1)
		}
		
		selectContact(by: indexPathAfterUpdateSections, in: tableView)
	}
	
	func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		deselectContact(by: indexPath, in: tableView)
		
		let sectionForSelectedContactsCanBeDeleted = sectionForSelectedContactsIsEmpty() && sectionForSelectedContactsIsCreated()
		if sectionForSelectedContactsCanBeDeleted {
			removeSectionForSelectedContacts(from: tableView)
		}
	}
	
	// MARK: - Working with section
	
	private func sectionForSelectedContactsIsCreated() -> Bool {
		return sections.contains { section in
			return section.type == .selectedContacts
		}
	}
	
	private func sectionForSelectedContactsIsEmpty() -> Bool {
		if let selectedContactsSections = sections.first(where: { $0.type == .selectedContacts }) {
			return selectedContactsSections.items.count == 0
		}
		return true
	}
	
	private func createSectionForSelectedContacts(in tableView: UITableView) {
		let selectedSection = Section(type: .selectedContacts, items: [])
		sections.insert(selectedSection, at: 0)
		
		tableView.beginUpdates()
		tableView.insertSections(IndexSet(integer: 0), with: .automatic)
		tableView.endUpdates()
	}
	
	private func removeSectionForSelectedContacts(from tableView: UITableView) {
		sections.remove(at: 0)
		
		tableView.beginUpdates()
		tableView.deleteSections(IndexSet(integer: 0), with: .automatic)
		tableView.endUpdates()

	}
	
	// MARK: - Working with contacts
	
	private func selectContact(by indexPath: IndexPath, in tableView: UITableView) {
		guard let indexOfSection = indexOfSection(by: .selectedContacts) else {
			return
		}
		
		moveContactToSelected(by: indexPath)
		
		let destinationIndexPath = IndexPath(row: tableView.numberOfRows(inSection: indexOfSection), section: 0)
		
		tableView.beginUpdates()
		tableView.moveRow(at: indexPath, to: destinationIndexPath)
		tableView.endUpdates()
		
		if let contactsViewCell = tableView.cellForRow(at: destinationIndexPath) as? ContactsViewCell {
			contactsViewCell.hideSeparationLine()
		}
	}
	
	private func moveContactToSelected(by indexPath: IndexPath) {
		let item = sections[indexPath.section].items[indexPath.row]
		
		director?.selectItem(by: item)
		
		append(item, to: .selectedContacts)
		remove(item, from: .contacts)
	}
	
	private func deselectContact(by indexPath: IndexPath, in tableView: UITableView) {
		moveContactFromSelected(by: indexPath)
		
		let destinationIndexPath = IndexPath(row: 0, section: 1)
		
		tableView.beginUpdates()
		tableView.moveRow(at: IndexPath(row: indexPath.row, section: 0), to: destinationIndexPath)
		tableView.endUpdates()
		
		if let contactsViewCell = tableView.cellForRow(at: destinationIndexPath) as? ContactsViewCell {
			contactsViewCell.showSeparationLine()
		}
	}
	
	private func moveContactFromSelected(by indexPath: IndexPath) {
		let item = sections[indexPath.section].items[indexPath.row]
		
		director?.delesectItem(by: item)
		
		append(item, to: .contacts)
		remove(item, from: .selectedContacts)
	}
	
	private func indexOfSection(by sectionType: SectionType) -> Int? {
		return sections.index(where: { $0.type == sectionType })
	}
	
	private func append(_ item: String, to section: SectionType) {
		guard let indexOfSection = indexOfSection(by: section) else {
			return
		}
		
		sections[indexOfSection].items.append(item)
	}
	
	private func remove(_ item: String, from section: SectionType) {
		guard let indexOfSection = indexOfSection(by: section) else {
			return
		}
		
		if let index = sections[indexOfSection].items.index(of: item) {
			sections[indexOfSection].items.remove(at: index)
		}
	}
	
	// MARK: - Heights
	
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		let sectionType = sections[section].type
		switch sectionType {
		case .contacts: return ContactsActionCorneredFooterView.height
		case .selectedContacts: return ContactsActionFooterView.height
		}
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return ContactsViewCell.height
	}
}
