//
//  LoginController.swift
//  BankingApp
//
//  Created by Fatima Abdinli on 24.01.24.
//

import UIKit
import RealmSwift

class LoginController: UIViewController {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    private var peopleList: Results<Person>?
    let realm = RealmHelper.instance.realm

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTargets()
        getPeopleList()
        print(realm?.configuration.fileURL ?? "")
    }
    
    
// read peopleList from realm
    fileprivate func getPeopleList() {
        let results = realm?.objects(Person.self)
        peopleList = results
//        print(peopleList)
    }

// alert function
    public func showAlertMessage(title: String, message: String){
            
            let alertMessagePopUpBox = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default)
            alertMessagePopUpBox.addAction(okButton)
            self.present(alertMessagePopUpBox, animated: true)
        }
    
   
    
    fileprivate func setupView() {
        emailTextField.layer.borderColor = UIColor.systemIndigo.cgColor
        passTextField.layer.borderColor = UIColor.systemIndigo.cgColor
        signUpButton.layer.borderWidth = 1
        signUpButton.layer.borderColor = UIColor.systemIndigo.cgColor
        
    }
    
    fileprivate func setupTargets() {
        signInButton.addTarget(self, action: #selector(signInActionLog), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpAction), for: .touchUpInside)
    }
    
// signIn button action
    @objc func signInActionLog() {
        checkUser()
    }

// check if username and password are correct
    fileprivate func checkUser() {
        guard let email = emailTextField.text,
              let password = passTextField.text,
              let list = peopleList else {return}
        
        
        if email.count < 6 && password.count < 5 {
            return
        } else {
//            if list.contains(where: {$0.email == email}) {
//                
//            } else {
//                
//            }
            
            guard let user = list.first(where: {$0.email == email}) else {
                showAlertMessage(title: "Alert", message: "User not found")
                return
            }
            if user.pass == password {
                logInSuccess()
            } else {
                showAlertMessage(title: "Alert", message: "Incorrect password")
            }
        }
    }
    
// if username and password are correct then enter HomeViewController
    fileprivate func logInSuccess() {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
        self.navigationController?.pushViewController(vc!, animated: true)
        UserDefaultsHelper.setBool(key: Constant.UD_IS_LOGIN_KEY, value: true)
    }
    
    @objc func signUpAction() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CreateAccountController") as! CreateAccountController
               vc.modalPresentationStyle = .fullScreen
               present(vc, animated: true)
    }
}

// check textFields correct filling
extension LoginController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        switch textField {
        case emailTextField:
           if (textField.text?.count ?? 0) > 6 {
               emailTextField.layer.borderWidth = 0
       
           } else {
               emailTextField.layer.borderWidth = 1
               emailTextField.layer.borderColor = UIColor.red.cgColor
           }
            
        case passTextField:
           if (textField.text?.count ?? 0) > 5 {
               passTextField.layer.borderWidth = 0
            
           } else {
               passTextField.layer.borderWidth = 1
               passTextField.layer.borderColor = UIColor.red.cgColor
           }
        default:
            break
        }
    }
}


