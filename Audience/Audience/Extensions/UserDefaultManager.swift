//
//  UserDefaultManager.swift
//  Audience
//
//  Created by 이요한 on 2020/01/03.
//  Copyright © 2020 yo. All rights reserved.
//

import Foundation
import UIKit

class UserDefaultManager {
  
  static let sharedInsatance = UserDefaultManager()
  static let defaults = UserDefaults.standard
  
  
  static func saveMusicList(_ musicName: [String]) {
    defaults.set(musicName, forKey: "musicNameForSave" )
  }
  
  static func getMusicList() -> [String]? {
    return defaults.array(forKey: "musicNameForSave") as? [String]
  }
  
  
}
