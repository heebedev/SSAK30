//
//  SignUpModel.swift
//  SSAK30
//
//  Created by 문단비 on 2020/09/08.
//  Copyright © 2020 김승희. All rights reserved.
//

// 회원가입
import Foundation

//protocol LoginModelProtocol: class {
//    func itemDownloaded(items: NSArray)
//}

class SignUpModel: NSObject {
    
    
    var urlPath = "http://localhost:8080/test/SignUp_ios.jsp"
    func SignUpInsertloadItems(uEmail: String, uPassword: String, uName: String, uBirth: String, uPhone: String, uBuySell: String) -> Bool{
        var result: Bool = true
        
        let urlAdd = "?uEmail=\(uEmail)&uPassword=\(uPassword)&uName=\(uName)&uBirth=\(uBirth)&uPhone=\(uPhone)&uBuySell=\(uBuySell)"
        urlPath += urlAdd
        
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        print(urlPath)
        
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
    
    
    
    
    
    
//    var delegate: LoginModelProtocol!
//    var urlPath1 = "http://localhost:8080/test/Login_ios.jsp"
//
//    func actionLogin(uSeqno: String, uEmail: String, uPassword: String, completion: @escaping (Int)->()) {
//        let urlAdd = "?uEmail=\(uEmail)&uPassword=\(uPassword)"
//        urlPath1 += urlAdd
//        // 한글 url encoding
//        urlPath1 = urlPath1.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
//
//        let url: URL = URL(string: urlPath1)!
//        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
//
//        let task = defaultSession.dataTask(with: url) {(data, respone, error) in
//
//
//            if error != nil {
//                completion(0)
//            } else {
//                let result = self.parseJSON(data!)
//                if result != 0 {
//                    completion(result)
//
//                } else {
//                    completion(0)
//
//                }
//            }
//        }
//        task.resume()
//
//    }
//
//    func parseJSON(_ data: Data) -> Int {
//        var jsonResult = String(data: data, encoding: .utf8)!
//        //        do {
//        //            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! Bool
//        //        } catch let error as NSError {
//        //            print(error)
//        //        }
//        jsonResult = jsonResult.replacingOccurrences(of: "\r\n", with: "")
//        jsonResult = jsonResult.replacingOccurrences(of: " ", with: "")
//
//        return Int(jsonResult) ?? 0
//
//        //        DispatchQueue.main.async(execute: {() -> Void in
//        //        self.delegate.itemDownloaded()
//        //        })
//
//    }
//
//
//    var delegate: LoginModelProtocol!
//    let urlPath1 = "http://localhost:8080/test/Login_ios.jsp"
//
//    func downloadItems(){
//        let url: URL = URL(string: urlPath1)!
//        let defaultSesstion = Foundation.URLSession(configuration: URLSessionConfiguration.default)
//        let task = defaultSesstion.dataTask(with: url){(data, response, error) in
//            if error != nil{
//                print("Failed to download data")
//            }else{
//                print("Data is downloaded")
//                // ---->
//                self.parseJSON(data!)
//            }
//        }
//        task.resume()   // 구동시키기
//    }
//
//
//    func parseJSON(_ data: Data){
//        var jsonResult = NSArray()      // 배열은 int,String을 잡아주는데 같이들어갈때 NSArray를 사용해줌
//                                        // NSArray 는 추가 삭제가 불가능함
//        do{
//            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
//
//        }catch let error as NSError{
//            print(error)
//        }
//        var jsonEletment = NSDictionary()
//        let locations = NSMutableArray()        // NSMutableArray는 NSArray랑같은기능이지만 추가삭제가 가증함
//
//        for i in 0..<jsonResult.count{
//            jsonEletment = jsonResult[i] as! NSDictionary
//            let query = SignUpDBModel()
//
//            if let uEmail = jsonEletment["uEmail"] as? String,
//               let uPassword = jsonEletment["uPassword"] as? String{
//                // 이상이 없다면 이안으로 들어옴
//                query.uEmail = uEmail     // 우리가 만들어놓은 class 인스턴스에 넣어줌
//                query.uPassword = uPassword
//
//            }
//            locations.add(query)
//        }
//
//        // 데이터에 쌓인것을 프로토콜에 넣어주는것
//        DispatchQueue.main.async(execute: {() -> Void in
//            self.delegate.itemDownloaded(items: locations)  // 위에잡은 delegate안에 itemDownloaded을 통해서 넘겨주는것
//        })
//    }
    
    
    
    
    
    
    
    
    
    
}//-------------------------
