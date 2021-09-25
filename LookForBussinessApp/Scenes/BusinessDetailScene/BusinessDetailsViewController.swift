//
//  BusinessDetailsViewController.swift
//  LookForBussinessApp
//
//  Created by carlos fernandez on 22/9/21.
//

import UIKit

class BusinessDetailsViewController: UIViewController {
    
    private let presenter: BusinesViewDetailable
    var businessId: String?
    weak var coordinator: Coordinator?
    
    var businessDetailDataModel: BusinessDetailsDataModel? {
        didSet {
            if let businessDetailModel = self.businessDetailDataModel {
                updateUIWith(viewDataModel: businessDetailModel)
            }
        }
    }
    
    // MARK: - View SetUp
    private lazy var mainStackView: UIStackView = {
        let mainVerticalStackView = UIStackView()
        mainVerticalStackView.axis = .vertical
        mainVerticalStackView.distribution = .fillEqually
        let margins = self.view.layoutMarginsGuide
        self.view.addSubview(mainVerticalStackView)
        mainVerticalStackView.pinEdgesToSafeArea(margins: margins)
        
        return mainVerticalStackView
    }()
    
    private lazy var detailsStackView: UIStackView = {
        let detailsVerticalStackView = UIStackView()
        detailsVerticalStackView.axis = .vertical
        detailsVerticalStackView.distribution = .fillEqually
        return detailsVerticalStackView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        return UILabel()
    }()
    
    private lazy var phoneLabel: UILabel = {
        return UILabel()
    }()
    
    private lazy var addressLabel: UILabel = {
        return UILabel()
    }()
    
    // To change MainCoordinator dependency with an interface
    init(presenter: BusinesViewDetailable) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.getBusinessDetails()
    }
    
    private func setupUI() {
        self.nameLabel.text = "Loading name"
        self.phoneLabel.text = "Loading phone"
        self.addressLabel.text = "Loading address"
        self.imageView.image = UIImage(named: "BusinessPlaceHolder")!
        
        self.detailsStackView.addArrangedSubview(self.nameLabel)
        self.detailsStackView.addArrangedSubview(self.phoneLabel)
        self.detailsStackView.addArrangedSubview(self.addressLabel)
        
        self.mainStackView.addArrangedSubview(self.imageView)
        self.mainStackView.addArrangedSubview(self.detailsStackView)
    }
    
    private func updateUIWith(viewDataModel: BusinessDetailsDataModel) {
        DispatchQueue.main.async {
            self.title = viewDataModel.name
            self.nameLabel.text = viewDataModel.name
            self.phoneLabel.text = viewDataModel.phone
            self.addressLabel.text = viewDataModel.address
            if let url = URL(string: viewDataModel.imageURL) {
                self.imageView.load(url: url)
            }
            
            self.detailsStackView.addArrangedSubview(self.nameLabel)
            self.detailsStackView.addArrangedSubview(self.phoneLabel)
            self.detailsStackView.addArrangedSubview(self.addressLabel)
            
            self.mainStackView.addArrangedSubview(self.imageView)
            self.mainStackView.addArrangedSubview(self.detailsStackView)
        }
    }
    
    private func getBusinessDetails() {
        if let businessId = self.businessId {
            self.presenter.getBusinessDetails(id: businessId) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let businessDetailDataModel):
                    self.businessDetailDataModel = businessDetailDataModel
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.coordinator?.showAlerWithTitle(title: "Error", message: error.localizedDescription)
                    }
                }
            }
        }
        
    }
    
}
