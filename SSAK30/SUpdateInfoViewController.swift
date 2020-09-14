//
//  SUpdateInfoViewController.swift
//  SSAK30
//
//  Created by sookjeon on 2020/09/10.
//  Copyright © 2020 김승희. All rights reserved.
//

import UIKit
import FirebaseStorage

class SUpdateInfoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfBusinessNo: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfAddress: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var receiveuSeqno = ""
    var receiveName = ""
    var receiveBusiness = ""
    var receiveAddress = ""
    var receivePhone = ""
    var receiveImage = ""
    var receiveServiceTime = ""
    var sImage: String?
    var openTime: String?
    var closeTime:String?
    var sServiceTime:String?
    let imagePickerController = UIImagePickerController()
    var imgUrl: URL?
    var rstImage: UIImage?
    
    let storage = Storage.storage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // viewMap: View 객체
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imgClick))
        imgImage.isUserInteractionEnabled = true
        imgImage.addGestureRecognizer(tapGestureRecognizer)

        tfName.text = receiveName
        tfBusinessNo.text = receiveBusiness
        tfPhone.text = receivePhone
        tfAddress.text = receiveAddress
        sServiceTime = receiveServiceTime
        
        imagePickerController.delegate = self
    }
    @objc func imgClick(){
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
    
    func receiveItems(_ uSeqno:String, _ name: String, _ image: String, _ businessNo: String, _ phone: String, _ address: String, _ serviceTime: String) {
        receiveuSeqno = uSeqno
        receiveName = name
        receiveImage = image
        receiveBusiness = businessNo
        receivePhone = phone
        receiveAddress = address
        receiveServiceTime = serviceTime
    }

    @IBAction func btnUpdate(_ sender: UIButton) {
        let sName = tfName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let sBusinessNo = tfBusinessNo.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let sPhone = tfPhone.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let sAddress = tfAddress.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let now = NSDate()
        if(openTime != nil && closeTime != nil){
            sServiceTime = openTime! + " ~ " + closeTime!
        }else{
            
        }
        if(sName == "" || sBusinessNo == "" || sPhone == "" || sAddress == "" || sServiceTime == ""){
            let checkAlert = UIAlertController(title: "알림", message: "빈칸을 입력하세요.", preferredStyle: UIAlertController.Style.alert)
            let onAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
            checkAlert.addAction(onAction)
            present(checkAlert, animated: true, completion: nil)
        }else{
                self.activityIndicator.startAnimating()
                
                //이미지 이름을 위한 dataformat
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyyMMddHHmmssEEE"
                let dateNow = dateFormatter.string(from: now as Date)
                
                //이미지 데이터화
                let imgData = rstImage?.jpegData(compressionQuality: 0.5)
                sImage = dateNow + sImage!
                let queryModel = SUpdateQueryModel()
                let result: Bool = queryModel.updateItem(uSeqno:receiveuSeqno, sName:sName!, sBusinessNo:sBusinessNo!, sServiceTime:sServiceTime!, sAddress:sAddress!, sPhone:sPhone!, sImage:sImage!)

                
                if result{
                    //DB에 들어가고 나면 FTP 이미지 업로드
                    let storageRef = storage.reference()
                    let sImageRef = storageRef.child("sImage/" + sImage!)
                    
                    sImageRef.putData(imgData!, metadata: nil)
                    
                    //끝나면 인디케이터 숨기기
                    activityIndicator.stopAnimating()
                    
                    let resultAlert = UIAlertController(title: "완료", message: "스토어정보가 수정되었습니다.", preferredStyle: UIAlertController.Style.alert)
                    let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {ACTION in

                        self.performSegue(withIdentifier: "sgOkUpdate", sender: self)
//                        self.navigationController?.popViewController(animated: true)
                    })
                    resultAlert.addAction(onAction)
                    present(resultAlert, animated: true, completion: nil)
                } else {
                    let resultAlert = UIAlertController(title: "실패", message: "에러가 발생 되었습니다.", preferredStyle: UIAlertController.Style.alert)
                    let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                    resultAlert.addAction(onAction)
                    present(resultAlert, animated: true, completion: nil)
                }
                
            }
    }
            
            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                
                if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                    imgImage.image = image
                    rstImage = image
                }
                if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL {
                    imgUrl = url
                    sImage = imgUrl?.lastPathComponent
                    print(imgUrl!)
                    print(imgUrl!.path)
                }
                    
                // 켜놓은 앨범 화면 없애기
                dismiss(animated: true, completion: nil)
            }
        
            
        
    

    @IBAction func openDatePicker(_ sender: UIDatePicker) {
        let datePickerView = sender
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        openTime = formatter.string(from: datePickerView.date)
    }
    
    @IBAction func closeDatePicker(_ sender: UIDatePicker) {
        let datePickerView = sender
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        closeTime = formatter.string(from: datePickerView.date)
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


