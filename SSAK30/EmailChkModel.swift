//
//  EmailChkModel.swift
//  SSAK30
//
//  Created by 문단비 on 2020/09/09.
//  Copyright © 2020 김승희. All rights reserved.
//

// 이메일 중복확인
import Foundation

class EmailChkModel: NSObject {
    
    var urlPath = "http://localhost:8080/SSAK30/EmailChk_ios.jsp"
    func EmailChkloadItems(uEmail: String) -> Bool{
        var result: Bool = true
        
        let urlAdd = "?uEmail=\(uEmail)"
        urlPath += urlAdd
        
        print(urlAdd)
        print(uEmail)
        
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
