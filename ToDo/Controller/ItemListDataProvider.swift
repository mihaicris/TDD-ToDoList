//
//  ItemListDataProvider.swift
//  ToDo
//
//  Created by Mihai Cristescu on 28/03/2017.
//  Copyright © 2017 Mihai Cristescu. All rights reserved.
//

import UIKit

class ItemListDataProvider: NSObject,
                            UITableViewDataSource,
                            UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
