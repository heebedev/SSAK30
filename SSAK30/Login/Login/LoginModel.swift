//
//  LoginModel.swift
//  SSAK30
//
//  Created by 김승희 on 2020/09/14.
//  Copyright © 2020 김승희. All rights reserved.
//

import Foundation

protocol LoginModelProtocol: class {
    func LoginChkDownloaded(uSeqno: String, uResult: String, uBuySellCode: String)
}
class LoginModel: NSObject {
    

    var delegate: LoginModelProtocol!
    
    // 로그인 아이디비밀번호확인
    func EmailloadItems(uEmail:String){
        let urlPath = "http://localhost:8080/test/LoginChk_ios.jsp?uEmail=\(uEmail)"  // urlPath 뒤에 ? 물음표 부터 뒤에 넣을 것 세팅
        print(urlPath)
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
        
        var falseOrPw = "false"
        var uSeqnoResult = "0"
        var uBuySellItem = "0"
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        }catch let error as NSError{
            print(error)
        }
        var jsonElement = NSDictionary()

        for i in 0..<jsonResult.count{
            jsonElement = jsonResult[i] as! NSDictionary
            // 첫번째 중괄호 안의 변수명 값들을 받아옴.
            if let uSeq = jsonElement["uSeqno"] as? String,
                let uBuySell = jsonElement["uBuySell"] as? String,
                let ckResult = jsonElement["result"] as? String {
                
                
                uSeqnoResult = uSeq
                uBuySellItem = uBuySell
                falseOrPw = ckResult
            
            }

        }
        DispatchQueue.main.async(execute: {() -> Void in
        self.delegate.LoginChkDownloaded(uSeqno: uSeqnoResult, uResult: falseOrPw, uBuySellCode: uBuySellItem)
        })
    }
    
}
