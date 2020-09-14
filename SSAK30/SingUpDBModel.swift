//
//  SingUpDBModel.swift
//  SSAK30
//
//  Created by 문단비 on 2020/09/14.
//  Copyright © 2020 김승희. All rights reserved.
//
// 회원가입

import Foundation

 

class SingUpDBModel: NSObject{

    var uSeqno: String?
    var uEmail: String?
    var uPassword: String?
    var uName: String?
    var uBirth: String?
    var uPhone: String?
    var uBuySell: String?
    var uRegistDate: String?
    var uValidation: String?

    

    override init() {

    }

    

    init(uSeqno: String, uEmail: String, uPassword: String, uName: String, uBirth: String, uPhone: String, uBuySell:String, uRegistDate:String, uValidation: String){
        self.uSeqno = uSeqno
        self.uEmail = uEmail
        self.uPassword = uPassword
        self.uName = uName
        self.uBirth = uBirth
        self.uPhone = uPhone
        self.uBuySell = uBuySell
        self.uRegistDate = uRegistDate
        self.uValidation = uValidation
    }

}
