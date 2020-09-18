//
//  InsertBuylistModel.swift
//  SSAK30
//
//  Created by Songhee Choi on 2020/09/13.
//  Copyright © 2020 김승희. All rights reserved.
//

import Foundation

class InsertBuylistModel: NSObject{
    
    var urlPath = "http://localhost:8080/ssak30/insertBuylist.jsp"
    
    func InsertItems(sellSeqno: String!, sSeqno: String!, uSeqno: String!, buyCount: String!, pickupDate: String!) -> Bool { // 매개변수 값으로 데이터 들어오고 리턴값 Bool로 받음
        var result: Bool = true // 리턴값 설정
        let urlAdd = "?sellSeqno=\(String(sellSeqno))&sSeqno=\(String(sSeqno))&uSeqno=\(String( uSeqno))&buyCount=\(String( buyCount))&pickupDate=\(String(pickupDate))" // urlPath 뒤에 ? 물음표 부터 뒤에 넣을 것 세팅
        urlPath += urlAdd
        
        // 한글 url encoding: url 타입은 한글들어가면 에러나기 때문에 addingPercentEncoding 퍼센트 들어가는걸로 바꿔줘야 함
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: url){(data, response, error) in
            if error != nil { // 에러코드가 없을 때 실행
                print("Failed to insert data")
                result = false// bool값 설정
            }else{
                print("Data is inserted")
                result = true// bool값 설정
            }
        }
        task.resume()

        return result
    }
    

    
}//----
