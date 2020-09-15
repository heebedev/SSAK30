//
//  SInterestVIPQueryModel.swift
//  SSAK30
//
//  Created by taeheum on 2020/09/14.
//  Copyright © 2020 김승희. All rights reserved.
//

import Foundation

protocol SInterestVIPQueryModelProtocol: class {
    func vipItemDownloaded(bName:String, bPrice:String)
}

class SInterestVIPQueryModel: NSObject{
    
    var delegate : SInterestVIPQueryModelProtocol!
    
    func vipDownloadItems(){
        let uSeqno:String = UserDefaults.standard.string(forKey: "uSeqno")!
        let urlPath = "http://localhost:8080/test/ssak30_interest_vip_query.jsp?uSeqno=\(uSeqno)"
    
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: url){(data, response, error) in
            if error != nil{
                print("Failed to download data")
            }else{
                print("Data is downloaded")
                self.parseJAON(data!)
            }
        }
        task.resume()
    }
    
    func parseJAON(_ data: Data){
        var jsonResult = NSArray()
        var name:String?
        var price:String?
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        }catch let error as NSError{
            print(error)
        }
        var jsonElement = NSDictionary()
        
        
        for i in 0..<jsonResult.count{
            jsonElement = jsonResult[i] as! NSDictionary
            
            // 첫번째 중괄호 안의 변수명 값들을 받아옴.
            if let bName = jsonElement["bName"] as? String,
                let bPrice = jsonElement["bPrice"] as? String
                {
               
                    name = bName
                    price = bPrice
            }
            
        }
        
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.vipItemDownloaded(bName: name!, bPrice: price!)
        })
    }
}// ——————
