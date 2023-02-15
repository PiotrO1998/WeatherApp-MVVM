//
//  SavedWeathersViewController.swift
//  WeatherApp
//
//  Created by Piotr Obara on 12/02/2023.
//

import UIKit
import RealmSwift

class SavedWeathersViewController: UIViewController {
    
    private let savedWeathersViewModel = SavedWeathersViewModel()
    let realm  = try! Realm()
    
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
        tableView.separatorColor = .black
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
        fetchSavedWeathers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    private func fetchSavedWeathers() {
        var savedWeathers: Results<WeatherToSave>?
        savedWeathers = realm.objects(WeatherToSave.self)
        
        if let savedWeathers = savedWeathers {
            print("SAVED WEATHER CPUNT: \(savedWeathers.count)")
            savedWeathers.forEach { savedWeather in
                print("SAVED WEATHER: \(savedWeather)")
                let state = savedWeather.state == "" ? nil : savedWeather.state
                NetworkingManager.shared.featchWeather(cityName: savedWeather.name, stateCode: state, countryCode: savedWeather.country) { result in
                    
                    switch result {
                    case .success(let weather):
                        print(weather)
                        let savedWeatherViewModel = SavedWeatherViewModel(weather: weather, searchResponse: SearchResponse(name: savedWeather.name, state: state, country: savedWeather.country))
                        self.savedWeathersViewModel.addSavedWeatherViewModel(savedWeatherViewModel)
                        self.tableView.reloadData()
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
}

// MARK: - SearchBar Methods
extension SavedWeathersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchResultsVC = searchController.searchResultsController as? SearchResultsViewController
        else {
            return
        }
        
        searchController.searchResultsController?.view.isHidden = false
        let query = searchController.searchBar.text
        
        if let query = query {
            searchResultsVC.delegate = self
            searchResultsVC.search(with: query)
        }
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
        let viewModel = self.savedWeathersViewModel.modelAt(indexPath.row)
        
        let vc = WeatherViewController(searchResponse: viewModel.searchResponse)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (contextualAction, view, boolValue) in
            
            
        }
        
        if #available(iOS 13.0, *) {
            deleteAction.image = UIImage(systemName: "trash")
        }
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return swipeActions
    }
}

// MARK: - Conforming to AddWeatherDelegate protocol
extension SavedWeathersViewController: SaveWeatherDelegate {
    func weatherDidSave(viewModel: SavedWeatherViewModel) {
        self.savedWeathersViewModel.addSavedWeatherViewModel(viewModel)
        tableView.reloadData()
    }
}
