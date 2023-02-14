//
//  ForecastWeatherTable.swift
//  WeatherApp
//
//  Created by Piotr Obara on 14/02/2023.
//

import UIKit

class ForecastWeatherTableHeader: UITableViewHeaderFooterView {
    static let identifier = "TableHeader"
    
    var iconString: String? {
        didSet {
            if let iconString = iconString {
                NetworkingManager.shared.getIconImage(iconCode: iconString, completion: { data in
                    if let data = data {
                        self.weatherIconImageView.image = UIImage(data: data)
                    }
                })
            }
        }
    }
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 50, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    private let conditionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private let sectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Next"
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    private let weatherIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(weatherIconImageView)
        contentView.addSubview(conditionLabel)
        contentView.addSubview(sectionLabel)
        contentView.backgroundColor = UIColor(named: "BackgroundColor")
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        conditionLabel.sizeToFit()
        temperatureLabel.sizeToFit()
        sectionLabel.sizeToFit()
        
        temperatureLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
         temperatureLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        
        conditionLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 0).isActive = true
        conditionLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        
        weatherIconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        weatherIconImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20).isActive = true
        weatherIconImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        weatherIconImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        sectionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        sectionLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
         
       
        /*
        cityLabel.frame = CGRect(x: 20,
                                 y: contentView.frame.size.height-10-cityLabel.frame.size.height, width: contentView.frame.size.width,
                                 height: cityLabel.frame.size.height)
        temperatureLabel.frame = CGRect(x: 20,
                                 y: contentView.frame.size.height-5-temperatureLabel.frame.size.height, width: contentView.frame.size.width,
                                 height: temperatureLabel.frame.size.height)
        weatherIconImageView.frame = CGRect(x: contentView.frame.size.width-20,
                                            y: contentView.frame.size.height-20-weatherIconImageView.frame.size.height, width: contentView.frame.size.width,
                                            height: weatherIconImageView.frame.size.height-15)
        
         */
    }
    
    func configure(_ viewModel: WeatherViewModel) {
        self.temperatureLabel.text = viewModel.currentTemperature
        self.conditionLabel.text = viewModel.currentCondition
        self.iconString = viewModel.currentWeatherIconString
    }
}
