import Foundation

class ContactsInteractor: IContactsInteractor {
	
	// MARK: - Dependence
	
	private lazy var contactService: IContactsService = inject()
	
	// MARK: - IContactsInteractor implementation
	
	func fetch(completion: @escaping (_ result: Result<[Contacts]>) -> ()) {
		contactService.fetch(with: { result in
			switch result {
			case .success(let contacts):  completion.success(contacts: contacts)
			case .failure(let error): completion(.failed(error: error))
			}
		})
	}
	
	func shouldMakeCall(by contactIdentifier: String) {
		
	}
	
	func shouldMakeVideoCall(by contactIdentifier: String) {
		
	}
	
	func shouldSendMessage(by contactIdentifier: String) {
		
	}
	
	func shouldMakeCall(by contactIdentifiers: [String]) {
		
	}
	
	func shouldMakeVideoCall(by contactIdentifiers: [String]) {
		
	}
	
	func shouldSendMessage(by contactIdentifiers: [String]) {
		
	}
}
