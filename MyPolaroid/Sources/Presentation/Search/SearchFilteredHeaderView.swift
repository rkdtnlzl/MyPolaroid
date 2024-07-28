//
//  SearchFilteredHeaderView.swift
//  MyPolaroid
//
//  Created by 강석호 on 7/25/24.
//

import UIKit
import SnapKit

class SearchFilteredHeaderView: BaseView {
    
    let redButton = UIButton()
    let purpleButton = UIButton()
    let greenButton = UIButton()
    let buttonStackView = UIStackView()
    let sortedButton = UIButton()
    var onSortButtonTapped: (() -> Void)?
    
    override func configureHierarchy() {
        addSubview(sortedButton)
        addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(redButton)
        buttonStackView.addArrangedSubview(purpleButton)
        buttonStackView.addArrangedSubview(greenButton)
    }
    
    override func configureUI() {
        sortedButton.setTitle("관련순", for: .normal)
        sortedButton.setImage(UIImage(named: "sort"), for: .normal)
        sortedButton.setTitleColor(.black, for: .normal)
        sortedButton.layer.cornerRadius = 10
        sortedButton.layer.borderColor = MPColors.darkGray.cgColor
        sortedButton.layer.borderWidth = 0.3
        
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 10
        buttonStackView.alignment = .fill
        buttonStackView.distribution = .fillEqually

        configureButton(button: redButton, title: "레드")
        configureButton(button: purpleButton, title: "퍼플")
        configureButton(button: greenButton, title: "그린")
    }
    
    func configureButton(button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.borderColor = MPColors.darkGray.cgColor
        button.layer.borderWidth = 0.3
    }
    
    override func configureConstraints() {
        buttonStackView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(5)
            make.leading.equalToSuperview().inset(10)
            make.width.equalTo(250)
        }
        sortedButton.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(5)
            make.trailing.equalToSuperview().inset(10)
            make.width.equalTo(100)
        }
    }
    
    override func configureAddTarget() {
        sortedButton.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
    }
    
    @objc private func sortButtonTapped() {
        onSortButtonTapped?()
    }
}
