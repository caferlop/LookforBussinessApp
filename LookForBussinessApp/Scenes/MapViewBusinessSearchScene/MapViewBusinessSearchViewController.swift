//
//  MapViewBusinessSearchViewController.swift
//  LookForBussinessApp
//
//  Created by carlos fernandez on 21/9/21.
//

import UIKit

class MapViewBusinessSearchViewController: UIViewController {
    
    private let mapView: Mapable
    private let presenter: MapViewSearchable
    
    init(mapView: Mapable, presenter: MapViewSearchable) {
        self.mapView = mapView
        self.presenter = presenter
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setUpViews() {
        self.view.addSubview(self.mapView.view)
        self.mapView.selectedLocation = { [weak self] id in
            
        }
    }
    
}
