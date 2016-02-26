//
//  DetailViewController.swift
//  SuperHeros
//
//  Created by Juan Pablo Villa on 2/23/16.
//  Copyright © 2016 Segundamano.mx. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imageView : UIImageView!
    
    var superHero : SuperHero?
    
    override func viewDidLoad() {
        findSuperHero()
    }
    
    func findSuperHero() {
        if superHero == nil {
            return
        }
        
        let url = NSURL(string: superHero!.image)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        let dataTask = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            if let myImageData = data {
                dispatch_async(dispatch_get_main_queue(), {
                    self.imageView.image = UIImage(data: myImageData)
                })
            }
        })
        
        dataTask.resume()
    }
}
