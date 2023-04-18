//
//  Welcome_ViewController.swift
//  SaleBuy
//
//  Created by Tung Dinh on 17/04/2023.
//

import UIKit

class Welcome_ViewController: UIViewController {


    @IBOutlet weak var img_Logo: UIImageView!


    @IBOutlet weak var img_BG1: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        img_BG1.frame.size.width = self.view.frame.size.width * 3
        img_BG1.frame.size.height = self.view.frame.size.height * 3
        img_BG1.frame.origin = CGPoint(x: 0, y: 0)
        img_BG1.alpha = 0

        UIView.animate(withDuration: 5, delay: 0, animations: {
            self.img_BG1.alpha = 0.9
            self.img_BG1.frame.size = CGSize(
                width: self.view.frame.size.width,
                height: self.view.frame.size.height
            )
        }, completion: nil)

        img_Logo.frame.origin.x = 0 - img_Logo.frame.size.width

        UIView.animateKeyframes(withDuration: 3, delay: 1, animations: {
            self.img_Logo.frame.origin = CGPoint(
                x: self.view.frame.size.width / 2 - self.img_Logo.frame.size.width / 2,
                y: self.view.frame.size.height / 2 - self.img_Logo.frame.size.height / 2
            )
        }, completion: nil)
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
