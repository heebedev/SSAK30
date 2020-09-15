//
//  ProductInsertModel.swift
//  SSAK30
//
//  Created by taeheum on 2020/09/08.
//  Copyright © 2020 김승희. All rights reserved.
//

import Foundation

class ProductInsertModel: NSObject{
    
    // 버튼 눌렀을 때 실행되니까 델리게이트 필요없음
    var urlPath = "http://localhost:8080/test/ProductInsert.jsp"
    
    func productInsertItems(title: String, totalEA: String, minimumEA: String, priceEA: String, openDate: String, closeDate: String, context: String, image: String) -> Bool{ // 괄호에 매개변수 값을 적어줌, 에러가 날 수도 있으니 리턴값을 하나 받음(-> Bool 이거)
        var result: Bool = true
        let uSeqno = UserDefaults.standard.integer(forKey: "uSeqno")
        let urlAdd = "?title=\(title)&totalEA=\(totalEA)&minimumEA=\(minimumEA)&priceEA=\(priceEA)&openDate=\(openDate)&closeDate=\(closeDate)&context=\(context)&image=\(image)&uSeqno=\(uSeqno)" // jsp뒤에 ?쓰고 변수이름 넣고 = & 변수 = 해야 하니까 만들어놓음
        urlPath += urlAdd
        // 한글 인코딩
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: url){(data, response, error) in
            if error != nil{
                print("Failed to download data")
                result = false
            }else{
                print("Data is inserted")
                result = true
            }
        }
        // task 구동
        task.resume()
        
        return result
    }
    
    
    
}
