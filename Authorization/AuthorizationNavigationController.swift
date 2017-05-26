import Foundation
import UIKit


class AuthorizationNavigationController : UINavigationController {
	
	// MARK: - Initialization
	
    required init?(coder aDecoder: NSCoder) {
        AuthDependenceProvider.loadDependences()
        super.init(coder: aDecoder)
    }
}
