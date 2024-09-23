//
//  LoginViewController.swift
//  Icewrap Test
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailIdTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var hostNameTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var viewModel: LoginViewModel?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardNotifications()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func submitButtonClick(_ sender: UIButton) {
        let loginModelRequest = LoginRequestModel(username: emailIdTextField.text, password: passwordTextField.text, hostName: hostNameTextField.text)
        self.showLoadingIndicator()
        viewModel?.submitButtonClick(loginModel: loginModelRequest)
    }
}

extension LoginViewController: LoginViewModelDelegate {

    func onLoginSuccess() {
        DispatchQueue.main.async { [weak self] in
            self?.resetTextField()
            self?.hideLoadingIndicator()
        }
    }
    
    func resetTextField() {
        emailIdTextField.text = nil
        passwordTextField.text = nil
        hostNameTextField.text = nil
    }
    
    func onLoginError(_ error: String) {
        DispatchQueue.main.async {  [weak self] in
            self?.hideLoadingIndicator()
            self?.showAlert(message: error)
        }
    }
}
// Notification observer for testfield scroll to visible area
extension LoginViewController {
    private func setupKeyboardNotifications() {
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
       }

       @objc private func keyboardWillShow(_ notification: Notification) {
           guard let userInfo = notification.userInfo,
                 let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

           // Adjust the scroll view's content inset
           let keyboardHeight = keyboardFrame.height
           scrollView.contentInset.bottom = keyboardHeight
           scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight
       }

       @objc private func keyboardWillHide(_ notification: Notification) {
           // Reset the content inset when the keyboard is dismissed
           scrollView.contentInset.bottom = 0
           scrollView.verticalScrollIndicatorInsets.bottom = 0
       }
    private func scrollToActiveTextField(_ textField: UITextField) {
        let textFieldFrame = textField.convert(textField.bounds, to: scrollView)
        scrollView.scrollRectToVisible(textFieldFrame, animated: true)
    }

}
// Textfield delegate 
extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollToActiveTextField(textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailIdTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            hostNameTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text as NSString? else { return true }
        let newText = currentText.replacingCharacters(in: range, with: string)

        if textField == emailIdTextField {
            return newText.count <= 60
        } else if textField == passwordTextField {
            return newText.count <= 20
        }
        
        return true
    }
}
