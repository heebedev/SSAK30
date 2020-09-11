//
//  BUpdateQueryModel.swift
//  SSAK30
//
//  Created by sookjeon on 2020/09/10.
//  Copyright © 2020 김승희. All rights reserved.
//

import Foundation

class BUpdateQueryModel: NSObject{

    var urlPath = "http://localhost:8080/test/ssak30_myInfo_update.jsp"
    
    func updateItem(uSeqno:String, uName:String, uPassword:String, uPhone:String, uImage:String) {
        let urlAdd = "?uSeqno=\(uSeqno)&uName=\(uName)&uPassword=\(uPassword)&uPhone=\(uPhone)&uImage=\(uImage)"  // urlPath 뒤에 ? 물음표 부터 뒤에 넣을 것 세팅
        urlPath += urlAdd
        // 한글 url encoding: url 타입은 한글들어가면 에러나기 때문에 addingPercentEncoding 퍼센트 들어가는걸로 바꿔줘야 함
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
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
