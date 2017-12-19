//
//  Enums.swift
//  MAFIA
//
//  Created by Santiago Carmona Gonzalez on 12/19/17.
//  Copyright © 2017 Santiago Carmona Gonzalez. All rights reserved.
//

import Foundation


enum Role {
    case king,
    doctor,
    sheriff,
    mafia,
    civilian
    
    var imageDescription: String {
        return String(describing: self)
    }
}
    

