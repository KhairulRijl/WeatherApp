//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by Khairul Rijal on 12/01/20.
//  Copyright © 2020 Khairul Rijal. All rights reserved.
//

import UIKit
import MapKit

class SearchViewController: UITableViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    var mapItems: [MKMapItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Alamat"
        self.tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mapItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.mapItems[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "backToForm", sender: nil)
    }
    
}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        searchLocation(with: searchController.searchBar.text!)
    }
    
    func searchLocation(with keyword: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = keyword
        let search = MKLocalSearch(request: request)
        
        search.start { (response, error) in
            if let _error = error {
                print(_error)
                return
            }
            
            if let _response = response {
                self.mapItems = _response.mapItems.filter { (item) -> Bool in
                    
                    guard item.placemark.postalCode != nil else {
                        return false
                    }
                    
                    if let countryCode = item.placemark.countryCode {
                        return countryCode.caseInsensitiveCompare("id") == .orderedSame
                    }
                    
                    return false
                }
                
                self.tableView.reloadData()
            }
        }
    }
    
}
