//
//  CityWeatherTests.swift
//  CityWeatherTests
//
//  Created by Dominic Edwayne Rivera on 18/8/17.
//  Copyright © 2017 Dominic Edwayne Rivera. All rights reserved.
//

import XCTest
@testable import CityWeather

class CityWeatherTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    
    
    func testInit(){
        
        let ausCities = ["Sydney":4163971, "Melbourne":2147714, "Brisbane":2174003]
        
        let weatherConnect:OpenWeather = OpenWeather.sharedInstance
        weatherConnect.SetCities(CitiesID: ausCities)
        weatherConnect.ProcessCityWeatherRequest()
         XCTAssertNotNil(weatherConnect.ProcessCityWeatherRequest())
        //weatherConnect.delegate = self
    }
    
    func testDailyForcast(){
        
         let weatherConnect:OpenWeather = OpenWeather.sharedInstance
         XCTAssertNotNil(weatherConnect.GetDailyForecast(CityName:"Sydney"))
        
    }
    
    func testSharedInstance(){
        
        let openWeather = OpenWeather.sharedInstance
        XCTAssertNotNil(openWeather)
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
