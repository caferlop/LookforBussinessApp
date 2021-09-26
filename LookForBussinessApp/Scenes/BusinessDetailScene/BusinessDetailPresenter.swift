//
//  BusinessDetailPresenter.swift
//  LookForBussinessApp
//
//  Created by carlos fernandez on 21/9/21.
//

import Foundation
import LookForBussiness

protocol BusinessDetailableInput: AnyObject {
    typealias BusinessDetailsResult = Swift.Result<BusinessDetailsDataModel, Error>
    func getBusinessDetails(id: String, completion: @escaping (BusinessDetailsResult) -> Void)
}

protocol BusinessDetaibaleOutPut: AnyObject {}

typealias BusinesViewDetailable = BusinessDetailableInput & BusinessDetaibaleOutPut

final class BusinessDetailsPresenter: BusinesViewDetailable {
    
    private let getBusinessDetail: BusinessDetailable
    
    init(getBusinessDetail: BusinessDetailable) {
        self.getBusinessDetail = getBusinessDetail
    }
    
    func getBusinessDetails(id: String, completion: @escaping (BusinessDetailsResult) -> Void) {
        let request = GetBusinessDetailEndPoint.getBusinessDetailById(id: id)
        self.getBusinessDetail.getBusinessDetail(request: request) {  result in
            switch result {
            case .success(let businessDetails):
                let businessDetailsDataModel = businessDetails.toBusinessDetailsDataModel()
                completion(.success(businessDetailsDataModel))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

fileprivate extension BusinessDetail {
    func toBusinessDetailsDataModel() -> BusinessDetailsDataModel {
        return BusinessDetailsDataModel(name: self.name,
                                        imageURL: self.imageURL,
                                        phone: self.phone,
                                        reviewCount: self.reviewCount,
                                        rating: self.rating,
                                        address: self.location.address1,
                                        photosURL: self.photos.first ?? "")
    }
}
