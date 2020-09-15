//
//  SInterestDBModel.swift
//  SSAK30
//
//  Created by taeheum on 2020/09/14.
//  Copyright © 2020 김승희. All rights reserved.
//

import Foundation

class SInterestDBModel: NSObject{
    
    var rTitle: String?
    var rContent: String?
    var bName: String?
    var bPrice: String?
    
    // 비어있는 init
    override init() {
        
    }
    
    init(rTitle: String, rContent: String){
        self.rTitle = rTitle
        self.rContent = rContent
    }
    
    init(bName: String, bPrice: String){
        self.bName = bName
        self.bPrice = bPrice
    }
    
    
    
    
} // ——
