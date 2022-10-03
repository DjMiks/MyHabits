//
//  Extention.swift
//  MyHabits
//
//  Created by Максим Ялынычев on 01.09.2022.
//

import UIKit

extension UIView {
    
    static var reuseID: String {
        return String(describing:Self.self)
    }
    func roundCornerWithRadius(
        _ radius: CGFloat,
        top: Bool? = true,
        bottom: Bool? = true,
        shadowEnabled: Bool = true
    ){
        
        var maskCorners = CACornerMask()
        
        if shadowEnabled  {
            clipsToBounds = true
            layer.masksToBounds = false
            layer.shadowOpacity = 0.5
            layer.shadowColor = UIColor(white: 0.0, alpha: 1.0).cgColor
            layer.shadowRadius = 4
            layer.shadowOffset = CGSize(width: 4, height: 4)
        }
        
        switch (top, bottom) {
        case(true, false):
            maskCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        case(true, true):
            maskCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        case(true, true):
            maskCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        default: break
        }
        layer.cornerRadius = radius
        layer.maskedCorners = maskCorners
    }
}
