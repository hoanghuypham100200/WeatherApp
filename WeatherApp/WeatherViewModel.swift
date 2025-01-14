import Foundation
import Alamofire
import RxSwift
import RxCocoa

class WeatherViewModel {

    // MARK: - Properties    
    // Observable for the weather data
    var weatherResponse = BehaviorRelay<WeatherResponse?>(value: nil)
    var errorMessage = BehaviorRelay<String?>(value: nil)
    
    var hourResponse : [Hour] = []
    var forecastResponse : [Forecastday] = []
    static var weatherResponseArray : [WeatherResponse] = []

    
    var reloadCollectionView: (() -> Void)?
    var reloadTabelView: (() -> Void)?
    var updateView: (() -> Void)?

    // MARK: - Fetch Weather Data
    func fetchWeather(for city: String) {
        let urlString = "https://api.weatherapi.com/v1/forecast.json"
        let parameters: [String: Any] = [
            "key": "a07037128eda4652adc105800251201",  // Replace with your actual API key
            "q": city,
            "aqi": "no",
            "days":7
        ]

        // Alamofire request with RxSwift
        AF.request(urlString, method: .get, parameters: parameters)
            .validate()
            .responseDecodable(of: WeatherResponse.self) { [weak self] response in
                switch response.result {
                case .success(let data):
                    self?.weatherResponse.accept(data)
                    
                    let evenHours = data.forecast.forecastday[0].hour.filter {
                        let hourNumber = (self?.extractHour(from: $0.time))!
                        let result = hourNumber % 2 == 0
                        return result
                    }
                    print(evenHours.count)
                    self?.hourResponse = evenHours
                    
                    
                    self?.forecastResponse = (data.forecast.forecastday)
                    DispatchQueue.main.async {
                        self?.reloadCollectionView?()
                    }
                case .failure(let error):
                    self?.errorMessage.accept(error.localizedDescription)  // Emit error message
                }
            }
    }
    
    func searchWeather(for city: String) {
        let urlString = "https://api.weatherapi.com/v1/forecast.json"
        let parameters: [String: Any] = [
            "key": "a07037128eda4652adc105800251201",  // Replace with your actual API key
            "q": city,
            "aqi": "no",
            "days":7
        ]

        // Alamofire request with RxSwift
        AF.request(urlString, method: .get, parameters: parameters)
            .validate()
            .responseDecodable(of: WeatherResponse.self) { [weak self] response in
                switch response.result {
                case .success(let data):
                    
                    let exists = WeatherViewModel.weatherResponseArray.contains(where: { $0.location.name.lowercased() == data.location.name.lowercased() })
                    
                    if exists {
                        print("has exists")
                    } else {
                        WeatherViewModel.weatherResponseArray.insert(data, at: 0)

                    }
                    
                    DispatchQueue.main.async {
                        self?.reloadTabelView?()
                    }
                case .failure(let error):
                    self?.errorMessage.accept(error.localizedDescription)  // Emit error message
                }
            }
    }
    
    func getHourResponse() -> [Hour] {
        return hourResponse
    }
    
    func getForecastResponse() -> [Forecastday] {
        return forecastResponse
    }
    


    func extractHour(from dateString: String) -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Ensure consistent parsing

        if let date = dateFormatter.date(from: dateString) {
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: date)
            return hour // Return the hour as an integer
        } else {
            return nil // Return nil if date parsing fails
        }
    }


}
