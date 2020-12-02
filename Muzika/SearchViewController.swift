//
//  SearchViewController.swift
//  Muzika
//
//  Created by Firas Soltani on 11/26/20.
//  Copyright © 2020 Firas Soltani. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController,UITableViewDataSource, UISearchBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as UITableViewCell
        let textLabel = cell.viewWithTag(1) as! UILabel
        textLabel.text = filteredData[indexPath.row].firstName! + " " + filteredData[indexPath.row].lastName!
                return cell
    }
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    private var accessToken: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
             tableView.dataSource = self
               searchBar.delegate = self
               filteredData = data
        let delegate = UIApplication.shared.delegate as! AppDelegate
        accessToken = delegate.accessToken
        // Do any additional setup after loading the view.
    }
    var data = [infos]()

       var filteredData: [infos ]!

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            // When there is no text, filteredData is the same as the original data
            // When user has entered text into the search box
            // Use the filter method to iterate over all items in the data array
            // For each item, return true if the item should be included and false if the
            // item should NOT be included
        if(!searchText.isEmpty){
            getData(accessToken: accessToken, searchString: searchText)
        }
            filteredData = searchText.isEmpty ? data : data.filter {
            return $0.firstName?.contains(searchText) ?? false || ((($0.lastName?.contains(searchText))) ?? false)
        }
            
            tableView.reloadData()
        }
}

extension SearchViewController {
    func getData(accessToken: String , searchString: String) {
        
        let url = URL(string: "https://nameless-cliffs-25074.herokuapp.com/search/"+searchString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        guard let requestUrl = url else { fatalError() }
        // Create URL Request
        var request = URLRequest(url: requestUrl)
        // Specify HTTP Method to use
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check if Error took place
            if let error = error {
                print("Error took place \(error)")
                return
            }
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    print(dataString)
                    let User = try! JSONDecoder().decode(id.self, from: data)
                    self.data = User.user ?? [infos]()
                }
            }
            
        }
        task.resume()
    }
}
struct infos: Codable{
    let firstName: String?
    let lastName: String?
    let spotifyId: String?
}
struct id: Codable {
    let user: [infos]?
}


