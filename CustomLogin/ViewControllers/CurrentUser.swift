//
//  CurrentUser.swift
//  CustomLogin
//
//  Created by formando on 20/11/2019.
//  Copyright © 2019 formando. All rights reserved.
//

import Foundation

struct CurrentUser{
    
    static var shared = CurrentUser()
    
    var uid: String?
    var profileEmail: String?
    var name: String?
    var surname: String?
    var profileUsername: String?
    
}
