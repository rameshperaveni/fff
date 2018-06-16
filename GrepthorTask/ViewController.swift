//
//  ViewController.swift
//  GrepthorTask
//
//  Created by brn.developers on 6/7/18.
//  Copyright © 2018 servizon. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var reason=[[String:Any]]()
    
 //   NsArray* afff = [NSaararay alloc]initwitobjects:zzzzzz
    
    
    
  //  let array  = ["","dsgdg"]
    
 
   
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reason.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.reasonLbl.text=reason[indexPath.row]["reason_note"] as? String
        cell.quantityLbl.text=reason[indexPath.row]["quantity"] as? String
        cell.titleLbl.text=reason[indexPath.row]["title"] as? String
        cell.stockLbl.text=reason[indexPath.row]["stock_id"] as? String
        cell.typeLbl.text=reason[indexPath.row]["type"] as? String
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    @IBOutlet weak var myTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        url1()
        url2()
        myTableView.delegate=self
        myTableView.dataSource=self
        let nibName=UINib(nibName: "TableViewCell", bundle: nil)
        myTableView.register(nibName, forCellReuseIdentifier: "TableViewCell")
        myTableView.estimatedRowHeight=180
        myTableView.rowHeight=UITableViewAutomaticDimension
        myTableView.isEditing=true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle==UITableViewCellEditingStyle.delete
        {
            self.reason.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.middle)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
func url1()
{
    let url = URL(string: "http://cyanous.com/projects/multivendor/index.php/Api_vendor/getStockdetail")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    let postString = "vendor_id=8"
    request.httpBody = postString.data(using: .utf8)
    URLSession.shared.dataTask(with: request) { data, response, error in
    guard let data = data, error == nil else {
    print("error=\(String(describing: error))")
    return }
        do
        {
        let content = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments) as! [[String:[[String:Any]]]]
            DispatchQueue.main.async {
            let stock = content[0] as [String:[[String:Any]]]
            let stockData=stock["stock"] as! [[String:Any]]
            for i in 0..<stockData.count
            {
            self.reason.append(stockData[i])
            }
            print(self.reason)
                self.myTableView.reloadData()
            }
        } catch{ }
    }.resume()
    }
}
func url2()
{
    let url = URL(string: "http://cyanous.com/projects/multivendor/index.php/Api_vendor/deleteStock")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    let postString = "stock_id=80"
    request.httpBody = postString.data(using: .utf8)
    URLSession.shared.dataTask(with: request) { data, response, error in
    guard let data = data, error == nil else {
    print("error=\(String(describing: error))")
    return }
        do
        {
        let content = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments) as! [String:Any]
            print(content)
        } catch{ }
        }.resume()
}

