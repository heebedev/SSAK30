//
//  LoginModel.swift
//  SSAK30
//
//  Created by 김승희 on 2020/09/14.
//  Copyright © 2020 김승희. All rights reserved.
//

import Foundation

protocol LoginModelProtocol: class {
    func LoginitemDownloaded(items: NSArray)
}
class LoginModel: NSObject {
    

    var delegate: LoginModelProtocol!
    var urlPath = "http://localhost:8080/test/Login_ios.jsp"
    
    func downloadItems(uEmail:String, uPassword: String){
        let urlAdd = "?uEmail=\(uEmail)&uPassword=\(uPassword)"  // urlPath 뒤에 ? 물음표 부터 뒤에 넣을 것 세팅
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
            let query = SingUpDBModel()
            
            // 첫번째 중괄호 안의 변수명 값들을 받아옴.
            if let uSeqno = jsonElement["uSeqno"] as? String,
               let uBuySell = jsonElement["uBuySell"] as? String{
               
                query.uSeqno = uSeqno
                query.uBuySell = uBuySell
                
                print(uSeqno)
                print(uBuySell)
            }
            
            locations.add(query)
        }
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.LoginitemDownloaded(items: locations)
        })
    }
    
}
