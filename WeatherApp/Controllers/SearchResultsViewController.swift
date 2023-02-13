//
//  SearchResultsViewController.swift
//  WeatherApp
//
//  Created by Piotr Obara on 12/02/2023.
//

import UIKit
import RxSwift
import RxCocoa

class SearchResultsViewController: UIViewController {
    
    private var searchResultsViewModel = SearchResultsViewModel()
    private var disposeBag = DisposeBag()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = UIColor(named: "BackgroundColor")
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        view.addSubview(tableView)
        tableView.frame = view.bounds
        bindTableData()
    }
    
    func search(with query: String) {
        searchResultsViewModel.search(with: query)
    }
    
}

// MARK: - Binding
extension SearchResultsViewController {
    func bindTableData() {
        searchResultsViewModel.searchResults.bind(
            to: tableView.rx.items(
                cellIdentifier: "cell",
                cellType: UITableViewCell.self)
        ) { row, model, cell in
            cell.backgroundColor = UIColor(named: "BackgroundColor")
            let state = model.state != nil ? ", \(model.state!)" : ""
            cell.textLabel?.text = model.name + state + ", " + model.country
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(SearchResponse.self).bind { response in
            print(response.name)
        }.disposed(by: disposeBag)
    }
}
