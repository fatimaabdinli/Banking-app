//
//  Person.swift
//  BankingApp
//
//  Created by Fatima Abdinli on 28.01.24.
//

import Foundation
import RealmSwift

class Person: Object {
    
    @Persisted var surname: String
    @Persisted var name: String
    @Persisted var age: String
    @Persisted var email: String
    @Persisted var pass: String

    }


