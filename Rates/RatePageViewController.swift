//
//  ViewController.swift
//  Rates
//
//  Created by Alex Glushko on 07/07/2019.
//  Copyright © 2019 Alex Glushko. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RatePageViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!

  let refreshControl = UIRefreshControl()
  
  var pairesOfCurrency: [(
    firstRateRedustion: String,
    firstRateFullName: String,
    secondRateredustion: String,
    secondRateFullName: String,
    rate: Double
    )] = []
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate = self
    refreshControl.addTarget(self, action: #selector(Updating), for: .valueChanged)
    tableView.refreshControl = refreshControl
  }
  
  @objc func Updating(){
    for number in 0 ..< pairesOfCurrency.count{
      let url = "https://api.exchangeratesapi.io/latest?base="
        + pairesOfCurrency[number].firstRateRedustion+"&symbols="
        + pairesOfCurrency[number].firstRateRedustion+"," + pairesOfCurrency[number].secondRateredustion
      print(url)
      Alamofire.request(url).responseJSON{
        response in
        switch response.result {
        case .failure:
          let alert = UIAlertController(title: "No internet connection!",
                                        message: "Your device has problems with internet connection. Plese connect the internet!",
                                        preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
          self.present(alert, animated: true)
        case .success(let data):
          let json = JSON(data)
          let newRate = json["rates"].dictionary![self.pairesOfCurrency[number].secondRateredustion]!.doubleValue
          self.pairesOfCurrency[number].rate = newRate
        }
      }
    }
    tableView.reloadData()
    self.refreshControl.endRefreshing()
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
    rateCell.SecondRateFullName.text = pairesOfCurrency[indexPath.row].secondRateFullName + "・" + pairesOfCurrency[indexPath.row].secondRateredustion
    rateCell.SecondRateTitel.text = String(format: "%.3f", pairesOfCurrency[indexPath.row].rate)
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


