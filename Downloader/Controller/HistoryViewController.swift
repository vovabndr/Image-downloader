//
//  HistoryViewController.swift
//  Downloader
//
//  Created by Владимир Бондарь on 6/16/18.
//  Copyright © 2018 vbbv. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet weak var historyTableView: UITableView!
    var storedData = [Image]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        historyTableView.delegate = self
        historyTableView.dataSource = self
        navigationController?.navigationBar.items![0].title = "Back"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateData()
    }
    
    fileprivate func updateData() {
        CoreDataHelper.fetch { self.storedData = $1 }
        historyTableView.reloadData()
    }
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storedData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath)
        cell.textLabel?.text = storedData[indexPath.row].link
        cell.imageView?.image = UIImage(data: storedData[indexPath.row].image)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let copyAction = UITableViewRowAction(style: .normal, title: "Copy") { _, _ in
            UIPasteboard.general.string = self.storedData[indexPath.row].link
        }
        copyAction.backgroundColor = .blue
        
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { _, _ in
                        CoreDataHelper.delete(by: indexPath.row)
                        self.updateData()
        }
        deleteAction.backgroundColor = .red
        return [deleteAction, copyAction]
    }
    
}
