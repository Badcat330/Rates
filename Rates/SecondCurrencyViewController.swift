//
//  SecondcurrencyViewController.swift
//  Rates
//
//  Created by Alex Glushko on 07/07/2019.
//  Copyright © 2019 Alex Glushko. All rights reserved.
//

import UIKit

class SecondCurrencyViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
   let lines = try! String(contentsOfFile: Bundle.main.path(forResource: "Currency", ofType: "txt")!).split{$0.isNewline}
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource=self
  }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
