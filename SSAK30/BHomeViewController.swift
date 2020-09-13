//
//  BHomeViewController.swift
//  SSAK30
//
//  Created by 김승희 on 2020/09/04.
//  Copyright © 2020 김승희. All rights reserved.
//

import UIKit

class BHomeViewController: UIViewController {
    
    @IBOutlet weak var bhomeBanner: UIImageView!
    @IBOutlet weak var bHomePageControl: UIPageControl!
    
    // 이미지 등록
    var bannerImages = ["playstore.png", "chicken.jpeg", "meat.jpeg"]
    
    //collection view
    var interestRecommendListViewController: BMainRecommendListViewController!
    var recentRecommendListViewController: BMainRecentRecommendListViewController!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarItem.image = UIImage(named: "home.png")
        
        //pageControl 환경//
        // 총 몇 페이지인지 알려줘야함
        bHomePageControl.numberOfPages = bannerImages.count
        bHomePageControl.currentPage = 0 // 넘길때마다 바뀜 // 지금은 첫 화면 실행 시, pageControl은 첫번째 설정 // 2로 바꾸면 3번째에 pageControl가있음
        
        // 색 지정
        bHomePageControl.pageIndicatorTintColor = UIColor.green // 선택 안된컬러
        bHomePageControl.currentPageIndicatorTintColor = UIColor.red // 선택한 컬러
        // pageControl 환경설정 끝 //
        
        // 이미지 띄워줌
        bhomeBanner.image = UIImage(named: bannerImages[0])
        
        // 한 손가락 Gesture 초기값 설정
               // 인식 : UISwipeGestureRecognizer // #selector 는 계속해서 뭘 받으려고 함
               // 한 손가락 함수 responseToSwipeGesture 생성
               
               // LEFT
               let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(BHomeViewController.responseToSwipeGesture(_ :)))
               // 한 손가락 스와이프 기능 추가
               swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
               self.view.addGestureRecognizer(swipeLeft)

               // RIGHT
               let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(BHomeViewController.responseToSwipeGesture(_ :)))
               // 한 손가락 스와이프 기능 추가
               swipeRight.direction = UISwipeGestureRecognizer.Direction.right
               self.view.addGestureRecognizer(swipeRight)
               // 한 손가락 GESTURE 초기값 설정 완료 //
        
        
    }
    
    // selector 함수 //
    // 한손가락 Gesture
    @objc func responseToSwipeGesture(_ gesture: UIGestureRecognizer){// nil값 정리: #selector 는 계속해서 뭘 받으려고 하기 때문에
       if let swipeGesture = gesture as? UISwipeGestureRecognizer{
               
           // 한 손가락으로 스와이프하기 ( 순환 )
           switch swipeGesture.direction {
               case UISwipeGestureRecognizer.Direction.left:
                    if bHomePageControl.currentPage == bannerImages.count-1 {
                        bHomePageControl.currentPage = 0 // 첫번째 페이지로
                        bhomeBanner.image = UIImage(named: bannerImages[bHomePageControl.currentPage])
                    }else{
                        bhomeBanner.image = UIImage(named: bannerImages[bHomePageControl.currentPage+1])
                        bHomePageControl.currentPage += 1
                    }
                  
               case UISwipeGestureRecognizer.Direction.right:
                    if bHomePageControl.currentPage == 0{ // 첫번째 페이지일 떄
                        bHomePageControl.currentPage = bannerImages.count // 마지막 페이지로 순환
                        bhomeBanner.image = UIImage(named: bannerImages[bannerImages.count-1]) // 이미지도 마지막꺼로
                    }else{
                        bhomeBanner.image = UIImage(named: bannerImages[bHomePageControl.currentPage-1])
                        bHomePageControl.currentPage -= 1
                    }
               default:
                    break
               }
           }
       }
    
    // 액션 //
    @IBAction func bHomePageChange(_ sender: UIPageControl) {
        bhomeBanner.image = UIImage(named: bannerImages[bHomePageControl.currentPage])
    }
    
    // collectionview
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "interest" {
            let destinationVC = segue.destination as? BMainRecommendListViewController
            interestRecommendListViewController = destinationVC
        }else if segue.identifier == "recent" {
            let destinationVC = segue.destination as? BMainRecentRecommendListViewController
            recentRecommendListViewController = destinationVC
        }
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
 
