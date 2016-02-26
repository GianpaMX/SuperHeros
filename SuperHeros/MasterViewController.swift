//
//  MasterViewController.swift
//  SuperHeros
//
//  Created by Juan Pablo Villa on 2/23/16.
//  Copyright © 2016 Segundamano.mx. All rights reserved.
//

import Foundation

import UIKit

class MasterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView : UITableView!
    
    var superHeros = [SuperHero]()
    
    override func viewDidLoad() {
        superHeros.append(SuperHero(name: "Ironman", realName: "Tony Stark", image: "https://vignette2.wikia.nocookie.net/marvel-contestofchampions/images/f/fb/Iron_Man_preview.png/revision/latest?cb=20150830074258"))
        superHeros.append(SuperHero(name: "Hulk", realName: "Bruce Banner", image: "https://vignette2.wikia.nocookie.net/marvel-contestofchampions/images/5/57/Hulk_preview.png/revision/latest?cb=20150825224301"))
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = superHeros[indexPath.row].name
        
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
}
