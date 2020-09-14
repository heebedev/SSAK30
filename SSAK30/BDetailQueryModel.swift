//
//  BDetailDBModel.swift
//  SSAK30
//
//  Created by Songhee Choi on 2020/09/12.
//  Copyright © 2020 김승희. All rights reserved.
//

import Foundation

// 디테일 정보 프로토콜
protocol BDetailQueryModelProtocol: class{
    func itemDownloaded(items:NSArray)
}

//떠리캐시 프로토콜
protocol BDetailThirycashQueryModelProtocol: class{
    func thirycashItemDownloaded(items:NSArray)
}

//

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

// 떠리캐시 select
class BDetailThirycashQueryModel: NSObject{
    var delegate: BDetailThirycashQueryModelProtocol!
    var urlPath = "http://localhost:8080/ssak30/detailThirycashQuery.jsp"

    func downloadItems(uSeqno: String?){
        let urlAdd = "?uSeqno=\(String(uSeqno!))"  // urlPath 뒤에 ? 물음표 부터 뒤에 넣을 것 세팅
        urlPath += urlAdd
        let url: URL = URL(string: urlPath)!

        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)

        let task = defaultSession.dataTask(with: url){(data, response, error) in
            if error != nil { // 에러코드가 없을 때 실행
                print("Failed to download data")
            }else{
                print("Detail thirycash is downloaded")

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
            print("떠리캐시 파서 성공")
        }catch let error as NSError{
            print("디테일 나의 떠리캐시 파서 에러 ", error)
        }

               var jsonElement = NSDictionary()
               let locations = NSMutableArray()

               for i in 0..<jsonResult.count{
                   jsonElement = jsonResult[i] as! NSDictionary
                   let query = ThirycashDBModel()

            if  let cashSeqno = jsonElement["cashSeqno"] as? String,
                let userinfo_uSeqno = jsonElement["userinfo_uSeqno"] as? String,
                let totalCash = jsonElement["totalCash"] as? String?,
                let useCode = jsonElement["useCode"] as? String,
                let usePrice = jsonElement["usePrice"] as? String,
                let useDate = jsonElement["useDate"] as? String,
                let sRegistDate = jsonElement["sRegistDate"] as? String,
                let cashValidation = jsonElement["cashValidation"] as? String {

                query.cashSeqno = cashSeqno
                query.userinfo_uSeqno = userinfo_uSeqno
                query.totalCash = totalCash!
                query.useCode = useCode
                query.usePrice = usePrice
                query.useDate = useDate
                query.sRegistDate = sRegistDate
                query.cashValidation = cashValidation
            }

                

            // 배열에 넣어줌
            
            locations.add(query)
            
        }

        // 프로토콜로 전달
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.thirycashItemDownloaded(items: locations)
        })

    }

}//----


// 떠리캐시 select
class BDetailUseThirycashUpdateInsertModel: NSObject{
    var delegate: BDetailUseThirycashUpdateInsertModel!
    var urlPath = "http://localhost:8080/ssak30/detailUseCash_update_insert.jsp"

    func UseThityCashItems(uSeqno: String, totalCash: String, usePrice: String)  -> Bool {
        var result: Bool = true // 리턴값 설정
        let urlAdd = "?uSeqno=\(String(uSeqno))&totalCash=\(String(totalCash))&usePrice=\(String(usePrice))"  // urlPath 뒤에 ? 물음표 부터 뒤에 넣을 것 세팅
        urlPath += urlAdd
        // 한글 url encoding: url 타입은 한글들어가면 에러나기 때문에 addingPercentEncoding 퍼센트 들어가는걸로 바꿔줘야 함
            urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            
            let url: URL = URL(string: urlPath)!
            let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
            
            let task = defaultSession.dataTask(with: url){(data, response, error) in
                if error != nil { // 에러코드가 없을 때 실행
                    print("Failed to update data")
                    result = false// bool값 설정
                }else{
                    print("Data is updated")
                    result = true// bool값 설정
                }
            }
            task.resume()

            return result
        }
 
}//----
