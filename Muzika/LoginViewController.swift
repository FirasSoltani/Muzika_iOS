//
//  LoginViewController.swift
//  Muzika
//
//  Created by Firas Soltani on 12/2/20.
//  Copyright © 2020 Firas Soltani. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var background: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    

    @IBAction func loginClicked(_ sender: Any) {
        getLogged()
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

    extension LoginViewController{
    func getLogged(){
        
        let url = URL(string: "https://nameless-cliffs-25074.herokuapp.com/api/auth/signin")
        guard let requestUrl = url else { fatalError() }
        let username = view.viewWithTag(1) as! UITextField
        let password = view.viewWithTag(2) as! UITextField
        print(username.text!)
        print(password.text!)
        let params = ["username" : username.text  , "password" : password.text]
        // Create URL Request
        var request = URLRequest(url: requestUrl)
        // Specify HTTP Method to use
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        // Send HTTP Request
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params)
        } catch let error {
           print(error)
        }
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check if Error took place
            if let error = error {
                print("Error took place \(error)")
                return
            }
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                
                DispatchQueue.main.async {
                    print(dataString)
                    let User: userLogin = try! JSONDecoder().decode(userLogin.self, from : data)
                    if(User.accessToken != nil){
                        print(User.username ??  "Nothing");
                        UserDefaults.standard.setValue(User.username, forKey: "Username")
                        UserDefaults.standard.setValue(User.email, forKey: "Email")
                        UserDefaults.standard.setValue(true, forKey: "Logged")
                        self.perform()
                    }
                    
                }
            }
            
        }
        task.resume()
    }

    func perform() {
        let storyboard = UIStoryboard(name: "Main" , bundle: nil)
        if #available(iOS 13.0, *) {
            let vc : UIViewController = storyboard.instantiateViewController(identifier: "MainTabBar")
                as! UITabBarController
            UIApplication.shared.keyWindow?.rootViewController = vc
        } else {
            // Fallback on earlier versions
        }
    }

}



