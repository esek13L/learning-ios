//
//  File.swift
//  core
//
//  Created by Esekiel Surbakti on 06/06/21.
//

import UIKit

public extension UIImage {
    enum AssetIdentifier: String {
        case dca = "imgDca"
    }
    
    convenience init!(asset: AssetIdentifier) {
        let bundle = Bundle(for: Core.self)
        self.init(named: asset.rawValue, in: bundle, compatibleWith: nil)
    }
}
