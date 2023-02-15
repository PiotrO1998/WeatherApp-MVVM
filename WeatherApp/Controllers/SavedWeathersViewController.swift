//
//  SavedWeathersViewController.swift
//  WeatherApp
//
//  Created by Piotr Obara on 12/02/2023.
//

import UIKit

class SavedWeathersViewController: UIViewController {
    
    private let savedWeathersViewModel = SavedWeathersViewModel()
    
    let searchController: UISearchController = {
        let vc = UISearchController(searchResultsController: SearchResultsViewController())
        vc.searchBar.placeholder = "Search for city"
        vc.searchBar.searchBarStyle = .minimal
        vc.definesPresentationContext = true
        return vc
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SavedWeatherTableViewCell.self, forCellReuseIdentifier: SavedWeatherTableViewCell.identifier)
        tableView.backgroundColor = UIColor(named: "BackgroundColor")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Weather"
        view.backgroundColor = UIColor(named: "BackgroundColor")
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}

// MARK: - SearchBar Methods
extension SavedWeathersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchResultsVC = searchController.searchResultsController as? SearchResultsViewController,
              let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
                  return
              }
        
        searchResultsVC.delegate = self
        searchResultsVC.search(with: query)
    }
}

// MARK: - conforming to SearchResultsViewControllerDelegate
extension SavedWeathersViewController: SearchResultsViewControllerDelegate {
    func showResult(controller: WeatherViewController) {
        controller.deletegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
}


// MARK: - Table View Data Source methods
extension SavedWeathersViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.savedWeathersViewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let savedWeather = self.savedWeathersViewModel.modelAt(indexPath.row)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SavedWeatherTableViewCell.identifier, for: indexPath) as! SavedWeatherTableViewCell
        
        cell.configure(savedWeather)
        
        return cell
    }
}

// MARK: - Table View Delegate methods
extension SavedWeathersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tap")
        let viewModel = self.savedWeathersViewModel.modelAt(indexPath.row)
        
        let vc = WeatherViewController(searchResponse: viewModel.searchResponse)
        navigationController?.pushViewController(vc, animated: true)
        
    }
}

// MARK: - Conforming to AddWeatherDelegate protocol
extension SavedWeathersViewController: SaveWeatherDelegate {
    func weatherDidSave(viewModel: SavedWeatherViewModel) {
        self.savedWeathersViewModel.addSavedWeatherViewModel(viewModel)
        tableView.reloadData()
    }
}
