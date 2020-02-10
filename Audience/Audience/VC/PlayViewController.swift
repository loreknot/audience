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
  @IBOutlet var timeCurrentLabel: UILabel!
  @IBOutlet var timeRemainingLabel: UILabel!
  @IBOutlet var volumeView: UIView!
  
  @IBOutlet var playButton: UIButton!
  @IBOutlet var previousButton: UIButton!
  @IBOutlet var nextButton: UIButton!
  
  // MARK: - Variable
  var player: AVAudioPlayer?
  var musicInfo = [MusicData]()
  var progressTimer: Timer!
  
  var listVC: ListViewController?
  let currentTimeSelector: Selector = #selector(PlayViewController.updateCurrentTime)
  let remainingTimeSelector: Selector =  #selector(PlayViewController.updateRemainingTime)
  
  // MARK: - Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
  
  
    setVolumeSlder()

    listVC = self.tabBarController?.viewControllers![1] as? ListViewController
    
    
    
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    
      loadTimeData()
      
  }

  // MARK: - Action
  @IBAction func tapPlaybutton(_ sender: Any) {
    
    if listVC!.choiceMusic && listVC!.nowPlaying {
      
      listVC!.playButton.setBackgroundImage(UIImage(systemName: "play.fill"),
                                    for: .normal)
      listVC?.musicPlayer?.pause()
      listVC!.nowPlaying = false
      listVC?.setNotPlayingViewAnimation()
      
      
      playButton.setBackgroundImage(UIImage(systemName: "play.circle.fill"),
      for: .normal)
      
    } else {
      
      
      guard listVC!.choiceMusic else {return}
      
      listVC?.musicPlayer?.play()
      listVC!.playButton.setBackgroundImage(UIImage(systemName: "pause.fill"),
                                    for: .normal)
      listVC?.setNowPlayingAnimation()
      
      playButton.setBackgroundImage(UIImage(systemName: "pause.circle.fill"),
      for: .normal)
      
      if let name = listVC?.musicName {
        listVC?.playViewLabel.text = name
      }
    }
    
  }
  // MARK: - func
  
  func loadTimeData() {
    
    if let player = listVC?.musicPlayer {
      if player.isPlaying {
        
        progressTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: currentTimeSelector, userInfo: nil, repeats: true)
        progressTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: remainingTimeSelector, userInfo: nil, repeats: true)

      }
    }
    
  }
  
  func convertTimeInterval(_ time: TimeInterval) -> String {
    let min = Int(time/60)
    let sec = Int(time.truncatingRemainder(dividingBy: 60))
    let strTime = String(format: "%02d:%02d", min, sec)
    return strTime
  }
  
  func setVolumeSlder() {
    
    let volumeBar = MPVolumeView(frame: volumeView.bounds)
    volumeView.addSubview(volumeBar)
    
    volumeView.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    
    
  }
  
  
  
  @objc func updateCurrentTime() {
    timeCurrentLabel.text = convertTimeInterval((listVC?.musicPlayer!.currentTime)!)
  }
  
  @objc func updateRemainingTime() {
    let duration = Int((listVC?.musicPlayer!.duration)!)
    let cuuretTime = Int((listVC?.musicPlayer!.currentTime)!)
    let ramainingTime = TimeInterval(duration - cuuretTime)
    
    timeRemainingLabel.text = "-" + convertTimeInterval(ramainingTime)
    
  }
  
  
  

    
}

