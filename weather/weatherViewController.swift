//
//  weatherViewController.swift
//  weather
//
//  Created by kuetcse on 31/10/21.
//  Copyright © 2021 kuetcse. All rights reserved.
//

import UIKit
import Foundation

let MBapiToken = "pk.eyJ1IjoicmFrODEwIiwiYSI6ImNraTYzdDdwMDJuMm4zMGtieDlsOHJ5bG0ifQ.51iHjVr-BxZq9FJvGEQyTw"
let OWMapiToken = "25eebf3ad2deabc5a763038ae0406abc"




class weatherViewController: UIViewController,UISearchBarDelegate {
    
    @IBOutlet weak var citySearch: UISearchBar!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var hazeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windflowLabel: UILabel!
    @IBOutlet weak var rainfallLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    
    
    
    struct PlaceName : Codable {
        var place_name : String
        var center : [Double]
    }

    struct LatLongQuery : Codable {
         var type : String
         var query : [String]
         var features : [PlaceName]
    }
    
    struct Weather : Codable {
        var main : String
        var description: String
    }

    struct Current : Codable {
        var temp : Double
        var feels_like : Double
        var pressure : Double
        var humidity : Double
        var wind_speed : Double
        var weather : [Weather]
    }
    
    struct WeatherResult : Codable {
        var current: Current?
    }
    
    
//    var res = WeatherResult()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        citySearch.delegate = self
        dayLabel.text = getWeekDay()
//      nabtnClick(sender: citySearch)
        //searchBarSearchButtonClicked(citySearch)
        // Do any additional setup after loading the view.
    }
    
//    @IBAction func btnClick(sender: UISearchBar) {
//        locationLabel.text = "Kanke Mage"
//    }
    func citySearch(citySearch: UISearchBar, textDidChange searchText: String) {
        print("searchText \(searchText)")
    }
    
    func getMapBoxURL(token : String, loc : String) -> Optional<URL> {
        let urlStr = "https://api.mapbox.com/geocoding/v5/mapbox.places/$\(loc).json?access_token=\(token)"
        return URL(string: urlStr.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed) ?? "")
        
        
    }
    func getOWeatherURL(token : String, lat : Double, long: Double) -> Optional<URL> {
        
        let urlStr = "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(long)&units=metric&exclude=minutely&appid=\(token)"
        return URL(string: urlStr.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed) ?? "")
    }
    

    
    @IBAction func showPopUp(_ sender: Any) {
        let alert = UIAlertController(
            title: "Error", message: "Error In Network. Change Wifi", preferredStyle: .alert
        )
        
        let okayAction = UIAlertAction(
            title: "OK!!", style: .default) {
                (action) in
                print(action)
            }
        
        alert.addAction(okayAction)
        present(alert, animated: true, completion: nil)
    }
    @IBAction func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        let city = citySearch.text
        print("searchText \(city)")
        
        let re = getLatLong(inputLoc: city ?? "dhaka")
        print("Going Inside getWeather")
        let weatherResult : WeatherResult = getWeather(lat: re.lat, long: re.long)
        sleep(1)
        print("lat : \(re.lat) long: \(re.long) loc: \(re.pl_name)")
        print("Inside Search Bar Func")

        if weatherResult.current == nil {
            print("Connection Error")
            showPopUp(weatherResult as Any)
        }
        else {
            temperatureLabel.text = String(format: "%.1f", weatherResult.current!.temp)
            hazeLabel.text = weatherResult.current?.weather[0].main
            humidityLabel.text = String(format: "%.2f", weatherResult.current!.humidity)
            windflowLabel.text = String(format: "%.2f", weatherResult.current!.wind_speed)
            windflowLabel.text = String(format: "%.2f", weatherResult.current!.pressure)
            feelsLikeLabel.text = String(format: "%.2f", weatherResult.current!.feels_like)
            locationLabel.text = re.pl_name
            
        }

        print(weatherResult)
        
    }
    
    
    func getWeekDay() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayOfTheWeekString = dateFormatter.string(from: date)
        return dayOfTheWeekString
    }
    
    func getLatLong(inputLoc : String) -> (lat:Double,long:Double,pl_name:String) {
        print("Inside getLatLong")
        var lat: Double = 0.0
        var long: Double = 0.0
        var cityLoc: String = ""
        let url = getMapBoxURL(token : MBapiToken, loc : inputLoc)
        let session = URLSession.shared

        let dataTask = session.dataTask(with : url!) {
            (data, response, error) in
        
            if error == nil && data != nil {
                let decoder = JSONDecoder()
                do {
                    
                    let query = try decoder.decode(LatLongQuery.self, from: data!)
                    long = query.features[0].center[0]
                    lat = query.features[0].center[1]
                    cityLoc = query.features[0].place_name
                }
                catch {
                    print("error in JSON parsing")
                }
            }
        }

        dataTask.resume()
        sleep(1)
        return (lat, long, cityLoc)
    }
    
    func getWeather(lat: Double, long: Double) -> WeatherResult {
        let url = getOWeatherURL(token: OWMapiToken, lat: lat, long: long)
        var res = WeatherResult()
        let session = URLSession.shared
        let dataTask = session.dataTask(with : url!) {
            (data, response, error) in
            print("Inside getWeather")
            if error == nil && data != nil {
                let decoder = JSONDecoder()
                do {
                    
                    let query = try decoder.decode(WeatherResult.self, from: data!)
                    res = query
                }
                catch {
                    print("error in JSON parsing")
                }
            }
        }
        
        dataTask.resume()
        sleep(1)
        return res
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
