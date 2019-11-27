//
//  CurrentUser.swift
//  CustomLogin
//
//  Created by formando on 20/11/2019.
//  Copyright © 2019 formando. All rights reserved.
//

import Foundation

struct CurrentUser{
    
    let firstName: String
    let lastName: String
    let email: String
    
    init(firstName: String, lastName: String, email: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }
    
    
}
