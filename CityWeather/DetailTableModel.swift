//
//  DetailTableModel.swift
//  CityWeather
//
//  Created by Dominic Edwayne Rivera on 20/8/17.
//  Copyright © 2017 Dominic Edwayne Rivera. All rights reserved.
//

import UIKit

class DetailTableModel: NSObject {
    
    private let dailyWeatherInfo:DailyForecast?
    private let cityWeatherInfo:WeatherInfo?
    
    init(CityWeather:WeatherInfo, DailyWeather:DailyForecast) {
        
        self.cityWeatherInfo = CityWeather
        self.dailyWeatherInfo = DailyWeather
        
    }

    
    func GetCityWeatherInfo()->WeatherInfo{
        
        return self.cityWeatherInfo!
    }
    
    //MARK: Table methods
    func NumRows()-> Int{
        
        return (self.dailyWeatherInfo?.weatherForcast.count)!
    }
    
    
    func GetWeatherImage(index:IndexPath)->UIImage{
        
        var imageIcon:UIImage?
        
        if  let weather = self.dailyWeatherInfo?.weatherForcast[index.row] {
          
                 imageIcon =  UIImage(named: weather.iconName)
        
           
        }
        
        
        return imageIcon!
    }
    
    
    func GetDate(index:IndexPath)->String{
        
        var dateStr:String?
        
        if  let weather = self.dailyWeatherInfo?.weatherForcast[index.row] {

             dateStr = weather.getConvertDate(currentDate: weather.dateStr, format: "EEE dd-MMM HH:mm")
           
        }

        return dateStr!
        
    }
    
    
    func GetDescript(index:IndexPath)->String{
        
         var summary:String?
        
        
        if  let weather = self.dailyWeatherInfo?.weatherForcast[index.row] {
            
            summary = weather.summary
        }
        
        return summary!
        
    }
    
    
    func GetTemperature(index:IndexPath)->String{
        var temp:String?
    
        if  let weather = self.dailyWeatherInfo?.weatherForcast[index.row] {
            
            let tempMaxInt = Int(weather.tempMax)
            let  tempMinInt = Int(weather.tempMin)
            temp = "\(tempMaxInt)°C - \(tempMinInt)°C"
        }
    
    return temp!
    
    }
    
    func SetTableViewCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:DetailsTableCell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! DetailsTableCell
                  DispatchQueue.main.async {
                cell.imageIcon.image = self.GetWeatherImage(index: indexPath)
                }
                cell.dayLabel.text = self.GetDate(index: indexPath)
                let tempStr = self.GetTemperature(index: indexPath)
                cell.tempLabel.attributedText = self.setLabel(descript: tempStr, label: "", labelSize: 18.0, descriptSize: 19.0)
                cell.descriptLabel.text =   self.GetDescript(index: indexPath)
        
        return cell
        
    }
    
    
    
   
    
    func setLabel(descript:String, label:String, labelSize:CGFloat, descriptSize:CGFloat)->NSMutableAttributedString{
        let yourAttributes = [NSForegroundColorAttributeName: UIColor.lightGray, NSFontAttributeName: UIFont.systemFont(ofSize: labelSize)]
        let yourOtherAttributes = [NSForegroundColorAttributeName: UIColor.darkGray, NSFontAttributeName: UIFont.systemFont(ofSize: descriptSize)]
        
        let partOne = NSMutableAttributedString(string:  label, attributes: yourAttributes)
        let partTwo = NSMutableAttributedString(string: descript, attributes: yourOtherAttributes)
        
        let combination = NSMutableAttributedString()
        
        combination.append(partOne)
        combination.append(partTwo)
        
        return combination
    }
    

}
