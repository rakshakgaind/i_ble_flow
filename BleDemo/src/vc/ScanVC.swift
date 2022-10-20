//
//  ScanVC.swift
//  BleDemo
//
//  Created by Admin on 13/10/22.
//

import UIKit
import CoreBluetooth

class ScanVC: UIViewController {
    @IBOutlet weak var tvScan: UITableView!
    
    private var cBCentralManager: CBCentralManager? = nil
    private let bleStateManager = BleStateManager.getInstance()
    private var list = [String]()
    
    override func viewDidLoad() {
        cBCentralManager = CBCentralManager(delegate: bleStateManager, queue: nil)
        
        bleStateManager.scanCallback = { list in
            self.list = list
            self.tvScan.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        cBCentralManager?.stopScan()
        super.viewWillDisappear(animated)
    }
}

extension ScanVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScanCell") as! ScanCell
        let key = list[indexPath.row]
        let data = bleStateManager.scanList[key]
        
        cell.lbTitle.text = data?.name
        cell.lbAddress.text = data?.identifier.uuidString
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let key = list[indexPath.row]
        let data = bleStateManager.scanList[key]
        doubleButtonAlert(msg: "Do you want to connect with \(data?.name ?? "")") {
            SessionManager.getInstance().setValue(key: SessionConstant.DEVICE_ID, value: data?.identifier.uuidString ?? "")
            self.cBCentralManager?.connect(data!)
        }
    }
}
