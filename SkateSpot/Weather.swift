//
//  Weather.swift
//  SkateSpot
//
//  Created by Nash Schultz on 4/21/22.
//

import Foundation

class WeatherService {
    
    struct WeatherSummary: Codable {
        var current: Weather
    }

    struct Weather: Codable {
        var last_updated: String
        var temp_f: Double
        var wind_mph: Double
    }
    
    private let API_KEY = "1de3b4e9d5e94ba487855537222204"
    
    func fetchWeather(zipCode: String, completionHandler: @escaping (Weather) -> Void) {
        let apiDomain = "https://api.weatherapi.com/v1/current.json?key=" + API_KEY + "&q=" + zipCode + "&aqi=no"
        guard let url = URL(string: apiDomain) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            if let error = error {
                print("Error with fetching films: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                      print("Error with the response, unexpected status code: \(response ?? HTTPURLResponse())")
                      return
                  }
            
            if let data = data,
               let weather = try? JSONDecoder().decode(WeatherSummary.self, from: data) {
                completionHandler(weather.current)
            }
        })
        task.resume()
    }
}
