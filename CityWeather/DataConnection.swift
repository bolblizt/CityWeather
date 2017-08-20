//
//  DataConnection.swift
//  TheWeather
//
//  Created by user on 5/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
import Alamofire

protocol OpenWeatherDelegate  {

    func UpdateTableView(weatherInformation:WeatherInfo)
    func CityDailyForcast(dailyWeatherForcast:DailyForecast)
}



class OpenWeather{
    

    private var weather:WeatherInfo?
    
    private var citiesID:[String:Int]?
    private var daily: DailyForecast?
    var delegate:OpenWeatherDelegate!
    var overLay:UIView!
    var citiesWeatherInfo:[WeatherInfo] = [WeatherInfo]()
    
    init (CitiesID:[String:Int]){
        
        self.citiesID = CitiesID
    }

    init() {
        
    }
    
    

   
    
    func isCitiesIDAvailable()->Bool{
       
        var result:Bool = false
        if (self.citiesID?.count)! > 0 {
            result = true
        }
        return result
    }
    
    
    
    func GetCityWeatherInfo(){
        
          let size = self.citiesID?.count
        
        
        if size! > 0 {
            
        }
        else
        {
            
        }
        
    }
    
    
   
    //MARK: -  After getting weather info the tableview gets updated via the delagate,
    func ProcessCityWeatherRequest() {
        
        let requestQueue  = OperationQueue()
        
        
        //Every weather object is padd to the delegate method
        let handlerBlock: (WeatherInfo) -> Void = { doneWork in
            
            self.delegate.UpdateTableView(weatherInformation: doneWork)
            
        }

        
        for (cityName,cityID) in self.citiesID!{
            
            let operation = BlockOperation(block: {
                
                self.CityWeatherInfo(CityID: String(cityID), CityName:cityName, Completion: handlerBlock)
                
                
            })
            
            operation.completionBlock = {
                
                print("weather completed, cancelled:\(operation.isCancelled) ")
                
            }
            requestQueue.addOperation(operation)
            
           

        }
     
        
        
        
    }
  
    
    //MARK: - Connect to OpenWeather
     func CityWeatherInfo(CityID:String, CityName:String, Completion: @escaping (WeatherInfo) -> Void) {
        
       let APIKEY = "969da40965d006526bb3c282196f20da"
        
        let urlStr = "https://api.openweathermap.org/data/2.5/weather?id=\(CityID)&units=metric&APPID=\(APIKEY)"
        Alamofire.request(urlStr).validate().responseJSON { response in
            switch response.result {
            case .success:
                if let json =  response.value as? [String: Any] {
                    
                    Completion(self.WeatherInit(jsonData: json))
                }
                
            case .failure(let error):
                print(error)
            }
        }
        
        
    }

    //MARK: City Daily Forecast
    func GetDailyForecast(CityName:String){
        
        let forecastBlock: (DailyForecast) -> Void = { weeklyForcast in
            
           self.delegate.CityDailyForcast(dailyWeatherForcast: weeklyForcast)
            
        }
        
        self.CityDailyForecast(Name: CityName, Completion: forecastBlock)
        
    }

    func CityDailyForecast(Name:String, Completion: @escaping (DailyForecast) -> Void) {
        
        let APIKEY = "969da40965d006526bb3c282196f20da"
        
        let urlStr = "https://api.openweathermap.org/data/2.5/forecast?q=\(Name),au&cnt=40&units=metric&mode=json&APPID=\(APIKEY)"
        print(urlStr)
        Alamofire.request(urlStr).validate().responseJSON { response in
            switch response.result {
            case .success:
                if let json =  response.value as? [String: Any] {
                    
                    
                    Completion(self.WeatherForcast(jsonData: json))
                }
                
            case .failure(let error):
                print(error)
            }
        }

        
    }
    
    func WeatherInit(jsonData:[String: Any]) ->WeatherInfo{
        
        self.weather = WeatherInfo.init(json: jsonData)
        
        return self.weather!
    }
  
    func WeatherForcast(jsonData:[String: Any]) ->DailyForecast{
        
        self.daily = DailyForecast(json: jsonData)
        
        return self.daily!
    }

    
    func getWeatherInfo() ->WeatherInfo{
        
        return self.weather!
    }
    

    
    
}



//MARK: - Init for WeatherInfo

extension WeatherInfo {
    
    
    init?(json: [String: Any]) {
        guard let name = json["name"] as? String,
            let coordinatesJSON = json["coord"] as? [String: Double],
                let latitude = coordinatesJSON["lat"],
                let longitude = coordinatesJSON["lon"],
            let mains = json["main"] as? [String:Float],
                let temp = mains["temp"],
                let tempMax = mains["temp_min"],
                let tempMin = mains["temp_max"],
                let humid = mains ["humidity"],
            let weather = json["weather"] as? NSArray
        
        
            else {
                return nil
        }

        
        let weatherInfo  = weather.object(at: 0) as? [String:Any]
        guard let descript = weatherInfo?["description"] as? String,
            let summa = weatherInfo?["main"] as? String,
            let iconName = weatherInfo?["icon"] as? String
            else{
                return nil
        }
        
        self.cityName = name
        self.location = (latitude, longitude)
        self.temperature = temp
        self.tempMax = tempMax
        self.tempMin = tempMin
        self.humidity = humid
        self.description = descript
        self.summary = summa
        self.dateStr = ""
        self.iconName = iconName

    }
    
}


extension DailyForecast{
    
    init?(json: [String: Any]) {
        guard  let cityInfo = json["city"] as? [String:Any],
                 let country  = cityInfo["country"] as? String,
                 let cityname = cityInfo["name"] as? String,
                 let coordinatesJSON = cityInfo["coord"] as? [String: Double],
                     let latitude = coordinatesJSON["lat"],
                     let longitude = coordinatesJSON["lon"],
                let forcast = json["list"] as? NSArray
            
            else {
                return nil
        }
        
        
        for i in 0 ..< forcast.count {
            print("index: \(i)")
            var dailyWeather:DailyWeather = DailyWeather()
           guard  let dayForcast = forcast.object(at: i) as? [String:Any],
                  let date = dayForcast["dt_txt"] as? String,
                  let mainInfo = dayForcast["main"] as? [String:Float],
                        let tempMax =  mainInfo["temp_max"],
                        let tempMin = mainInfo["temp_min"],
                  let  weather = dayForcast["weather"] as? NSArray

                else{
                    return nil
            }

            for i in 0..<weather.count{
                
              guard let weatherData = weather.object(at: i) as? [String:Any],
                    let summary = weatherData["main"] as? String,
                    let description = weatherData["description"] as? String,
                    let iconName = weatherData["icon"] as? String
                
                else{
                    return nil
                }

                dailyWeather.summary = summary
                dailyWeather.description = description
                dailyWeather.iconName = iconName
            }
            
            dailyWeather.dateStr = date
            dailyWeather.tempMin = tempMin
            dailyWeather.tempMax = tempMax
            self.weatherForcast.append(dailyWeather)
            
        }
        
        
        self.cityName = cityname
        self.location = (latitude, longitude)
        self.country = country

        
    }

    
}
