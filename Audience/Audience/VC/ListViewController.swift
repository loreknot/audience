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
    // MARK: - Outlet and variable
    

    @IBOutlet var listTableView: UITableView!
    
    @IBOutlet var playView: UIView!
    @IBOutlet var playButton: UIButton!
    
    
    var musicPlayer: AVAudioPlayer?
    var musicInfo: [MusicData] = [MusicData]()
    var musicURL: URL?
    
    var nowPlaying = false
    var musicChoice = false
    var nextRow: Int?
    
    let fileManager = FileManager.default
    
    
    // MARK: - Outlet Action
    
    @IBAction func tapPlayButton(_ sender: Any) {
        
        if musicChoice && nowPlaying {
            
            playButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
            musicPlayer?.pause()
            nowPlaying = false
        
        } else {
         
            guard musicChoice else {return}
            playMusic(url: musicURL!)
            playButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
            nowPlaying = true
            
        }
    }
    
    
    @IBAction func nextButton(_ sender: Any) {
        
        
        
        guard musicChoice else {return}
        listTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
        
    
    }
    
    
    // MARK: - General func
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playViewBottomRadi()
        cofigureFileSystem()
        
        listTableView.delegate = self
        listTableView.dataSource = self
        
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
        
        let documentsDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].path
        
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
            musicPlayer?.volume = 1.0
            musicPlayer?.play()
            
        } catch {
        }
        
//       do {
//            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowAirPlay])
//            print("Playback OK")
//            try AVAudioSession.sharedInstance().setActive(true)
//            print("Session is Active")
//        } catch {
//            print(error)
//        }
    }
    
    
    func loadMusicList() {
        
         musicInfo.removeAll()
                
                let documentsDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].path
                
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
                        let meta = asset.commonMetadata.filter { $0.commonKey?.rawValue == "artwork"}
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
                        musicInfo.append(MusicData(cover: image, title: musicName, artist: artistString, musicName: musicName))
                        
                    }
                    
                } catch {
                    print("Not Found item")
                }
                musicInfo.reverse()
                listTableView.reloadData()

    }
    
    
// MARK: - TableView Delegate
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        musicInfo.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listTableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
        
        let model = musicInfo[indexPath.row]
        
        cell.coverImage.image = model.cover
        cell.titleLabel.text = model.title
        cell.artistLabel.text = model.artist
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let documentsDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let musicFile = musicInfo[indexPath.row].musicName
        
        if let documentPath: URL = documentsDir.first {
            let musicPath = documentPath.appendingPathComponent(musicFile!)
            musicURL = musicPath
            
            playMusic(url: musicURL!)
            nowPlaying = true
            musicChoice = true
        }
        
        if nowPlaying == true {
            playButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
            
        }
        
    }
    
    
    
}
