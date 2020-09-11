//
//  StoreMarketQueryModel.swift
//  SSAK30
//
//  Created by 김승희 on 2020/09/10.
//  Copyright © 2020 김승희. All rights reserved.
//

import Foundation

protocol StoreMarketQueryModelProtocol: class {
    func itemDownloaded(items: NSArray, purpose: String)
}

class StoreMarketQueryModel: NSObject{
    
    var delegate: StoreMarketQueryModelProtocol!
    var urlPath = ""
    
    func downloadItems(purpose:String, latitude:Double, longitude:Double) {
        switch purpose {
        case "nearStore":
            urlPath = "http://localhost:8080/test/nearStore_query_ios.jsp?latitude=\(latitude)&longitude=\(longitude)"
        case "nearMarket":
            urlPath = "http://localhost:8080/test/nearMarket_query_ios.jsp?latitude=\(latitude)&longitude=\(longitude)"
        default: break
        }
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: url){(data, response, error) in
            if error != nil {
                print("Failed to download data")
            } else {
                print("Data is downloaded")
                self.parseJSON(purpose: purpose, data: data!)
            }
        }
        task.resume()
    }
    
    func parseJSON(purpose:String, data: Data) {
        var jsonResult = NSArray()
        
        do {
            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        } catch let error as NSError {
            print(error)
        }
        
        var jsonElement = NSDictionary()
        let items = NSMutableArray()
        
        switch purpose {
        case "nearStore":
            for i in 0..<jsonResult.count {
                
                jsonElement = jsonResult[i] as! NSDictionary
                let query = NearStoreModel()
                
                if let sSeqno = jsonElement["sSeqno"] as? String,
                    let sName = jsonElement["sName"] as? String,
                    let rctSellNameofStore = jsonElement["rctSellNameofStore"] as? String,
                    let sLiked = jsonElement["sLiked"] as? String,
                    let sImage = jsonElement["sImage"] as? String {
                    
                    query.sSeqno = Int(sSeqno)
                    query.sName = sName
                    query.rctSellNameofStore = rctSellNameofStore
                    query.sLiked = Int(sLiked)
                    query.sImage = sImage
                }
                items.add(query)
            }
        case "nearMarket":
            for i in 0..<jsonResult.count {
                jsonElement = jsonResult[i] as! NSDictionary
                
                let query = MarketModel()
                
                if let mName = jsonElement["mName"] as? String,
                    let mIncludedSales = jsonElement["mIncludedSales"] as? String,
                    let mLatitude = jsonElement["mLatitude"] as? String,
                    let mLongitude = jsonElement["mLongitude"] as? String {
                    
                    query.mName = mName
                    query.mIncludedSales = Int(mIncludedSales)
                    query.mLatitude = Double(mLatitude)
                    query.mLongitude = Double(mLongitude)
                }
                items.add(query)
            }
        default: break
        }
        
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.itemDownloaded(items: items, purpose: purpose)
        })
        
    }

    
}
