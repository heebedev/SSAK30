//
//  MyInfoQueryModel.swift
//  SSAK30
//
//  Created by sookjeon on 2020/09/08.
//  Copyright © 2020 김승희. All rights reserved.
//

import Foundation

protocol BMyInfoQueryModelProtocol: class {
    func itemDownloaded(items:NSArray)
}

class BMyInfoQueryModel: NSObject{
    
    var delegate: BMyInfoQueryModelProtocol!
    var urlPath = "http://localhost:8080/test/ssak30_myInfo_query.jsp"
    
    func downloadItems(uSeqno:String){
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
            let query = BMyInfoDBModel()
            
            // 첫번째 중괄호 안의 변수명 값들을 받아옴.
            if let uName = jsonElement["uName"] as? String,
               let uImage = jsonElement["uImage"] as? String,
               let uEmail = jsonElement["uEmail"] as? String,
               let uPassword = jsonElement["uPassword"] as? String,
               let uPhone = jsonElement["uPhone"] as? String,
               let totalCash = jsonElement["totalCash"] as? String{
                
                query.uName = uName
                query.uImage = uImage
                query.totalCash = totalCash
                query.uEmail = uEmail
                query.uPassword = uPassword
                query.uPhone = uPhone
            }
            
            locations.add(query)
        }
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.itemDownloaded(items: locations)
        })
    }
}// ------------

