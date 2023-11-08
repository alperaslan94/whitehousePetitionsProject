//
//  ViewController.swift
//  whitehousePetitionsProject
//
//  Created by Alperaslan on 7.11.2023.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let urlString: String
        if navigationController?.tabBarItem.tag == 0 {
        urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
                   let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                       if let error = error {
                           print("Error: \(error.localizedDescription)")
                           self?.showError()
                           return
                       }
                       
                       if let data = data {
                           self?.parse(json: data)
                       }
                   }
                   task.resume()
               }
        
       showError()
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading Error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(ac, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return petitions.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

