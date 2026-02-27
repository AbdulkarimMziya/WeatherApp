//
//  ViewController.swift
//  WeatherApp
//
//  Created by Abdulkarim Mziya on 2026-02-21.
//

import UIKit

class ViewController: UIViewController {
    
    private let weatherService = WeatherService()

    // MARK: - UI Elements
        private let stackView = UIStackView()
        private let titleLabel = UILabel()
        private let locationLabel = UILabel()
        private let temperatureLabel = UILabel()
        private let headerStack = UIStackView()
        private let mapIcon = UIImageView()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 0.35, green: 0.62, blue: 0.94, alpha: 1.0)
        setupLayout()
        loadWeatherData()
    }
    
    private func setupLayout() {
        // 1. Configure the Header (HOME + Icon)
        titleLabel.text = "HOME"
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .white
        
        mapIcon.image = UIImage(systemName: "location.fill")
        mapIcon.tintColor = .white
        mapIcon.contentMode = .scaleAspectFit
        
        headerStack.axis = .horizontal
        headerStack.spacing = 4
        headerStack.addArrangedSubview(mapIcon)
        headerStack.addArrangedSubview(titleLabel)
        

        // 2. Configure Location Label
        locationLabel.text = "Kamloops"
        locationLabel.font = .systemFont(ofSize: 34, weight: .medium)
        locationLabel.textColor = .white

        // 3. Configure Temperature Label
        temperatureLabel.text = "--°"
        temperatureLabel.font = .systemFont(ofSize: 96, weight: .thin)
        temperatureLabel.textColor = .white

        // 4. Main StackView setup
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
            
        view.addSubview(stackView)
        stackView.addArrangedSubview(headerStack)
        stackView.addArrangedSubview(locationLabel)
        stackView.addArrangedSubview(temperatureLabel)

        // Constraints
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24)
        ])
    }


    
    @MainActor
    func loadWeatherData() {
        Task {
            do{
                let weather = try await weatherService.fetchWeatherData()
                
                let temp = weather.current.temperature
                temperatureLabel.text = "\(Int(temp.rounded()))°"
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
