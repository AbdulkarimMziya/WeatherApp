//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Abdulkarim Mziya on 2026-02-21.
//

import Foundation

protocol WeatherServiceProtocol {
    func fetchWeatherData() async throws -> WeatherData
}

class WeatherService: WeatherServiceProtocol {

    func fetchWeatherData() async throws -> WeatherData {

        let endpoint = "https://api.open-meteo.com/v1/forecast?latitude=50.6665&longitude=-120.3192&current=temperature_2m"

        guard let url = URL(string: endpoint) else {
            throw NetworkError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }

        do {
            return try JSONDecoder().decode(WeatherData.self, from: data)
        } catch {
            throw NetworkError.decodingFailed
        }
    }
}


