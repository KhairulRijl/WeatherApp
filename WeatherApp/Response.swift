//
//  Response.swift
//  WeatherApp
//
//  Created by Khairul Rijal on 12/01/20.
//  Copyright © 2020 Khairul Rijal. All rights reserved.
//

import Foundation

struct Main: Codable {
    var temp: Double
    var feels_like: Double
    var temp_min: Double
    var temp_max: Double
    var pressure: Double
    var humidity: Double
}

struct Weather: Codable {
    var main: String
    var description: String
    var icon: String
}

struct Clouds: Codable {
    var all: Double
}

struct Wind: Codable {
    var speed: Double
    var deg: Double
}

struct Weathers: Codable {
    var dt: Date
    var main: Main
    var weather: [Weather]
    var clouds: Clouds
    var wind: Wind
}

struct City: Codable {
    var name: String
    var country: String
}

struct Response: Codable {
    var list: [Weathers]
    var city: City
}
