//
//  NearStoreModel.swift
//  SSAK30
//
//  Created by 김승희 on 2020/09/10.
//  Copyright © 2020 김승희. All rights reserved.
//

import Foundation

class NearStoreModel: NSObject {
    
    var uSeqno: Int?
    var sName: String?
    var rctSellNameofStore:String?
    var sLiked: Int?
    var sImage: String?
    
    func inti(uSeqno:Int, sName:String, rctSellNameofStore:String, sLiked:Int, sImage:String) {
        
        self.uSeqno = uSeqno
        self.sName = sName
        self.rctSellNameofStore = rctSellNameofStore
        self.sLiked = sLiked
        self.sImage = sImage
    }
    
}
