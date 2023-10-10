//
//  signUpViewController.swift
//  weather
//
//  Created by kuetcse on 31/10/21.
//  Copyright © 2021 kuetcse. All rights reserved.
//

import UIKit
import FirebaseDatabase


//struct User {
//    var name : String = ""
//    var email : String = ""
//    var password : String = ""
//
//}
class signUpViewController: UIViewController {
    let db = Database.database().reference()
    @IBOutlet weak var unameLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passLabel: UITextField!
    
    @IBOutlet weak var signupOutLabel: UIButton!
    @objc func signupLabel(_ sender: Any) {
        var isComplete = true
        if unameLabel.text == "" {
            isComplete = false
            showToast(message: "Please enter Username")
            print("Please enter Username")
        }
        
        if emailLabel.text == "" {
            isComplete = false
            showToast(message: "Please enter email")
            print("Please enter email")
        }
        
        if passLabel.text == "" {
            isComplete = false
            showToast(message: "Please enter password")
            print("Please enter password")
        }
        if isComplete {
            
            let object: [String: String] = ["username" : unameLabel.text!, "email" : emailLabel.text!, "pass" : passLabel.text!]
            
            if !unameCheck() {
                db.child(unameLabel.text!).setValue(object)
                
                showWeatherViewController()
                print("SignUp Done")
            }
            else {
                showToast(message: "Username already exists")
            }

        }
    }
    
    func unameCheck() -> Bool {
        
        var isTrue : Bool = true
        
        db.child(unameLabel.text!).getData(completion:  { error, snapshot in
          guard error == nil else {
            isTrue = false
            print(error!.localizedDescription)
            print("errorrrrrrrr")
            return;
          }
        });
        
        return isTrue
    }
    func showWeatherViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let weatherVC = storyboard.instantiateViewController(identifier: "weatherViewController")

        show(weatherVC, sender: self)
    }

    func showToast(message : String) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 170, y: self.view.frame.size.height-100, width: 350, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 5.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        signupOutLabel.addTarget(self, action: #selector(signupLabel), for: .touchUpInside)
        // Do any additional setup after loading the view.
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
