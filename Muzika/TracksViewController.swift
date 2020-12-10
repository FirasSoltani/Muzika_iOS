//
//  TracksViewController.swift
//  Muzika
//
//  Created by Firas Soltani on 12/10/20.
//  Copyright © 2020 Firas Soltani. All rights reserved.
//

import UIKit
import AVFoundation

@available(iOS 13.0, *)
class TracksViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackList?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(5)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trackCell")
        let title = cell?.viewWithTag(1) as! UILabel
        let album = cell?.viewWithTag(2) as! UILabel
        let imageView = cell?.viewWithTag(3) as! UIImageView
        
        //Image synchronous loading
        let url = URL(string: trackList?.items[indexPath.row].track.album?.images[0].url ??  "https://bitsofco.de/content/images/2018/12/broken-1.png")
        let data = try? Data(contentsOf: url!)
        imageView.image = UIImage(data: data!)
        //Finished
        title.text = trackList?.items[indexPath.row].track.name ?? "Not available"
        album.text = trackList?.items[indexPath.row].track.album?.name ?? "Not available"
        print(title.text = trackList?.items[indexPath.row].track.name)
        //playButton?.tag = indexPath.row
        return cell!
    }
    
    
    var player : AVPlayer?
    var accessToken : String = ""
    var playlistId : String = ""
    var trackList : tracks?
    var playButton : UIButton?
    @IBOutlet var tableView : UITableView?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.dataSource = self
        tableView?.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        playButton = self.view.viewWithTag(5) as? UIButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        accessToken = delegate.accessToken
        getData()
    }
}



@available(iOS 13.0, *)
extension TracksViewController{
    func getData(){
        let url = URL(string: "https://api.spotify.com/v1/playlists/"+playlistId+"/tracks")
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
                    self.trackList = try! JSONDecoder().decode(tracks.self, from: data)
                    self.tableView?.reloadData()
                    //print(trackList)
                }
            }
        }
        task.resume()
    }
    
    @IBAction func playRef() {
        guard let refUrl = trackList?.items[0].track.preview_url else { return }
        guard let url = URL.init(string: refUrl) else { return }
               let playerItem = AVPlayerItem.init(url: url)
               player = AVPlayer.init(playerItem: playerItem)
        player?.play()
        playButton?.setImage(UIImage(systemName: "pause.fill"),for: .normal)
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification){
            print("Video Finished")
        playButton?.setImage(UIImage(systemName: "play.fill"), for: .normal)
        //playButton?.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
    }
}
