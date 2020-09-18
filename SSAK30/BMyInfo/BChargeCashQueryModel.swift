//
//  BChargeCashQueryModel.swift
//  SSAK30
//
//  Created by sookjeon on 2020/09/10.
//  Copyright © 2020 김승희. All rights reserved.
//

import Foundation

class BChargeCashQueryModel: NSObject{

    var urlPath = "http://localhost:8080/test/ssak30_chargeCash_update.jsp"
    
    func updateItem(uSeqno:String, thiryCash:String, usePrice:String) {
        let urlAdd = "?uSeqno=\(uSeqno)&totalCash=\(thiryCash)&usePrice=\(usePrice)"  // urlPath 뒤에 ? 물음표 부터 뒤에 넣을 것 세팅
        urlPath += urlAdd
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url){(data, response, error) in
            if error != nil{
            }else{
                    }
        }
        task.resume()
    }
   
}// ------------
