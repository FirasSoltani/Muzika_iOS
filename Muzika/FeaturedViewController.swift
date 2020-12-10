//
//  SettingsViewController.swift
//  Muzika
//
//  Created by Firas Soltani on 11/19/20.
//  Copyright © 2020 Firas Soltani. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class FeaturedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    private var accessToken: String = ""
    @IBOutlet weak var tableView: UITableView!
    let cellSpacingHeight: CGFloat = 5
    var Playlist: Featured?
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
        let url = URL(string: Playlist!.playlists.items[indexPath.section].images[0].url!)
        let data = try? Data(contentsOf: url!)
        imageView.image = UIImage(data: data!)
        //Finished
        
        
        label.text = Playlist!.playlists.items[indexPath.section].description
        name.text = Playlist!.playlists.items[indexPath.section].name
        
        
        //Radius handling
        imageView.layer.cornerRadius = 20
        buttonView?.layer.cornerRadius = 30
        playlistCell?.layer.cornerRadius = 30
        tableView.viewWithTag(10)?.layer.cornerRadius = 30
        contentView?.frame.inset(by: UIEdgeInsets(top: 50, left: 30, bottom: 50, right: 30))
        
        print("Loading Cell")
        
        return playlistCell!
    }
   
    
    @IBAction func followClicked(_ sender: Any) {
        var superview = (sender as AnyObject).superview
        while let view = superview, !(view is UITableViewCell) {
            superview = view?.superview
        }
        guard let cell = superview as? UITableViewCell else {
            print("button is not contained in a table view cell")
            return
        }
        guard let indexPath = tableView.indexPath(for: cell) else {
            print("failed to get index path for cell containing button")
            return
        }
        print("button is in row \(indexPath.section)")
        print(follow(id: Playlist!.playlists.items[indexPath.section].id!))
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        var superview = (sender as AnyObject).superview
        while let view = superview, !(view is UITableViewCell) {
            superview = view?.superview
        }
        guard let cell = superview as? UITableViewCell else {
            print("button is not contained in a table view cell")
            return
        }
        guard let indexPath = tableView.indexPath(for: cell) else {
            print("failed to get index path for cell containing button")
            return
        }
       
        if segue.identifier == "postSegue"
        {
            let vc = segue.destination as? PostViewController
            vc?.playlistId = Playlist!.playlists.items[indexPath.section].id!
            vc?.playlistDescription = Playlist!.playlists.items[indexPath.section].description!
            vc?.playlistTitle = Playlist!.playlists.items[indexPath.section].name!
            vc?.image = Playlist!.playlists.items[indexPath.section].images[0].url!
        }
        else if segue.identifier == "trackSegue"
        {
            let vc = segue.destination as? TracksViewController
            vc?.playlistId = Playlist!.playlists.items[indexPath.section].id!
        }
    }
    
    
    @IBAction func postAdd(_ sender: Any) {
    performSegue(withIdentifier: "postSegue", sender: sender)
    }
    
}
@available(iOS 13.0, *)
extension FeaturedViewController {
    
    func getData(){
        
        let url = URL(string: "https://api.spotify.com/v1/browse/featured-playlists")
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
                    self.Playlist = try! JSONDecoder().decode(Featured.self, from: data)
                    self.playlistCount = self.Playlist!.playlists.items.count
                    self.tableView.reloadData() // this calls the table view data source methods again
                }
            }
        }
        task.resume()
    }
    
    func follow(id : String) -> Bool {
        let url = URL(string: "https://api.spotify.com/v1/playlists/"+id+"/followers")
        guard let requestUrl = url else { fatalError() }
        // Create URL Request
        var request = URLRequest(url: requestUrl)
        var state = true;
        // Specify HTTP Method to use
        request.httpMethod = "PUT"
        request.addValue("Bearer "+accessToken, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        
        // Send HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check if Error took place
            print(response ?? "No data")
            if let error = error {
                print("Error took place \(error)")
                state = false
                return
            }
            
        }
        task.resume()
        return state
    }
    
}

