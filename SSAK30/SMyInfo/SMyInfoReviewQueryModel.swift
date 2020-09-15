//
//  SMyInfoReviewQueryModel.swift
//  SSAK30
//
//  Created by sookjeon on 2020/09/09.
//  Copyright © 2020 김승희. All rights reserved.
//

import Foundation

protocol SMyInfoReviewQueryModelProtocol: class {
    func gradeItemDownloaded(items:NSArray)
}

class SMyInfoReviewQueryModel: NSObject{
    
    var delegate: SMyInfoReviewQueryModelProtocol!
    var urlPath = "http://localhost:8080/test/ssak30_storereview_query.jsp"
    
    
    func downloadItems(uSeqno: String){
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
            let query = SMyInfoDBModel()
            
            // 첫번째 중괄호 안의 변수명 값들을 받아옴.
            if let rGrade = jsonElement["rGrade"] as? String,
               let reviewCount = jsonElement["reviewCount"] as? String{
            
                query.rGrade = rGrade
                query.reviewCount = reviewCount
                
            }
            
            locations.add(query)
        }
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.gradeItemDownloaded(items: locations)
        })
    }

}// ------------
