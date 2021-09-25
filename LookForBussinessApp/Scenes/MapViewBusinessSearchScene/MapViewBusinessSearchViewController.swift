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
    weak var coordinator: Coordinator?
    
    var mapViewBusinessSearchDataModel: MapViewBusinessSearchDataModel? {
        didSet {
            if let mapViewBusinessSearchDataModel = self.mapViewBusinessSearchDataModel {
                self.mapView.passLocations(locations: mapViewBusinessSearchDataModel.businessLocations)
            }
        }
    }
   
    init(mapView: Mapable, presenter: MapViewSearchable) {
        self.mapView = mapView
        self.presenter = presenter
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
            if let kickOffCoordinator = self?.coordinator as? KickOffCoordinator {
                kickOffCoordinator.goToBusinessDetails(id: id)
                print("Selected location id:", id)
            }
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
