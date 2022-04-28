//
//  ExceptionListTableViewController.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 03.04.2022.
//

import UIKit
import SwiftUI
import RealmSwift

class ExceptionListTableViewController: UITableViewController {
    
    var exceptions = [Exception]()
    
    var showsOldExceptions = false
    
    private var notificationToken = NotificationToken()
    
    private var currentStorageFilter = StorageFilter.new

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(ExceptionTableViewCell.self, forCellReuseIdentifier: ExceptionTableViewCell.reuseID)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        queryExceptions(for: .new)
        observeExceptionsStorage()
    }
    
    private func queryExceptions(for parameter: StorageFilter) {
        var predicate = NSPredicate()
        switch parameter {
        case .predicate(let nsPredicate):
            predicate = nsPredicate
        case .new:
            predicate = NSPredicate(format: "to >= %@", argumentArray: [Date().startOfDay])
        case .outbound:
            predicate = NSPredicate(format: "to <= %@", argumentArray: [Date().startOfDay])
        }
        self.exceptions = Array(ExceptionsDataStorageManager.shared.filtred(by: predicate).sorted(byKeyPath: "from", ascending: false))
    }
    
    private func observeExceptionsStorage() {
        notificationToken = realm.objects(Exception.self).observe({ [unowned self] event in
            switch event {
            case .initial(_):
                tableView.reloadData()
            case .update(_, deletions: _, insertions: _, modifications: _):
                queryExceptions(for: .new)
                tableView.reloadData()
            case .error(_):
                break
            }
        })
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exceptions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExceptionTableViewCell.reuseID, for: indexPath) as! ExceptionTableViewCell

        var content = cell.defaultContentConfiguration()
        
        content.text = exceptions[indexPath.row].name + ", " + exceptions[indexPath.row].from.string()

        cell.contentConfiguration = content
        
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do {
                try ExceptionsDataStorageManager.shared.remove(exceptions[indexPath.row])
            } catch {

            }
        }
    }

    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hostingController = UIHostingController(rootView: ExceptionDetailsView(date: exceptions[indexPath.row].from).environment(\.colorPalette, ApplicationColorPalette.shared))
        DispatchQueue.main.async { [unowned self] in
            self.navigationController?.pushViewController(hostingController, animated: true)
        }
    }

    private enum StorageFilter {
        case predicate(NSPredicate)
        case new
        case outbound
    }
}
