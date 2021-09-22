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
    weak var coordinator: MainCoordinator?
    
    var mapViewBusinessSearchDataModel: MapViewBusinessSearchDataModel? {
        didSet {
            if let mapViewBusinessSearchDataModel = self.mapViewBusinessSearchDataModel {
                self.mapView.passLocations(locations: mapViewBusinessSearchDataModel.businessLocations)
            }
        }
    }
    // To change MainCoordinator dependency with an interface
    init(mapView: Mapable, presenter: MapViewSearchable, coordinator: MainCoordinator) {
        self.mapView = mapView
        self.presenter = presenter
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Food and Fun"
        setUpViews()
        selectedBusinessLocation()
        gottenCurrentLocation()
    }
    
    private func setUpViews() {
        self.view.backgroundColor = .white
        self.mapView.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.mapView.view)
        self.mapView.view.backgroundColor = .red
        self.mapView.view.pinEdges(to: self.view)
        self.mapView.setUpMapView()
        
    }
    
    private func selectedBusinessLocation() {
        self.mapView.selectedLocation = { [weak self] id in
            self?.coordinator?.getBusinessDetails(id: id)
            print("Selected location id:", id)
        }
    }
    
    private func gottenCurrentLocation() {
        self.mapView.currentLocation = { [weak self] currentCoordinates in
            guard let self = self else { return }
            self.presenter.loadBussinessesByLocation(coordinates: currentCoordinates) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let mapViewDataModel):
                    DispatchQueue.main.async {
                        self.mapViewBusinessSearchDataModel = mapViewDataModel
                    }
                case .failure(let error):
                    self.coordinator?.showAlerWithTitle(title: "Error", message: error.localizedDescription)
                }
            }
        }
    }
}
