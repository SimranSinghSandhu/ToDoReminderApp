//
//  ViewController.swift
//  ToDoReminderApp
//
//  Created by Simran Singh Sandhu on 14/12/19.
//  Copyright © 2019 Simran Singh Sandhu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let tableView: UITableView = {
        let tblView = UITableView()
        tblView.backgroundColor = UIColor.white
        tblView.translatesAutoresizingMaskIntoConstraints = false
        return tblView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        settingTableView()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func settingTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }

}
