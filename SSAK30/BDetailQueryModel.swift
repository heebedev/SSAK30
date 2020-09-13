//
//  BDetailDBModel.swift
//  SSAK30
//
//  Created by Songhee Choi on 2020/09/12.
//  Copyright © 2020 김승희. All rights reserved.
//

import Foundation

protocol BDetailQueryModelProtocol: class{
    func itemDownloaded(items:NSArray)
}

class BDetailQueryModel: NSObject{
    var delegate: BDetailQueryModelProtocol!
    var urlPath = "http://localhost:8080/ssak30/bDetailQuery.jsp"

    func downloadItems(sellSeqno: String?){
        let urlAdd = "?sellSeqno=\(String(sellSeqno!))"  // urlPath 뒤에 ? 물음표 부터 뒤에 넣을 것 세팅
        urlPath += urlAdd
        let url: URL = URL(string: urlPath)!
        print(url)

        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)

        let task = defaultSession.dataTask(with: url){(data, response, error) in
            if error != nil { // 에러코드가 없을 때 실행
                print("Failed to download data")
            }else{
                print("Detail Data is downloaded")

                //parse JSON
                self.parseJSON(data!)
            }
        }
        task.resume()
    }

    func parseJSON(_ data: Data){
       var jsonResult = NSArray()

        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        }catch let error as NSError{
            print("디테일 파서 에러 ", error)
        }

               var jsonElement = NSDictionary()
               let locations = NSMutableArray()

               for i in 0..<jsonResult.count{
                   jsonElement = jsonResult[i] as! NSDictionary
                   let query = BHomeDBModel()

            if  let sellSeqno = jsonElement["sellSeqno"] as? String,
                let sSeqno = jsonElement["storeinfo_sSeqno"] as? String,
                let sbTitle = jsonElement["sbTitle"] as? String,
                let sbContext = jsonElement["sbContent"] as? String,
                let sbImage = jsonElement["sbImage"] as? String,
                let tatalEA = jsonElement["totalEA"] as? String,
                let minimumEA = jsonElement["minimumEA"] as? String,
                let priceEA = jsonElement["priceEA"] as? String,
                let openDate = jsonElement["openDate"] as? String,
                let closeDate = jsonElement["closeDate"] as? String,
                let sellRegistDate = jsonElement["sellRegistDate"] as? String,
                let storeUSeqno = jsonElement["userinfo_uSeqno"] as? String,
                let sName = jsonElement["sName"] as? String,
                let sBusinessNo = jsonElement["sBusinessNo"] as? String,
                let sPhone = jsonElement["sPhone"] as? String,
                let sAddress = jsonElement["sAddress"] as? String,
                let sServiceTime = jsonElement["sServiceTime"] as? String,
                let sImage = jsonElement["sImage"] as? String,
                let mSeqno = jsonElement["mSeqno"] as? String,
                let mName = jsonElement["mName"] as? String,
                let sum_buyEA = jsonElement["sum_buyEA"] as? String {

                query.sellSeqno = sellSeqno
                query.sSeqno = sSeqno
                query.sbTitle = sbTitle
                query.sbContext = sbContext
                query.sbImage = sbImage
                query.tatalEA = tatalEA
                query.minimumEA = minimumEA
                query.priceEA = priceEA
                query.openDate = openDate
                query.closeDate = closeDate
                query.sellRegistDate = sellRegistDate
                query.storeUSeqno = storeUSeqno
                query.sName = sName
                query.sBusinessNo = sBusinessNo
                query.sPhone = sPhone
                query.sAddress = sAddress
                query.sServiceTime = sServiceTime
                query.sImage = sImage
                query.mSeqno = mSeqno
                query.mName = mName
                query.sum_buyEA = sum_buyEA
            }


            // 배열에 넣어줌
            locations.add(query)
        }

        // 프로토콜로 전달
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.itemDownloaded(items: locations)
        })

    }

}//----
