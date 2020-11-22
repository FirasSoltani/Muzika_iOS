//
//  ProfileViewController.swift
//  Muzika
//
//  Created by Firas Soltani on 11/19/20.
//  Copyright © 2020 Firas Soltani. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
   

    @IBOutlet weak var liked: UIView!
    @IBOutlet weak var logout: UIView!
    @IBOutlet weak var favorites: UIView!
    @IBOutlet weak var playlists: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
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

}


