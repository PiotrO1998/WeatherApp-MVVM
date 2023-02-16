//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Piotr Obara on 13/02/2023.
//

import UIKit
import RxSwift
import RxCocoa

protocol SaveWeatherDelegate {
    func weatherDidSave(viewModel: SavedWeatherViewModel)
}

class WeatherViewController: UIViewController {
    
    private let searchResponse: SearchResponse
    private var weatherViewModel: WeatherViewModel!
    var deletegate: SaveWeatherDelegate?
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ForecastWeatherTableViewCell.self, forCellReuseIdentifier: ForecastWeatherTableViewCell.identifier)
        tableView.backgroundColor = UIColor(named: "BackgroundColor")
        tableView.register(ForecastWeatherTableHeader.self, forHeaderFooterViewReuseIdentifier: ForecastWeatherTableHeader.identifier)
        tableView.separatorStyle = .none
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
        NetworkingManager.shared.fetchWeather (cityName: data.name, stateCode: data.state, countryCode: data.country) { results in
            
            switch results {
            case .success(let currentWeather):
                self.weatherViewModel = WeatherViewModel(currentWeatherResponse: currentWeather)
                self.title = self.weatherViewModel.name
                NetworkingManager.shared.fetchForecastWeather (cityName: data.name, stateCode: data.state, countryCode: data.country) { results in
                    
                    switch results {
                    case .success(let forecastWeather):
                        self.weatherViewModel.forecastWeatherResponse = forecastWeather.list
                        self.tableView.reloadData()
                        self.setupSaveButton()
                    case .failure(let error):
                        print(error)
                        
                        let alert = UIAlertController(title: "Sorry", message: "There were an issue fetching weather for this place", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                            self.navigationController?.popToRootViewController(animated: true)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
            case .failure(let error):
                print(error)
                let alert = UIAlertController(title: "Sorry", message: "There were an issue fetching weather for this place", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    self.navigationController?.popToRootViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    private func setupSaveButton() {
        if !Constants.checkIfWeatherSaved(id: weatherViewModel.id) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonTapped))
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    @objc func saveButtonTapped() {
        if let weatherViewModel = self.weatherViewModel {
            let viewModel = SavedWeatherViewModel(weather: weatherViewModel.currentWeatherResponse, searchResponse: self.searchResponse)
            deletegate?.weatherDidSave(viewModel: viewModel)
            setupSaveButton()
        }
    }
}

// MARK: - Table View Data Source methods
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
        
        switch forecastWeather.main.temp {
        case ..<10:
            cell.temperatureLabel.textColor = .blue
        case 10...20:
            cell.temperatureLabel.textColor = .black
        case 20...:
            cell.temperatureLabel.textColor = .red
        default:
            cell.temperatureLabel.textColor = .orange
        }
        
        
        return cell
    }
}

// MARK: - Table View Delegate methods
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
