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
  
  var pairesOfCurrency: [(
    firstRateRedustion: String,
    firstRateFullName: String,
    secondRateredustion: String,
    secondRateFullName: String
    )] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    for pair in pairesOfCurrency{
      print(pair)
    }
  }
  
  @IBAction func PlusButtonPress(_ sender: Any) {
    let ViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FirstCurrency") as! FirstCurrencyViewController
    ViewController.loadViewIfNeeded()
    show(ViewController, sender: nil)
  }
}

extension RatePageViewController: UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return pairesOfCurrency.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let rateCell = tableView.dequeueReusableCell(withIdentifier: "RateCell") as! RateTableViewCell
    rateCell.firstRateTitel.text = "1 " + pairesOfCurrency[indexPath.row].firstRateRedustion
    rateCell.firstRateFullName.text = pairesOfCurrency[indexPath.row].firstRateFullName
    rateCell.SecondRateTitel.text = "1 "
    rateCell.SecondRateFullName.text = pairesOfCurrency[indexPath.row].secondRateFullName + "・" + pairesOfCurrency[indexPath.row].secondRateredustion
    return rateCell
  }
}

extension RatePageViewController: UITableViewDelegate{
  //delegate for deleting
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      pairesOfCurrency.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .fade)
    }
  }
}
