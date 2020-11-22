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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let playlistCell = tableView.dequeueReusableCell(withIdentifier: "playlistCell")
        let contentview = playlistCell?.contentView
        let imageView = contentview?.viewWithTag(1) as! UIImageView
        let label = contentview?.viewWithTag(2) as! UILabel
        
        imageView.image = UIImage(named: "Lofi")
        label.text = "Lofi playlist"
        
        return playlistCell!
    }
}



