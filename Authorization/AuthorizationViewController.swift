import Foundation
import UIKit


class AuthorizationViewController : UIViewController {
	
    // MARK: - IBOutlets
	
    @IBOutlet var loginButton: UIButton?
	@IBOutlet var companyTextField: UITextField?
    @IBOutlet var userNameTextField: UITextField?
    @IBOutlet var passwordTextField: UITextField?
    
	// MARK: - Dependence
	
    private var design: IAuthorizationDesign = inject()
    private var interactor: IAuthorizationInteractor = inject()
    private var router: IAuthorizationRouter = inject()
	private let preloader: IPreLoader = inject()
	
    // MARK: - Life cycle
	
    override func viewDidLoad() {
        super.viewDidLoad()
		confugure()
    }

	// MARK: - Configuration
	
	private func confugure() {
		design.applyDesign(to: self)
		
		companyTextField?.placeholder = LS(key: "Login.CompanyName")
		userNameTextField?.placeholder = LS(key: "Login.UserName")
		passwordTextField?.placeholder = LS(key: "Login.Password")
		
		companyTextField?.addTarget(self, action: #selector(didChangeText(textField:)), for: .editingChanged)
		userNameTextField?.addTarget(self, action: #selector(didChangeText(textField:)), for: .editingChanged)
		passwordTextField?.addTarget(self, action: #selector(didChangeText(textField:)), for: .editingChanged)
		
		loginButton?.isEnabled = false
	}

	// MARK: - Text field events
	
	internal func didChangeText(textField: UITextField) {
		let validationResult = validateAuthorizationData()
		loginButton?.isEnabled = validationResult.isSuccess
	}
	
	private func validateAuthorizationData() -> Result<Void, ApplicationError> {
		return interactor.validateAuthorizationData(
			by: userNameTextField?.text,
			password: passwordTextField?.text,
			company: companyTextField?.text
		)
	}
	
	// MARK: Actions
	
	@IBAction func loginButtonPressed() {
		authorization()
	}
	
	// MARK: - Working with interactor
	
	private func authorization() {
		guard let login = userNameTextField?.text, let password = passwordTextField?.text, let company = companyTextField?.text else {
			return
		}
		
		preloader.presentLoader()
		
		interactor.signIn(login: login, password: password, company: company) { [weak self] result in
			guard let `self` = self else { return }
			
			self.preloader.hideLoader()
			
			switch result {
			case .success: self.showMain()
			case .failure(let error): self.showAlert(with: error)
			}
		}
	}
	
	private func showMain() {
		router.showMain()
	}

	private func showAlert(with error: Error) {
		let alertController = AlertController.createAlert(with: error)
		present(alertController, animated: true, completion: nil)
	}
}
