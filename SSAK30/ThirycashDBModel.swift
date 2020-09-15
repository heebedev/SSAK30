//
//  ThirycashDBModel.swift
//  SSAK30
//
//  Created by Songhee Choi on 2020/09/14.
//  Copyright © 2020 김승희. All rights reserved.
//

import Foundation

class ThirycashDBModel: NSObject{
    
    // Properties
    var cashSeqno: String?
    var userinfo_uSeqno: String?
    var totalCash: String?
    var useCode: String?
    var usePrice: String?
    var useDate: String?
    var sRegistDate: String?
    var cashValidation: String?
    
    //Empty Constructor
    override init() {
        
    }
    
    // Constructor
    // my 떠리캐시 전체 select
    init(cashSeqno: String, userinfo_uSeqno:String, totalCash:String, useCode:String, usePrice:String, useDate:String, sRegistDate:String, cashValidation:String) {
        self.cashSeqno = cashSeqno
        self.userinfo_uSeqno = userinfo_uSeqno
        self.totalCash = totalCash
        self.useCode = useCode
        self.usePrice = usePrice
        self.useDate = useDate
        self.sRegistDate = sRegistDate
        self.cashValidation = cashValidation
    }
}
