//
//  PaireOfRates.swift
//  Rates
//
//  Created by Alex Glushko on 13/07/2019.
//  Copyright © 2019 Alex Glushko. All rights reserved.
//

import Foundation

struct PaireOfRates: Codable {
  let firstRateRedustion: String
  let firstRateFullName: String
  let secondRateRedustion: String
  let secondRateFullName: String
  var rate: Double
  
  init(firstRateRedustion: String, firstRateFullName: String, secondRateRedustion: String, secondRateFullName: String, rate: Double) {
    self.firstRateFullName = firstRateFullName
    self.firstRateRedustion = firstRateRedustion
    self.secondRateFullName = secondRateFullName
    self.secondRateRedustion = secondRateRedustion
    self.rate = rate
  }
}
