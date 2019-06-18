//
//  SecondViewController.swift
//  JogTracker
//
//  Created by Евгений Клебан on 6/17/19.
//  Copyright © 2019 klevg. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    var arrayOfItems: [JogItem] = []
    var accessToken: String = ""
    var tokenType: String = ""
    
    private let heightOfTableViewCell: CGFloat = 188
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if arrayOfItems.count == 0 {
            tableView.isHidden = true
        }
        tableView.dataSource = self
        tableView.delegate = self
        
        let nib = UINib.init(nibName: "TableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "cell")
    }
    
    @IBAction func addButton(_ sender: UIButton) {
        
        performSegue(withIdentifier: "createForm", sender: self)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        let distance = arrayOfItems[indexPath.row].distance
        let time = arrayOfItems[indexPath.row].time
        let speed = distance / time
        
        let  date = Date(timeIntervalSince1970: Double(arrayOfItems[indexPath.row].date))

        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeZone = .current
        let localDate = dateFormatter.string(from: date)
        
        cell.distance.text = "Distance: \(distance)"
        cell.speed.text = "Speed: \(speed)"
        cell.time.text = "Time: \(time)"
        cell.date.text = "Date: \(localDate)"

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightOfTableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
