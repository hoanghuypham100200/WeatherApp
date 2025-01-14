//
//  WeatherTableCell.swift
//  WeatherApp
//
//  Created by Huy on 13/1/25.
//
import UIKit

class WeatherTableCell: UITableViewCell {

    let containerView = UIView()
    let backgroundImageView = UIImageView()
    let iconWeatherImageView = UIImageView()
    let tempLabel = UILabel()
    let statusLabel = UILabel()
    let cityLabel = UILabel()
    let maxTempLabel = UILabel()
    let minTempLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()

    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupConstraints()
    }
    
  
    
    // Setup UI elements and constraints
    private func setupUI() {
        containerView.backgroundColor = UIColor(hex:"#372C66")
        contentView.backgroundColor = UIColor(hex:"#372C66")
        backgroundImageView.image = UIImage.backgroundSearch
        iconWeatherImageView.image = UIImage.moomMidRain
        
        tempLabel.text = "19"
        tempLabel.textColor = .white
        tempLabel.font = UIFont.systemFont(ofSize: 70, weight: .regular)
        
        maxTempLabel.text = "H:25"
        maxTempLabel.textColor = .white.withAlphaComponent(0.4)
        maxTempLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        
        minTempLabel.text = "L:15"
        minTempLabel.textColor = .white.withAlphaComponent(0.4)
        minTempLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        
        cityLabel.text = "Ha Noi, Viet Nam"
        cityLabel.textColor = .white.withAlphaComponent(0.8)
        cityLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        statusLabel.text = "Fast wind"
        statusLabel.textColor = .white.withAlphaComponent(0.6)
        statusLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
    }
    private func setupConstraints() {
        contentView.addSubview(containerView)
        containerView.addSubview(backgroundImageView)
        containerView.addSubview(iconWeatherImageView)

        backgroundImageView.addSubview(tempLabel)
        backgroundImageView.addSubview(maxTempLabel)
        backgroundImageView.addSubview(minTempLabel)
        backgroundImageView.addSubview(cityLabel)
        backgroundImageView.addSubview(statusLabel)

        containerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().inset(16)
            $0.leading.trailing.equalToSuperview().inset(10)

            $0.height.equalTo(190)
        }
        iconWeatherImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(10)
            $0.top.equalToSuperview().offset(10)
            $0.height.equalToSuperview().multipliedBy(0.75)
            $0.width.equalToSuperview().multipliedBy(0.4)

        }
        backgroundImageView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.9)
        }
        tempLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.leading.equalToSuperview().offset(20)
        }
        maxTempLabel.snp.makeConstraints {
            $0.top.equalTo(tempLabel.snp.bottom)
            $0.leading.equalToSuperview().offset(20)

        }
        minTempLabel.snp.makeConstraints {
            $0.top.equalTo(tempLabel.snp.bottom)
            $0.left.equalTo(maxTempLabel.snp.right).offset(5)

        }
        cityLabel.snp.makeConstraints {
            $0.top.equalTo(minTempLabel.snp.bottom)
            $0.leading.equalToSuperview().offset(20)
            $0.width.equalToSuperview().multipliedBy(0.5)

        }
        statusLabel.snp.makeConstraints {
            $0.top.equalTo(minTempLabel.snp.bottom)
            $0.trailing.equalToSuperview().inset(20)
        }

    }
    func getCurrentTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a" // 12-hour format with AM/PM
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Ensure consistent formatting
        let currentTime = dateFormatter.string(from: Date())
        return currentTime
    }
    
    func configure(temp:Double, code:Int, country: String, status:String, maxTemp:String, minTemp: String ){
        tempLabel.text = "\(temp)°"
        cityLabel.text = country
        maxTempLabel.text = maxTemp
        minTempLabel.text = minTemp
        statusLabel.text = status
        let currentTime = getCurrentTime()
       
        
        if (code == 1000) {
            if (currentTime.suffix(2) == "PM") {
                iconWeatherImageView.image = UIImage.moomFastWindIcon

            } else {
                iconWeatherImageView.image = UIImage.sun

            }
        }
       
       
        if (1003...1030).contains(code) {
            iconWeatherImageView.image = UIImage.cloud
        }
        
        if (1063...1189).contains(code) {
            if(currentTime.suffix(2) == "AM"){
                iconWeatherImageView.image = UIImage.sunAngledRain

            }else {
                iconWeatherImageView.image = UIImage.moomMidRain

            }
        }
        if (1192...1246).contains(code) {
            if(currentTime.suffix(2) == "AM"){
                iconWeatherImageView.image = UIImage.sunMidRain

            }else {
                iconWeatherImageView.image = UIImage.moomMidRain
            }
        }
        if (1273...1276).contains(code) {
            iconWeatherImageView.image = UIImage.rain
        }
        
    }
}

