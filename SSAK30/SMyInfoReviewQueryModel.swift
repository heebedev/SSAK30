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
    var urlPath2 = "http://localhost:8080/test/ssak30_storerlike_query.jsp"
    
    func downloadItems(uSeqno: String){
        let urlAdd = "?uSeqno=\(uSeqno)"  // urlPath 뒤에 ? 물음표 부터 뒤에 넣을 것 세팅
        urlPath += urlAdd
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url){(data, response, error) in
            if error != nil{
                print("Failed to download data")
            }else{
                print("Data is downloaded")
                self.parseJAON(data!)
            }
        }
        task.resume()
    }
    
    func likeDownloadItems(uSeqno: String){
        let urlAdd = "?uSeqno=\(uSeqno)"  // urlPath 뒤에 ? 물음표 부터 뒤에 넣을 것 세팅
        urlPath2 += urlAdd
        let url: URL = URL(string: urlPath2)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url){(data, response, error) in
            if error != nil{
                print("Failed to download data")
            }else{
                print("Data is downloaded")
                self.parseJAON2(data!)
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
    func parseJAON2(_ data: Data){
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
            if let likeCount = jsonElement["likeCount"] as? String{
            
                query.likeCount = likeCount
                print(likeCount)
            }
            
            locations.add(query)
        }
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.gradeItemDownloaded(items: locations)
        })
    }
}// ------------
