//
//  SInterestQueryModel.swift
//  SSAK30
//
//  Created by taeheum on 2020/09/14.
//  Copyright © 2020 김승희. All rights reserved.
//

import Foundation

protocol SInterestQueryModelProtocol: class {
    func reviewItemDownloaded(items:NSArray)
}

class SInterestQueryModel: NSObject{
    
    var delegate: SInterestQueryModelProtocol!
    
    func downloadItems(){
        let uSeqno:String = UserDefaults.standard.string(forKey: "uSeqno")!
        let urlPath = "http://localhost:8080/test/ssak30_interest_review_query.jsp?uSeqno=\(uSeqno)"
        print(urlPath)
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
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        }catch let error as NSError{
            print(error)
        }
        var jsonElement = NSDictionary()
        let locations = NSMutableArray()
        
        for i in 0..<jsonResult.count{
            jsonElement = jsonResult[i] as! NSDictionary
            let query = SInterestDBModel()
            
            // 첫번째 중괄호 안의 변수명 값들을 받아옴.
            if let rTitle = jsonElement["rTitle"] as? String,
                let rContent = jsonElement["rContent"] as? String
                {
               
                    query.rTitle = rTitle
                    query.rContent = rContent
                
            }
            
            locations.add(query)
        }
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.reviewItemDownloaded(items: locations)
        })
    }
}// ——————
