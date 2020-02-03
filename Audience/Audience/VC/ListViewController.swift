//
//  IndexViewController.swift
//  Audience
//
//  Created by 이요한 on 2019/12/06.
//  Copyright © 2019 yo. All rights reserved.
//

import UIKit
import AVFoundation



struct MusicData {

    var cover: UIImage?
    var title: String?
    var artist: String?
    var musicName: String?
    
    init(cover: UIImage?, title: String?, artist: String?, musicName: String?) {
        self.cover = cover
        self.title = title
        self.artist = artist
        self.musicName = musicName
    }
}




class ListViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
 
  
  // MARK: - Outlet
  
  @IBOutlet var listTableView: UITableView!
  
  @IBOutlet var playView: UIView!
  @IBOutlet var playButton: UIButton!
  @IBOutlet var playViewCoverImage: UIImageView!
  @IBOutlet var playViewLabel: UILabel!
  
  @IBOutlet var imageViewLeftConstraint: NSLayoutConstraint!
  @IBOutlet var imageViewRightConstraint: NSLayoutConstraint!
  @IBOutlet var imageViewLastConstraint: NSLayoutConstraint!
  
  @IBOutlet var test: UIButton!
  
  
  // MARK: - variable
  
  var musicPlayer: AVAudioPlayer?
  var musicInfo = [MusicData]()
  var musicURL: URL?
  var nextMusicURL: URL?
  
  var musicName: String?
  
  var nowPlaying = false
  var choiceMusic = false
  var selectedRow: Int?

  let fileManager = FileManager.default
  
    
  // MARK: - Outlet Action
  
  @IBAction func tapPlayButton(_ sender: Any) {
    
    if choiceMusic && nowPlaying {
      
      playButton.setBackgroundImage(UIImage(systemName: "play.fill"),
                                    for: .normal)
      musicPlayer?.pause()
      nowPlaying = false
      setNotPlayingViewAnimation()
      
      
      
    } else {
      
      guard choiceMusic else {return}
      musicPlayer?.play()
      playButton.setBackgroundImage(UIImage(systemName: "pause.fill"),
                                    for: .normal)
      setNowPlayingAnimation()
      
      if let name = musicName {
        playViewLabel.text = name
      }
    }
  }
  
  
  
  @IBAction func nextButton(_ sender: Any) {
    
    guard choiceMusic else {return}
    
    if selectedRow! == musicInfo.count - 1 {
      selectedRow = -1
    }
    
    guard selectedRow! < musicInfo.count - 1 else {return} // 마지막 리스트 일 때
    
    
    selectedRow = selectedRow! + 1
    listTableView.selectRow(at: IndexPath(row: selectedRow!, section: 0),
                            animated: true,
                            scrollPosition: .top)
    
    
    let documentsDir = fileManager.urls(for: .documentDirectory,
                                        in: .userDomainMask)
    
    let nextMusicFile = musicInfo[selectedRow!].musicName
    let nextMusicCover = musicInfo[selectedRow!].cover
    
    if let documentPath: URL = documentsDir.first {
      let nextMusicPath = documentPath.appendingPathComponent(nextMusicFile!)
      
      nextMusicURL = nextMusicPath
      
      if nowPlaying == true {
        
        playMusic(url: nextMusicURL!)
        
        setNowPlayingAnimation()
        playViewLabel.text = nextMusicFile
        playViewCoverImage.image = nextMusicCover
        
      } else {
        
        musicName = nextMusicFile
        playViewCoverImage.image = nextMusicCover
        
//        playButton.setBackgroundImage(UIImage(systemName: "pause.fill"),
//                                      for: .normal)
      }
      
    }
    
  }
  
  
  // MARK: - func
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    playViewBottomRadi()
    cofigureFileSystem()
    
    listTableView.delegate = self
    listTableView.dataSource = self
    
    setNotPlayingLabel()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(false)
    
    loadMusicList()
  }
  
  
  func playViewBottomRadi() {
    
    let path = UIBezierPath(roundedRect:playView.bounds,
                            byRoundingCorners:[.bottomLeft, .bottomRight],
                            cornerRadii: CGSize(width: 7, height:  7))
    
    let maskLayer = CAShapeLayer()
    
    maskLayer.path = path.cgPath
    playView.layer.mask = maskLayer
  }
  
  
  func cofigureFileSystem() {
    
    let documentsDir = fileManager.urls(for: .documentDirectory,
                                        in: .userDomainMask)[0].path
    
    do {
      let items = try fileManager.contentsOfDirectory(atPath: documentsDir)
      for item in items {
        print("Found : \(item)")
      }
    } catch {
      print("Not Found item")
    }
    
    if fileManager.changeCurrentDirectoryPath(documentsDir) {
      print("Current Path :  \(fileManager.currentDirectoryPath)")
    } else {
      print("Fail")
    }
  }
  
  
  func playMusic(url: URL) {
    
    do {
      musicPlayer = try AVAudioPlayer(contentsOf: url)
      print(url)
      musicPlayer?.prepareToPlay()
      musicPlayer?.play()
      
    } catch {
    }
    
    //       do {
    //            try AVAudioSession.sharedInstance().setCategory(.playback,
    //      mode: .default, options: [.mixWithOthers, .allowAirPlay])
    //            print("Playback OK")
    //            try AVAudioSession.sharedInstance().setActive(true)
    //            print("Session is Active")
    //        } catch {
    //            print(error)
    //        }
  }
  
  
  func loadMusicList() {
    
    musicInfo.removeAll()
    
    let documentsDir = fileManager.urls(for: .documentDirectory,
                                        in: .userDomainMask)[0].path
    
    var image: UIImage!
    //var titleString: String!
    var artistString: String!
    var musicName: String!
    
    do {
      let items = try fileManager.contentsOfDirectory(atPath: documentsDir)
      
      for item in items {
        
        let url = URL(fileURLWithPath: item)
        let asset = AVAsset(url: url) as AVAsset
        musicName = item
        
        // artwork image 얻기
        let meta = asset.commonMetadata.filter
        { $0.commonKey?.rawValue == "artwork"}
        
        if meta.count > 0 {
          let imageData = meta[0].value
          image = UIImage(data: imageData as! Data)
        } else {
          image = UIImage(named: "noImage")
        }
        
        for metaDataItems in asset.commonMetadata {
          //                    if metaDataItems.commonKey?.rawValue == "title" {
          //                        guard let titleData = metaDataItems.value else {return}
          //                        titleString = titleData as? String
          //                    }
          if metaDataItems.commonKey?.rawValue == "artist" {
            guard let artistData = metaDataItems.value else {return}
            artistString = artistData as? String
          }
        }
        musicInfo.append(MusicData(cover: image,
                                   title: musicName,
                                   artist: artistString,
                                   musicName: musicName))
        
      }
      
    } catch {
      print("Not Found item")
    }
    musicInfo.reverse()
    listTableView.reloadData()
    
  }
  
  func setNotPlayingLabel() {
    
    let removeConstraint: CGFloat = -30
    imageViewLeftConstraint.constant = imageViewLeftConstraint.constant + removeConstraint
    imageViewRightConstraint.constant = imageViewRightConstraint.constant + removeConstraint
    imageViewLastConstraint.constant = 20
    self.playViewLabel.text = "Not playing"
  }
  
  func setNowPlayingAnimation() {
    
    UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 20.0, options: .curveEaseInOut, animations: {
        
      self.imageViewLeftConstraint.constant = self.imageViewLeftConstraint.constant - 30
      self.imageViewRightConstraint.constant = self.imageViewRightConstraint.constant - 30
    
      self.view.layoutIfNeeded()
        
      }, completion: nil)
    
    if nowPlaying {
      UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 20.0, options: .curveEaseInOut, animations: {
          
        self.imageViewLeftConstraint.constant = self.imageViewLeftConstraint.constant + 30
        self.imageViewRightConstraint.constant = self.imageViewRightConstraint.constant + 30
        self.imageViewLastConstraint.constant = 5
        
        self.view.layoutIfNeeded()
        self.playViewCoverImage.isHidden = false
        
        }, completion: nil)
      
      
      
    } else {
      UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 20.0, options: .curveEaseInOut, animations: {
            
            self.imageViewLeftConstraint.constant = self.imageViewLeftConstraint.constant + 60
             self.imageViewRightConstraint.constant = self.imageViewRightConstraint.constant + 60
             self.imageViewLastConstraint.constant = 0
           
             self.view.layoutIfNeeded()
             self.playViewCoverImage.isHidden = false
        
             }, completion: nil)
      
       nowPlaying = true
    }
    
    
  }
  
  func setPlayViewAnimation() {
    UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 40, options: .curveEaseInOut, animations: {
      
      self.imageViewLeftConstraint.constant = self.imageViewLeftConstraint.constant + 30
      self.imageViewRightConstraint.constant = self.imageViewRightConstraint.constant + 30
      self.imageViewLastConstraint.constant = 0

      self.playViewCoverImage.isHidden = false
      self.view.layoutIfNeeded()
      
    }, completion: nil)
  }
  
  func setNotPlayingViewAnimation() {
    UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 20.0, options: .curveEaseInOut, animations: {
      
      self.setNotPlayingLabel()
      self.playViewCoverImage.isHidden = true
      self.view.layoutIfNeeded()
      
    }, completion: nil)
  }
  
  
  // MARK: - TableView Delegate
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    musicInfo.count
  }
  
  
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = listTableView.dequeueReusableCell(withIdentifier: "ListTableViewCell",
                                                 for: indexPath) as! ListTableViewCell
    
    let model = musicInfo[indexPath.row]
    
    cell.coverImage.image = model.cover
    cell.titleLabel.text = model.title
    cell.artistLabel.text = model.artist
    
    return cell
  }
  
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let documentsDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
    let musicFile = musicInfo[indexPath.row]
    
    musicName = musicFile.musicName
    
    playViewLabel.text = musicFile.musicName
    playViewCoverImage.image = musicFile.cover
    
    if let documentPath: URL = documentsDir.first {
      let musicPath = documentPath.appendingPathComponent(musicFile.musicName!)
      musicURL = musicPath
      
      selectedRow = indexPath.row
      
      playMusic(url: musicURL!)
      choiceMusic = true
      
    }
    playButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
   
    setNowPlayingAnimation()
    
    
  }
  
  
  
}
