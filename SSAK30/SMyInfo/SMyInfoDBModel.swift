//
//  SMyInfoDBModel.swift
//  SSAK30
//
//  Created by sookjeon on 2020/09/09.
//  Copyright © 2020 김승희. All rights reserved.
//

import Foundation

class SMyInfoDBModel: NSObject{
    
    var sSeqno: String?
    var sName: String?
    var sImage: String?
    var sBusinessNo: String?
    var sPhone: String?
    var sAddress: String?
    var sServiceTime: String?
    var rGrade: String?
    var reviewCount: String?
    var likeCount: String?
    var sellCount: String?
    var sellSeqno: String?
    var sbImage: String?
    var sbTitle: String?
    var priceEA: String?
    
    override init() {
    
    }
    
    init(sSeqno:String, sName: String, sImage: String, sBusinessNo:String, sPhone:String, sAddress:String, sServiceTime:String){
        self.sSeqno = sSeqno
        self.sName = sName
        self.sImage = sImage
        self.sBusinessNo = sBusinessNo
        self.sPhone = sPhone
        self.sAddress = sAddress
        self.sServiceTime = sServiceTime
    }
    
    init(rGrade: String, reviewCount: String){
        self.rGrade = rGrade
        self.reviewCount = reviewCount
    }
    
    init(sellSeqno: String, sbImage: String, sbTitle:String, priceEA:String, sellCount:String){
        self.sellSeqno = sellSeqno
        self.sbImage = sbImage
        self.sbTitle = sbTitle
        self.priceEA = priceEA
        self.sellCount = sellCount
    }
}
