//
//  SearchResultsViewModel.swift
//  WeatherApp
//
//  Created by Piotr Obara on 12/02/2023.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

class SearchResultsViewModel {
    var searchResults = PublishSubject<[SearchResponse]>()
    let realm  = try! Realm()
    
    init() {
        fetchSavedResults()
    }
    
    // Perform search
    func search(with query: String) {
        NetworkingManager.shared.searchForCities(with: query) { results in
            self.searchResults.onNext(results)
        }
    }
    
    func saveSearchResponse(search: SearchResponse) {
        let searchToSave = SearchResponseToSave()
        searchToSave.name = search.name
        searchToSave.state = search.state ?? ""
        searchToSave.country = search.country
        
        var searchArray: Results<SearchResponseToSave>?
        searchArray = realm.objects(SearchResponseToSave.self)
        
        if let searchArray = searchArray {
            let result = searchArray.contains {
                $0.name == searchToSave.name &&
                $0.state == searchToSave.state &&
                $0.country == searchToSave.country
            }
            if result {
                return
            }
        }
        
        do {
            try realm.write({
                realm.add(searchToSave)
            })
        } catch {
            print("Error saving search, \(error)")
        }
        
        checkIfNeedToDeleteItemFromRealm()
    }
    
    func checkIfNeedToDeleteItemFromRealm() {
        var searchArray: Results<SearchResponseToSave>?
        searchArray = realm.objects(SearchResponseToSave.self)
        
        if let searchArray = searchArray {
            if searchArray.count > 5 {
                let sortedArray = searchArray.sorted(byKeyPath: "dateCreated", ascending: false)
                if let itemToDelete = sortedArray.last {
                    do {
                        try realm.write({
                            realm.delete(itemToDelete)
                        })
                    } catch {
                        print("Error saving search, \(error)")
                    }
                }
            }
        }
    }
    
    func fetchSavedResults() {
        var searchArray: Results<SearchResponseToSave>?
        searchArray = realm.objects(SearchResponseToSave.self).sorted(byKeyPath: "dateCreated", ascending: false)
        
        if let searchArray = searchArray {
            var savedSearchResponse = [SearchResponse]()
            searchArray.forEach { savedSearch in
                let state = savedSearch.state == "" ? nil : savedSearch.state
                savedSearchResponse.append(SearchResponse(name: savedSearch.name, state: state, country: savedSearch.country))
            }
            self.searchResults.onNext(savedSearchResponse)
        }
    }
}
