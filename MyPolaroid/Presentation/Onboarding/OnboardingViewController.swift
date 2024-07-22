//
//  OnboardingViewController.swift
//  MyPolaroid
//
//  Created by 강석호 on 7/22/24.
//

import UIKit
import SnapKit

final class OnboardingViewController: BaseViewController {
    
    private let logoImageView = UIImageView()
    private let polaroidImageView = UIImageView()
    private let nameLabel = UILabel()
    private let startButton = UIButton()
    
    @objc func startButtonClicked() {
        let vc = NicknameSettingViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func configureHierarchy() {
        view.addSubview(logoImageView)
        view.addSubview(polaroidImageView)
        view.addSubview(nameLabel)
        view.addSubview(startButton)
    }
    
    override func configureUI() {
        logoImageView.image = UIImage(named: "launchTitle")
        logoImageView.contentMode = .scaleAspectFit
        
        polaroidImageView.image = UIImage(named: "launchImage")
        polaroidImageView.contentMode = .scaleAspectFit
        
        nameLabel.text = "강석호"
        nameLabel.textColor = .black
        nameLabel.font = .boldSystemFont(ofSize: 17)
        nameLabel.textAlignment = .center
        
        startButton.setTitle("시작하기", for: .normal)
        startButton.setTitleColor(.white, for: .normal)
        startButton.backgroundColor = .blue
        startButton.layer.cornerRadius = 20
    }
    
    override func configureConstraints() {
        logoImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        polaroidImageView.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(polaroidImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        startButton.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(44)
        }
    }
    
    override func configureTarget() {
        startButton.addTarget(self, action: #selector(startButtonClicked), for: .touchUpInside)
    }
}
