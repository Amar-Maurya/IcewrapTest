//
//  String+Extension.swift
//  Icewrap Test
//

import Foundation

extension String {
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self) 
    }
    
    func isValidPassword() -> Bool {
        return self.count >= 6
    }
    
    func isNonEmpty() -> Bool {
        self.count != 0
    }
}
