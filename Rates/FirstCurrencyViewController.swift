//
//  FirstCurrencyViewController.swift
//  Rates
//
//  Created by Alex Glushko on 07/07/2019.
//  Copyright © 2019 Alex Glushko. All rights reserved.
//

import UIKit

class FirstCurrencyViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  
  let lines = try! String(contentsOfFile: Bundle.main.path(forResource: "Currency", ofType: "txt")!).split{$0.isNewline}
  
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
      tableView.delegate = self
    }
}

extension FirstCurrencyViewController : UITableViewDataSource{
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

extension FirstCurrencyViewController : UITableViewDelegate{
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
    let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SecondCurrency") as! SecondCurrencyViewController
    viewController.loadViewIfNeeded()
    let selectedCell = tableView.cellForRow(at: indexPath) as! CurrencyTableViewCell
    viewController.previousSelection = selectedCell.reductionLabel[0].text
    show(viewController, sender: nil)
  }
}
