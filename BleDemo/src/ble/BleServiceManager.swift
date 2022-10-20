//
//  BleServiceManager.swift
//  BleDemo
//
//  Created by Admin on 17/10/22.
//

import Foundation
import CoreBluetooth

class BleServiceManager: NSObject, CBPeripheralDelegate {
    
    private override init() {
        super.init()
    }
    
    private static var instance: BleServiceManager!
    static func getInstance() -> BleServiceManager {
        if instance == nil {
            instance = BleServiceManager()
        }
        return instance
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        peripheral.services?.enumerated().forEach({ i, service in
            print("UUID -> Service: \(service.uuid.uuidString)")
            peripheral.discoverCharacteristics(nil, for: service)
        })
        print("")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        service.characteristics?.enumerated().forEach({ i, characteristic in
            print("UUID -> ServiceWithChar: \(service.uuid.uuidString), Characteristic: \(characteristic.uuid.uuidString)")
            peripheral.discoverDescriptors(for: characteristic)
        })
        print("")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        characteristic.descriptors?.enumerated().forEach({ i, descriptor in
            let v = descriptor.uuid.uuidString == CBUUIDClientCharacteristicConfigurationString
            print("UUID -> Characteristic: \(characteristic.uuid.uuidString), Descriptor: \(descriptor.uuid.uuidString), isStandard: \(v), Msg: \(descriptor.description)")
            
            if characteristic.uuid.uuidString == "2A19" {
                peripheral.setNotifyValue(true, for: characteristic)
            } else if v == false {
                peripheral.readValue(for: characteristic)
            } else {
                peripheral.readValue(for: descriptor)
            }
        })
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
        print("CBDescriptor: \(descriptor.characteristic?.uuid.uuidString ?? "") is also known as \(descriptor.value)")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        print("didUpdateNotificationStateFor: \(characteristic.uuid.uuidString) is also known as \(characteristic.description)")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("CBCharacteristic: \(characteristic.uuid.uuidString) is also known as \(characteristic.description)")
    }
}
