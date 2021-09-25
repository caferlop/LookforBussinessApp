//
//  BusinessDetailSceneComposer.swift
//  LookForBussinessApp
//
//  Created by carlos fernandez on 21/9/21.
//

import Foundation
import LookForBussiness

public final class BusinessDetailSceneComposer {
    private init(){}
    static func makeBusinessDetailsPresenter(getBusinessesDetails: BusinessDetailable) -> BusinesViewDetailable {
        return BusinessDetailsPresenter(getBusinessDetail:getBusinessesDetails)
    }
    static func makeBusinessDetailsViewController(getBusinessDetails: BusinessDetailable) -> BusinessDetailsViewController {
        let presenter = makeBusinessDetailsPresenter(getBusinessesDetails: getBusinessDetails)
        return BusinessDetailsViewController(presenter: presenter)
    }
}
