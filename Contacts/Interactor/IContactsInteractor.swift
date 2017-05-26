import Foundation

protocol IContactsInteractor: class {
	
	// MARK: - Working with data
	
	func fetch(completion: @escaping (_ result: Result<[Contacts]>) -> ())
	
	// MARK: - Action
	
	func shouldMakeCall(by contactIdentifier: String)
	func shouldMakeVideoCall(by contactIdentifier: String)
	func shouldSendMessage(by contactIdentifier: String)
	
	func shouldMakeCall(by contactIdentifiers: [String])
	func shouldMakeVideoCall(by contactIdentifiers: [String])
	func shouldSendMessage(by contactIdentifiers: [String])
}
