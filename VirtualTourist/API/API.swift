//
//  API.swift
//  VirtualTourist
//
//  Created by Abdulkrum Alatubu on 12/12/1441 AH.
//  Copyright © 1441 AbdulkarimAlotaibi. All rights reserved.
//

import Foundation

class API {
    
    
    static func  baseURL (lat:String, lon :String)-> URL? {
        
        var components = URLComponents()
        components.scheme = API.Scheme
        components.host = API.Host
        components.path = API.Path
        components.queryItems = [
            URLQueryItem(name: "method", value: "flickr.photos.search"),
            URLQueryItem(name: "api_key", value: "8ce27c1015a582e95a0242b92eb7400c"),
            URLQueryItem(name: "content_type", value: "1"),
            URLQueryItem(name: "lat", value: lat),
            URLQueryItem(name: "lon", value: lon),
            URLQueryItem(name: "extras", value: "url_s"),
            URLQueryItem(name: "per_page", value: "20"),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "nojsoncallback", value: "1")
        ]
        
        
        return components.url
    }
    
    
    
    
    static func getURL(latitude: String, longitude: String, completion: @escaping (PhotoAlbumData?, String?)->Void) {
        
        guard let url = baseURL(lat: latitude, lon: longitude)
           
            else {
                completion(nil ,"Supplied url is invalid")
                return
        }
         print(url)
        var errString: String?
        let request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            var photoAlbumData: PhotoAlbumData?
            if let statusCode = (response as? HTTPURLResponse)?.statusCode { //Request sent succesfully
                if statusCode >= 200 && statusCode < 300 { //Response is ok
                    
                    do {
                        photoAlbumData = try JSONDecoder().decode(PhotoAlbumData.self, from: data!)
                    } catch {
                        errString = "there is some error on read data"
                    }
                }else{
                    errString = "\(String(describing: error))"
                    
                }
                
            }else{
                errString = "Check your internet connection"
            }
            
            DispatchQueue.main.async {
                completion(photoAlbumData, errString)
            }
            
        }
        task.resume()
    }
}
