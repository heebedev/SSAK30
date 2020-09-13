//
//  AfterSearchResultModel.swift
//  SSAK30
//
//  Created by 김승희 on 2020/09/11.
//  Copyright © 2020 김승희. All rights reserved.
//

import Foundation

class AfterSearchResultModel: NSObject {
    
    var sellSeqno: Int?
    var sName: String?
    var sbTitle: String?
    var sbImage: String?
    var mName: String?
    
    func inti(sellSeqno:Int, sName:String, sbTitle:String, sbImage:String, mName:String?) {
        
        self.sellSeqno = sellSeqno
        self.sName = sName
        self.sbTitle = sbTitle
        self.sbImage = sbImage
        self.mName = mName
    
    }
    
}
