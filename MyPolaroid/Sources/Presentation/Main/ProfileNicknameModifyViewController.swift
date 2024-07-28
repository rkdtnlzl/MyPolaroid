//
//  ProfileNicknameModifyViewController.swift
//  MyPolaroid
//
//  Created by 강석호 on 7/28/24.
//

import UIKit
import SnapKit

final class ProfileNicknameModifyViewController: BaseViewController {
    
    private let profileImageView = UIImageView()
    private let profileImageButton = UIButton()
    private let nicknameTextField = UITextField()
    private let nicknameTextFieldLine = UIView()
    private let nicknameStatusLabel = UILabel()
    private let mbtiLabel = UILabel()
    private let mbtiView = MBTIView()
    private let withdrawButton = UIButton()
    private let viewModel = NicknameSettingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        loadUserData()
        configureNavigationItems()
    }
    
    override func configureNavigation() {
        navigationItem.title = StringLiterals.NavigationTitle.profileSetting
    }
    
    private func configureNavigationItems() {
        let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonClicked))
        navigationItem.rightBarButtonItem = saveButton
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    override func configureHierarchy() {
        view.addSubviews(profileImageView, profileImageButton, nicknameTextField, nicknameTextFieldLine, nicknameStatusLabel, mbtiLabel, mbtiView, withdrawButton)
    }
    
    override func configureUI() {
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 50
        profileImageView.layer.borderWidth = 5
        profileImageView.layer.borderColor = MPColors.blue.cgColor
        
        profileImageButton.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        profileImageButton.tintColor = .white
        profileImageButton.backgroundColor = MPColors.blue
        profileImageButton.layer.cornerRadius = 16
        
        nicknameTextField.placeholder = StringLiterals.Placeholder.requestNickName
        nicknameTextField.tintColor = .lightGray
        
        nicknameTextFieldLine.backgroundColor = .darkGray
        
        nicknameStatusLabel.textColor = MPColors.red
        nicknameStatusLabel.font = .systemFont(ofSize: 13)
        
        mbtiLabel.text = StringLiterals.LabelText.MBTITitle
        mbtiLabel.textColor = .black
        mbtiLabel.font = .boldSystemFont(ofSize: 17)
        
        withdrawButton.setTitle("탈퇴하기", for: .normal)
        withdrawButton.setTitleColor(MPColors.blue, for: .normal)
    }
    
    override func configureConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.width.height.equalTo(100)
        }
        profileImageButton.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(profileImageView)
            make.width.height.equalTo(32)
        }
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(30)
            make.leading.trailing.equalTo(view.safeAreaInsets).inset(20)
            make.height.equalTo(44)
        }
        nicknameTextFieldLine.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom)
            make.leading.trailing.equalTo(view.safeAreaInsets).inset(20)
            make.height.equalTo(1)
        }
        nicknameStatusLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextFieldLine.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view.safeAreaInsets).inset(20)
        }
        mbtiLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameStatusLabel.snp.bottom).offset(30)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        mbtiView.snp.makeConstraints { make in
            make.top.equalTo(nicknameStatusLabel.snp.bottom).offset(20)
            make.leading.equalTo(mbtiLabel.snp.trailing).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(120)
        }
        withdrawButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureTarget() {
        nicknameTextField.addTarget(self, action: #selector(nicknameTextFieldDidChange), for: .editingChanged)
        profileImageButton.addTarget(self, action: #selector(profileImageButtonClicked), for: .touchUpInside)
        mbtiView.selectionChanged = { [weak self] in
            let selectedMBTI = self?.mbtiView.getSelectedMBTI() ?? []
            self?.viewModel.inputMBTISelection.value = selectedMBTI
        }
        withdrawButton.addTarget(self, action: #selector(withdrawButtonClicked), for: .touchUpInside)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func loadUserData() {
        let profileNumber = UserDefaults.standard.integer(forKey: "\(UserDefaultsKey.profileNumberKey)")
        let profileImageName = "profile_\(profileNumber)"
        profileImageView.image = UIImage(named: profileImageName)
        if let nickname = UserDefaults.standard.string(forKey: UserDefaultsKey.nicknameKey) {
            nicknameTextField.text = nickname
            viewModel.inputNickname.value = nickname
        }
        if let savedMBTI = UserDefaults.standard.array(forKey: UserDefaultsKey.mbtiKey) as? [String] {
            viewModel.inputMBTISelection.value = savedMBTI
            mbtiView.setSelectedMBTI(savedMBTI)
        }
    }
    
    private func bindViewModel() {
        viewModel.outputProfileImage.bind { [weak self] imageName in
            self?.profileImageView.image = UIImage(named: imageName ?? StringLiterals.Default.defaultProfileImage)
        }
        viewModel.outputNicknameStatus.bind { [weak self] message in
            self?.nicknameStatusLabel.text = message
        }
        viewModel.outputIsCompleteButtonEnabled.bind { [weak self] isEnabled in
            self?.navigationItem.rightBarButtonItem?.isEnabled = isEnabled
        }
    }
    
    @objc func nicknameTextFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        viewModel.inputNickname.value = text
    }
    
    @objc func saveButtonClicked() {
        viewModel.saveUserData()
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        let rootVC = TabBarController()
        sceneDelegate?.window?.rootViewController = rootVC
        sceneDelegate?.window?.makeKeyAndVisible()
    }
    
    @objc func profileImageButtonClicked() {
        let vc = ProfileImageModifyViewController()
        vc.selectedImage = profileImageView.image
        vc.onSelectImage = { [weak self] selectedIndex in
            self?.profileImageView.image = UIImage(named: "profile_\(selectedIndex)")
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func withdrawButtonClicked() {
        showAlertToReset()
    }
    
    private func showAlertToReset() {
        showAlert(title: StringLiterals.AlertLabel.alertTitle,
                  message: StringLiterals.AlertLabel.alertMessage,
                  ok: "확인") { _ in
            if let appDomain = Bundle.main.bundleIdentifier {
                UserDefaults.standard.removePersistentDomain(forName: appDomain)
            }
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let sceneDelegate = windowScene?.delegate as? SceneDelegate
            let rootVC = UINavigationController(rootViewController: OnboardingViewController())
            sceneDelegate?.window?.rootViewController = rootVC
            sceneDelegate?.window?.makeKeyAndVisible()
        }
    }
}
