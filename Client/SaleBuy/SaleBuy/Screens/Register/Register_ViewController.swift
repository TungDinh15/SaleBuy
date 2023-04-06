//
//  Register_ViewController.swift
//  SaleBuy
//
//  Created by Tung Dinh on 22/03/2023.
//

import UIKit

class Register_ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    
    @IBOutlet weak var txt_Username: UITextField!
    @IBOutlet weak var txt_Password: UITextField!
    @IBOutlet weak var txt_Name: UITextField!
    @IBOutlet weak var txt_Email: UITextField!
    @IBOutlet weak var txt_Address: UITextField!
    @IBOutlet weak var txt_PhoneNumber: UITextField!
    
    @IBOutlet weak var imgAvatar: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func RegisterNewUser(_ sender: Any) {
        
        // Upload Avatar
        var url = URL(string: "http://10.0.1.3:3000/uploadFile")
        let boundary = UUID().uuidString
        let session = URLSession.shared
        
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // config the image data variable
        var data = Data()
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"hinhdaidien\"; filename=\"avatar.png\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append((imgAvatar.image?.pngData())!)
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        session.uploadTask(with: urlRequest, from: data, completionHandler: { [self]
            responseData, response, error in
            if error == nil {
                let jsonData = try? JSONSerialization.jsonObject(with: responseData!, options: .allowFragments)
                if let json = jsonData as? [String: Any] {
                    if (json["result"] as! Int == 1) {
                        let urlFile = json["urlFile"] as? [String: Any]
                        // print( urlFile!["filename"] )
                        
                        let queueSendUserInformation = DispatchQueue(label: "SendUserInformation")
                        queueSendUserInformation.async {
                            // Send user register info
                            let parameters = [
                                "Username": self.txt_Username.text!,
                                "Name": self.txt_Name.text!,
                                "Image": urlFile!["Filename"] as! String,
                                "Email": self.txt_Email.text!,
                                "Adress": self.txt_Address.text!,
                                "PhoneNumber": self.txt_PhoneNumber.text!
                            ]
                            
                            url = URL(string: "http://10.0.1.3:3000/register")
                            var request = URLRequest(url: url!)
                            request.httpMethod = "POST"
                            
                            do {
                                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                            } catch
                                let error { print(error.localizedDescription)
                                
                            }
                            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                            request.addValue("application/json", forHTTPHeaderField: "Accept")
                            
                            let taskUserRegister = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                                guard error == nil else { return }
                                guard let data = data else { return }
                                
                                do {
                                    guard try JSONSerialization.jsonObject(with: data, options: .mutableContainers) is [String: Any] else { return }
                                } catch let error { print(error.localizedDescription) }
                            })
                            taskUserRegister.resume()
                        }
                        
                    } else {
                        print("Upload failed!")
                    }
                }
            }
        }).resume()
    }
    
    // Choose photo from Gallery by open the new nav to pickup one
    @IBAction func ChooseImageFromPhotoGallery(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage {
            imgAvatar.image = image
        } else {
            
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func UploadImageToServer(_ sender: Any) {
        
        // config the url connect to backend route
        let url = URL(string: "http://10.0.1.3:3000/uploadFile")
        let boundary = UUID().uuidString
        let session = URLSession.shared
        
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // config the image data variable
        var data = Data()
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"hinhdaidien\"; filename=\"avatar.png\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append((imgAvatar.image?.pngData())!)
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        session.uploadTask(with: urlRequest, from: data, completionHandler: {
            responseData, response, error in
            if error == nil {
                let jsonData = try? JSONSerialization.jsonObject(with: responseData!, options: .allowFragments)
                if let json = jsonData as? [String: Any] {
                    print(json)
                }
            }
        }).resume()
    }
}
