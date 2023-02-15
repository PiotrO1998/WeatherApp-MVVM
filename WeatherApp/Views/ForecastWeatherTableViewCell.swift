//
//  ForecastWeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Piotr Obara on 14/02/2023.
//

import UIKit

class ForecastWeatherTableViewCell: UITableViewCell {
    static let identifier = "ForecastWeatherTableViewCell"
    
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
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    
    let weatherIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(timeLabel)
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(weatherIconImageView)
        
        self.backgroundColor = .clear
        self.selectionStyle = .none
        self.isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
         
        let stackView = UIStackView(arrangedSubviews: [timeLabel, weatherIconImageView, temperatureLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        contentView.addSubview(stackView)
        
        stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        
        stackView.backgroundColor = UIColor(named: "BackgroundColor")
        stackView.layer.cornerRadius = 8
        stackView.layer.masksToBounds = false
        stackView.layer.shadowOffset = CGSizeMake(0, 3)
        stackView.layer.shadowColor = UIColor.black.cgColor
        stackView.layer.shadowOpacity = 0.23
        stackView.layer.shadowRadius = 4
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        weatherIconImageView.image = nil
        timeLabel.text = nil
        temperatureLabel.text = nil
    }
}
