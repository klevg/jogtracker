//
//  FormViewController.swift
//  JogTracker
//
//  Created by Евгений Клебан on 6/17/19.
//  Copyright © 2019 klevg. All rights reserved.
//

import UIKit

class FormViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var timetextField: UITextField!
    @IBOutlet weak var distanceTextField: UITextField!
   
    private var time: Int = 0
    private var distance: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(FormViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        timetextField.delegate = self
        distanceTextField.delegate = self
    }
  
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        backgroundView.layer.cornerRadius = 29
        saveButton.layer.cornerRadius = 25
        saveButton.layer.borderColor = UIColor.white.cgColor
        saveButton.layer.borderWidth = 2.0
        
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        
        let currentDateTime = Date()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        let date = formatter.string(from: currentDateTime)
        
        
      
        
        Networking.createNewJog(accessToken: Networking.accessToken, tokenType: Networking.tokenType, distance: distance, time: time, date: date) { (success) in
            if success {
                print("Ok")
                
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        
        if textField == timetextField {
            if let text = textField.text {
                time = Int(text)!
                print(time)
            }
        } else if textField == distanceTextField {
            if let text = textField.text {
                distance = Int(text)!
                print(distance)
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if textField == timetextField {
            if let text = textField.text {
                time = Int(text)!
                print(time)
            }
        } else if textField == distanceTextField {
            if let text = textField.text {
                distance = Int(text)!
                print(distance)
            }
        }
        return true
    }
}
