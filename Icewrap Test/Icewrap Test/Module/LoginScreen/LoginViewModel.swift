//
//  LoginViewModel.swift
//  Icewrap Test
//

import Foundation

protocol LoginViewModelDelegate: AnyObject {
    func onLoginSuccess()
    func onLoginError(_ error: String)
}


class LoginViewModel {
    
    weak var delegate: LoginViewModelDelegate?
    
    init(delegate: LoginViewModelDelegate? = nil) {
        self.delegate = delegate
    }
    
    func submitButtonClick(loginModel: LoginRequestModel) {
        if let error = checkValidation(loginModel: loginModel) {
            self.delegate?.onLoginError(error)
        } else {
            callLoginAPI(loginModel.toDictionary())
        }
    }
    
    private func checkValidation(loginModel: LoginRequestModel) -> String? {
        guard let username = loginModel.username, username.isNonEmpty(),
              let password = loginModel.password, password.isNonEmpty()
        /* ,let hostName = loginModel.hostName, hostName.isNonEmpty()*/ else {
            return ValidationError.emptyField.localizedDescription
        }
        
        if loginModel.username?.isValidEmail() == false {
            return ValidationError.invalidEmail.localizedDescription
        }
        
        if loginModel.password?.isValidPassword() == false {
            return ValidationError.passwordTooShort.localizedDescription
        }
        
        return nil
    }
    
}

extension LoginViewModel {
    
    private func callLoginAPI(_ parameters: [String: Any]) {
        Task {
            do {
                let createdChannel: LoginResponseModel = try await NetworkManager.shared.postFormEncoded(urlEndPoint: Constants.EndPoint.login, parameters: parameters)
                if let token = createdChannel.token, createdChannel.authorized == true {
                    self.delegate?.onLoginSuccess()
                    KeyChainManager.shared.token = token
                    AppCoordinator.shared.showChannelList(viewModel: ChannelListViewModel(token: token))
                } else {
                    self.delegate?.onLoginError(Constants.URLSessionError.invalidToken)
                }
            } catch (let error) {
                var errorMessage = error.localizedDescription.description
                if let error = error as? ValidationError {
                    errorMessage = error.localizedDescription
                } else if let error = error as? UrlSessionError {
                    errorMessage = error.localizedDescription
                }
                self.delegate?.onLoginError(errorMessage)
            }
        }
    }
    
}
