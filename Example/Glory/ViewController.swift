//
//  ViewController.swift
//  Glory
//
//  Created by John Kricorian on 12/22/2021.
//  Copyright (c) 2021 John Kricorian. All rights reserved.
//


import UIKit
import Glory

class ViewController: UIViewController {
    
    var currentTransaction: Transaction?
    var glory: Glory?
    var user = "right_user"
    var pwd = "glory"
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBAction func occupy(_ sender: UIButton) {
        glory?.openOperation(user: user, pwd: pwd, completionHandler: { sessionId in
            self.glory?.occupyOperation(sessionId: sessionId)
        })
    }
    
    @IBAction func release(_ sender: UIButton) {
        glory?.openOperation(user: user, pwd: pwd, completionHandler: { sessionId in
            self.glory?.releaseOperation(sessionId: sessionId)
        })
    }
    
    @IBAction func change(_ sender: UIButton) {
        glory?.changeOperation(user: "Glory", amount: 200, gloryDelegate: self, completionHandler: { transaction in
            
        })
    }
    
    @IBAction func reset(_ sender: UIButton) {
        glory?.resetOperation()
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        glory?.changeCancelOperation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        glory = Glory(clientIP: "192.168.1.25", gloryDelegate: self, user: user, pwd: pwd)
    }
}

extension ViewController: GloryDelegate {
    func didUpdate(status: Status) {
        statusLabel.text = status.statusCode.rawValue
        if status.statusCode == .dispensing {
            
        }
        if status.isFlaggedStacker {
            let alert = UIAlertController(title: "Attention", message: "Un ou plusieurs stacker est dephasé. Merci de faire un collecte de vérification.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            present(alert, animated: true)
        }
    }
    
    func didFail(transaction: Transaction?, error: Error) {
        
    }
    
    func eventError(url: String, hexaErrorCode: String) {
        print(url)
        print(hexaErrorCode)
    }
    
    func didStart(transaction: Transaction?) {
        
    }
    
    func didUpdate(transaction: Transaction?) {
        
    }
    
    func didSucceed(transaction: Transaction?) {
        
    }
}

