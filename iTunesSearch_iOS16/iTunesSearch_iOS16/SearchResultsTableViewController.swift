//
//  SearchResultsTableViewController.swift
//  iTunesSearch_iOS16
//
//  Created by Stephanie Ballard on 4/6/20.
//  Copyright © 2020 Stephanie Ballard. All rights reserved.
//

import UIKit

class SearchResultsTableViewController: UITableViewController, UISearchBarDelegate {

    let searchResultsController = SearchResultController()
    
    @IBOutlet weak var appsMusicMoviesSegmentedControl: UISegmentedControl!
    @IBOutlet weak var iTunesSearchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iTunesSearchBar.delegate = self
    }

    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
    
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text,
            searchTerm != "" else { return }
        
        var resultType: ResultType!
        
        switch appsMusicMoviesSegmentedControl.selectedSegmentIndex {
        case 0:
            resultType = .software
        case 1:
            resultType = .musicTrack
        case 2:
            resultType = .movie
        default:
            break
        }
        searchResultsController.performSearch(searchTerm: searchTerm, resultType: resultType) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchResultsController.searchResults.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultsCell", for: indexPath)

        let searchResult = searchResultsController.searchResults[indexPath.row]
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.creator

        return cell
    }
}
