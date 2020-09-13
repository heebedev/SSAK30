//
//  BHomeDBModel.swift
//  SSAK30
//
//  Created by Songhee Choi on 2020/09/08.
//  Copyright © 2020 김승희. All rights reserved.
//

import Foundation

class BHomeDBModel: NSObject{

    // Properties
    // BHome sellBoard
    var sellSeqno: String?
    var sSeqno: String?
    var sbTitle: String?
    var sbContext: String?
    var sbImage: String?
    var tatalEA: String?
    var minimumEA: String?
    var priceEA: String?
    var openDate: String?
    var closeDate: String?
    var sellRegistDate: String?
    
    // BDetailView 추가
    var storeUSeqno: String?
    var sName: String?
    var sBusinessNo: String?
    var sPhone: String?
    var sAddress: String?
    var sServiceTime: String?
    var sImage: String?
    var mSeqno: String?
    var mName: String?
    var sum_buyEA: String?
    
    
    //Empty Constructor
    override init() {
        
    }
    
    // Constructor
    // 메인
    init(sellSeqno: String, sSeqno:String, sbTitle:String, sbContext:String, sbImage:String, tatalEA:String, minimumEA:String, priceEA:String, openDate:String, closeDate: String, sellRegistDate:String, sellImage:String  ) {
        self.sellSeqno = sellSeqno
        self.sSeqno = sSeqno
        self.sbTitle = sbTitle
        self.sbContext = sbContext
        self.sbImage = sbImage
        self.tatalEA = tatalEA
        self.minimumEA = minimumEA
        self.priceEA = priceEA
        self.openDate = openDate
        self.closeDate = closeDate
        self.sellRegistDate = sellRegistDate
    }
    
//    // BDetailVeiw
    init(sellSeqno: String, sSeqno:String, sbTitle:String, sbContext:String, sbImage:String, tatalEA:String, minimumEA:String, priceEA:String, openDate:String, closeDate: String, sellRegistDate:String, sellImage:String, storeUSeqno:String, sName:String, sBusinessNo:String, sPhone:String, sAddress:String, sServiceTime:String, sImage:String, mSeqno:String, mName:String, sum_buyEA:String ) {
        self.sellSeqno = sellSeqno
        self.sSeqno = sSeqno
        self.sbTitle = sbTitle
        self.sbContext = sbContext
        self.sbImage = sbImage
        self.tatalEA = tatalEA
        self.minimumEA = minimumEA
        self.priceEA = priceEA
        self.openDate = openDate
        self.closeDate = closeDate
        self.sellRegistDate = sellRegistDate
        self.storeUSeqno = storeUSeqno
        self.sName = sName
        self.sBusinessNo = sBusinessNo
        self.sPhone = sPhone
        self.sAddress = sAddress
        self.sServiceTime = sServiceTime
        self.sImage = sImage
        self.mSeqno = mSeqno
        self.mName = mName
        self.sum_buyEA = sum_buyEA
        
    }
}

