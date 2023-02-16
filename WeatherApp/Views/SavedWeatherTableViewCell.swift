//
//  SavedWeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Piotr Obara on 15/02/2023.
//

import Foundation

import UIKit

class SavedWeatherTableViewCell: UITableViewCell {
    static let identifier = "SavedWeatherTableViewCell"
    
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
    
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 1
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
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    let weatherIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var mainStackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(weatherIconImageView)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let leftStackView = UIStackView(arrangedSubviews: [cityLabel, conditionLabel])
        leftStackView.translatesAutoresizingMaskIntoConstraints = false
        leftStackView.axis = .vertical
        leftStackView.distribution = .fillEqually
        
        let rightStackView = UIStackView(arrangedSubviews: [temperatureLabel, weatherIconImageView])
        rightStackView.translatesAutoresizingMaskIntoConstraints = false
        rightStackView.axis = .vertical
        rightStackView.distribution = .fillEqually
        
        mainStackView = UIStackView(arrangedSubviews: [leftStackView, rightStackView])
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .vertical
        mainStackView.distribution = .fillEqually

        contentView.addSubview(leftStackView)
        contentView.addSubview(rightStackView)
        contentView.addSubview(mainStackView)
        
        mainStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        mainStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20).isActive = true
        mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
        
        leftStackView.topAnchor.constraint(equalTo: mainStackView.topAnchor, constant: 0).isActive = true
        leftStackView.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 0).isActive = true
        leftStackView.leftAnchor.constraint(equalTo: mainStackView.leftAnchor, constant: 15).isActive = true
        
        rightStackView.topAnchor.constraint(equalTo: mainStackView.topAnchor, constant: 0).isActive = true
        rightStackView.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 0).isActive = true
        rightStackView.rightAnchor.constraint(equalTo: mainStackView.rightAnchor, constant: 0).isActive = true
        
                
        mainStackView.layer.zPosition = 0
        leftStackView.layer.zPosition = 1
        rightStackView.layer.zPosition = 1
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        weatherIconImageView.image = nil
        cityLabel.text = nil
        conditionLabel.text = nil
        temperatureLabel.text = nil
    }
    
    func configure(_ viewModel: SavedWeatherViewModel) {
        self.cityLabel.text = viewModel.name
        self.temperatureLabel.text = viewModel.temperature
        self.conditionLabel.text = viewModel.condition
        self.iconString = viewModel.iconString
    }
}
