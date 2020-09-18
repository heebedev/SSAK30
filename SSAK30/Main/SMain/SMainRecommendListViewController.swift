//
//  SMainSellingRecommendListViewController.swift
//  SSAK30
//
//  Created by Songhee Choi on 2020/09/10.
//  Copyright © 2020 김승희. All rights reserved.
//

import UIKit
import Firebase

var uSeqno: String? // uSeqno test //

// 판매 중
class SMainSellingRecommendListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, SHomeSellingQueryModelProtocol {
    
    @IBOutlet weak var sellingListCollectionView: UICollectionView!
    @IBOutlet weak var lblSellingProduct: UILabel!
    
    var feedItem: NSArray = NSArray()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        // uSeqno
        uSeqno = String(UserDefaults.standard.integer(forKey: "uSeqno"))
        print(uSeqno)
        
        //delegate 처리
        self.sellingListCollectionView?.delegate = self
        self.sellingListCollectionView?.dataSource = self
        
        
        let queryModel = SHomeSellingQueryModel() // 프로토콜
        queryModel.delegate = self
        queryModel.downloadItems(uSeqno: uSeqno!)
        
        

    }
    
    func itemDownloaded(items: NSArray) {
        feedItem = items
        self.sellingListCollectionView?.reloadData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let queryModel = SHomeSellingQueryModel() // 프로토콜 
        queryModel.delegate = self
        queryModel.downloadItems(uSeqno: uSeqno!)
        
    }

    // UICollectionViewDelegate
  // 셀이 클릭되었을때 어쩔꺼야? >> DetailView로 sellSeqno 넘겨줌
       func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           let board = UIStoryboard.init(name: "Main", bundle: nil)
           guard let detailVC = board.instantiateViewController(withIdentifier: "BDetailViewController") as? BDetailViewController else {return}
           
           let item: BHomeDBModel = feedItem[(indexPath as NSIndexPath).item] as! BHomeDBModel // 받은 내용 몇번째인지 확인하고 DBModel로 변환한 후
           // 필요한 값 넘겨줌
           let sellSeqno = String(item.sellSeqno!)
           let sSeqno = String(item.sSeqno!)
           // 구매갯수 체크
           //let remainBuyCount = Int(item.tatalEA!)! - Int(item.sum_buyEA!)!
           let remainBuyCount = Int(item.tatalEA!)!
           print("전달팀전체갯수", String(item.tatalEA!))
           //print("전달팀팔린갯수", item.sum_buyEA ?? 0)
           //print("언제넘어가는지테스트", item.sName)
           var canBuyMaxNum : Int?
           if remainBuyCount < Int(item.minimumEA!)! {
               canBuyMaxNum = remainBuyCount
           }else{
               canBuyMaxNum = Int(item.minimumEA!)!
           }

           // 디테일뷰에 넣어줌
           detailVC.receiveItems(sellSeqno, canBuyMaxNum: canBuyMaxNum!, sSeqno: sSeqno)
           // 이동
           self.present(detailVC, animated: true, completion: nil)
           
       }
    
    // UICollectionViewDataSource
    // 몇개 보여줄까요?
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedItem.count
    }
    
    //셀은 어떻게 표현할거야?
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendCell", for: indexPath) as? SellingRecommendCell else { // 셀 수정 
            return UICollectionViewCell()
        }
        
        
        let item: BHomeDBModel = feedItem[indexPath.item] as! BHomeDBModel
    
        //Firbase 이미지 불러오기
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imgRef = storageRef.child("sbImage").child(item.sbImage!)
        
        imgRef.getData(maxSize: 1 * 1024 * 1024) {data, error in
            if error != nil {
                cell.sellingImage?.image = UIImage(named: "emptyImage.png")
            } else {
                cell.sellingImage?.image = UIImage(data: data!)
            }
        }
        
        cell.sellingTitle?.text = "\(item.sbTitle!)" // 제목 수정
        cell.sellingPrice?.text = "\(item.priceEA!)" // 가격 수정
        
        
        let url = URL(string: "http://localhost:8080/ftp/\(item.sbImage!)")! // 원래이름 ( tomcat 서버에 넣어놓음)
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: url){(data, response, error) in
            if error != nil{
                print("Failed to download data")
            }else{
                print("Data is downloaded")
                DispatchQueue.main.async {
                    cell.sellingImage?.image = UIImage(data: data!) // 이미지수정
                    // jpg
                    if let image = UIImage(data: data!){
                        if let data = image.jpegData(compressionQuality: 0.8){// 일반적으로 80% 압축
                            let filename = self.getDecumentDirectory().appendingPathComponent("selling.jpg") // 다운받을때 이미지이름 설정(동일한이름 들어가면 1,2 로변함)
                            try? data.write(to: filename)
                            print("Data is writed")
                            
                        }
                    }
                    
                    // png 쓸 때 사용
                    if let image = UIImage(data: data!){
                        if let data = image.pngData() {//
                            let filename = self.getDecumentDirectory().appendingPathComponent("selling.jpg") // // 다운받을때 이미지이름
                            try? data.write(to: filename)
                            print("Data is writed")
                           
                            
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

class SellingRecommentListViewModel {
    enum RecommendingType {
        case selling
        case doneSell
      
        var title: String {
            switch self {
            case .selling: return "우리매장 판매중인 떠리"
            case .doneSell: return "우리매장 판매완료된 떠리"
            
                
            }
        }
    }
}


class SellingRecommendCell: UICollectionViewCell{
    @IBOutlet weak var sellingImage: UIImageView!
    @IBOutlet weak var sellingTitle: UILabel!
    @IBOutlet weak var sellingPrice: UILabel!
    
}






// 판매완료 //
class SMainDoneSellRecommendListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, SHomeDoneSellQueryModelProtocol {
    
    // 판매완료
    @IBOutlet weak var doneSellListCollectionView: UICollectionView!
    @IBOutlet weak var lblDoneSellProduct: UILabel!
    
    //let viewModel = SellingRecommentListViewModel()
    var feedItem: NSArray = NSArray()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.doneSellListCollectionView?.delegate = self
        self.doneSellListCollectionView?.dataSource = self
        
        let queryModel = SHomeDoneSellQueryModel() // 프로토콜
        queryModel.delegate = self
        queryModel.downloadItems(uSeqno: uSeqno!)

        
    }
    
    func itemDownloaded(items: NSArray) {
        feedItem = items
        self.doneSellListCollectionView?.reloadData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let queryModel = SHomeDoneSellQueryModel() // 프로토콜
        queryModel.delegate = self
        queryModel.downloadItems(uSeqno: uSeqno!)
    }

    // UICollectionViewDelegate
     // 셀이 클릭되었을때 어쩔꺼야? >> DetailView로 sellSeqno 넘겨줌
       func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           let board = UIStoryboard.init(name: "Main", bundle: nil)
           guard let detailVC = board.instantiateViewController(withIdentifier: "BDetailViewController") as? BDetailViewController else {return}
           
           let item: BHomeDBModel = feedItem[(indexPath as NSIndexPath).item] as! BHomeDBModel // 받은 내용 몇번째인지 확인하고 DBModel로 변환한 후
           // 필요한 값 넘겨줌
           let sellSeqno = String(item.sellSeqno!)
           let sSeqno = String(item.sSeqno!)
          
           // 구매갯수 체크
           //let remainBuyCount = Int(item.tatalEA!)! - Int(item.sum_buyEA!)!
           let remainBuyCount = Int(item.tatalEA!)!
           print("전달팀전체갯수", String(item.tatalEA!))
           //print("전달팀팔린갯수", item.sum_buyEA ?? 0)
           //print("언제넘어가는지테스트", item.sName)
           var canBuyMaxNum : Int?
           if remainBuyCount < Int(item.minimumEA!)! {
               canBuyMaxNum = remainBuyCount
           }else{
               canBuyMaxNum = Int(item.minimumEA!)!
           }

           // 디테일뷰에 넣어줌
           detailVC.receiveItems(sellSeqno, canBuyMaxNum: canBuyMaxNum!, sSeqno: sSeqno)
           // 이동
           self.present(detailVC, animated: true, completion: nil)
           
       }
    
    // UICollectionViewDataSource
    // 몇개 보여줄까요?
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedItem.count
    }
    
    //셀은 어떻게 표현할거야?
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendCell", for: indexPath) as? DoneSellRecommendCell else { // 셀 수정
            return UICollectionViewCell()
        }
        
        
        let item: BHomeDBModel = feedItem[indexPath.item] as! BHomeDBModel
        
        //Firbase 이미지 불러오기
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imgRef = storageRef.child("sbImage").child(item.sbImage!)
        imgRef.getData(maxSize: 1 * 1024 * 1024) {data, error in
            if error != nil {
                cell.doneSellImage?.image = UIImage(named: "emptyImage.png")
            } else {
                cell.doneSellImage?.image = UIImage(data: data!)
            }
        }
        
        
        cell.doneSellTitle?.text = "\(item.sbTitle!)"
        cell.doneSellPrice?.text = "\(item.priceEA!)"
        
        
        let url = URL(string: "http://localhost:8080/ftp/\(item.sbImage!)")! // 원래이름 ( tomcat 서버에 넣어놓음)
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: url){(data, response, error) in
            if error != nil{
                print("Failed to download data")
            }else{
                print("Data is downloaded")
                DispatchQueue.main.async {
                    cell.doneSellImage?.image = UIImage(data: data!)
                    // jpg
                    if let image = UIImage(data: data!){
                        if let data = image.jpegData(compressionQuality: 0.8){// 일반적으로 80% 압축
                            let filename = self.getDecumentDirectory().appendingPathComponent("doneSell.jpg") // 다운받을때 이미지이름 설정(동일한이름 들어가면 1,2 로변함)
                            try? data.write(to: filename)
                            print("Data is writed")
                        }
                    }
                    
                    // png 쓸 때 사용
                    if let image = UIImage(data: data!){
                        if let data = image.pngData() {//
                            let filename = self.getDecumentDirectory().appendingPathComponent("doneSell.jpg") // // 다운받을때 이미지이름
                            try? data.write(to: filename)
                            print("Data is writed")
                            
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


class DoneSellRecommendCell: UICollectionViewCell{
    @IBOutlet weak var doneSellImage: UIImageView!
    @IBOutlet weak var doneSellTitle: UILabel!
    @IBOutlet weak var doneSellPrice: UILabel!
}
