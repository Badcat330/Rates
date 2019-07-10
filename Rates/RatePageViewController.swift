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

  @IBOutlet weak var tableView: UITableView!{
    didSet{
      let swipe = UISwipeGestureRecognizer(target: self, action: nil)
      swipe.direction = .up
      swipe.delegate = self
      tableView.addGestureRecognizer(swipe)
    }
  }
  
  
  var pairesOfCurrency: [(
    firstRateRedustion: String,
    firstRateFullName: String,
    secondRateredustion: String,
    secondRateFullName: String,
    rate: Double
    )] = []
  
  var rateForBuf: Double?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
  }
  
  func GetRate(firstCurrency: String, secondCurrency: String){
    let url = "https://api.exchangeratesapi.io/latest?base="
      + firstCurrency+"&symbols="
      + firstCurrency+"," + secondCurrency
    
    Alamofire.request(url).responseJSON{
      response in
      switch response.result {
      case .failure(let error):
        // TODO: fix error
        assertionFailure(error.localizedDescription)
      case .success(let data):
        let json = JSON(data)
        let newRate = json["rates"].dictionary![secondCurrency]!.doubleValue
        self.rateForBuf = newRate
      }
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

extension RatePageViewController: UIGestureRecognizerDelegate{
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                         shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    print("Updating start")
    for number in 0 ..< pairesOfCurrency.count{
      GetRate(firstCurrency: pairesOfCurrency[number].firstRateRedustion, secondCurrency: pairesOfCurrency[number].secondRateredustion)
      if let newRate = rateForBuf{
        pairesOfCurrency[number].rate = newRate
      }
    }
    tableView.reloadData()
    print("Updating finish")
    return true
  }
}
