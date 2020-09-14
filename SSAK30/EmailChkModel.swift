//
//  EmailChkModel.swift
//  SSAK30
//
//  Created by 문단비 on 2020/09/09.
//  Copyright © 2020 김승희. All rights reserved.
//

// 이메일 중복확인
import Foundation

protocol EmailChkModelProtocol: class {
    func itemDownloaded(item: Int)
}

class EmailChkModel: NSObject {

 

    var delegate: EmailChkModelProtocol!

    func EmailChkloadItems(uEmail: String){
        let urlPath = "http://localhost:8080/ssak30/EmailChk_ios.jsp?uEmail=\(uEmail)"

        print(urlPath)

        let url: URL = URL(string: urlPath)!

        let defaultSesstion = Foundation.URLSession(configuration: URLSessionConfiguration.default)

        let task = defaultSesstion.dataTask(with: url){(data, response, error) in

            if error != nil{

                print("Failed to insert data")

 

            }else{

                print("Data is inserted")

                self.parseJSON(data!)

 

            }

        }

        task.resume()

        

    }

    

    func parseJSON(_ data: Data) {

        var jsonResult = NSArray()

        var result = 1

        

           do {

               jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray

           } catch let error as NSError {

               print(error)

           }

           

           var jsonElement = NSDictionary()

           

           for i in 0..<jsonResult.count {

               jsonElement = jsonResult[i] as! NSDictionary

    

               if let ckEmail = jsonElement["ckEmail"] as? String {

                print(result)

                result = Int(ckEmail)!

                print(result)

               }

           }

        

           DispatchQueue.main.async(execute: {() -> Void in

            print("delegare \(result)")

            self.delegate.itemDownloaded(item: result)

            print("delegare \(result)")

           })

       }

    

    

    

    

}//-------------------------
