//
//  SProductAddViewController.swift
//  SSAK30
//
//  Created by taeheum on 2020/09/08.
//  Copyright © 2020 김승희. All rights reserved.
//

import UIKit
import FirebaseStorage

class SProductAddViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imgName: String?
    var imgUrl: URL?
    var rstImage: UIImage?
    
    let storage = Storage.storage()
    
    @IBOutlet weak var tfSellTitle: UITextField!
    @IBOutlet weak var tfSellTotalEA: UITextField!
    @IBOutlet weak var tfSellMinimumEA: UITextField!
    @IBOutlet weak var tfSellPriceEA: UITextField!
    @IBOutlet weak var tvContext: UITextView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var openDate:String = ""
    var closeDate:String = ""
    let imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imagePickerController.delegate = self
        
    }
    
    @IBAction func btnAlbum(_ sender: UIButton) {
        let imageRoutCheckAlert =  UIAlertController(title: "이미지 가져오기", message: "이미지를 가져올 방식을 선택하세요", preferredStyle: .actionSheet)
        let libraryAction =  UIAlertAction(title: "앨범", style: .default, handler: { ACTION in
            if(UIImagePickerController .isSourceTypeAvailable(.photoLibrary)){
                self.imagePickerController.sourceType = .photoLibrary
                self.present(self.imagePickerController, animated: false, completion: nil)
            } else {
                print("Camera not available")
            }
        })
        
        let cameraAction =  UIAlertAction(title: "카메라", style: .default, handler: { ACTION in
            if(UIImagePickerController .isSourceTypeAvailable(.camera)){
                self.imagePickerController.sourceType = .camera
                self.present(self.imagePickerController, animated: false, completion: nil)
            } else {
                print("Camera not available")
            }
        })
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        imageRoutCheckAlert.addAction(libraryAction)
        imageRoutCheckAlert.addAction(cameraAction)
        imageRoutCheckAlert.addAction(cancelAction)
        present(imageRoutCheckAlert, animated: true, completion: nil)

    }
    
    
    @IBAction func openDatePicker(_ sender: UIDatePicker) {
        let datePickerView = sender
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm EEE"
        openDate = formatter.string(from: datePickerView.date)
    }
    
    @IBAction func closeDatePicker(_ sender: UIDatePicker) {
        let datePickerView = sender
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm EEE"
        closeDate = formatter.string(from: datePickerView.date)
    }
    
    @IBAction func btnRegist(_ sender: UIButton) {
        let title = tfSellTitle.text
        let totalEA = tfSellTotalEA.text
        let minimumEA = tfSellMinimumEA.text
        let priceEA = tfSellPriceEA.text
        let context = tvContext.text
        let now = NSDate()
        
        self.activityIndicator.startAnimating()
        
        //이미지 이름을 위한 dataformat
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmssEEE"
        let dateNow = dateFormatter.string(from: now as Date)
        
        //이미지 데이터화
        let imgData = rstImage?.jpegData(compressionQuality: 0.5)
        
        let productInsertModel = ProductInsertModel()
        let result = productInsertModel.productInsertItems(title: title!, totalEA: totalEA!, minimumEA: minimumEA!, priceEA: priceEA!, openDate: openDate, closeDate: closeDate, context: context!, image: imgName!)
        
        if result{
            //DB에 들어가고 나면 FTP 이미지 업로드
            let storageRef = storage.reference()
            let sbImageRef = storageRef.child("sbImage/" + dateNow + imgName!)
            
            sbImageRef.putData(imgData!, metadata: nil)
            
            //끝나면 인디케이터 숨기기
            activityIndicator.stopAnimating()
            
            let resultAlert = UIAlertController(title: "완료", message: "상품이 등록되었습니다.", preferredStyle: UIAlertController.Style.alert)
            let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            resultAlert.addAction(onAction)
            present(resultAlert, animated: true, completion: nil)
        } else {
            let resultAlert = UIAlertController(title: "실패", message: "에러가 발생 되었습니다.", preferredStyle: UIAlertController.Style.alert)
            let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            resultAlert.addAction(onAction)
            present(resultAlert, animated: true, completion: nil)
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imgView.image = image
            rstImage = image
        }
        if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            imgUrl = url
            imgName = imgUrl?.lastPathComponent
            print(imgUrl!)
            print(imgUrl!.path)
        }
            
        // 켜놓은 앨범 화면 없애기
        dismiss(animated: true, completion: nil)
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

