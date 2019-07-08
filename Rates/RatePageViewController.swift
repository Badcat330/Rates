//
//  ViewController.swift
//  Rates
//
//  Created by Alex Glushko on 07/07/2019.
//  Copyright © 2019 Alex Glushko. All rights reserved.
//

import UIKit
import Foundation

class RatePageViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  var pairesOfCurrency: [String:String] = [:]
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func PlusButtonPress(_ sender: Any) {
    let ViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FirstCurrency") as! FirstCurrencyViewController
    ViewController.loadViewIfNeeded()
    show(ViewController, sender: nil)
  }
}

