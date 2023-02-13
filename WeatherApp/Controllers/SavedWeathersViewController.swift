//
//  SavedWeathersViewController.swift
//  WeatherApp
//
//  Created by Piotr Obara on 12/02/2023.
//

import UIKit

class SavedWeathersViewController: UIViewController, UISearchResultsUpdating {
    
    let searchController: UISearchController = {
        let vc = UISearchController(searchResultsController: SearchResultsViewController())
        vc.searchBar.placeholder = "Search for city"
        vc.searchBar.searchBarStyle = .minimal
        vc.definesPresentationContext = true
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Weathers"
        view.backgroundColor = UIColor(named: "BackgroundColor")
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }   
}

// MARK: - SearchBar Methods

extension SavedWeathersViewController {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchResultsVC = searchController.searchResultsController as? SearchResultsViewController,
              let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
                  return
              }
        print(query)
        
        searchResultsVC.search(with: query)
    }
}
