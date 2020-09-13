//
//  CheckFindIdPwModel.swift
//  SSAK30
//
//  Created by 김승희 on 2020/09/13.
//  Copyright © 2020 김승희. All rights reserved.
//

import Foundation

protocol CheckFindIdPwModelProtocol: class {
    func itemDownloaded(code: String, item: String)
}

class CheckFindIdPwModel: NSObject {
    
    var delegate : CheckFindIdPwModelProtocol!
    var urlPath = ""
    var ckCode = ""
    
    func downloadItems(code: String, id: String, name: String, birth: String) {
        ckCode = code
        if code == "findId" {
            urlPath = "http://localhost:8080/test/findId_query_ios.jsp?name=\(name)&birth=\(birth)"
        } else {
            urlPath = "http://localhost:8080/test/findPw_query_ios.jsp?id=\(id)&name=\(name)&birth=\(birth)"
        }
        
        if let encodedPath = urlPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url:URL = URL(string: encodedPath) {
                let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
                
                let task = defaultSession.dataTask(with: url) {(data, response, error) in
                    if error != nil {
                        print("Failed to download data")
                    } else {
                        print("Data is downloaded")
                        self.parseJSON(data!)
                    }
                }
                task.resume()
            }
    }
    
    
    func parseJSON(_ data: Data) {
        var jsonResult = NSArray()
        
        do {
            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        } catch let error as NSError {
            print(error)
        }
        
        var jsonElement = NSDictionary()
        var queryResult:String = ""
        
        for i in 0..<jsonResult.count {
            jsonElement = jsonResult[i] as! NSDictionary
            
            if let result = jsonElement["result"] as? String {
                queryResult = result
            }

        }
        
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.itemDownloaded(code: self.ckCode, item: queryResult)
        })
 
    }
    
}
