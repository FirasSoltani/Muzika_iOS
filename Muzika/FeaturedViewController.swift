//
//  SettingsViewController.swift
//  Muzika
//
//  Created by Firas Soltani on 11/19/20.
//  Copyright © 2020 Firas Soltani. All rights reserved.
//

import UIKit

class FeaturedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    
    
    
    
    
    private var accessToken: String = ""
    @IBOutlet weak var tableView: UITableView!
    let cellSpacingHeight: CGFloat = 5
    var Playlist: playlistStructure?
    var playlistCount: Int = 0
    func numberOfSections(in tableView: UITableView) -> Int {
        return playlistCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Object definition
        let playlistCell = tableView.dequeueReusableCell(withIdentifier: "playlistCell")
        let contentView = playlistCell?.contentView
        let imageView = contentView?.viewWithTag(1) as! UIImageView
        let label = contentView?.viewWithTag(2) as! UILabel
        let name = contentView?.viewWithTag(5) as! UILabel
        let buttonView = contentView?.viewWithTag(10)!
        
        //Image synchronous loading
        let url = URL(string: Playlist!.items[indexPath.section].images[0].url!)
        let data = try? Data(contentsOf: url!)
        imageView.image = UIImage(data: data!)
        //Finished
        
        
        label.text = Playlist!.items[indexPath.section].description
        name.text = Playlist!.items[indexPath.section].name
        
        
        //Radius handling
        imageView.layer.cornerRadius = 20
        buttonView?.layer.cornerRadius = 30
        playlistCell?.layer.cornerRadius = 30
        tableView.viewWithTag(10)?.layer.cornerRadius = 30
        contentView?.frame.inset(by: UIEdgeInsets(top: 50, left: 30, bottom: 50, right: 30))
        
        print("Loading Cell")
        
        return playlistCell!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        accessToken = delegate.accessToken
        getData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.viewWithTag(10)?.layer.cornerRadius = 50
        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    func getData(){
        
        let url = URL(string: "https://api.spotify.com/v1/me/playlists")
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
                    self.Playlist = try! JSONDecoder().decode(playlistStructure.self, from: data)
                    self.playlistCount = self.Playlist!.items.count
                    self.tableView.reloadData() // this calls the table view data source methods again
                }
            }
            
        }
        task.resume()
    }
    
}

