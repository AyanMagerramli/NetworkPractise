//
//  ViewController.swift
//  NetworkPractise
//
//  Created by Ayan on 26.11.23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var table: UITableView!
    
    var posts = [ResponseModelPOST]()
    let baseURL = "https://jsonplaceholder.typicode.com/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        getPostItems()
    }
    
    func configureUI() {
        table.delegate = self
        table.dataSource = self
    }
    
    func getPostItems() {
        guard let url = URL(string: "\(baseURL)posts") else {return}
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                do {
                    self.posts = try JSONDecoder().decode(postItems.self, from: data!)
                    DispatchQueue.main.async {
                        self.table.reloadData()
                    }
                    print(self.posts)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = storyboard?.instantiateViewController(identifier: "\(SecondViewController.self)") as! SecondViewController
        controller.postID = posts[indexPath.row].id ?? 0
        navigationController?.show(controller, sender: nil)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = posts[indexPath.row].title
        return cell
    }
}
