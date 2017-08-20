//
//  CitiesTableController.swift
//  CityWeather
//
//  Created by Dominic Edwayne Rivera on 18/8/17.
//  Copyright © 2017 Dominic Edwayne Rivera. All rights reserved.
//

import UIKit

class CitiesTableController: UITableViewController, OpenWeatherDelegate {

    var weatherList:[WeatherInfo]? = [WeatherInfo]()
    var selectedCity:WeatherInfo?
     var viewOverlay: UIView!
    
    
    override func viewDidLoad() {
     super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(CitiesTableController.AlertMsg), name: NSNotification.Name(rawValue: "errorFetching"), object: nil)
        self.SetupViews()
        
    }

    //MARK: - ViewSetup
    func SetupViews(){
 
        let ausCities = ["Sydney":4163971, "Melbourne":2147714, "Brisbane":2174003]
        let weatherConnect:OpenWeather = OpenWeather.sharedInstance
        weatherConnect.SetCities(CitiesID: ausCities)
        weatherConnect.ProcessCityWeatherRequest()
        weatherConnect.delegate = self
        DispatchQueue.main.async {
            self.title = "Weather®"
            _ = self.AddOverLay()
            self.Overlay(start: true)
 
        }
  
    }
    
    //MARK: Overlay View
    func Overlay(start:Bool){
        
        if start {
            UIView.animate(withDuration: 2.5, delay: 0.0, options: UIViewAnimationOptions(), animations: { () -> Void in
                
                self.viewOverlay!.alpha = 0.8
                
            }, completion: { (finished: Bool) -> Void in
                
            })
        }
        else
        {
            UIView.animate(withDuration: 2.5, delay: 0.0, options: UIViewAnimationOptions(), animations: { () -> Void in
                
                self.viewOverlay!.alpha = 0.0
                
            }, completion: { (finished: Bool) -> Void in
                
               
            })
        }
    }

    
    //MARK: - WeatherDelegate
    func UpdateTableView(weatherInformation:WeatherInfo){
        
        self.weatherList?.append(weatherInformation)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func CityDailyForcast(dailyWeatherForcast: DailyForecast) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let resultController = storyboard.instantiateViewController(withIdentifier: "detailTable") as? DetailsViewController {
            
            resultController.detailsCellModel = DetailTableModel(CityWeather: self.selectedCity!, DailyWeather: dailyWeatherForcast)
            
            DispatchQueue.main.async {
                self.Overlay(start: false)
                 self.navigationController?.pushViewController(resultController, animated: true)
            }
           
            
        }

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (self.weatherList?.count)!
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath)

        if cell == nil {
             cell = UITableViewCell(style: .value1, reuseIdentifier: "weatherCell")
        }
       
        let cityWeather:WeatherInfo = (self.weatherList?[indexPath.row])!
        cell?.textLabel?.text =  cityWeather.cityName
        
        
        print("\(cityWeather.tempMax)")
        let tempMaxInt = Int(cityWeather.tempMax)
        let tempMinInt = Int(cityWeather.tempMin)
        
        cell?.detailTextLabel?.text =  "\(tempMaxInt)°C - \(tempMinInt)°C"
        
        if indexPath.row < (self.weatherList?.count)!{
             self.Overlay(start: false)
        }
        

        return cell!
    }
    

  

    //MARK: - Overlay Setup
    func AddOverLay()->Bool{
        
        var result:Bool = false
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        
        let rect = UIScreen.main.bounds
        var indicator:UIActivityIndicatorView!
        
        if self.viewOverlay == nil{
            self.viewOverlay = UIView(frame: rect)
            self.viewOverlay!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.viewOverlay!.backgroundColor = UIColor.white
            indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            indicator.color = UIColor.darkGray
            indicator.frame = CGRect(x: (rect.size.width-50)/2, y: (rect.size.height-50)/2, width: 50, height: 50)
            indicator.hidesWhenStopped = true
            indicator.startAnimating()
            self.viewOverlay?.addSubview(blurEffectView)
            self.viewOverlay!.alpha = 0.8
            self.viewOverlay!.addSubview(indicator)
            self.view.addSubview(self.viewOverlay)
            self.view.bringSubview(toFront: self.viewOverlay)
            result = true
            
        }
        
        return result
      
    }
    
    // MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
       
        
        DispatchQueue.main.async {
            self.Overlay(start: true)
        }
        
        self.perform(#selector(CitiesTableController.GetDailyForcast), with: nil, afterDelay: 2.0)
        return false
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
    }
    
    
    //Mark: - DailyForcast
    
    func GetDailyForcast(){
        
        
        let index = self.tableView.indexPathForSelectedRow
        if let cityWeather = self.weatherList?[(index?.row)!]{
            
            self.selectedCity = cityWeather
            let connectWeather = OpenWeather.sharedInstance
                connectWeather.delegate = self
             let queue = DispatchQueue(label: "com.Financial.ruler", qos: .utility)
            queue.async {
                connectWeather.GetDailyForecast(CityName: cityWeather.cityName)
            }
            
            
        }
        
    }
    
    //MARK: Error Alert MSG
    func AlertMsg(_ notification:Notification){
        
        var errorMessage:String = "An Error has occured while getting the weather data. Please try again."
         if let myDict = (notification as NSNotification).userInfo  {
            errorMessage = myDict["errorMsg"] as! String
        }
        
            
            let alertView = UIAlertController(title: "Weather®", message: "ERROR: \(errorMessage).", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
                print("OK")
                self.Overlay(start: false)
            }
            alertView.addAction(okAction)
            self.present(alertView, animated: true, completion: nil)
        
        
        DispatchQueue.main.async {
            self.Overlay(start: false)
        }
        
        
    }

}
