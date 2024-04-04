//
//  CardCell.swift
//  BankingApp
//
//  Created by Fatima Abdinli on 08.02.24.
//

import UIKit
import RealmSwift

protocol CardCellProtocol {
    var name: String {get}
    var number: String {get}
    var cardID: String {get}
    var type: String {get}
    var amount: Float {get}
}

class CardCell: UICollectionViewCell {
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var cardName: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var cardNumber: UILabel!
    @IBOutlet weak var cardType: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    private var cardId: String?

    var favoriteCallback: ((String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        setupTarget()
    }
    
    func configureCell(card: CardCellProtocol) {
        cardName.text = card.name
        cardNumber.text = card.number
        cardType.text = card.type
        amount.text = "\(String(card.amount)) AZN"
        cardId = card.cardID
    }
    
    fileprivate func setupView() {
        cellView.layer.cornerRadius = 8
    }
    
    fileprivate func setupTarget() {
        self.favoriteButton.addTarget(self, action: #selector(favoriteButtonAction), for: .touchUpInside)
    }
    
    @objc func favoriteButtonAction() {
        favoriteCallback?(cardId ?? "")
        
        if (favoriteButton.imageView?.image == UIImage(systemName: "star")) {
            favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
}
 
