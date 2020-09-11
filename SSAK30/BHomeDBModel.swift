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
    var sellSeqno: String?
    var sSeqno: String?
    var sellTitle: String?
    var sellContext: String?
    var tatalEA: String?
    var minimumEA: String?
    var priceEA: String?
    var openDate: String?
    var closeDate: String?
    var sellRegistDate: String?
    var sellImage: String?
    
    
    //Empty Constructor
    override init() {
        
    }
    
    // Constructor
    init(sellSeqno: String, sSeqno:String, sellTitle:String, sellContext:String,  tatalEA:String, minimumEA:String, priceEA:String, openDate:String, closeDate: String, sellRegistDate:String, sellImage:String  ) {
        self.sellSeqno = sellSeqno
        self.sSeqno = sSeqno
        self.sellTitle = sellTitle
        self.sellContext = sellContext
        self.tatalEA = tatalEA
        self.minimumEA = minimumEA
        self.priceEA = priceEA
        self.openDate = openDate
        self.closeDate = closeDate
        self.sellRegistDate = sellRegistDate
        self.sellImage = sellImage
    }
}

