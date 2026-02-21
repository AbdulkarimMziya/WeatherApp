//
//  WeatherModels.swift
//  WeatherApp
//
//  Created by Abdulkarim Mziya on 2026-02-21.
//

import Foundation

// MARK: - Weather Model
struct WeatherData: Codable {
    let current: CurrentWeather
}

struct CurrentWeather: Codable {
    let temperature: Double

    enum CodingKeys: String, CodingKey {
        case temperature = "temperature_2m"
    }
}

// MARK: - Network Errors
enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingFailed
}

