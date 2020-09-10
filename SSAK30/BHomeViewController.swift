//
//  BHomeViewController.swift
//  SSAK30
//
//  Created by 김승희 on 2020/09/04.
//  Copyright © 2020 김승희. All rights reserved.
//

import UIKit

class BHomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, QueryModelProtocol {
    
    
    
    @IBOutlet weak var listTableView: UITableView!
    

    var feedItem: NSArray = NSArray()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //delegate 처리
         self.listTableView.delegate = self
         self.listTableView.dataSource = self
         
         let queryModel = BHomeQueryModel()
         queryModel.delegate = self
         queryModel.downloadItems()
                
                
        // 열 높이 변경
        listTableView.rowHeight = 240
    }
    
    
    func itemDownloaded(items: NSArray) {
        feedItem = items
        self.listTableView.reloadData()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return feedItem.count
       }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bHomeCell", for: indexPath) as! BHomeTableViewCell
        
        let item: BHomeDBModel = feedItem[indexPath.row] as! BHomeDBModel //feedItem 있는 것 하나씩 가져와서 구성함
        // set custom text
        
        cell.sellTitle?.text = "\(item.sellTitle!)"
        cell.sellPrice?.text = "\(item.priceEA!)"
        
        let url = URL(string: "http://192.168.0.5:8080/ftp/\(item.sellImage!)")! // 원래이름 ( tomcat 서버에 넣어놓음)
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: url){(data, response, error) in
            if error != nil{
                print("Failed to download data")
            }else{
                print("Data is downloaded")
                DispatchQueue.main.async {
                    cell.imgView.image = UIImage(data: data!)
                    // jpg
                    if let image = UIImage(data: data!){
                        if let data = image.jpegData(compressionQuality: 0.8){// 일반적으로 80% 압축
                            let filename = self.getDecumentDirectory().appendingPathComponent("copy.jpg") // 다운받을때 이미지이름 설정(동일한이름 들어가면 1,2 로변함)
                            try? data.write(to: filename)
                            print("Data is writed")
                            print(self.getDecumentDirectory()) // 저장 위치 확인
                        }
                    }
                    
                    // png 쓸 때 사용
                    if let image = UIImage(data: data!){
                        if let data = image.pngData() {//
                            let filename = self.getDecumentDirectory().appendingPathComponent("copy.jpg") // // 다운받을때 이미지이름
                            try? data.write(to: filename)
                            print("Data is writed")
                            print(self.getDecumentDirectory()) // 저장 위치
                            
                        }
                    }
                }
            }
        }
        task.resume() // task 실행
     
        return cell
    }
    
    
    
    
    
    // write 위치 (스마트폰의)
    func getDecumentDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0] // 첫번째 값 앱에 설정한 것의 위치
    }
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    
    
    
}
 
