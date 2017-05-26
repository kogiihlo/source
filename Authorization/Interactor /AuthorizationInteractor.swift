import Foundation
import Result

class AuthorizationInteractor : IAuthorizationInteractor
{
	// MARK: - Dependencies
	
	private lazy var sessionService: ISessionService = inject()
	
	// MARK: - IAuthInteractor
	
	func isAuthorized() -> Bool {
		return sessionService.isAuthorized()
	}

	func validateAuthorizationData(by login: String?, password: String?, company: String?) -> Result<Void, ApplicationError> {
		if !LoginValidator(login: login).isValid() {
			return .failure(.validationFailed(reason: .invalidLogin))
		}
		
		if !PasswordValidator(password: password).isValid() {
			return .failure(.validationFailed(reason: .invalidPassword))
		}
		
		if !CompanyValidator(company: company).isValid() {
			return .failure(.validationFailed(reason: .invalidCompanyName))
		}
		
		return .success()
	}
	
	func signIn(login: String, password: String, company: String, completion: AuthorizationInteractorCompletion) {
		sessionService.signIn(login: login, password: password, company: company) { result in
			completion(result)
		}
    }
}
