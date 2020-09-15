//
//  AfterSearchQueryModel.swift
//  SSAK30
//
//  Created by 김승희 on 2020/09/11.
//  Copyright © 2020 김승희. All rights reserved.
//

import Foundation

protocol AfterSearchQueryModelProtocol: class {
    func itemDownloaded(items: NSArray)
}

class AfterSearchQueryModel: NSObject {
    
    var delegate: AfterSearchQueryModelProtocol!
    var urlPath = ""
    
    func downloadItems(searchItem: String) {
        urlPath = "http://localhost:8080/test/afterSearch_query_ios.jsp?searchItem=\(searchItem)"
        
        if let encodedPath = urlPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url:URL = URL(string: encodedPath) {
                let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
                print(url)
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
        let results = NSMutableArray()
        
        for i in 0..<jsonResult.count {
            jsonElement = jsonResult[i] as! NSDictionary
            let query = AfterSearchResultModel()
            
            if let sellSeqno = jsonElement["sellSeqno"] as? String,
                let sName = jsonElement["sName"] as? String,
                let sbTitle = jsonElement["sbTitle"] as? String,
                let sbImage = jsonElement["sbImage"] as? String,
                let mName = jsonElement["mName"] as? String {
                
                query.sellSeqno = Int(sellSeqno)
                query.sName = sName
                query.sbTitle = sbTitle
                query.sbImage = sbImage
                query.mName = mName
            }

            results.add(query)
        }
        
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.itemDownloaded(items: results)
            
        })
 
    }
    
}
