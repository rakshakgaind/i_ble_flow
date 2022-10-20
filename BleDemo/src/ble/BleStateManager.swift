//
//  BleStateManager.swift
//  BleDemo
//
//  Created by Admin on 13/10/22.
//

import CoreBluetooth

protocol BleStateManagerDelegate {
    func connected()
    func disconnected()
}

class BleStateManager: NSObject, CBCentralManagerDelegate {
    
    private var timer: Timer? = nil
    private var keyList = [String]()
    
    var scanList = [String: CBPeripheral]()
    var scanCallback: ((_ keyList: [String]) -> Void)? = nil

    /// Ble Connection
    var connectedDevice: CBPeripheral? = nil
    var cbCentralManager: CBCentralManager? = nil
    var delegate: BleStateManagerDelegate? = nil
    
    /// Ble Service
    var bleServiceManager = BleServiceManager.getInstance()
    
    private override init() {
        super.init()
    }
    
    private static var instance: BleStateManager!
    static func getInstance() -> BleStateManager {
        if instance == nil {
            instance = BleStateManager()
        }
        return instance
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            cbCentralManager = central
            keyList.removeAll()
            scanList.removeAll()

            if let id = SessionManager.getInstance().getString(key: SessionConstant.DEVICE_ID) {
                if let value = UUID.init(uuidString: id) {
                    let device = cbCentralManager?.retrievePeripherals(withIdentifiers: [value])
                    connectedDevice = device?.first
                    if connectedDevice != nil {
                        central.connect(connectedDevice!)
                    }
                }
            }
            if connectedDevice == nil {
                central.scanForPeripherals(withServices: nil)
            }
        } else {
            cbCentralManager = nil
            delegate?.disconnected()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let uuid = peripheral.identifier.uuidString
        if peripheral.name == nil || keyList.contains(uuid) {
            return
        }
        
        if let id = SessionManager.getInstance().getString(key: SessionConstant.DEVICE_ID) {
            if uuid == id {
                central.connect(peripheral)
                central.stopScan()
            }
        }
        
        keyList.append(uuid)
        scanList[uuid] = peripheral
        
        timer?.invalidate()
        timer = nil
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(scanResult), userInfo: nil, repeats: false)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected: \(peripheral.name ?? "")")
        cbCentralManager = nil
        connectedDevice = nil
        delegate?.disconnected()
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Fail to connect: \(error?.localizedDescription ?? "")")
        cbCentralManager = nil
        connectedDevice = nil
        delegate?.disconnected()
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected: \(peripheral.name ?? "")")
        cbCentralManager = central
        connectedDevice = peripheral
        delegate?.connected()
        
        connectedDevice?.delegate = bleServiceManager
        connectedDevice?.discoverServices(nil)
    }
}

extension BleStateManager {
    @objc func scanResult() {
        scanCallback?(keyList)
    }
}
