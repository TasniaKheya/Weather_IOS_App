//
//  ViewController.swift
//  weather
//
//  Created by kuetcse on 31/10/21.
//  Copyright © 2021 kuetcse. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController {
    
    private let database = Database.database().reference()
    
    @IBOutlet weak var unameLoginLabel: UITextField!
    @IBOutlet weak var passLoginLabel: UITextField!
    
    @IBOutlet weak var loginBtnLabel: UIButton!
    @objc func loginBtn(_ sender: Any) {
        print("Button Pressed")
        var obj : [String : String] = ["email" : "", "pass" : "", "username": ""]
        
        if unameLoginLabel.text! == "" || passLoginLabel.text! == "" {
            showToast(message: "Please Enter Username or Password")
        }
        else {
            database.child(unameLoginLabel.text!).getData(completion:  { error, snapshot in
              guard error == nil else {
                print(error!.localizedDescription)
                print("errorrrrrrrr")
                return;
              }

                print("username : \(self.unameLoginLabel.text!)")
                print("pass : \(self.passLoginLabel.text!)")

                if let result = snapshot.children.allObjects as? [DataSnapshot] {
                    for child in result {
                        obj[child.key] = child.value as? String
                    }
                }

                print("Inside Closure")
                print(obj)

            });
            
            sleep(1)
            print(obj)
            
            if obj["username"] != self.unameLoginLabel.text! {
                showToast(message: "Invalid Username")
            }
            else {
                if obj["pass"] != self.passLoginLabel.text! {
                    showToast(message: "Wrong Password")
                    print("wrong password")

                }
                else {
                    showWeatherViewController()
                    print("right password")
                }
            }

        }

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

    func showWeatherViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let weatherVC = storyboard.instantiateViewController(identifier: "weatherViewController")

        show(weatherVC, sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginBtnLabel.addTarget(self, action: #selector(loginBtn), for: .touchUpInside)
    }


}

