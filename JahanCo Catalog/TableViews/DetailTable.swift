//
//  DetailTable.swift
//  JahanCo Catalog
//
//  Created by Vahid Ghanbarpour on 7/29/17.
//  Copyright © 2017 Vahid Ghanbarpour. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DetailTable: UITableViewController {

    @IBOutlet var table: UITableView!
    
    var arrRes = [[String:AnyObject]]() //Array of dictionary
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let url = ""
        
        Alamofire.request(url).validate().responseJSON { response in
            switch response.result {
            case .success:
                let swiftyJsonVar = JSON(response.result.value!)
                if let resData = swiftyJsonVar.arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                }
                if self.arrRes.count > 0 {
                    self.table.reloadData()
                } else {
                    let alert = UIAlertController(title: "Error", message:"No such data!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
                    self.present(alert, animated: true){}
                }
            case .failure(let error):
                let alert = UIAlertController(title: "Error", message:"Something is wrong!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
                self.present(alert, animated: true){}
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRes.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DetailCell
        var dict = arrRes[indexPath.row]
        cell.detailTitleLabel?.text = dict["title"] as? String
        cell.detailDescriptionLabel?.text = dict["description"] as? String
        let imageCount = dict["image_count"] as! String
        let ID = dict["id"] as! Int
        let idString = "\(ID)"
        UserDefaults.standard.set(String(describing: imageCount), forKey: "imageC")
        UserDefaults.standard.set(String(describing: idString), forKey: "id")
        UserDefaults.standard.synchronize()
        
        return cell
    }
}
