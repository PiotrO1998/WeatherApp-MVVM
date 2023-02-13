//
//  SearchResultsViewModel.swift
//  WeatherApp
//
//  Created by Piotr Obara on 12/02/2023.
//

import Foundation
import RxSwift
import RxCocoa

class SearchResultsViewModel {
    var searchResults = PublishSubject<[SearchResponse]>()
    
    // Perform search
    func search(with query: String) {
        NetworkingManager.shared.searchForCities(with: query) { results in
            self.searchResults.onNext(results)
        }
    }
}
