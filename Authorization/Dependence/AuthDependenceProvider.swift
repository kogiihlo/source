import Foundation

class AuthorizationDependenceProvider : IDependenceProvider {
	
	// MARK : - IDependenceProvider implementation
	
    static func loadDependences() {
        loadDesign()
    }
	
	// MARK: - Private
	
    private static func loadDesign() {
        let design: IAuthorizationDesign = AuthorizationDesign()
        prepareInjection(design, memoryPolicy: .Strong)
    }
}
