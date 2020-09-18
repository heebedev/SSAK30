//
//  MarketModel.swift
//  SSAK30
//
//  Created by 김승희 on 2020/09/10.
//  Copyright © 2020 김승희. All rights reserved.
//

import Foundation

class MarketModel: NSObject {
    
    var mName: String?
    var mIncludedSales : Int?
    var mLatitude : Double?
    var mLongitude : Double?
    
    
    func inti(mName:String, mIncludedSales:Int, mLatitude:Double, mLongitude:Double) {
        self.mName = mName
        self.mIncludedSales = mIncludedSales
        self.mLatitude = mLatitude
        self.mLongitude = mLongitude
    }
    
}
