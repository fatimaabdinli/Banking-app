//
//  Card.swift
//  BankingApp
//
//  Created by Fatima Abdinli on 29.01.24.
//

import Foundation
import RealmSwift

class Card: Object, CardCellProtocol {
    var name: String {
        return cardName
    }
    
    var number: String {
        return cardNumber
    }
    
    var type: String {
        return cardType
    }
    
    var amount: Float {
        return cardAmount
    }
    
    @Persisted var cardName: String
    @Persisted var cardAmount: Float = 0
    @Persisted var cardNumber: String
    @Persisted var cardType: String
    @Persisted var cardID: String
    @Persisted var isFavorite: Bool
    
    override static func primaryKey() -> String? {
        return "cardID"
    }
}
