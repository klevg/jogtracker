//
//  MenuViewController.swift
//  JogTracker
//
//  Created by Евгений Клебан on 6/17/19.
//  Copyright © 2019 klevg. All rights reserved.
//

import UIKit
import MessageUI

class MenuViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBAction func closeButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func contuctUsButton(_ sender: UIButton) {
        sendEmail()
    }
}


// MARK: MessageUI
extension MenuViewController {
    @objc func sendEmail() {
        let mailComposeViewController = configureMailController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        }
    }
    
    func configureMailController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(["support@whocalledme.app"])
        mailComposerVC.setSubject("Тема письма")
        mailComposerVC.setMessageBody("Текст вашего обращения или отзыв", isHTML: false)
        
        return mailComposerVC
    }
    
    func showMailError() {
        let sendMailErrorAlert = UIAlertController(title: "Ошибка", message: "Невозможно отправить письмо. Вы можете сделать это вручную support@whocalledme.app", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Close", style: .default, handler: nil)
        sendMailErrorAlert.addAction(dismiss)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

