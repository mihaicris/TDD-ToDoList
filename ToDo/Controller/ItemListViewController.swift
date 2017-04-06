//
//  ItemListViewController.swift
//  ToDo
//
//  Created by Mihai Cristescu on 28/03/2017.
//  Copyright © 2017 Mihai Cristescu. All rights reserved.
//

import UIKit

class ItemListViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var dataProvider: (UITableViewDataSource & UITableViewDelegate & ItemManagerSettable)!
    
    let itemManager = ItemManager()
    
    override func viewDidLoad() {
        tableView.dataSource = dataProvider
        tableView.delegate = dataProvider
        dataProvider.itemManager = itemManager
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showDetails(sender:)),
                                               name: Notification.Name("ItemSelectedNotification"),
                                               object: nil)
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func showDetails(sender: Notification) {
    
        guard let index = sender.userInfo?["index"] as? Int else {
            fatalError()
        }
        
        if let nextViewController = storyboard?
            .instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            nextViewController.itemInfo = (itemManager, index)
            
            navigationController?.pushViewController(nextViewController, animated: true)
        }
    
    }
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        
        if let nextViewController = storyboard?
            .instantiateViewController(withIdentifier: "InputViewController") as? InputViewController {
            
            nextViewController.itemManager = self.itemManager
            
            present(nextViewController, animated: true, completion: nil)
        }
    }
}
