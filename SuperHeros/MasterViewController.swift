//
//  MasterViewController.swift
//  SuperHeros
//
//  Created by Juan Pablo Villa on 2/23/16.
//  Copyright © 2016 Segundamano.mx. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class MasterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView : UITableView!
    
    var superHeros = [SuperHero]()
    
    let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    
    override func viewDidLoad() {
        findRealmAvangerList()
        findAvangerList()
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : CustomTableViewCell = tableView.dequeueReusableCellWithIdentifier("Custom", forIndexPath: indexPath) as! CustomTableViewCell
        
        let superHero = superHeros[indexPath.row]
        
        let url = NSURL(string: superHero.image)
        
        let dataTask = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            if let myImageData = data {
                dispatch_async(dispatch_get_main_queue(), {
                    cell.imageView!.image = UIImage(data: myImageData)
                    self.tableView.reloadData()
                })
            }
        })
        dataTask.resume()

        
        cell.nameLabel.text = superHero.name
        cell.realNameLabel.text = superHero.realName
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return superHeros.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailViewController = storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        
        detailViewController.superHero = superHeros[indexPath.row]
        
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func findRealmAvangerList() {
        superHeros.removeAll()
        
        let realm = try! Realm()
        
        let realSuperHeroList : Results<RealmSuperHero> = realm.objects(RealmSuperHero)
        for realmSuperHero in realSuperHeroList {
            superHeros.append(SuperHero(realmSuperHero: realmSuperHero))
        }
        tableView.reloadData()
    }
    
    func findAvangerList() {
        let url = NSURL(string: "http://codigoambar.herokuapp.com/avengers")
        let task = session.dataTaskWithURL(url!, completionHandler: { data, response, error -> Void in
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                if let jsonSuperHeros = json["avengers"] as? [[String:String]] {
                    let realm = try! Realm()
                    
                    realm.beginWrite()
                    let realSuperHeroList : Results<RealmSuperHero> = realm.objects(RealmSuperHero)
                    for realmSuperHero in realSuperHeroList {
                        realm.delete(realmSuperHero)
                    }
                    try! realm.commitWrite()
                    
                    for jsonSuperHero in jsonSuperHeros {
                        if let superHeroObject = jsonSuperHero as? [String: String] {
                            if let name = superHeroObject["name"], let realName = superHeroObject["realName"], let image = superHeroObject["image"] {
                                let realmSuperHero = RealmSuperHero()
                                realmSuperHero.name = name
                                realmSuperHero.realName = realName
                                realmSuperHero.image = image
                                
                                let realm = try! Realm()
                                try! realm.write({ () -> Void in
                                    realm.add(realmSuperHero)
                                })
                            }
                        }
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.findRealmAvangerList()
                    })
                }
            } catch {
                print("")
            }
        })
        task.resume()
    }
}
