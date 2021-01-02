
import UIKit

class SearchViewController: UIViewController,UITableViewDataSource, UISearchBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as UITableViewCell
        let textLabel = cell.viewWithTag(1) as! UILabel
        textLabel.text = filteredData[indexPath.row].display_name!
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
    var data = [user]()
    var filteredData: [user ]!

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            
        if(!searchText.isEmpty){
            getData(accessToken: accessToken, searchString: searchText)
        }
            filteredData = searchText.isEmpty ? data : data.filter {
            return $0.display_name?.contains(searchText) ?? false
        }
            tableView.reloadData()
        }
}

extension SearchViewController {
    func getData(accessToken: String , searchString: String) {
        
        let url = URL(string: "https://nameless-cliffs-25074.herokuapp.com/api/search")
        
        let json: [String: Any] = ["username": "firaspop"]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
            
        guard let requestUrl = url else { fatalError() }
        // Create URL Request
        var request = URLRequest(url: requestUrl)
        // Specify HTTP Method to use
        request.httpMethod = "GET"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check if Error took place
            if let error = error {
                print("Error took place \(error)")
                return
            }
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    print(dataString)
                    let User = try! JSONDecoder().decode([user].self, from: data)
                    self.data = User
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


