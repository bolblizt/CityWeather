//
//  DetailsViewController.swift
//  CityWeather
//
//  Created by Dominic Edwayne Rivera on 18/8/17.
//  Copyright © 2017 Dominic Edwayne Rivera. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var iconView:UIImageView!
    @IBOutlet weak var cityLabel:UILabel!
    @IBOutlet weak var tempLabel:UILabel!
    @IBOutlet weak var descriptLabel:UILabel!
    
    @IBOutlet weak var descriptSideLabel:UILabel!
    @IBOutlet weak var sideIconView:UIImageView!
    @IBOutlet weak var tempSideLabel:UILabel!
    
    
    var cityWeatherInfo:WeatherInfo!
    var detailsCellModel:DetailTableModel?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

       
       self.SetupViewsAndLabels(weatherCity: (self.detailsCellModel?.GetCityWeatherInfo())!)
        
        
        // Do any additional setup after loading the view.
    }

    //MARK: SetupView 
    
    func SetupViewsAndLabels(weatherCity:WeatherInfo){
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

    
        if let otherLabel = self.view.viewWithTag(102) as? UILabel {
            otherLabel.text = weatherCity.summary
        }
        
        let tempMaxInt = Int(weatherCity.tempMax)
        let tempMinInt = Int(weatherCity.tempMin)
        
        let temperatureStr = "\(tempMaxInt)°C - \(tempMinInt)°C"
        let summaryStr = weatherCity.summary
        
        self.descriptLabel.text =  summaryStr
        self.descriptSideLabel.text = summaryStr
        
        self.cityLabel.text = weatherCity.cityName
        self.tempLabel.text = temperatureStr
        self.tempSideLabel.text = temperatureStr
        
        
        DispatchQueue.main.async {
            self.iconView.image = UIImage(named: weatherCity.iconName)
            self.sideIconView.image = UIImage(named: weatherCity.iconName)

            self.tableView.reloadData()
            
        }

        
    }
    
    
    //MARK: TableView Delegates methods
     func numberOfSections(in tableView: UITableView) -> Int {
        
        return 5
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (self.detailsCellModel?.NumRows())!
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell:UITableViewCell? = self.detailsCellModel?.SetTableViewCell(tableView, cellForRowAt: indexPath)
        return cell!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    //MARK: Orientation Change
    //MARK: Orientation Changes
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            
            
            if (UIScreen.main.bounds.size.width > 400) {
               self.cityLabel.textAlignment = .center
            }
        } else {
            self.cityLabel.textAlignment = .left
        }
    }
    

}
