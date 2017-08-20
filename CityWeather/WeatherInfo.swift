//
//  WeatherInfo.swift
//  TheWeather
//
//  Created by user on 5/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation


struct WeatherInfo{
    
    
    //var latitude: String?
    //var longitude:String?
    let tempMax: Float
    let tempMin:Float
    let description: String
    let temperature: Float
    let summary:String
    let humidity:Float
    let cityName:String
    let dateStr:String
    let iconName:String
    let location: (latitude: Double, longitude: Double)
   
   
 //  private var dailyWeather:DailyForecast?
    
    
    /*
     mutating func InitDailyWeather(weekWeather:DailyForecast){
        
        self.dailyWeather = weekWeather
    }
       func getForecast()->DailyForecast{
    
        return self.dailyWeather!
    }
     */
    
    
    func FahrenheitToCelcious(fahrenheit:Float)->String{
        let celsius:Float =  (fahrenheit - 32) * 5/9
        
        let temp = Int(celsius)
        return String (temp)
    }
    
    
    
    
}
