//
//  ViewController.swift
//  What's The Weather
//
//  Created by Gurjap Singh on 2016-12-29.
//  Copyright © 2016 Geranium. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var cityTextField: UITextField!
    @IBOutlet var displayLabel: UILabel!
    @IBOutlet var cityNameLabel: UILabel!
    var firstLoad = true
    @IBOutlet var submitButton: UIButton!
    var myStringValue: String?
    
    @IBAction func buttonTapped(_ sender: Any) {
        
        self.view.endEditing(true)
        
        //firstLoad = false
        
        var userCity = cityTextField.text
        
        userCity = userCity?.trimmingCharacters(in: .whitespacesAndNewlines) // trim the whitespace around a string
        
        if (userCity?.contains(" "))! {
        
            userCity = userCity?.replacingOccurrences(of: " ", with: "-")
            
        }
        
        userCity = userCity?.capitalized // capitalize first letters
        
        if let url = URL(string: "http://www.weather-forecast.com/locations/"+userCity!+"/forecasts/latest"){
            let request = NSMutableURLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, response, error in
                
                var toDisplay = ""
                if (error != nil) {
                    
                    print(error!)
                } else {
                    
                    if let unwrappedData = data {
                        
                        let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                        
                        var token = "3 Day Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">"
                        
                        if let stringArray = dataString?.components(separatedBy: token) {
                            
                            if stringArray.count > 1 {
                                
                                token = "</span>"
                                
                                let finalParagraph = stringArray[1].components(separatedBy: token)
                                    
                                    if finalParagraph.count > 1 {
                                        toDisplay = finalParagraph[0].replacingOccurrences(of: "&deg;", with: "°")
                                        print(toDisplay)
                                        
                                        let userLocations = UserDefaults.standard.object(forKey: "recentWeatherLocations")
                                        
                                        var userLocationsItems: [String]
                                        
                                        if let tempLocationItems = userLocations as? [String] {
                                            userLocationsItems = tempLocationItems
                                            
                                            var newSearch = true
                                            for locations in userLocationsItems {
                                                
                                                if locations.lowercased() == userCity?.lowercased() {
                                                    newSearch = false
                                                }
                                            }
                                            
                                            if newSearch == true {
                                                userLocationsItems.append(userCity!)
                                            }
                                            
                                        } else {
                                            userLocationsItems = [userCity!]
                                        }
                                        UserDefaults.standard.set(userLocationsItems, forKey: "recentWeatherLocations")
                                    
                                }
                            }
                            
                        }
                        //print(dataString!)
                    }
                
                }
                
                if (self.cityTextField.text == "") {
                    toDisplay = "Please enter a city or select one from the 'Recents' page."
                    userCity = ""
                }
                else if toDisplay == "" {
                    toDisplay = "Invalid Location. The weather at your specified location could not be found. Please try again."
                    userCity = ""
                }
                
                DispatchQueue.main.sync(execute: {
                    
                    self.displayLabel.text = toDisplay
                    if (userCity?.contains("-"))! {
                        
                        userCity = userCity?.replacingOccurrences(of: "-", with: " ")
                        
                    }
                    self.cityNameLabel.text = userCity
                })
            }
            task.resume()
            
        } else {
            
            displayLabel.text = "Invalid Location. The weather at your specified location could not be found. Please try again"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        displayLabel.text = ""
        submitButton.layer.cornerRadius = 4
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.setToolbarHidden(false, animated: true)
        
        if myStringValue != nil {
            
            if (myStringValue?.contains("-"))! {
            
                myStringValue = myStringValue?.replacingOccurrences(of: "-", with: " ")
            
            }
        }
        
        cityTextField.text = myStringValue
        if firstLoad != true {
            submitButton.sendActions(for: UIControlEvents.touchUpInside)
        }
        
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

