//
//  Extension.swift
//  BleDemo
//
//  Created by Admin on 13/10/22.
//

import UIKit

extension UIViewController {
    func doubleButtonAlert(msg: String, callback: (() -> Void)? = nil) {
        let alertDialog = UIAlertController(title: AppConstant.APP_NAME, message: msg, preferredStyle: .alert)
        
        alertDialog.addAction(UIAlertAction(title: AppConstant.CANCEL, style: .cancel))
        alertDialog.addAction(UIAlertAction(title: AppConstant.OK, style: .default, handler: { _ in
            callback?()
        }))
        
        self.present(alertDialog, animated: true)
    }
}
