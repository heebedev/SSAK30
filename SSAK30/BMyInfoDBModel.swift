//
//  MyInfoDBModel.swift
//  SSAK30
//
//  Created by sookjeon on 2020/09/08.
//  Copyright © 2020 김승희. All rights reserved.
//

import Foundation

class BMyInfoDBModel:NSObject {
    
    var uImage: String?
    var uName: String?
    var totalCash: String?
    var sellSeqno: String?
    var sellImage: String?
    var sellTitle: String?
    var priceEA: String?
    var reviewSeq: String?
    var reviewListImage: String?
    var reviewListTitle: String?
    
    override init() {
            
    }
    
    init(uImage: String, uName: String, totalCash:String) {
        self.uImage = uImage
        self.uName = uName
        self.totalCash = totalCash
    }

    init(sellSeqno: String?, sellImage: String, sellTitle: String, priceEA: String){
        self.sellSeqno = sellSeqno
        self.sellImage = sellImage
        self.sellTitle = sellTitle
        self.priceEA = priceEA
    }
    
    init(reviewSeq: String, reviewListImage: String, reviewListTitle: String){
        self.reviewSeq = reviewSeq
        self.reviewListImage = reviewListImage
        self.reviewListTitle = reviewListTitle
    }

}
