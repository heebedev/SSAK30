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
    
    var urlPath = "http://localhost:8080/SSAK30/SignUp_ios.jsp"
    func SignUpInsertloadItems(uEmail: String, uPassword: String, uName: String, uBirth: String, uPhone: String, uBuySell: String) -> Bool{
        var result: Bool = true
        
        let urlAdd = "?uEmail=\(uEmail)&uPassword=\(uPassword)&uName=\(uName)&uBirth=\(uBirth)&uPhone=\(uPhone)&uBuySell=\(uBuySell)"
        urlPath += urlAdd
        
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
}//-------------------------
