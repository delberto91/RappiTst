//
//  Extensions.swift
//  Rappi
//
//  Created by Delberto Martinez on 5/19/19.
//  Copyright © 2019 Delberto Martinez. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    //Public func to download image url 
    public func downloadImage(downloadURL : String, completion: @escaping (Bool?) -> ()) {
        if (self.image == nil){
            self.image = UIImage(named: "profileDefault")
        }
        //let imageSufix =  "profile-" + userAppfterId
        //self.image = UIImage(named: "profileDefault")
        if(downloadURL != ""){
            URLSession.shared.dataTask(with: URL(string: downloadURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!, completionHandler: { (data, response, error) -> Void in
                guard
                    let httpURLResponse = response as? HTTPURLResponse , httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType , mimeType.hasPrefix("image"),
                    let data = data , error == nil,
                    let imageLocal = UIImage(data: data)
                    else {

                        completion(true)
                        return
                }
                
                
                DispatchQueue.main.async { () -> Void in
                    
                    self.image =  imageLocal
                    completion(true)

                }
            }).resume()
        }else{
            completion(true)
        }
        
        
        
    }
}


