//
//  DetailWeatherViewController.swift
//  WeatherApp
//
//  Created by Khairul Rijal on 12/01/20.
//  Copyright © 2020 Khairul Rijal. All rights reserved.
//

import UIKit

class DetailWeatherViewController: UIViewController {
    
    var response: Response!
    var name: String!
    var dailyForecast: [Weathers] = []
    
    @IBOutlet weak var sayHiLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentWeatherLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var feelslikeLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var cloudnessLabel: UILabel!
    @IBOutlet weak var dailyForecastTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dailyForecastTableView.tableFooterView = UIView()
        
        self.cityNameLabel.text = response.city.name
        self.sayHiLabel.text = "Hi,\(name!)"
        
        if let current = self.response.list.first {
            self.currentWeatherLabel.text = current.weather.first?.main
            self.currentTempLabel.text = "\(current.main.temp)ºC"
            
            self.feelslikeLabel.text = "\(current.main.feels_like)ºC"
            self.humidityLabel.text = "\(current.main.humidity)%"
            self.windLabel.text = "\(current.wind.speed) km/h"
            self.cloudnessLabel.text = "\(current.clouds.all)%"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        
        var days = [String]()
        
        self.dailyForecast = self.response.list
            .sorted(by: {$0.dt.compare($1.dt) == .orderedAscending})
            .filter { (weather) -> Bool in
            
            let day = dateFormatter.string(from: weather.dt)
            print(day)
            
            if !days.contains(day) {
                days.append(day)
                print(days)
                return true
            }
            
            return false
        }
        
        self.dailyForecastTableView.reloadData()
    }
    
}

extension DetailWeatherViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dailyForecast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ForecastCell
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        
        let weather = self.dailyForecast[indexPath.row]
        cell.dayLabel.text = dateFormatter.string(from: weather.dt)
        cell.maxDegree.text = "\(weather.main.temp_max)º"
        cell.minDegree.text = "\(weather.main.temp_min)º"
        cell.weatherConditionLabel.text = weather.weather.first?.main
        
        return cell
    }
    
}

class ForecastCell: UITableViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var maxDegree: UILabel!
    @IBOutlet weak var minDegree: UILabel!
    @IBOutlet weak var weatherConditionLabel: UILabel!
    
}
