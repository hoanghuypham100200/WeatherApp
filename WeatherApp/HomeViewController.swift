//
//  ViewController.swift
//  WeatherApp
//
//  Created by Huy on 11/1/25.
//

import UIKit
import SnapKit
import RxSwift
class HomeViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private var isWeeklyData: Bool = false
    private let containerView = UIView()
    private let backgroundImageView = UIImageView()
    private let infoView = UIView()
    private let homeImageView = UIImageView()
    private let HLView = UIView()
    private let botView = UIView()
    let visualEffectView = UIVisualEffectView.init(effect: UIBlurEffect.init(style: .systemUltraThinMaterialDark))

    private let cityLabel = UILabel()
    private let statusWeatherLabel = UILabel()
    private let fLabel = UILabel()
    private let uvLabel = UILabel()
    private let temperatureLabel = UILabel()
    
    private let topBarView = UIView()
    private let hourlyForecast = UILabel()
    private let weeklyForecast = UILabel()
    private let lineView = UIView()
    
    private let navigateBarView = UIView()
    private let logoImage = UIImageView()
    private let searchView = UIView()
    private let searchImageView = UIImageView()
    private let emptyView = UIView()
    private let lineNavigateView = UIView()
    
    var weatherCollectionView: UICollectionView!
    let layout = UICollectionViewFlowLayout()
    
    let weatherViewModel = WeatherViewModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupRx()
    }
    private func setupUI() {
        backgroundImageView.image = UIImage.backgroundHome
        backgroundImageView.isUserInteractionEnabled = true

        homeImageView.image = UIImage.home
        
        cityLabel.text = "HCM City"
        cityLabel.textColor = .white
        cityLabel.font = UIFont.systemFont(ofSize: 30,weight: .medium)
        
        temperatureLabel.textColor = .white
        temperatureLabel.font = UIFont.systemFont(ofSize: 93, weight: .thin)
        
        statusWeatherLabel.textColor = .white.withAlphaComponent(0.6)
        statusWeatherLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        
        fLabel.textColor = .white
        fLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        
        uvLabel.textColor = .white
        uvLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        
        botView.backgroundColor = .clear
        botView.layer.cornerRadius = 40
        botView.clipsToBounds = true
       
        visualEffectView.backgroundColor = UIColor(red: 0.5, green: 0, blue: 0.9, alpha: 0.25)
        visualEffectView.frame = self.view.bounds
        visualEffectView.alpha = 0.98
        
        
        hourlyForecast.text = "Hourly Forecast"
        hourlyForecast.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        hourlyForecast.textColor = isWeeklyData ? UIColor.white.withAlphaComponent(0.4) : UIColor.white.withAlphaComponent(0.8)
        hourlyForecast.isUserInteractionEnabled = true
        
        weeklyForecast.text = "Weekly Forecast"
        weeklyForecast.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        weeklyForecast.textColor = isWeeklyData ? UIColor.white.withAlphaComponent(0.8) : UIColor.white.withAlphaComponent(0.4)
        weeklyForecast.isUserInteractionEnabled = true

        lineView.backgroundColor = .gray.withAlphaComponent(0.3)
        
        searchImageView.image = UIImage(systemName: "list.bullet",withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .bold))
        searchImageView.tintColor = .white.withAlphaComponent(0.8)
        logoImage.image = UIImage.logo
        logoImage.tintColor = .purple
        
        lineNavigateView.backgroundColor = .gray.withAlphaComponent(0.3)
        
        layout.itemSize = CGSize(width: 65, height: 155)
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0) // Add 16pt padding to the left

        weatherCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        weatherCollectionView.backgroundColor = .clear
        weatherCollectionView.dataSource = self
        weatherCollectionView.delegate = self
        weatherCollectionView.register(WeatherCell.self, forCellWithReuseIdentifier: WeatherCell.identifier)
        weatherCollectionView.isScrollEnabled = true
        
        
    }
    private func setupConstraints() {
        view.addSubview(containerView)
        containerView.addSubview(backgroundImageView)
        backgroundImageView.addSubview(infoView)
        backgroundImageView.addSubview(homeImageView)
        backgroundImageView.addSubview(botView)
        infoView.addSubview(cityLabel)
        infoView.addSubview(temperatureLabel)
        infoView.addSubview(statusWeatherLabel)
        infoView.addSubview(HLView)
        HLView.addSubview(fLabel)
        HLView.addSubview(uvLabel)
        botView.addSubview(visualEffectView)
        botView.addSubview(topBarView)
        botView.addSubview(navigateBarView)
        botView.addSubview(weatherCollectionView)
        navigateBarView.addSubview(searchView)
        navigateBarView.addSubview(logoImage)
        navigateBarView.addSubview(emptyView)
        navigateBarView.addSubview(lineNavigateView)
        searchView.addSubview(searchImageView)
        topBarView.addSubview(lineView)
        topBarView.addSubview(hourlyForecast)
        topBarView.addSubview(weeklyForecast)
        weatherCollectionView.snp.makeConstraints {
            $0.top.equalTo(topBarView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(5)
            $0.bottom.equalTo(navigateBarView.snp.top)
        }
        lineNavigateView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.top.leading.trailing.equalToSuperview()
        }
        navigateBarView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(70)
        }
        searchView.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.33)
            $0.top.trailing.bottom.equalToSuperview()
        }
        searchImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(14)
        }
        logoImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(50)
            $0.top.equalToSuperview().offset(3)
        }
        hourlyForecast.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-5)
            $0.leading.equalToSuperview().offset(30)
        }
        weeklyForecast.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-5)
            $0.trailing.equalToSuperview().offset(-30)
        }
        topBarView.snp.makeConstraints {
            $0.top.trailing.leading.equalToSuperview()
            $0.height.equalTo(50)
        }
        lineView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        infoView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.33)
        }
        cityLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(110)
        }
        temperatureLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(cityLabel.snp.bottom).offset(-5)
        }
        statusWeatherLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(temperatureLabel.snp.bottom).offset(-5)
        }
        HLView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(statusWeatherLabel.snp.bottom)
            $0.width.equalTo(130)
            $0.height.equalTo(20)
        }
        fLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview()
        }
        uvLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.top.equalToSuperview()
        }
        homeImageView.snp.makeConstraints {
            $0.top.equalTo(infoView.snp.bottom).offset(20)
            $0.height.equalTo(450)
            $0.leading.trailing.equalToSuperview()
        }
        
        botView.snp.makeConstraints {
            $0.trailing.left.bottom.equalToSuperview()
            $0.height.equalTo(310)
        }
        emptyView.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview()
            $0.right.equalTo(logoImage.snp.left)
        }
        
    }
    private func setupRx() {
        fetchWeather()
        bindViewModel()
        tapGesture()
        weatherViewModel.reloadCollectionView = { [weak self] in
            self?.weatherCollectionView.reloadData()
            self?.scrollNow()

        }
    }

    
    private func scrollNow() {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        var currentHour = Int(dateFormatter.string(from: date))
        
        if (currentHour! % 2 != 0){
            currentHour = (currentHour! + 1)/2
        } else {
            currentHour = currentHour!/2
        }
        
        weatherCollectionView.scrollToItem(at: IndexPath(item: Int(currentHour!), section: 0), at: .centeredHorizontally, animated: false)
    }

    

    
    private func tapGesture() {
        let hourtapGesture = UITapGestureRecognizer(target: self, action: #selector(handleHourTap))
        hourlyForecast.addGestureRecognizer(hourtapGesture)
        
        let weektapGesture = UITapGestureRecognizer(target: self, action: #selector(handleWeekTap))
        weeklyForecast.addGestureRecognizer(weektapGesture)
        
        let tapSearchViewGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapSearchView))
        searchView.addGestureRecognizer(tapSearchViewGesture)
        
    }
    
    @objc func handleTapSearchView() {
        let searchVC = SearchViewController()
        searchVC.weatherDelegate = self
        isWeeklyData = false
        navigationController?.pushViewController(searchVC, animated: true)
        changeColorLabelByBool()
    }
    
    @objc func handleHourTap() {
        isWeeklyData = false
        weatherCollectionView.reloadData()
        changeColorLabelByBool()
        scrollNow()

    }
    
    @objc func handleWeekTap() {
        isWeeklyData = true
        weatherCollectionView.reloadData()
        changeColorLabelByBool()
    }
    private func changeColorLabelByBool() {
        if (isWeeklyData){
            hourlyForecast.textColor = UIColor.white.withAlphaComponent(0.4)
            weeklyForecast.textColor = UIColor.white.withAlphaComponent(0.8)
        }
        else {
            hourlyForecast.textColor = UIColor.white.withAlphaComponent(0.8)
            weeklyForecast.textColor = UIColor.white.withAlphaComponent(0.4)
        }
    }
    
    func fetchWeather() {
        weatherViewModel.fetchWeather(for: "Ho chi minh")
        
    }
    // MARK: - Bind ViewModel to View
    func bindViewModel() {
        // Bind weather data to UI elements
        weatherViewModel.weatherResponse
            .compactMap { $0 }  // Ensure data exists
            .subscribe(onNext: { [weak self] weather in
                self?.cityLabel.text = weather.location.name
                self?.temperatureLabel.text = "\(weather.current.tempC)°"
                self?.statusWeatherLabel.text = "Mostly \(weather.current.condition.text)"
                self?.uvLabel.text = "UV: \(weather.current.uv)"
                self?.fLabel.text = "F: \(weather.current.tempF)"
            })
            .disposed(by: disposeBag)

        // Bind error message to alert
        weatherViewModel.errorMessage
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] error in
                self?.showError(message: error)
            })
            .disposed(by: disposeBag)
    }

    
    func showError(message: String) {
           let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default))
           present(alert, animated: true)
    }
    
    func formatTime(_ timeString: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "HH:mm"  // Input format: 24-hour clock
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "h a"   // Output format: 12-hour clock with AM/PM
        if let date = inputFormatter.date(from: timeString) {
            return outputFormatter.string(from: date)
        } else {
            return nil  // Return nil if the input format is invalid
        }
    }
    
    func extractTime(from dateTimeString: String) -> String? {
        let components = dateTimeString.split(separator: " ")
        return components.count == 2 ? String(components[1]) : nil
    }
    
    func scrollToIndex(in collectionView: UICollectionView, at index: Int) {
        let indexPath = IndexPath(item: index, section: 0) // Assuming section 0
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }
    func getCurrentHour() -> String {
        let date = Date() // Get current date and time
        let dateFormatter = DateFormatter()
        // Set format to display hour and AM/PM
        dateFormatter.dateFormat = "h a"
        return dateFormatter.string(from: date)
    }
    func getCurrentDate() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Desired format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: date)
    }

    
    func dayOfWeek(from dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Input format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Ensure consistent parsing
        dateFormatter.timeZone = TimeZone.current

        // Convert the string to a Date object
        guard let date = dateFormatter.date(from: dateString) else { return nil }

        // Get the day of the week as a string
        dateFormatter.dateFormat = "E" // Full day name (e.g., Monday)
        return dateFormatter.string(from: date)
    }

}



extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var total:Int?
        if(isWeeklyData) {
            total = weatherViewModel.getForecastResponse().count
            
        } else {
            total =  weatherViewModel.getHourResponse().count
        }
        return total!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCell.identifier, for: indexPath) as? WeatherCell else {
            fatalError("Failed to dequeue CustomCollectionViewCell")
        }
        if (isWeeklyData == true) {
            let data: [Forecastday] = weatherViewModel.getForecastResponse()
            let day = self.dayOfWeek(from: data[indexPath.row].date)

            let dateCurrent = getCurrentDate()
            if (dateCurrent ==  data[indexPath.row].date) {
                scrollToIndex(in: weatherCollectionView, at: indexPath.row)
                cell.changeColor()
            }else {
                cell.removeColor()
            }
            cell.timeLabel.text = day
            let meanTemp = (data[indexPath.row].day.maxtemp_c + data[indexPath.row].day.mintemp_c)/2
            let formattedTemp = String(format: "%.1f", meanTemp)
           
            cell.configure(time: day ?? "Now", code: data[indexPath.row].day.condition.code, temp: formattedTemp)
            return cell
        } else {
            let data: [Hour] = weatherViewModel.getHourResponse()
            let extractTime = self.extractTime(from: data[indexPath.row].time)
            let timeAM = self.formatTime(extractTime ?? "nil")

            
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH"
            var currentHour = Int(dateFormatter.string(from: date))
            
            if (currentHour! % 2 != 0){
                currentHour = (currentHour! + 1)/2
            } else {
                currentHour = currentHour!/2
            }
            if (indexPath.row == currentHour) {
                cell.changeColor()
                cell.timeLabel.text = "Now"
            } else {
                cell.removeColor()
                cell.timeLabel.text = timeAM

            }
           
            cell.configure(time: timeAM ?? "nil", code: data[indexPath.row].condition.code, temp: "\(data[indexPath.row].temp_c)")
            
           
            return cell
        }
    }
}
extension HomeViewController:UpdateWeatherDelegate {
    func updateWeather(name: String) {
        weatherViewModel.fetchWeather(for: name)
    }
    
    
}




