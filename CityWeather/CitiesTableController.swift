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

        self.SetupViews()
        
    }

    //MARK: - ViewSetup
    func SetupViews(){
        let ausCities = ["Sydney":4163971, "Melbourne":2147714, "Brisbane":2174003]
        
        let weatherConnect:OpenWeather = OpenWeather(CitiesID: ausCities)
        weatherConnect.ProcessCityWeatherRequest()
        //weatherConnect.GetDailyForecast(CityName: "Sydney")
        weatherConnect.delegate = self
        
        DispatchQueue.main.async {
            self.title = "Weather®"
            self.AddOverLay()
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
        let tempMax:String = String(describing: cityWeather.tempMax)
        let tempMin:String = String(describing: cityWeather.tempMin)
        cell?.detailTextLabel?.text =  "\(tempMax)°C - \(tempMin)°C"
        
        if indexPath.row < (self.weatherList?.count)!{
             self.Overlay(start: false)
        }
        

        return cell!
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

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
    
    
    //Mark: - 
    
    func GetDailyForcast(){
        
        
        let index = self.tableView.indexPathForSelectedRow
        if let cityWeather = self.weatherList?[(index?.row)!]{
            
            self.selectedCity = cityWeather
            let connectWeather = OpenWeather()
                connectWeather.delegate = self
             let queue = DispatchQueue(label: "com.Financial.ruler", qos: .utility)
            queue.async {
                connectWeather.GetDailyForecast(CityName: cityWeather.cityName)
            }
            
            
        }
        
        
        
    }

}
