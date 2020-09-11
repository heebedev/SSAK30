//
//  SignUpModel.swift
//  SSAK30
//
//  Created by 문단비 on 2020/09/08.
//  Copyright © 2020 김승희. All rights reserved.
//

// 회원가입
import Foundation

class SignUpModel: NSObject {
    
    var delegate: QueryModelProtocol!
    var urlPath = "http://localhost:8080/SSAK30/SignUp_ios.jsp"
    var urlPath1 = "http://localhost:8080/SSAK30/Login_ios.jsp"
    
    func SignUpInsertloadItems(uEmail: String, uPassword: String, uName: String, uBirth: String, uPhone: String, uBuySell: String) -> Bool{
        var result: Bool = true
        
        let urlAdd = "?uEmail=\(uEmail)&uPassword=\(uPassword)&uName=\(uName)&uBirth=\(uBirth)&uPhone=\(uPhone)&uBuySell=\(uBuySell)"
        urlPath += urlAdd
        
//        print(uBuySell, "확인")
        
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        let url: URL = URL(string: urlPath)!
        let defaultSesstion = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSesstion.dataTask(with: url){(data, response, error) in
            if error != nil{
                print("Failed to insert data")
                result = false
            }else{
                print("Data is inserted")
                result = true
            }
        }
        task.resume()
        
        return result
    }
    
    
    func downloadItems(uEmail: String, uPassword: String) -> Bool{
            var result: Bool = true
            
//            let urlAdd = "?uEmail=\(uEmail)&uPassword=\(uPassword)&uName=\(uName)&uBirth=\(uBirth)&uPhone=\(uPhone)&uBuySell=\(uBuySell)"
//            urlPath += urlAdd
            
    //        print(uBuySell, "확인")
            
            urlPath1 = urlPath1.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            
            let url: URL = URL(string: urlPath1)!
            let defaultSesstion = Foundation.URLSession(configuration: URLSessionConfiguration.default)
            let task = defaultSesstion.dataTask(with: url){(data, response, error) in
                if error != nil{
                    print("Failed to insert data")
                    result = false
                }else{
                    print("Data is inserted")
//                    self.parseJSON(data!)
                    result = true
                }
            }
            task.resume()
                print(uEmail, "SignUp")
                print(uPassword, "SignUp")
                
            return result
        }
    
    
    
    
    
    
//    func downloadItems(uEmail: String, uPassword: String) -> Bool{
//        var result: Bool = true
//        let url: URL = URL(string: urlPath)!
//        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
//
////        let urlAdd = "?uSeqno\(uSeqno)"
////        urlPath += urlAdd
//
////        print(urlAdd)
//
//        let task = defaultSession.dataTask(with: url){(data, response, error) in
//            if error != nil {
//                print("failed to download data")
//                result = false
//            } else {
//                print("Data is downloaded")
//                self.parseJSON(data!)
//                result = true
//            }
//        }
//        task.resume()
//
//        return result
//    }
    
//    func parseJSON(_ data: Data) {
//        var jsonResult = NSArray()
//
//        do {
//            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
//        } catch let error as NSError {
//            print(error)
//        }
//        var jsonElement = NSDictionary()
//        let locations = NSMutableArray()
//
//        for i in 0..<jsonResult.count {
//            jsonElement = jsonResult[i] as! NSDictionary
//            let query = SingUpDBModel()
//
//            if let uEmail = jsonElement["uEmail"] as? String,
//               let uPassword = jsonElement["uPassword"] as? String {
//
////                query.uSeqno = uSeqno
//                query.uEmail = uEmail
//                query.uPassword = uPassword
//            }
//
//            locations.add(query)
//
//        }
//
//        DispatchQueue.main.async(execute: {() -> Void in
//            self.delegate.itemDownloaded(items: locations)
//        })
//    }
    
    
    
    
}//-------------------------
