import Foundation
import Result

protocol IAuthorizationInteractor : class {
	
	typealias AuthorizationInteractorCompletion = (Result<Void, ApplicationError>) -> ()
	
    func isAuthorized() -> Bool
	func signIn(login: String, password: String, company: String, completion: AuthorizationInteractorCompletion)
	func validateAuthorizationData(by login: String?, password: String?, company: String?) -> Result<Void, ApplicationError>
}
