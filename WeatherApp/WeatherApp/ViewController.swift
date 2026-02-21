//
//  ViewController.swift
//  WeatherApp
//
//  Created by Abdulkarim Mziya on 2026-02-21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .cyan
        loadWeatherData()
    }

    
    @MainActor
    func loadWeatherData() {
        Task {
            do{
                let weather = try await fetchWeatherData()
                
                let temp = weather.current.temperature
                print("The current temperature is \(temp)°C")
                
            } catch NetworkError.invalidURL {
                print("Error: The URL provided was invalid.")
            } catch NetworkError.invalidResponse {
                print("Error: The server returned an invalid response.")
            } catch NetworkError.decodingFailed {
                print("Error: Failed to parse the weather data. Check your model keys.")
            } catch {
                print("An unexpected error occurred: \(error.localizedDescription)")
            }
        }
    }

}

// MARK: Weather Model
struct WeatherData: Codable {
    let current: CurrentWeather
}

struct CurrentWeather: Codable {
    let temperature: Double

    enum CodingKeys: String, CodingKey {
        case temperature = "temperature_2m" // Maps JSON "temperature_2m" to Swift "temperature"
    }
}

// MARK: Define Errors
enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingFailed
}

// MARK: Fetch Function Definition
func fetchWeatherData() async throws -> WeatherData {
    let endpoint = "https://api.open-meteo.com/v1/forecast?latitude=50.6665&longitude=-120.3192&current=temperature_2m"
    
    guard let url = URL(string: endpoint) else { throw NetworkError.invalidURL }

    let (data, response) = try await URLSession.shared.data(from: url)

    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw NetworkError.invalidResponse
    }

    do {
        return try JSONDecoder().decode(WeatherData.self, from: data)
    } catch {
        print("Decoding error: \(error)")
        throw NetworkError.decodingFailed
    }
}
