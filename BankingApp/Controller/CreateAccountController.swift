//
//  CreateAccountController.swift
//  BankingApp
//
//  Created by Fatima Abdinli on 24.01.24.
//

import UIKit
import RealmSwift

class CreateAccountController: UIViewController {
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var surnameField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!

    
    private var peopleList: Results<Person>?
    let realm = RealmHelper.instance.realm
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(realm?.configuration.fileURL ?? "")
        setupTarget()
    }

// save user to realm
    fileprivate func saveObjectToRealm(surname: String, name: String, age: String, email: String, pass: String, update: Bool = true) {
        let person = Person()
        person.surname = surname
        person.name = name
        person.age = age
        person.email = email
        person.pass = pass

        try! realm?.write() {
            realm?.add(person)
        }
    }
        
    fileprivate func setupTarget() {
        signInButton.addTarget(self, action: #selector(signInAction), for: .touchUpInside)
        dismissButton.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)

    }
    
    public func showAlertMessage(title: String, message: String){
            
            let alertMessagePopUpBox = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default)
            alertMessagePopUpBox.addAction(okButton)
            self.present(alertMessagePopUpBox, animated: true)
        }
    
    @objc func signInAction() {
        if ((surnameField.text!.isEmpty)) || ((nameField.text!.isEmpty)) || ((ageField.text!.isEmpty)) || ((emailField.text!.isEmpty)) || ((passField.text!.isEmpty)) {
            showAlertMessage(title: "Alert", message: "Fill all fields")
        } else {
            saveObjectToRealm(surname: surnameField.text ?? "", name: nameField.text ?? "", age: ageField.text ?? "", email: emailField.text ?? "", pass: passField.text ?? "")
            dismiss(animated: true)
        }
    }
    
    @objc func dismissAction() {
    dismiss(animated: true)
    }
}


extension CreateAccountController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case surnameField:
            if (textField.text?.count ?? 0) > 4 {
                surnameField.layer.borderWidth = 0
            } else {
                surnameField.layer.borderWidth = 1
                surnameField.layer.borderColor = UIColor.red.cgColor
            }
        case nameField:
            if (textField.text?.count ?? 0) > 4 {
                nameField.layer.borderWidth = 0
            } else {
                nameField.layer.borderWidth = 1
                nameField.layer.borderColor = UIColor.red.cgColor
            }
        case ageField:
            if (textField.text?.count ?? 0) > 0 && (textField.text?.count ?? 0) < 3 {
                ageField.layer.borderWidth = 0
            } else {
                ageField.layer.borderWidth = 1
                ageField.layer.borderColor = UIColor.red.cgColor
            }
        case emailField:
            if (textField.text?.count ?? 0) > 6 {
                emailField.layer.borderWidth = 0
            } else {
                emailField.layer.borderWidth = 1
                emailField.layer.borderColor = UIColor.red.cgColor
            }
        case passField:
            if (textField.text?.count ?? 0) > 5 {
                passField.layer.borderWidth = 0
            } else {
                passField.layer.borderWidth = 1
                passField.layer.borderColor = UIColor.red.cgColor
            }
        default:
            break
        }
    }
}
