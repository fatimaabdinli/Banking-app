//
//  TransferController.swift
//  BankingApp
//
//  Created by Fatima Abdinli on 25.02.24.
//

import UIKit
import RealmSwift

class TransferController: UIViewController {
    
    @IBOutlet weak var transferHeader: UILabel!
    @IBOutlet weak var sendFromLabel: UILabel!
    @IBOutlet weak var sendFromCardName: UITextField!
    @IBOutlet weak var sendToLabel: UILabel!
    @IBOutlet weak var sendToCardName: UITextField!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var transferButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    
    let realm = RealmHelper.instance.realm

    var fromCard: Card?
    var availableCards: Results<Card>?
    var toCard: Card?
    
//    transfer complete olanda (getCardList isletmek ucun, ki cardCellde amount update edesen)
    var transferCallback: (() -> Void)?
    
    var pickerView: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTarget()
        setupView()
        
//        prevents sending funds to the fromCard
        availableCards = availableCards?.where { $0.cardID != fromCard!.cardID }
    }
    
    fileprivate func setupView() {
        
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
//        fromCard name and number in textField
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view.addGestureRecognizer(tap)
    
        sendFromCardName.text = getCardTitle(card: fromCard!)
        
//        add done button to pickerView (programatically)
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.systemIndigo
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        sendToCardName.inputAccessoryView = toolBar
        
        sendToCardName.inputView = pickerView
        sendFromCardName.isUserInteractionEnabled = false
    }
    
    @objc func donePicker() {
        sendToCardName.resignFirstResponder()
    }
    
    fileprivate func getCardTitle(card: Card) -> String {
        return "\(card.cardName) (\(card.cardNumber))"
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
       self.view.endEditing(true)
    }
    
    fileprivate func setupTarget() {
        transferButton.addTarget(self, action: #selector(transferAction), for: .touchUpInside)
        dismissButton.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)

    }
    
    @objc func transferAction() {
        let amount: Float = Float(amountTextField.text!) ?? 0
        
        if (fromCard != nil && toCard != nil /*&& availableCards?.count ?? 0 > 1*/) {
            if fromCard!.cardAmount > amount /*&& availableCards?.count ?? 0 > 1*/ {
                try! realm?.write() {
                    fromCard!.cardAmount = fromCard!.cardAmount - amount
                    toCard!.cardAmount = toCard!.cardAmount + amount
                    showAlertMessage(title: "Successful transfer", message: "Amount has been transferred")
                    transferCallback?()
                }
                
            } else {
                showAlertMessage(title: "Cannot transfer", message: "No enough funds in your card")
            }
        }
    }
    
    @objc func dismissAction() {
        dismiss(animated: true)
    }
    
    public func showAlertMessage(title: String, message: String){
            let alertMessagePopUpBox = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: returnToHomeVC)
            alertMessagePopUpBox.addAction(okButton)
            self.present(alertMessagePopUpBox, animated: true)
        }
    
    func returnToHomeVC(_: UIAlertAction) {
        self.dismiss(animated: true)
    }
}


extension TransferController: UIPickerViewDelegate, UIPickerViewDataSource {
  
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        availableCards?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       return getCardTitle(card: availableCards![row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        sendToCardName.text = getCardTitle(card: availableCards![row])
        toCard = availableCards![row]
    }
}


