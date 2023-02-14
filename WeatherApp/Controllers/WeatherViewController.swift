//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Piotr Obara on 13/02/2023.
//

import UIKit
import RxSwift
import RxCocoa

class WeatherViewController: UIViewController {
    
    private let searchResponse: SearchResponse
    private var weatherViewModel: WeatherViewModel!
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ForecastWeatherTableViewCell.self, forCellReuseIdentifier: ForecastWeatherTableViewCell.identifier)
        tableView.backgroundColor = UIColor(named: "BackgroundColor")
        tableView.separatorStyle = .none
        tableView.register(ForecastWeatherTableHeader.self, forHeaderFooterViewReuseIdentifier: ForecastWeatherTableHeader.identifier)
        return tableView
    }()
    
    init(searchResponse: SearchResponse) {
        self.searchResponse = searchResponse
        super.init(nibName: nil, bundle: nil)
        
        self.fetchWeather(with: self.searchResponse)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BackgroundColor")
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // Fetch Weather
    private func fetchWeather(with data: SearchResponse) {
        NetworkingManager.shared.featchWeather (cityName: data.name, stateCode: data.state, countryCode: data.country) { results in
            
            switch results {
            case .success(let currentWeather):
                self.weatherViewModel = WeatherViewModel(currentWeatherResponse: currentWeather)
                self.title = self.weatherViewModel.city
                NetworkingManager.shared.fetchForecastWeather (cityName: data.name, stateCode: data.state, countryCode: data.country) { results in
                    
                    switch results {
                    case .success(let forecastWeather):
                        self.weatherViewModel.forecastWeatherResponse = forecastWeather.list
                        self.tableView.reloadData()
                    case .failure(let error):
                        print(error)
                    }
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension WeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weatherViewModel == nil ? 0 :
        self.weatherViewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let forecastWeather = weatherViewModel.forecastWeatherAt(indexPath.row)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ForecastWeatherTableViewCell.identifier, for: indexPath) as! ForecastWeatherTableViewCell
        
        cell.timeLabel.text = Constants.stringToTime(dateString: forecastWeather.dt_txt)
        cell.temperatureLabel.text = String(format: "%.1f", forecastWeather.main.temp)
        cell.iconString = forecastWeather.weather[0].icon
        
        return cell
    }
}

extension WeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let _ = self.weatherViewModel else {
            return nil
        }
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ForecastWeatherTableHeader.identifier) as? ForecastWeatherTableHeader
        header?.configure(self.weatherViewModel)
        return header
    }
}
