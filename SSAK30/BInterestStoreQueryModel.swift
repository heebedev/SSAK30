//
//  BInterestStoreQueryModel.swift
//  SSAK30
//
//  Created by taeheum on 2020/09/10.
//  Copyright © 2020 김승희. All rights reserved.
//

import Foundation

protocol BInterestStoreQueryModelProtocol: class {
    func storeItemDownloaded(items:NSArray)
}

class BInterestStoreQueryModel: NSObject{
    
    var delegate: BInterestStoreQueryModelProtocol!
    var urlPath = "http://localhost:8080/test/ssak30_interest_store_query.jsp?uSeqno="
    
    func downloadItems(){
        let uSeqno:Int = UserDefaults.standard.integer(forKey: "uSeqno")
//        let urlAdd = "?uSeqno=\(uSeqno)"  // urlPath 뒤에 ? 물음표 부터 뒤에 넣을 것 세팅
//        urlPath += urlAdd
        urlPath += String(uSeqno)
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
            let query = BInterestDBModel()
            
            // 첫번째 중괄호 안의 변수명 값들을 받아옴.
            if let sName = jsonElement["sName"] as? String,
                let sImage = jsonElement["sImage"] as? String
//               let sImage = jsonElement["sImage"] as? String
                {
               
                    query.sName = sName
                    query.sImage = sImage
//                query.sImage = sImage
                
            }
            
            locations.add(query)
        }
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.storeItemDownloaded(items: locations)
        })
    }
}// ------------
