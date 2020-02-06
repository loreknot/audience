//
//  ViewController.swift
//  Audience
//
//  Created by 이요한 on 2019/11/20.
//  Copyright © 2019 yo. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer

class PlayViewController: UIViewController {

  // MARK: - Oulet
  
  @IBOutlet var coverImage: UIImageView!
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var artistLabel: UILabel!
  
  @IBOutlet var progressBar: UIProgressView!
  @IBOutlet var timeElapsedLabel: UILabel!
  @IBOutlet var timeRemainingLabel: UILabel!
  @IBOutlet var volumeView: UIView!
  
  @IBOutlet var playButton: UIButton!
  @IBOutlet var previousButton: UIButton!
  @IBOutlet var nextButton: UIButton!
  
  // MARK: - Variable
  
  var musicInfo = [MusicData]()

  
  // MARK: - Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
      
      let volumebar = MPVolumeView(frame: volumeView.bounds)
         volumeView.addSubview(volumebar)
       
      
    }

  
  // MARK: - func
  
  func loadData() {
  
  }
  

    
}

