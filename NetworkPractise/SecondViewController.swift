//
//  SecondViewController.swift
//  NetworkPractise
//
//  Created by Ayan on 26.11.23.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var table: UITableView!
    
    var comments = [CommentResponseModel]()
    var postID = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        getComments()
    }
    
    func configureUI() {
        table.delegate = self
        table.dataSource = self
    }
    
    func getComments() {
        guard let url = URL( string: "https://jsonplaceholder.typicode.com/comments?postId=\(postID)") else {return}
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                do {
                    self.comments = try JSONDecoder().decode(Comments.self, from: data!)
                    print(self.comments)
                    DispatchQueue.main.async {
                        self.table.reloadData()
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
}

extension SecondViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = comments[indexPath.row].body
        return cell
    }
}

extension SecondViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
