//
//  MoreViewController.swift
//  BankingApp
//
//  Created by Fatima Abdinli on 17.01.24.
//

import UIKit

class LogOutViewController: UIViewController {
    @IBOutlet weak var logOutLabel: UILabel!
    @IBOutlet weak var nameSurnameLabel: UILabel!
    @IBOutlet weak var logOutButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    fileprivate func setupTarget() {
        logOutButton.addTarget(self, action: #selector(logOutAction), for: .touchUpInside)
    }
    
    @objc func logOutAction() {
        UserDefaultsHelper.setBool(key: Constant.UD_IS_LOGIN_KEY, value: false)
        
    }
}
