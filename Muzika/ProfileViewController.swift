//
//  ProfileViewController.swift
//  Muzika
//
//  Created by Firas Soltani on 11/19/20.
//  Copyright © 2020 Firas Soltani. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
   

    
    private var accessToken: String = ""

    @IBOutlet weak var liked: UIView!
    @IBOutlet weak var logout: UIView!
    @IBOutlet weak var favorites: UIView!
    @IBOutlet weak var playlists: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var profileImage:
        UIImageView!
    @IBOutlet weak var playlistCount: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
     
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = profileImage.bounds.width / 2
        cardView.layer.cornerRadius = 50
        favorites.layer.cornerRadius = 30
        logout.layer.cornerRadius = 30
        playlists.layer.cornerRadius = 30
        liked.layer.cornerRadius = 30
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
        
    override func viewWillAppear(_ animated: Bool) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        accessToken = delegate.accessToken
        getData(accessToken: accessToken)
        //Finished
    }
    @IBAction func logoutAction(_ sender: Any) {
        UserDefaults.standard.setValue(false, forKey: "Logged")
        let storyboard = UIStoryboard.init(name: "Main" , bundle: nil)
            if #available(iOS 13.0, *) {
                let vc : UIViewController = storyboard.instantiateViewController(identifier: "loginView")
                UIApplication.shared.keyWindow?.rootViewController = vc
            }
    }
}


extension ProfileViewController {
    func getData(accessToken: String) {
        
        let url = URL(string: "https://api.spotify.com/v1/me")
        var User: user?
        guard let requestUrl = url else { fatalError() }
        // Create URL Request
        var request = URLRequest(url: requestUrl)
        // Specify HTTP Method to use
        request.httpMethod = "GET"
        request.addValue("Bearer "+accessToken, forHTTPHeaderField: "Authorization")
        // Send HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check if Error took place
            if let error = error {
                print("Error took place \(error)")
                return
            }
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    print(dataString)
                    User = try! JSONDecoder().decode(user.self, from: data)
                    //self.playlistCount.text = String(self.playlistsCount!) + " Playlists"
                    self.setUser(currentUser: User!)
                }
            }
            
        }
        task.resume()
    }
    
    func setUser(currentUser: user) {
        userNameLabel.text = currentUser.display_name
        //Image synchronous loading
        if(currentUser.images?.count != 0){
        let url = URL(string: currentUser.images?[0].url ?? "")!
        let data = try? Data(contentsOf: url)
        profileImage.image = UIImage(data: data!)
        }
        else
        {
            if #available(iOS 13.0, *) {
                profileImage.image = UIImage(systemName:"person")
            }
        }
    }
    
}





