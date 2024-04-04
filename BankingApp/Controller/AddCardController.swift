//
//  AddCardController.swift
//  BankingApp
//
//  Created by Fatima Abdinli on 29.01.24.
//

import UIKit
import RealmSwift

class AddCardController: UIViewController {
    @IBOutlet weak var cardNameTextField: UITextField!
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var cardTypeTextField: UITextField!
    @IBOutlet weak var confirmCardButton: UIButton!
    
    var cardAddCallback: (() -> Void)?

    let realm = RealmHelper.instance.realm
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTargets()
        setupView()
        cardNumberTextField.text = "1111111111111111111"
        print(realm?.configuration.fileURL ?? "")
    }
    
    fileprivate func setupView() {
        confirmCardButton.layer.borderWidth = 1
        confirmCardButton.layer.borderColor = UIColor.black.cgColor
        confirmCardButton.layer.cornerRadius = 8

    }
    
    fileprivate func setupTargets() {
        confirmCardButton.addTarget(self, action: #selector(confirmButtonAction), for: .touchUpInside)
    }
    
    @objc func confirmButtonAction() {
        if ((cardNameTextField.text!.isEmpty)) || ((cardNumberTextField.text!.isEmpty)) || ((cardTypeTextField.text!.isEmpty)) {
            showAlertMessage(title: "Alert", message: "Fill all fields")
        } else {
            saveObjectToRealm(cardName: cardNameTextField.text ?? "", cardNumber: cardNumberTextField.text ?? "", cardType: cardTypeTextField.text ?? "")
            self.cardAddCallback?()
            dismiss(animated: true)
        }
    }
    
    fileprivate func saveObjectToRealm(cardName: String, cardNumber: String, cardType: String, update: Bool = true) {
        let card = Card()
        card.cardName = cardName
        card.cardNumber = cardNumber
        card.cardType = cardType
        card.cardID = UUID().uuidString    // remember!
        try! realm?.write() {
            realm?.add(card)
        }
    }
    
    public func showAlertMessage(title: String, message: String) {
            let alertMessagePopUpBox = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default)
            alertMessagePopUpBox.addAction(okButton)
            self.present(alertMessagePopUpBox, animated: true)
        }
}


extension AddCardController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case cardNameTextField:
            if (textField.text?.count ?? 0) > 3 {
                cardNameTextField.layer.borderWidth = 0
            } else {
                cardNameTextField.layer.borderWidth = 1
                cardNameTextField.layer.borderColor = UIColor.red.cgColor
            }
        case cardNumberTextField:
            if (textField.text?.count ?? 0) == 19 {
                cardNumberTextField.layer.borderWidth = 0
            } else {
                cardNumberTextField.layer.borderWidth = 1
                cardNumberTextField.layer.borderColor = UIColor.red.cgColor
            }
        case cardTypeTextField:
            if (textField.text?.count ?? 0) > 3 {
                cardTypeTextField.layer.borderWidth = 0
            } else {
                cardTypeTextField.layer.borderWidth = 1
                cardTypeTextField.layer.borderColor = UIColor.red.cgColor
            }
        default:
            break
        }
    }
}
