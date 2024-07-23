//
//  BaseViewController.swift
//  MyPolaroid
//
//  Created by 강석호 on 7/22/24.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        configureHierarchy()
        configureUI()
        configureConstraints()
        configureTarget()
        configureNavigation()
    }
    
    func configureHierarchy() { }
    
    func configureUI() { }
    
    func configureConstraints() { }
    
    func configureTarget() { }
    
    func configureNavigation() { }
}
