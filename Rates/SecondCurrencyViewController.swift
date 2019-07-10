//
//  SecondcurrencyViewController.swift
//  Rates
//
//  Created by Alex Glushko on 07/07/2019.
//  Copyright © 2019 Alex Glushko. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON



class SecondCurrencyViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  var vSpinner: UIView?
  let lines = try! String(contentsOfFile: Bundle.main.path(forResource: "Currency", ofType: "txt")!).split{$0.isNewline}
  var rate: Double?{
    didSet{
      
      if let rateViewController = (navigationController?.viewControllers[0] as? RatePageViewController){
        let pairOfRates = (previousSelection[0],
                           previousSelection[1],
                           nowSelection[0],
                           nowSelection[1],
                           rate)
        rateViewController.loadViewIfNeeded()
        rateViewController.pairesOfCurrency.append(pairOfRates as! (firstRateRedustion: String, firstRateFullName: String, secondRateredustion:    String, secondRateFullName: String, rate: Double ))
        rateViewController.tableView.reloadData()
        self.removeSpinner()
        navigationController?.popToViewController(rateViewController, animated: true)
      }
    }
  }
  
  var previousSelection: [String] = []
  var nowSelection: [String] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate = self
  }
  
  func GetRate(firstCurrency: String, secondCurrency: String){
      showSpinner(onView: self.view)
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
          if let newRate = json["rates"].dictionary?[secondCurrency]?.doubleValue{
            self.rate = newRate
          }
        }
      }
    }
  
}

extension SecondCurrencyViewController : UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return lines.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "PikerCell", for: indexPath) as! CurrencyTableViewCell
    let cellDataStrings = lines[indexPath.row].split(separator: " ")
    for label in cell.reductionLabel{
      label.text = String(cellDataStrings[0])
    }
    for label in cell.fullNameLabel{
      label.text = String(cellDataStrings[2])
    }
    return cell
  }
}



extension SecondCurrencyViewController: UITableViewDelegate{
  //delgate for pressing row
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
    let selectedCell = tableView.cellForRow(at: indexPath) as! CurrencyTableViewCell
    nowSelection.append(selectedCell.reductionLabel[0].text!)
    nowSelection.append(selectedCell.fullNameLabel[0].text!)
    GetRate(firstCurrency: previousSelection[0], secondCurrency: nowSelection[0])
  }
}

extension SecondCurrencyViewController {
  // spiner indecator declaration
  func showSpinner(onView : UIView) {
    let spinnerView = UIView.init(frame: onView.bounds)
    spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
    let ai = UIActivityIndicatorView.init(style: .whiteLarge)
    ai.startAnimating()
    ai.center = spinnerView.center
    
    DispatchQueue.main.async {
      spinnerView.addSubview(ai)
      onView.addSubview(spinnerView)
    }
    
    vSpinner = spinnerView
  }
  
  func removeSpinner() {
    DispatchQueue.main.async {
      self.vSpinner?.removeFromSuperview()
      self.vSpinner = nil
    }
  }
}
