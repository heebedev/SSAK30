//
//  passwordChangeModel.swift
//  SSAK30
//
//  Created by 김승희 on 2020/09/13.
//  Copyright © 2020 김승희. All rights reserved.
//

import Foundation

class passwordChangeModel: NSObject {
    
    func passwordChangeItems(uSeqno: Int, uPassword: String){
        let urlPath = "http://localhost:8080/test/changePw_query_ios.jsp?uSeqno=\(uSeqno)&uPassword=\(uPassword)"
        print(urlPath)
        if let encodedPath = urlPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url:URL = URL(string: encodedPath) {
                let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
                
                let task = defaultSession.dataTask(with: url) {(data, response, error) in
                    if error != nil {
                        print("Failed to download data")
                    } else {
                        print("Data is downloaded")
                    }
                }
                task.resume()
            }
    }
    
    
    
    
    
    
    
    
    
    
    
}
