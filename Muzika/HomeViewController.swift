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
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var headerView: UIView!
    
    
    
    
    var images: [String] = ["Lofi","Beatles","Alan Watts"]
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    let cellSpacingHeight: CGFloat = 5
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        for index in 0..<images.count {
            frame.origin.x = scrollView.frame.size.width * CGFloat(index)
            frame.size = scrollView.frame.size

            let imageView = UIImageView(frame: frame)
            imageView.image = UIImage(named: images[index])
            self.scrollView.addSubview(imageView)
        }
       
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    
    
}

extension HomeViewController : UITableViewDataSource , UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return images.count
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
        let label = contentView?.viewWithTag(2) as! UILabel
        let buttonView = contentView?.viewWithTag(10)!
        
        
        imageView.image = UIImage(named: images[indexPath.section])
        label.text = "Lofi playlist with cool music inside this lofi playlist"
        
        imageView.layer.cornerRadius = 20
        buttonView?.layer.cornerRadius = 30
        playlistCell?.layer.cornerRadius = 30
        tableView.viewWithTag(10)?.layer.cornerRadius = 20
        contentView?.frame.inset(by: UIEdgeInsets(top: 50, left: 30, bottom: 50, right: 30))
        
        
        
        return playlistCell!
    }
}



