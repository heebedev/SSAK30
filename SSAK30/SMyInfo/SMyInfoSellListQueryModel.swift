//
//  SMyInfoSellListQueryModel.swift
//  SSAK30
//
//  Created by sookjeon on 2020/09/10.
//  Copyright © 2020 김승희. All rights reserved.
//

import Foundation

protocol SMyInfoSellListQueryModelProtocol: class {
    func sellListItemDownloaded(items:NSArray)
}

class SMyInfoSellListQueryModel: NSObject{
    
    var delegate: SMyInfoSellListQueryModelProtocol!
    var urlPath = "http://localhost:8080/test/ssak30_storeInfo_selllist_query.jsp"
    
    func downloadItems(uSeqno: String){
        let urlAdd = "?uSeqno=\(uSeqno)"  // urlPath 뒤에 ? 물음표 부터 뒤에 넣을 것 세팅
        urlPath += urlAdd
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url){(data, response, error) in
            if error != nil{
            }else{
                self.parseJAON(data!)
            }
        }
        task.resume()
    }
    
    func parseJAON(_ data: Data){
        var jsonResult = NSArray()
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        }catch let error as NSError{
            print(error)
        }
        var jsonElement = NSDictionary()
        let locations = NSMutableArray()
        
        for i in 0..<jsonResult.count{
            jsonElement = jsonResult[i] as! NSDictionary
            let query = SMyInfoDBModel()
            // 첫번째 중괄호 안의 변수명 값들을 받아옴.
            if let sellSeqno = jsonElement["sellSeqno"] as? String,
                let sbTitle = jsonElement["sbTitle"] as? String,
                let sbImage = jsonElement["sbImage"] as? String,
                let priceEA = jsonElement["priceEA"] as? String{
            
                query.sellSeqno = sellSeqno
                query.sbTitle = sbTitle
                query.sbImage = sbImage
                query.priceEA = priceEA
            }
            
            locations.add(query)
        }
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.sellListItemDownloaded(items: locations)
        })
    }
}
