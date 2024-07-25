//
//  FilteredHeaderView.swift
//  MyPolaroid
//
//  Created by 강석호 on 7/25/24.
//

import UIKit
import SnapKit

class FilteredHeaderView: BaseView {
    
    let sortedButton = UIButton()
    var onSortButtonTapped: (() -> Void)?
    
    override func configureHierarchy() {
        addSubview(sortedButton)
    }
    
    override func configureUI() {
        sortedButton.setTitle("최신순", for: .normal)
        sortedButton.setImage(UIImage(named: "sort"), for: .normal)
        sortedButton.setTitleColor(.black, for: .normal)
        sortedButton.layer.cornerRadius = 10
        sortedButton.layer.borderColor = MPColors.darkGray.cgColor
        sortedButton.layer.borderWidth = 0.3
    }
    
    override func configureConstraints() {
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
