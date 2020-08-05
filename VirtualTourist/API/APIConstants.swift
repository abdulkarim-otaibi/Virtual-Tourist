//
//  APIConstants.swift
//  VirtualTourist
//
//  Created by Abdulkrum Alatubu on 12/12/1441 AH.
//  Copyright © 1441 AbdulkarimAlotaibi. All rights reserved.
//

import Foundation

extension API {

    // MARK: Types
    enum API {
        static let Scheme = "https"
        static let Host = "api.flickr.com"
        static let Path = "/services/rest"
    }

    enum Methods {
        static let PhotosSearch = "flickr.photos.search"
    }

    enum ParameterDefaultValues {
        static let APIKey = "8ce27c1015a582e95a0242b92eb7400c"
        static let Format = "json"
        static let NoJsonCallback = "1"
        static let ExtraMediumURL = "url_m"
    }
}
