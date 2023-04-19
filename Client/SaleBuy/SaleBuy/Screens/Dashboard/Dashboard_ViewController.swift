//
//  Dashboard_ViewController.swift
//  SaleBuy
//
//  Created by Tung Dinh on 17/04/2023.
//

import UIKit

class Dashboard_ViewController: UIViewController {


    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_Email: UILabel!
    @IBOutlet weak var img_Avatar: UIImageView!

    let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        img_Avatar.layer.cornerRadius = img_Avatar.frame.size.width / 2

        self.navigationController?.setNavigationBarHidden(true, animated: false)

        // Check Login

        if let UserToken = userDefaults.string(forKey: "UserToken") {
            // Already have Token
            // Verify the Token
            let url = URL(string: Config.ServerURL + "/verifyToken")
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"


            let sData = "Token=" + UserToken

            let postData = sData.data(using: .utf8)
            request.httpBody = postData

            let taskUserRegister = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                guard error == nil else {
                    print("error");
                    return
                }
                guard let data = data else { return }

                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else { return }

                    if (json["result"] as! Int == 1) {
                        // Success
                        print(" Verify OK")
                        let user = json["User"] as? [String: Any]
                        let imgString = user!["Image"] as? String
                        let urlImage = Config.ServerURL + "/upload/" + imgString!
                        DispatchQueue.main.async {
                            do {
                                let imgData = try! Data(contentsOf: URL(string: urlImage)!)
                                self.img_Avatar.image = UIImage(data: imgData)
                            } catch {
                                print("Error in Image URL!")
                            }

                            self.lbl_Name.text = user!["Name"] as? String
                            self.lbl_Email.text = user!["Email"] as? String
                        }

                    } else {
                        DispatchQueue.main.async {
                            let sb = UIStoryboard(name: "Main", bundle: nil)
                            let login_VC = sb.instantiateViewController(identifier: "LOGIN") as! Login_ViewController
                            self.navigationController?.pushViewController(login_VC, animated: false)
                        }
                    }

                } catch let error { print(error.localizedDescription) }
            })
            taskUserRegister.resume()

        } else {
            // Have not Login
            print("There is no token")
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let login_VC = sb.instantiateViewController(identifier: "LOGIN") as! Login_ViewController
            self.navigationController?.pushViewController(login_VC, animated: false)
        }
    }


    @IBAction func logout(_ sender: Any) {
        let url = URL(string: Config.ServerURL + "/logout")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"

        if let UserToken = userDefaults.string(forKey: "UserToken") {

            let sData = "Token=" + UserToken

            let postData = sData.data(using: .utf8)
            request.httpBody = postData

            let taskUserRegister = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                guard error == nil else { print("error"); return }
                guard let data = data else { return }

                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else { return }

                    if (json["result"] as! Int == 1) {
                        // Logout Successfully

                        // Remove token from device
                        self.userDefaults.removeObject(forKey: "UserToken")

                        // Navigate to Login Screen
                        DispatchQueue.main.async {
                            let sb = UIStoryboard(name: "Main", bundle: nil)
                            let login_VC = sb.instantiateViewController(identifier: "LOGIN") as! Login_ViewController
                            self.navigationController?.pushViewController(login_VC, animated: false)
                        }

                    } else {
                        DispatchQueue.main.async {
                            let alertView = UIAlertController(title: "Notification", message: (json["errMsg"] as! String), preferredStyle: .alert)
                            alertView.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                            self.present(alertView, animated: true, completion: nil)
                        }
                    }

                } catch let error { print(error.localizedDescription) }
            })
            taskUserRegister.resume()
        } else {

        }
    }

}
