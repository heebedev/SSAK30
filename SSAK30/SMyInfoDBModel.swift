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
    var sellSeq: String?
    var sellImage: String?
    var sellTitle: String?
    var PriceEA: String?
    
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
    
    init(sellSeq: String, sellImage: String, sellTitle:String, PriceEA:String, sellCount:String){
        self.sellSeq = sellSeq
        self.sellImage = sellImage
        self.sellTitle = sellTitle
        self.PriceEA = PriceEA
        self.sellCount = sellCount
    }
}
