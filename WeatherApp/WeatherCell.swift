//
//  WeatherCell.swift
//  WeatherApp
//
//  Created by Huy on 12/1/25.
//
import UIKit
class WeatherCell: UICollectionViewCell {
    private let containerView = UIView()
     let timeLabel = UILabel()
    private let iconImageView = UIImageView()
    private let temperatureLabel = UILabel()
    static let identifier = "WeatherCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        timeLabel.font = UIFont.systemFont(ofSize: 15,weight: .bold)
        timeLabel.textColor = .white
        
        
        temperatureLabel.text = "19°"
        temperatureLabel.font = UIFont.systemFont(ofSize: 20,weight: .medium)
        temperatureLabel.textColor = .white
        // Add constraints using SnapKit
        
        containerView.backgroundColor = UIColor(hex: "#4c3584").withAlphaComponent(0.7)
        containerView.layer.cornerRadius = 30
        containerView.clipsToBounds = true
        containerView.layer.borderWidth = 0.5
        containerView.layer.borderColor =  UIColor.gray.withAlphaComponent(0.4).cgColor
        
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.5
        contentView.layer.shadowOffset = CGSize(width: 7, height: 7) // Shadow position
        contentView.layer.shadowRadius = 4
        
        
    }
    private func setupConstraints() {
        contentView.addSubview(containerView)
        containerView.addSubview(iconImageView)
        containerView.addSubview(temperatureLabel)
        containerView.addSubview(timeLabel)
        
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.equalTo(60)
            $0.height.equalTo(150)
        }
        timeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(15)
        }
        iconImageView.snp.makeConstraints {
            $0.top.equalTo(timeLabel.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(35)
        }
        temperatureLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()

        }
        
    }

    func changeColor () {
        containerView.backgroundColor = UIColor(hex: "#483194")
    }
    func removeColor () {
        containerView.backgroundColor =  UIColor(hex: "#4c3584").withAlphaComponent(0.7)
    }
   
    func configure(time:String, code:Int, temp:String){
        temperatureLabel.text = "\(temp)°"
        
        if (code == 1000) {
            if (time.suffix(2) == "PM") {
                iconImageView.image = UIImage.moomFastWindIcon

            } else {
                iconImageView.image = UIImage.sun

            }
        }
       
       
        if (1003...1030).contains(code) {
            iconImageView.image = UIImage.cloud
        }
        
        if (1063...1189).contains(code) {
            if(time.suffix(2) == "AM"){
                iconImageView.image = UIImage.sunAngledRain

            }else {
                iconImageView.image = UIImage.moomMidRain

            }
        }
        if (1192...1246).contains(code) {
            if(time.suffix(2) == "AM"){
                iconImageView.image = UIImage.sunMidRain

            }else {
                iconImageView.image = UIImage.moomMidRain
            }
        }
        if (1273...1276).contains(code) {
            iconImageView.image = UIImage.rain
        }
        
    }
}
