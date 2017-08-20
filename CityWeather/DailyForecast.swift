//
//  DailyForecast.swift
//  TheWeather
//
//  Created by user on 6/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation


struct DailyForecast{
    

    var weatherForcast:[DailyWeather] = [DailyWeather]()
    let cityName:String
    let country:String
    let location: (latitude: Double, longitude: Double)
    
    /*
    init(dailyList:[DailyDetails], hourlyList:[Hourly], dailyForcast:[WeatherInfo]) {
        
        self.dayDetails = dailyList
        self.hourlyDetails = hourlyList
        self.dailyForcast = dailyForcast

    }
    
    
     init(){
        self.dayDetails = [DailyDetails]()
        self.hourlyDetails = [Hourly]()
        self.dailyForcast = [WeatherInfo]()
        
    }
 
    func getDailyForcast() ->[WeatherInfo]{
        
        return self.dailyForcast!
    }

    

    func getDailyCount()->Int{
        
        return (self.dailyForcast?.count)!
    }

     */

    
   
}

struct DailyWeather{
    
    var tempMax:Float = 0.00
    var tempMin:Float = 0.00
    var description: String = ""
    var temperature: Float = 0.00
    var summary:String = ""
    var dateStr:String = ""
    var iconName:String = ""
    
    func getConvertDate(currentDate:String, format:String)->String{
        
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let yourDate = formatter.date(from: currentDate)

        formatter.dateFormat = format//"EEEE, MMM d, yyyy"
        // again convert your date to string
        let dateString = formatter.string(from: yourDate!)
        
        return dateString
        
    }
    

    
}

struct DailyDetails {
    var daySummary:String?
    var temperatureMin:Float
    var temperatureMax:Float
    var icon:String?
    var time:Date?
    
    
    init() {
        
       // self.daySummary = ""
        self.temperatureMax = 0.00
        self.temperatureMin = 0.00
       // self.icon = ""
    }
    
    
}





