//
//  PostViewController.swift
//  Muzika
//
//  Created by Firas Soltani on 12/8/20.
//  Copyright © 2020 Firas Soltani. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {

    @IBOutlet weak var viewRectangle: UIView!
    var image: String?
    var playlistTitle: String?
    var playlistDescription: String?
    var playlistId: String?
    @IBOutlet var textField : UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewRectangle.layer.cornerRadius = 20
        let imageView = self.view.viewWithTag(1) as! UIImageView
        let description = self.view.viewWithTag(2) as! UILabel
        let title = self.view.viewWithTag(3) as! UILabel
        description.text = playlistDescription
        title.text = playlistTitle
        
        let url = URL(string: self.image ?? "https://bitsofco.de/content/images/2018/12/broken-1.png")
        let data = try? Data(contentsOf: url!)
        imageView.image = UIImage(data: data!)
        imageView.layer.cornerRadius = 20
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func addPost(_ sender: Any) {
        let userId:Int = UserDefaults.standard.object(forKey: "Id") as! Int
        let url = URL(string: "https://nameless-cliffs-25074.herokuapp.com/api/posts/add/"+String(userId)+"/"+playlistId!)
        guard let requestUrl = url else { fatalError() }
        // Create URL Request
        var request = URLRequest(url: requestUrl)
        // Specify HTTP Method to use
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonData : [String:Any] = ["postContent" : self.textField?.text ?? ""]
        request.httpBody = try? JSONSerialization.data(withJSONObject: jsonData)
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
            
                }
            }
        }
        task.resume()
    }
    
}
