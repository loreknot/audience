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
import JellySlider
import fluid_slider

class PlayViewController: UIViewController {

  // MARK: - Oulet
  
  @IBOutlet var coverImage: UIImageView!
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var artistLabel: UILabel!
  @IBOutlet var coverOuterView: UIView!
  
  @IBOutlet var progressBar: UIProgressView!
  @IBOutlet var timeCurrentLabel: UILabel!
  @IBOutlet var timeRemainingLabel: UILabel!
  @IBOutlet var volumeView: UIView!
  
  @IBOutlet var playButton: UIButton!
  @IBOutlet var previousButton: UIButton!
  @IBOutlet var nextButton: UIButton!
  
  // MARK: - Variable
  var progressTimer: Timer!
  
  var listVC: ListViewController?
  
  let currentTimeSelector: Selector = #selector(PlayViewController.updateCurrentTime)
  let remainingTimeSelector: Selector =  #selector(PlayViewController.updateRemainingTime)
  let progressTimeSelector: Selector =  #selector(PlayViewController.updateProgressTime)

  var slider: Slider!
  var jellySlider: JellySlider!
  
  // MARK: - Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
  
    listVC = self.tabBarController?.viewControllers![1] as? ListViewController
    
    setFluidSlider()
    setCoverImage()
    setVolumeSlder()
    
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
  
  @IBAction func firstTimePreviousButton(_ sender: Any) {
    
    listVC?.musicPlayer?.currentTime = (listVC?.musicPlayer!.currentTime)! - 5
    
  }
  
  
  
  // MARK: - func
  
  
  
  func loadTimeData() {
    
    if let player = listVC?.musicPlayer {
      if player.isPlaying {
        progressTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: currentTimeSelector, userInfo: nil, repeats: true)
        progressTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: remainingTimeSelector, userInfo: nil, repeats: true)
        progressTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: progressTimeSelector, userInfo: nil, repeats: true)
      }
    }
  }
  
  func setCoverImage() {
    coverOuterView.layer.cornerRadius = 20
    coverOuterView.layer.shadowOffset = CGSize(width: 0.0, height: 10)
    coverOuterView.layer.shadowRadius = 20
    coverOuterView.layer.shadowOpacity = 0.4
    coverOuterView.layer.shadowPath = UIBezierPath(roundedRect: coverImage.bounds, cornerRadius: 20).cgPath
    
    coverImage.layer.cornerRadius = 20
    coverImage.clipsToBounds = true
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
    
  
  func setJellySlider() {
    
    let uiTintColor = UIColor(hue: 0.6, saturation: 0.35, brightness: 0.8, alpha: 0.8)
    let sliderFrame = CGRect(x: 50, y: view.bounds.height * 0.5, width:  view.bounds.width * 0.74, height: 40)
    
    jellySlider = JellySlider(frame: sliderFrame)
    jellySlider.trackColor = uiTintColor
    jellySlider.sizeToFit()
    view.addSubview(jellySlider)
    
    jellySlider.onValueChange = { value in
      var hue: CGFloat = 0
      var sat: CGFloat = 0
      var bri: CGFloat = 0
      var alp: CGFloat = 0
      uiTintColor.getHue(&hue, saturation: &sat, brightness: &bri, alpha: &alp)
      
      let adjustedColor = UIColor(hue: value/1, saturation: sat, brightness: bri, alpha: alp)
  
      CATransaction.begin()
      CATransaction.setValue(true, forKey: kCATransactionDisableActions)
      self.jellySlider.trackColor = adjustedColor
      CATransaction.commit()
      
    }
    
     
    
  }

  
  
  func setFluidSlider() {

    let sliderFrame = CGRect(x: 48, y: view.bounds.height * 0.58, width:  view.bounds.width * 0.75, height: 19)
     
    slider = Slider(frame: sliderFrame)
    
    slider.sizeToFit()
    view.addSubview(slider)
    
    let labelTextAttributes: [NSAttributedString.Key : Any] = [.font: UIFont.systemFont(ofSize: 12, weight: .medium), .foregroundColor: UIColor.white]
    
    if let player = listVC?.musicPlayer {
    
      let currenTime = CGFloat((player.currentTime))
      let duration = CGFloat(player.duration)
      slider.fraction = currenTime/duration
      
      player.currentTime = TimeInterval(slider.fraction/duration)
    
    } else {
      slider.fraction = 0
    }
    
    slider.setMinimumLabelAttributedText(NSAttributedString(string: "", attributes: labelTextAttributes))
    slider.setMaximumLabelAttributedText(NSAttributedString(string: "", attributes: labelTextAttributes))
    
    slider.shadowOffset = CGSize(width: 0, height: 10)
    slider.shadowBlur = 5
    slider.shadowColor = UIColor(white: 0, alpha: 0.1)
    slider.contentViewColor = #colorLiteral(red: 0.4244939621, green: 0.7339108379, blue: 0.5933058707, alpha: 1)
      //UIColor(red: 78/255.0, green: 77/255.0, blue: 224/255.0, alpha: 1)
    slider.valueViewColor = .white
    
    
    slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
    
    
  }
  
  
  

  
  // MARK: - Selector
  
  @objc func updateCurrentTime() {
    timeCurrentLabel.text = convertTimeInterval((listVC?.musicPlayer!.currentTime)!)
  }
  
  @objc func updateRemainingTime() {
    let duration = Int((listVC?.musicPlayer!.duration)!)
    let curretTime = Int((listVC?.musicPlayer!.currentTime)!)
    let ramainingTime = TimeInterval(duration - curretTime)
    
    timeRemainingLabel.text = "-" + convertTimeInterval(ramainingTime)
  }
  
  @objc func updateProgressTime()  {
      let currenTime = CGFloat((listVC?.musicPlayer!.currentTime)!)
      let duration = CGFloat((listVC?.musicPlayer!.duration)!)
      slider.fraction = currenTime/duration
    
  }
  
  @objc func sliderValueChanged() {
    if let player = listVC?.musicPlayer {
      let duration = CGFloat((player.duration))
      let progress = TimeInterval(duration * slider.fraction  )
      listVC?.musicPlayer?.currentTime = progress

    }
  }
  

    
}

