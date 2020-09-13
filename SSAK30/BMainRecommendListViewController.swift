//
//  BMainRecommendListViewController.swift
//  SSAK30
//
//  Created by Songhee Choi on 2020/09/10.
//  Copyright © 2020 김승희. All rights reserved.
//

import UIKit

 // 관심매장 최근
class BMainRecommendListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, BHomeInterestQueryModelProtocol {
    
   
    @IBOutlet weak var listCollectionView: UICollectionView!
    @IBOutlet weak var lblrecentSellProduct: UILabel!
    
    let viewModel = RecommentListViewModel()
    var feedItem: NSArray = NSArray()
    var uSeqno: String? = "1" // test
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //delegate 처리
        self.listCollectionView?.delegate = self
        self.listCollectionView?.dataSource = self
        
        let queryModel = BHomeInterestQueryModel()
        queryModel.delegate = self
        queryModel.downloadItems(uSeqno: uSeqno!)
    }
    
    
    func itemDownloaded(items: NSArray) {
        feedItem = items
        self.listCollectionView?.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let queryModel = BHomeInterestQueryModel()
        queryModel.delegate = self
        queryModel.downloadItems(uSeqno: uSeqno!)
    }
    
    // UICollectionViewDelegate
    // 셀이 클릭되었을때 어쩔꺼야? >> DetailView로 sellSeqno 넘겨줌
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let board = UIStoryboard.init(name: "Main", bundle: nil)
        guard let detailVC = board.instantiateViewController(withIdentifier: "BDetailViewController") as? BDetailViewController else {return}
        
        let item: BHomeDBModel = feedItem[(indexPath as NSIndexPath).item] as! BHomeDBModel // 받은 내용 몇번째인지 확인하고 DBModel로 변환한 후
        // sellSeqno 넘겨줌
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
            return canBuyMaxNum = remainBuyCount
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendCell", for: indexPath) as? RecommendCell else {
            return UICollectionViewCell()
        }
        
        let item: BHomeDBModel = feedItem[indexPath.item] as! BHomeDBModel
        cell.sellTitle?.text = "\(item.sbTitle!)"
        cell.sellPrice?.text = "\(item.priceEA!)"
        
        
        let url = URL(string: "http://localhost:8080/ftp/\(item.sbImage!)")! // 원래이름 ( tomcat 서버에 넣어놓음)
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: url){(data, response, error) in
            if error != nil{
                print("Failed to download data")
            }else{
                print("Data is downloaded")
                DispatchQueue.main.async {
                    cell.thumbnailImage?.image = UIImage(data: data!)
                    // jpg
                    if let image = UIImage(data: data!){
                        if let data = image.jpegData(compressionQuality: 0.8){// 일반적으로 80% 압축
                            let filename = self.getDecumentDirectory().appendingPathComponent("recent.jpg") // 다운받을때 이미지이름 설정(동일한이름 들어가면 1,2 로변함)
                            try? data.write(to: filename)
                            print("Data is writed")
                       
                        }
                    }
                    
                    // png 쓸 때 사용
                    if let image = UIImage(data: data!){
                        if let data = image.pngData() {//
                            let filename = self.getDecumentDirectory().appendingPathComponent("recent.jpg") // // 다운받을때 이미지이름
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
    
}//---


class RecommentListViewModel {
    enum RecommendingType {
        case interest
        case recent

        
        var title: String {
            switch self {
            case .recent: return "최근 등록된 떠리"
            case .interest: return "관심매장 최근 떠리"

                
            }
        }
    }
}


class RecommendCell: UICollectionViewCell {
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var sellTitle: UILabel!
    @IBOutlet weak var sellPrice: UILabel!
}



 //최근 게시물 //
class BMainRecentRecommendListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, QueryModelProtocol {
    
   
    @IBOutlet weak var listCollectionView: UICollectionView!
    @IBOutlet weak var lblrecentSellProduct: UILabel!
    
    //let viewModel = RecentRecommentListViewModel()
    var feedItem: NSArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //delegate 처리
        self.listCollectionView?.delegate = self
        self.listCollectionView?.dataSource = self
        
        let queryModel = BHomeQueryModel()
        queryModel.delegate = self
        queryModel.downloadItems()
    }
    
    
    func itemDownloaded(items: NSArray) {
        feedItem = items
        self.listCollectionView?.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let queryModel = BHomeQueryModel()
        queryModel.delegate = self
        queryModel.downloadItems()
    }
    
    // UICollectionViewDelegate
    // 셀이 클릭되었을때 어쩔꺼야? >> DetailView로 연결해야함!! //////////
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let board = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = board.instantiateViewController(withIdentifier: "BDetailViewController")
        self.present(vc, animated: true, completion: nil)
    }
    
    // UICollectionViewDataSource
    // 몇개 보여줄까요?
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedItem.count
    }
    
    //셀은 어떻게 표현할거야?
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendCell", for: indexPath) as? RecentRecommendCell else {
            return UICollectionViewCell()
        }
        
        let item: BHomeDBModel = feedItem[indexPath.item] as! BHomeDBModel
        cell.recentTitle?.text = "\(item.sbTitle!)"
        cell.recentPrice?.text = "\(item.priceEA!)"
        
        
        let url = URL(string: "http://localhost:8080/ftp/\(item.sbImage!)")!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: url){(data, response, error) in
            if error != nil{
                print("Failed to download data")
            }else{
                print("Data is downloaded")
                DispatchQueue.main.async {
                    cell.recentImage?.image = UIImage(data: data!)
                    // jpg
                    if let image = UIImage(data: data!){
                        if let data = image.jpegData(compressionQuality: 0.8){// 일반적으로 80% 압축
                            let filename = self.getDecumentDirectory().appendingPathComponent("recent.jpg")
                            try? data.write(to: filename)
                            print("Data is writed")
                        }
                    }
                    
                    // png 쓸 때 사용
                    if let image = UIImage(data: data!){
                        if let data = image.pngData() {//
                            let filename = self.getDecumentDirectory().appendingPathComponent("recent.jpg")
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
    
}//---


class RecentRecommentListViewModel {
    enum RecommendingType {
        case interest
        case recent

        
        var title: String {
            switch self {
            case .recent: return "최근 등록된 떠리"
            case .interest: return "관심매장 최근 떠리"

                
            }
        }
    }
}


class RecentRecommendCell: UICollectionViewCell {
    
    @IBOutlet weak var recentImage: UIImageView!
    @IBOutlet weak var recentTitle: UILabel!
    @IBOutlet weak var recentPrice: UILabel!
}
