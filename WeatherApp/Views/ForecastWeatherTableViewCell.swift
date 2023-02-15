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
        self.backgroundColor = .clear
        self.selectionStyle = .none
        self.isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let containerView = UIView(frame: CGRect(x: 10, y: 0, width: contentView.frame.width-20, height: contentView.frame.height-20))
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        containerView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        
        contentView.addSubview(timeLabel)
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(weatherIconImageView)
        
        timeLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        timeLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 40).isActive = true
        
        temperatureLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        temperatureLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -40).isActive = true
        
        weatherIconImageView.heightAnchor.constraint(equalToConstant: containerView.frame.size.height/1.5).isActive = true
        weatherIconImageView.widthAnchor.constraint(equalToConstant: containerView.frame.size.height/1.5).isActive = true
        weatherIconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        weatherIconImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
        containerView.backgroundColor = UIColor(named: "BackgroundColor")
        containerView.layer.cornerRadius = 8
        containerView.layer.masksToBounds = false
        containerView.layer.shadowOffset = CGSizeMake(0, 3)
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.23
        containerView.layer.shadowRadius = 4
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        weatherIconImageView.image = nil
        timeLabel.text = nil
        temperatureLabel.text = nil
    }
}
