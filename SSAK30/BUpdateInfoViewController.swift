//
//  BUpdateInfoViewController.swift
//  SSAK30
//
//  Created by sookjeon on 2020/09/10.
//  Copyright © 2020 김승희. All rights reserved.
//

import UIKit
import FirebaseStorage

class BUpdateInfoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var imgMyImage: UIImageView!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfNAme: UITextField!
    @IBOutlet weak var tfPasswordChk: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var receiveuSeqno = ""
    var receiveEmail = ""
    var receiveName = ""
    var receivePassword = ""
    var receivePhone = ""
    var receiveImage = ""
    var uImage:String?
    let imagePickerController = UIImagePickerController()
    var imgUrl: URL?
    var rstImage: UIImage?
    
    let storage = Storage.storage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imgClick))
        imgMyImage.isUserInteractionEnabled = true
        imgMyImage.addGestureRecognizer(tapGestureRecognizer)

        // Do any additional setup after loading the view.
        tfEmail.text = String(receiveEmail)
        tfEmail.isUserInteractionEnabled = false // Read Only
        tfPassword.text = receivePassword
        tfPasswordChk.text = receivePassword
        tfNAme.text = receiveName
        tfPhone.text = receivePhone
        
        imagePickerController.delegate = self
    }
    
    func receiveItems(_ uSeqno:String, _ name: String, _ image: String, _ password: String, _ phone: String, _ email: String) {
        receiveuSeqno = uSeqno
        receiveName = name
        receiveImage = image
        receivePassword = password
        receivePhone = phone
        receiveEmail = email
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

    @IBAction func btnUpdate(_ sender: UIButton) {
        let uName = tfNAme.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let uPassword = tfPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let uPasswordChk = tfPasswordChk.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let uPhone = tfPhone.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let now = NSDate()
        if(uName == "" || uPassword == "" || uPhone == ""){
            let checkAlert = UIAlertController(title: "알림", message: "빈칸을 입력하세요.", preferredStyle: UIAlertController.Style.alert)
            let onAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
            checkAlert.addAction(onAction)
            present(checkAlert, animated: true, completion: nil)
        }else if(uPassword != uPasswordChk) {
            let checkAlert = UIAlertController(title: "알림", message: "비밀번호가 일치하지 않습니다.", preferredStyle: UIAlertController.Style.alert)
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
            uImage = dateNow + uImage!
            let queryModel = BUpdateQueryModel()
            let result = queryModel.updateItem(uSeqno: receiveuSeqno , uName: uName!, uPassword: uPassword!, uPhone: uPhone!, uImage: uImage!)
            if result{
                //DB에 들어가고 나면 FTP 이미지 업로드
                let storageRef = storage.reference()
                let uImageRef = storageRef.child("uImage/" + uImage!)
                
                uImageRef.putData(imgData!, metadata: nil)
                
                //끝나면 인디케이터 숨기기
                activityIndicator.stopAnimating()
                
                let resultAlert = UIAlertController(title: "완료", message: "개인정보가 수정되었습니다.", preferredStyle: UIAlertController.Style.alert)
                let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {ACTION in
                    self.performSegue(withIdentifier: "sgOkuUpdate", sender: self)
//                      self.navigationController?.popViewController(animated: true)
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
            imgMyImage.image = image
            rstImage = image
        }
        if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            imgUrl = url
            uImage = imgUrl?.lastPathComponent
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
