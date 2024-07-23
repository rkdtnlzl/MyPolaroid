//
//  NicknameSettingViewController.swift
//  MyPolaroid
//
//  Created by 강석호 on 7/22/24.
//

import UIKit
import SnapKit

final class NicknameSettingViewController: BaseViewController {
    
    private let profileImageView = UIImageView()
    private let profileImageButton = UIButton()
    private let nicknameTextField = UITextField()
    private let nicknameTextFieldLine = UIView()
    private let nicknameStatusLabel = UILabel()
    private let completeButton = UIButton()
    private let mbtiLabel = UILabel()
    private let mbtiView = MBTIView()
    
    private let viewModel = NicknameSettingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let profileNumber = UserDefaults.standard.integer(forKey: "\(UserDefaultsKey.profileNumberKey)")
        viewModel.inputProfileNumber.value = profileNumber
    }
    
    private func bindViewModel() {
        viewModel.outputProfileImage.bind { [weak self] imageName in
            self?.profileImageView.image = UIImage(named: imageName ?? StringLiterals.Default.defaultProfileImage)
        }
        viewModel.outputNicknameStatus.bind { [weak self] message in
            self?.nicknameStatusLabel.text = message
        }
        viewModel.outputIsCompleteButtonEnabled.bind { [weak self] isEnabled in
            self?.completeButton.isEnabled = isEnabled
            self?.completeButton.backgroundColor = isEnabled ? MPColors.blue : MPColors.gray
        }
    }
    
    @objc func nicknameTextFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        viewModel.inputNickname.value = text
    }
    
    @objc func profileImageButtonClicked() {
        let vc = ProfileImageSettingViewController()
        vc.selectedImage = profileImageView.image
        vc.navigationItem.hidesBackButton = false
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func completeButtonClicked() {
        viewModel.saveUserData()
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        let rootVC = TabBarController()
        sceneDelegate?.window?.rootViewController = rootVC
        sceneDelegate?.window?.makeKeyAndVisible()
    }
    
    override func configureNavigation() {
        navigationItem.title = StringLiterals.NavigationTitle.profileSetting
    }
    
    override func configureHierarchy() {
        view.addSubviews(profileImageView, profileImageButton, nicknameTextField, nicknameTextFieldLine, nicknameStatusLabel, completeButton, mbtiLabel, mbtiView)
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
        
        completeButton.tintColor = .white
        completeButton.backgroundColor = MPColors.gray
        completeButton.setTitle(StringLiterals.ButtonTitle.finish, for: .normal)
        completeButton.setTitleColor(.white, for: .normal)
        completeButton.layer.cornerRadius = 20
        completeButton.isEnabled = false
        
        mbtiLabel.text = StringLiterals.LabelText.MBTITitle
        mbtiLabel.textColor = .black
        mbtiLabel.font = .boldSystemFont(ofSize: 17)
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
        completeButton.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(44)
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
    }
    
    override func configureTarget() {
        nicknameTextField.addTarget(self, action: #selector(nicknameTextFieldDidChange), for: .editingChanged)
        profileImageButton.addTarget(self, action: #selector(profileImageButtonClicked), for: .touchUpInside)
        completeButton.addTarget(self, action: #selector(completeButtonClicked), for: .touchUpInside)
        
        mbtiView.selectionChanged = { [weak self] in
            let selectedMBTI = self?.mbtiView.getSelectedMBTI() ?? []
            self?.viewModel.inputMBTISelection.value = selectedMBTI
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
