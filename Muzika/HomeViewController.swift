//
//  ViewController.swift
//  Muzika
//
//  Created by Firas Soltani on 11/18/20.
//  Copyright © 2020 Firas Soltani. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController , UIScrollViewDelegate  {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var headerView: UIView!
    private var accessToken: String = ""
    var posts: [PostHolder]?
    var images: [String] = ["Lofi","Beatles","Alan Watts"]
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    let cellSpacingHeight: CGFloat = 5

        override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let delegate = UIApplication.shared.delegate as! AppDelegate
        accessToken = delegate.accessToken
        let Id: String? = UserDefaults.standard.string(forKey: "Id")
        if(Id != nil){
            getData(Id: Id!)
        }
    }
}

extension HomeViewController : UITableViewDataSource , UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts?.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let playlistCell = tableView.dequeueReusableCell(withIdentifier: "playlistCell")
        let contentView = playlistCell?.contentView
        let imageView = contentView?.viewWithTag(1) as! UIImageView
        let buttonView = contentView?.viewWithTag(10)!
        
        let postContent = contentView?.viewWithTag(3) as! UILabel
        postContent.text = posts![indexPath.row].postContent
        imageView.image = UIImage(named: images[indexPath.section])
        
        postContent.layer.masksToBounds = true
        postContent.layer.cornerRadius = 20
        imageView.layer.cornerRadius = 20
        buttonView?.layer.cornerRadius = 30
        playlistCell?.layer.cornerRadius = 30
        tableView.viewWithTag(10)?.layer.cornerRadius = 20
        contentView?.frame.inset(by: UIEdgeInsets(top: 50, left: 30, bottom: 50, right: 30))
        
        return playlistCell!
    }
    
    func getData(Id : String){
        let url = URL(string: "https://nameless-cliffs-25074.herokuapp.com/api/posts/friendsPosts/"+Id)
        guard let requestUrl = url else { fatalError() }
        // Create URL Request
        var request = URLRequest(url: requestUrl)
        // Specify HTTP Method to use
        request.httpMethod = "GET"
        request.addValue("Bearer "+accessToken, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error took place \(error)")
                return
            }
            if let data = data, let _ = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    self.posts = try! JSONDecoder().decode([PostHolder].self, from: data)   
                    self.tableView.reloadData()
                }
            }
        }
        task.resume()
    }
}
    


