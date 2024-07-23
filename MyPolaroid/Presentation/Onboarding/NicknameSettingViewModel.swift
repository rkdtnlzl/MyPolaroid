//
//  NicknameSettingViewModel.swift
//  MyPolaroid
//
//  Created by 강석호 on 7/23/24.
//

import Foundation

class NicknameSettingViewModel {

    var inputProfileNumber: Observable<Int> = Observable(0)
    var inputNickname: Observable<String> = Observable("")
    var inputMBTISelection: Observable<[String]> = Observable([])

    var outputProfileImage: Observable<String?> = Observable(nil)
    var outputNicknameStatus: Observable<String> = Observable("")
    var outputIsCompleteButtonEnabled: Observable<Bool> = Observable(false)

    init() {
        inputProfileNumber.bind { [weak self] profileNumber in
            self?.updateProfileImage(profileNumber: profileNumber)
        }
        inputNickname.bind { [weak self] nickname in
            self?.updateNickname(nickname)
        }
        inputMBTISelection.bind { [weak self] selection in
            self?.updateMBTISelection(selection)
        }
    }
    
    private func updateProfileImage(profileNumber: Int) {
        outputProfileImage.value = "profile_\(profileNumber)"
    }
    
    private func updateNickname(_ nickname: String) {
        let validationResult = nickname.validateNickname()
        outputNicknameStatus.value = validationResult.message
        updateCompleteButtonState()
    }
    
    private func updateMBTISelection(_ selection: [String]) {
        updateCompleteButtonState()
    }
    
    private func updateCompleteButtonState() {
        let isNicknameValid = inputNickname.value.validateNickname().isValid
        let isMBTIComplete = inputMBTISelection.value.count == 4
        outputIsCompleteButtonEnabled.value = isNicknameValid && isMBTIComplete
    }
    
    func saveUserData() {
        UserDefaults.standard.set(inputMBTISelection.value, forKey: UserDefaultsKey.mbtiKey)
        UserDefaults.standard.set(inputNickname.value, forKey: UserDefaultsKey.nicknameKey)
        UserDefaults.standard.set(true, forKey: UserDefaultsKey.isUserKey)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let currentDate = dateFormatter.string(from: Date())
        UserDefaults.standard.set(currentDate, forKey: UserDefaultsKey.joinDateKey)
    }
}
