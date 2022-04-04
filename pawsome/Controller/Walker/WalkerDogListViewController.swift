//
//  WalkerDogListViewController.swift
//  Pawsome
//
//  Created by Roch on 3/31/22.
//

import UIKit

class WalkerDogListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let walkerServices = WalkerService()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .black
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    var dogs: [Dog] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.getDogs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Dogs' List"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.title = ""
    }
    
    private func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.refreshControl = refreshControl
    }
    
    private func reloadTableView() {
        self.tableView.reloadData()
    }
    
    private func getDogs() {
        walkerServices.getAllNoticeListing { success, message in
            self.refreshControl.endRefreshing()
            if success {
                
            } else {
                self.alert(message: message, title: nil, okAction: nil)
            }
        }
    }
    
    // MARK: pullToRefresh
    @objc private func pullToRefresh() {
        getDogs()
    }

}

extension WalkerDogListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DogListTableViewCell") as! DogListTableViewCell
        cell.dog = dogs[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DogProfileViewController") as! DogProfileViewController
        vc.dog = dogs[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension WalkerDogListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
