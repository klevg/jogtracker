//
//  ViewController.swift
//  JogTracker
//
//  Created by Евгений Клебан on 6/17/19.
//  Copyright © 2019 klevg. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!

    private var accessToken = ""
    private var tokenType = ""
    private var arrayOfItems: [JogItem] = []
    
    private let loginButtonBorderWidth: CGFloat = 3.0
    private let loginButtonCornerRadius: CGFloat = 36.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.borderColor = AppColors.purple.cgColor
        loginButton.layer.borderWidth = loginButtonBorderWidth
        loginButton.layer.cornerRadius = loginButtonCornerRadius

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 80)
        self.navigationController?.navigationBar.barTintColor = AppColors.green
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        loginButton.isEnabled = false
        Networking.login("hello") { (dataDictionary, error) in
            guard error == nil else { return }
            
            self.accessToken = dataDictionary!["accessToken"]!
            self.tokenType = dataDictionary!["tokenType"]!
            
            Networking.checkJogs(self.accessToken, tokenType: self.tokenType, completion: { (array, error) in
                guard error == nil else { return }
                self.arrayOfItems = array!
                
                
                self.performSegue(withIdentifier: "presentSecondVC", sender: nil)
            })
        }
        
        
    }
    @IBAction func showMenu(_ sender: UIBarButtonItem) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "menuController") as? MenuViewController
        
        self.present(vc!, animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentSecondVC" {
            if let destinationVC = segue.destination as? SecondViewController {
                destinationVC.arrayOfItems = arrayOfItems
            }
        }
    }
    
    
}


