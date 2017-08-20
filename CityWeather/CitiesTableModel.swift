//
//  DailyViewModel.swift
//  WeatherApp
//
//  Created by user on 8/5/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

struct CitiesTableModel {
    
    
    private var rows:Int = 0
    private var sections:Int = 0
    private var weather:WeatherInfo?
    
    init(weatherInfo:WeatherInfo) {
        self.weather = weatherInfo
       // self.rows = weatherInfo.getForecast().getDailyCount()
    }
    
    func getRows()-> Int{
        
        return self.rows
    }
    
    
    mutating func setRows(rows:Int){
        
        self.rows = rows
    }
    
    
    func getSections()->Int{
        return sections
    }
    
    mutating func setSections(sections:Int){
        
        
        self.sections = sections
    }
    
    /*
    func getCellLabel(index:IndexPath)->String{
        
        let dailyList = self.weather?.getForecast().getDailyDetails()
        let hourDetail = dailyList?[index.row]
        let celsius = self.weather?.FahrenheitToCelcious(fahrenheit: (hourDetail?.temperatureMax)!)
        return  "\(celsius!)°C " + (self.weather?.getForecast().getConvertDate(currentDate: (hourDetail?.time)!, format: "EEEE, MMM d"))!
    }
    
    
    func getCellDetail(index:IndexPath)->String{
        let dailyList = self.weather?.getForecast().getDailyDetails()
        let hourDetail = dailyList?[index.row]
        let tempStr = "\((hourDetail?.daySummary)!) "
        return tempStr
    }
    
    
    func getCellImage(index:IndexPath)->UIImage{
        
        let dailyList = self.weather?.getForecast().getDailyDetails()
        let hourDetail = dailyList?[index.row]
        let tempStr = hourDetail?.icon
        
        return UIImage(named:tempStr!)!
    }
 
    
    func tableCell(index:IndexPath, tableView:UITableView)->UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "dailyCell", for: index) as UITableViewCell
        
        cell.textLabel?.text = getCellLabel(index: index)
        cell.detailTextLabel?.text = getCellDetail(index:index)
        cell.imageView?.image = getCellImage(index: index)
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
    }*/

}
