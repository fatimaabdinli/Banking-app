//
//  QuickActionCell.swift
//  BankingApp
//
//  Created by Fatima Abdinli on 08.02.24.
//

import UIKit

class QuickActionCell: UICollectionViewCell {
    @IBOutlet weak var actionView: UIView!
    @IBOutlet weak var actionImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        actionView.layer.cornerRadius = 30
    }
}
