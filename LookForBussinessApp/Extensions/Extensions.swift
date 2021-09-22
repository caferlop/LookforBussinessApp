//
//  UIViewExtension.swift
//  LookForBussinessApp
//
//  Created by carlos fernandez on 21/9/21.
//

import Foundation
import UIKit

extension UIView {
    func pinEdges(to other: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: other.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: other.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: other.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: other.bottomAnchor).isActive = true
    }
    
    func pinEdgesToSafeArea(margins: UILayoutGuide) {
        self.translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}


