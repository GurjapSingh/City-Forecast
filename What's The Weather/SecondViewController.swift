//
//  SecondViewController.swift
//  What's The Weather
//
//  Created by Gurjap Singh on 2016-12-31.
//  Copyright © 2016 Geranium. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var goBack: UIBarButtonItem!
    
    var locations: [String] = []
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return locations.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = locations[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell \(indexPath.row)!")
        
        let firstViewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
        firstViewController.myStringValue = String(locations[indexPath.row])
        //navigationController?.popViewController(animated: true)
        firstViewController.firstLoad = false
        self.navigationController?.pushViewController(firstViewController, animated: true)
        //UIApplication.shared.sendAction(goBack.action!, to: goBack.target, from: self, for: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print("second view controller")
        self.tableView!.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.setToolbarHidden(true, animated: true)
        let locationItems = UserDefaults.standard.object(forKey: "recentWeatherLocations")
        
        if let tempLocations = locationItems as? [String] {
            
            locations = tempLocations
        }
        
        tableView.reloadData()
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

}
