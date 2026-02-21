//
//  ViewController.swift
//  WeatherApp
//
//  Created by Abdulkarim Mziya on 2026-02-21.
//

import UIKit

class ViewController: UIViewController {
    private let weatherService = WeatherService()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .cyan
        loadWeatherData()
    }

    
    @MainActor
    func loadWeatherData() {
        Task {
            do{
                let weather = try await weatherService.fetchWeatherData()
                
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
