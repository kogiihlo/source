import Foundation
import UIKit

protocol IContactsSearchBarDirector: class {
	func filter(by searchText: String)
}


class ContactsSearchBarColleague: NSObject, UISearchBarDelegate {
	
	// MARK: - Properties
	
	private weak var director: IContactsSearchBarDirector?
	
	// MARK: Initialization
	
	init(director: IContactsSearchBarDirector) {
		self.director = director
	}
	
	// MARK: - UISearchBarDelegate implementation
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		director?.filter(by: searchText)
	}
	
	func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
		searchBar.setShowsCancelButton(true, animated: true)
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		director?.filter(by: "")
		searchBar.text = nil
		searchBar.setShowsCancelButton(false, animated: true)
		searchBar.resignFirstResponder()
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
	}
}
