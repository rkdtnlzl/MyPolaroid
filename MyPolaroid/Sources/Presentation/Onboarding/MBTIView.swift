//
//  MBTIView.swift
//  MyPolaroid
//
//  Created by 강석호 on 7/22/24.
//

import UIKit
import SnapKit

class MBTIView: BaseView {
    
    private let stackView = UIStackView()
    private let topRowStackView = UIStackView()
    private let bottomRowStackView = UIStackView()
    private let topRowTitles = ["E", "S", "T", "J"]
    private let bottomRowTitles = ["I", "N", "F", "P"]
    private var selectedButtons: [Int: UIButton] = [:]
    var selectionChanged: (() -> Void)?
    
    override func configureHierarchy() {
        addSubview(stackView)
        stackView.addArrangedSubview(topRowStackView)
        stackView.addArrangedSubview(bottomRowStackView)
    }
    
    override func configureUI() {
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        configureRowStackView(rowStackView: topRowStackView, titles: topRowTitles, rowIndex: 0)
        configureRowStackView(rowStackView: bottomRowStackView, titles: bottomRowTitles, rowIndex: 1)
    }
    
    override func configureConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureRowStackView(rowStackView: UIStackView, titles: [String], rowIndex: Int) {
        rowStackView.axis = .horizontal
        rowStackView.spacing = 20
        rowStackView.alignment = .center
        
        for (index, title) in titles.enumerated() {
            let button = createButton(withTitle: title)
            button.tag = rowIndex * 4 + index
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            rowStackView.addArrangedSubview(button)
        }
    }
    
    private func createButton(withTitle title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = MPColors.gray
        button.layer.cornerRadius = 22
        button.layer.masksToBounds = true
        button.snp.makeConstraints { make in
            make.width.height.equalTo(44)
        }
        return button
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        let group = sender.tag % 4
        if let selectedButton = selectedButtons[sender.tag], selectedButton == sender {
            selectedButton.backgroundColor = MPColors.gray
            selectedButtons.removeValue(forKey: sender.tag)
        } else {
            for tag in stride(from: group, to: 8, by: 4) {
                if let selectedButton = selectedButtons[tag] {
                    selectedButton.backgroundColor = MPColors.gray
                    selectedButtons.removeValue(forKey: tag)
                }
            }
            selectedButtons[sender.tag] = sender
            sender.backgroundColor = MPColors.blue
        }
        selectionChanged?()
    }
    
    func isSelectionComplete() -> Bool {
        return selectedButtons.keys.filter { $0 < 8 }.count == 4
    }
    
    func getSelectedMBTI() -> [String] {
        let sortedKeys = selectedButtons.keys.sorted()
        return sortedKeys.compactMap { selectedButtons[$0]?.title(for: .normal) }
    }
    
    func setSelectedMBTI(_ mbti: [String]) {
        clearSelection()
        for (_, letter) in mbti.enumerated() {
            let rowIndex = (letter == "E" || letter == "S" || letter == "T" || letter == "J") ? 0 : 1
            let titles = rowIndex == 0 ? topRowTitles : bottomRowTitles
            if let buttonIndex = titles.firstIndex(of: letter) {
                let buttonTag = rowIndex * 4 + buttonIndex
                if let button = getButtonWithTag(buttonTag) {
                    buttonTapped(button)
                }
            }
        }
    }
    
    private func getButtonWithTag(_ tag: Int) -> UIButton? {
        let allButtons = topRowStackView.arrangedSubviews + bottomRowStackView.arrangedSubviews
        return allButtons.compactMap { $0 as? UIButton }.first(where: { $0.tag == tag })
    }
    
    private func clearSelection() {
        for (_, button) in selectedButtons {
            button.backgroundColor = MPColors.gray
        }
        selectedButtons.removeAll()
    }
}

