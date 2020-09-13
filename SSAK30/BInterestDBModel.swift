//
//  BInterestDBModel.swift
//  SSAK30
//
//  Created by taeheum on 2020/09/10.
//  Copyright © 2020 김승희. All rights reserved.
//

import Foundation

class BInterestDBModel: NSObject{
    
    var sName: String?
    var sImage: String?
//    var sImage: String?
    
    // 비어있는 init
    override init() {
        
    }
    
    init(sName: String, sImage: String){
        self.sName = sName
        self.sImage = sImage
//        self.sImage = sImage
    }
    
    
    
    
} // ----
