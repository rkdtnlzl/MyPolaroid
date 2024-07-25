//
//  String+.swift
//  MyPolaroid
//
//  Created by 강석호 on 7/22/24.
//

import Foundation

extension String {
    func validateNickname() -> NicknameValidationResult {
        let specialLiterals = CharacterSet(charactersIn: "@#$%")
        let numbers = CharacterSet.decimalDigits
        
        if self.isEmpty {
            return .empty
        } else if self.count < 2 || self.count > 9 {
            return .invalidLength
        } else if self.rangeOfCharacter(from: specialLiterals) != nil {
            return .containsSpecialCharacters
        } else if self.rangeOfCharacter(from: numbers) != nil {
            return .containsNumbers
        } else {
            return .valid
        }
    }
}
