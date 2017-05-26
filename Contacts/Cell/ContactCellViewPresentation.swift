import Foundation

struct ContactCellViewPresentation {
	
	// MARK: - Types
	
	enum Status: String {
		case online
		case offline
	}
	
	// MARK: - Properties
	
	let id: String
	let name: String
	let status: Status
}
