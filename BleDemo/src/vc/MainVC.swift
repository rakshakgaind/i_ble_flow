//
//  ViewController.swift
//  BleDemo
//
//  Created by Admin on 13/10/22.
//

import UIKit
import CoreBluetooth

class MainVC: UIViewController {
    
    fileprivate let bleStateManager = BleStateManager.getInstance()
    var cbCentralManager: CBCentralManager? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bleStateManager.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let _ = bleStateManager.connectedDevice {
            view.backgroundColor = UIColor.green
        } else {
            cbCentralManager = CBCentralManager(delegate: bleStateManager, queue: nil)
            view.backgroundColor = UIColor.red
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        cbCentralManager?.stopScan()
        super.viewWillDisappear(animated)
    }
    
    @IBAction func btScan(_ sender: Any) {
        performSegue(withIdentifier: "navigate_to_scan", sender: self)
    }
}

extension MainVC: BleStateManagerDelegate {
    func connected() {
        view.backgroundColor = UIColor.green
    }
    
    func disconnected() {
        view.backgroundColor = UIColor.red
    }
}
