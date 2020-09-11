//
//  MainQueryModel.swift
//  SSAK30
//
//  Created by Songhee Choi on 2020/09/08.
//  Copyright © 2020 김승희. All rights reserved.
//

import Foundation

protocol QueryModelProtocol: class{
    func itemDownloaded(items:NSArray)
}

class BHomeQueryModel: NSObject{
    
    var delegate: QueryModelProtocol!
    let urlPath = "http://localhost:8080/ssak30/bHomeQuery_recent_ios.jsp"
    
    func downloadItems(){
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: url){(data, response, error) in
            if error != nil { // 에러코드가 없을 때 실행
                print("Failed to download data")
            }else{
                print("Data is downloaded")
                
                //parse JSON
                self.parseJSON(data!)
            }
        }
        task.resume()
    }
    
    func parseJSON(_ data: Data){
        var jsonResult = NSArray()
           
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        }catch let error as NSError{
            print(error)
        }
            
        var jsonElement = NSDictionary()
        let locations = NSMutableArray()
        
        for i in 0..<jsonResult.count{
            jsonElement = jsonResult[i] as! NSDictionary // 제일 처음 중괄호 묶여있는 데이터 jsonResult[i]> 0번으로 들어와있고 > Dictionary로 바꿔주고
            let query = BHomeDBModel()
            
            if  let sellSeqno = jsonElement["sellSeqno"] as? String,
                let sSeqno = jsonElement["storeinfo_sSeqno"] as? String,
                let sbTitle = jsonElement["sbTitle"] as? String,
                let sbContext = jsonElement["sbContent"] as? String,
                let sbImage = jsonElement["sbImage"] as? String,
                let tatalEA = jsonElement["tatalEA"] as? String,
                let minimumEA = jsonElement["minimumEA"] as? String,
                let priceEA = jsonElement["priceEA"] as? String,
                let openDate = jsonElement["openDate"] as? String,
                let closeDate = jsonElement["closeDate"] as? String,
                let sellRegistDate = jsonElement["sellRegistDate"] as? String{
                
                query.sellSeqno = sellSeqno
                query.sSeqno = sSeqno
                query.sbTitle = sbTitle
                query.sbContext = sbContext
                query.sbImage = sbImage
                query.tatalEA = tatalEA
                query.minimumEA = minimumEA
                query.priceEA = priceEA
                query.openDate = openDate
                query.closeDate = closeDate
                query.sellRegistDate = sellRegistDate
                
            }
            
            // 배열에 넣어줌
            locations.add(query)
        }
        
        // 프로토콜로 전달
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.itemDownloaded(items: locations)
        })
        
    }
    
}//----
