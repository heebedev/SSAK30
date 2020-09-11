//
//  EmailChkModel.swift
//  SSAK30
//
//  Created by 문단비 on 2020/09/09.
//  Copyright © 2020 김승희. All rights reserved.
//

// 이메일 중복확인
import Foundation
protocol EmailChkModelProtocol: class {
    func itemDownloaded(items: NSArray)
}

class EmailChkModel: NSObject {
    
    var delegate: EmailChkModelProtocol!
    var urlPath = "http://localhost:8080/test/EmailChk_ios.jsp"
    
    func downloadItems() {
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: url){(data, response, error) in
            if error != nil {
                print("failed to download data")
            } else {
                print("Data is downloaded")
                self.parseJSON(data!)
            }
        }
        task.resume()
    }
    
    func parseJSON(_ data: Data) {
        var jsonResult = NSArray()
        
        do {
            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        } catch let error as NSError {
            print(error)
        }
        var jsonElement = NSDictionary()
        let locations = NSMutableArray()
        
        for i in 0..<jsonResult.count {
            jsonElement = jsonResult[i] as! NSDictionary
            let query = SignUpDBModel()
            
            if let uSeqno = jsonElement["uSeqno"] as? String,
               let uEmail = jsonElement["uEmail"] as? String {
                
                query.uSeqno = uSeqno
                query.uEmail = uEmail
            }
            
            locations.add(query)
            
        }
        
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.itemDownloaded(items: locations)
        })
    }
    


}//-------------------------
