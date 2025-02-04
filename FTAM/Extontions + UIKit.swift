//
//  Extontions + UIKit.swift
//  FTAM
//
//  Created by Игорь Клевжиц on 04.02.2025.
//

import UIKit

extension UIImageView {
    convenience init(nameImage: String) {
        self.init(image: UIImage(named: nameImage))
        self.contentMode = .scaleAspectFit
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension UIButton {
    convenience init(color: UIColor, emoji: String) {
        self.init(type: .system)
        self.backgroundColor = color
        self.layer.cornerRadius = 20
        self.setTitle(emoji, for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 35)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
