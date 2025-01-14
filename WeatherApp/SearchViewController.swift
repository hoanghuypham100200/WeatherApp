//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by Huy on 13/1/25.
//

//
//  ViewController.swift
//  wallPage
//
//  Created by Huy on 7/12/24.
//

import UIKit
import SnapKit

protocol UpdateWeatherDelegate: AnyObject {
    func updateWeather(name: String)
}

class SearchViewController: UIViewController {
    weak var weatherDelegate: UpdateWeatherDelegate?

    
    private let containerView = UIView()
    private let navigateView = UIView()
    
    private let backImageView = UIImageView()
    private let weatherLabel = UILabel()
    
    private let tableView = UITableView()
    private let searchBar = UISearchBar()
    
    private let weatherViewModel = WeatherViewModel()
    
    private let emptyImageView = UIImageView()
    
    var filteredWeather: [WeatherResponse] = WeatherViewModel.weatherResponseArray

    private let enterButton = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupRx()
    }
    
    private func setupUI() {
        navigationController?.navigationBar.isHidden = true
        containerView.backgroundColor = UIColor(hex: "#372C66")
        
        backImageView.image = UIImage(systemName: "chevron.left",withConfiguration: UIImage.SymbolConfiguration(pointSize: 21, weight: .semibold))
        backImageView.isUserInteractionEnabled =  true
        backImageView.tintColor = .white.withAlphaComponent(0.6)
        
        weatherLabel.text = "Weather"
        weatherLabel.textColor = .white
        weatherLabel.font = UIFont.systemFont(ofSize: 25,weight: .semibold)
        
        searchBar.delegate = self
        searchBar.placeholder = "Enter your country"
        searchBar.barTintColor = UIColor(hex:"#372C66")
        searchBar.searchTextField.leftView?.tintColor = .gray
        searchBar.searchTextField.textColor = .white
        searchBar.sizeToFit()
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
                    string: searchBar.placeholder ?? "",
                    attributes: [
                        .foregroundColor: UIColor.gray, // Placeholder text color
                        .font: UIFont.italicSystemFont(ofSize: 17) // Optional: Font style
                    ]
                )
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WeatherTableCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = UIColor(hex:"#372C66")
        tableView.separatorStyle = .none
        
        enterButton.setImage(UIImage(systemName: "arrow.up.circle",withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)), for: .normal)
        enterButton.tintColor = .white.withAlphaComponent(0.5)
        
        emptyImageView.image = UIImage.empty
        
    }
    private func setupConstraints() {
        view.addSubview(containerView)
        containerView.addSubview(navigateView)
        containerView.addSubview(searchBar)
        containerView.addSubview(tableView)
        navigateView.addSubview(backImageView)
        navigateView.addSubview(weatherLabel)
        searchBar.addSubview(enterButton)
        tableView.addSubview(emptyImageView)
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        navigateView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(100)
        }
        backImageView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-2)
            $0.leading.equalToSuperview().offset(10)
        }
        weatherLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.left.equalTo(backImageView.snp.right ).offset(5)
        }
        searchBar.snp.makeConstraints {
            $0.top.equalTo(navigateView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        tableView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.top.equalTo(searchBar.snp.bottom).offset(16)
        }
        enterButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(10)
            $0.height.equalToSuperview()
            $0.width.equalTo(30)
        }
        emptyImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(140)
            $0.height.width.equalTo(250)
        }
        
        
    }
    private func setupRx() {
        enterButton.addTarget(self, action: #selector(handleTapEnterBtn), for: .touchUpInside)
        tapGesture()
       
    }
    private func isEmpty() {
        if(filteredWeather.count == 0) {
            emptyImageView.isHidden = false
        }
        else {
            emptyImageView.isHidden = true
        }
    }
    
    private func tapGesture() {
        let backGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        backImageView.addGestureRecognizer(backGesture)
        
    }
    @objc func handleTap() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleTapEnterBtn() {
        
        if let text = searchBar.text {
            weatherViewModel.searchWeather(for: text)
            weatherViewModel.reloadTabelView = { [weak self] in
                self?.filteredWeather = WeatherViewModel.weatherResponseArray

                self?.tableView.reloadData()
                
            }
        }
        
        searchBar.text = ""
        tableView.reloadData()
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfArray = filteredWeather.count
        isEmpty()

        return numberOfArray
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? WeatherTableCell else {
            fatalError("Failed to dequeue CustomCollectionViewCell")
        }
        let temp = filteredWeather[indexPath.row].current.tempC
        let code = filteredWeather[indexPath.row].current.condition.code
        let country = filteredWeather[indexPath.row].location.country
        let name = filteredWeather[indexPath.row].location.name
        let status = filteredWeather[indexPath.row].current.condition.text
        let fTemp = filteredWeather[indexPath.row].current.tempF
        let uvTemp = filteredWeather[indexPath.row].current.uv
        
        cell.configure(temp: temp, code: code, country: "\(name), \(country)", status: status, maxTemp: "F:\(fTemp)", minTemp: "UV:\(uvTemp)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        weatherDelegate?.updateWeather(name: filteredWeather[indexPath.row].location.name)
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
                if searchText.isEmpty {
                    filteredWeather = WeatherViewModel.weatherResponseArray
                } else {
                    filteredWeather = WeatherViewModel.weatherResponseArray.filter {
                        let name = $0.location.name.lowercased()
                        let country = $0.location.country.lowercased()
                        return name.contains(searchText.lowercased()) || country.contains(searchText.lowercased())
                    }
                }
        tableView.reloadData()
    }
    
}




    

    
    

