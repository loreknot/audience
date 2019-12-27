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
    
    init(cover: UIImage?, title: String?, artist: String?) {
        self.cover = cover
        self.title = title
        self.artist = artist
       }
}


class ListViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
  
    
    // MARK: - Outlet and variable
    
    @IBOutlet var playView: UIView!
    @IBOutlet var listTableView: UITableView!
    
    
    var musicInfo: [MusicData] = [MusicData]()
    let fileManager = FileManager.default
   
    
    
    // MARK: - Outlet Action
    
    
    @IBAction func loadMusicList(_ sender: Any) {
        
        musicInfo.removeAll()
        
         let documentsDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].path
        
        var image: UIImage!
        var titleString: String!
        var artistString: String!
        
        do {
            
            let items = try fileManager.contentsOfDirectory(atPath: documentsDir)
            
            for item in items {
                
                let url = URL(fileURLWithPath: item)
                let asset = AVAsset(url: url) as AVAsset
              
                print(url)
                
                for metaDataItems in asset.commonMetadata {
                    
                    if metaDataItems.commonKey?.rawValue == "artwork" {
                       guard let imageData = metaDataItems.value else {return}
                        image = UIImage(data: imageData as! Data)!
                    }
                    
                    if metaDataItems.commonKey?.rawValue == "title" {
                        guard let titleData = metaDataItems.value else {return}
                        titleString = titleData as? String
                    }
                           
                    if metaDataItems.commonKey?.rawValue == "artist" {
                        guard let artistData = metaDataItems.value else {return}
                        artistString = artistData as? String
                    }
                    
                 }
                
                musicInfo.append(MusicData(cover: image, title: titleString, artist: artistString))
                            
            }
            
        } catch {
            print("Not Found item")
        }
        
         listTableView.reloadData()
        
        
    }
    
    
    // MARK: - General func
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playViewBottomRadi()
        cofigureFileSystem()
        
        listTableView.delegate = self
        listTableView.dataSource = self
        
    
    }


    func playViewBottomRadi() {
        
        let path = UIBezierPath(roundedRect:playView.bounds,
                                      byRoundingCorners:[.bottomLeft, .bottomRight],
                                      cornerRadii: CGSize(width: 10, height:  10))

              let maskLayer = CAShapeLayer()

              maskLayer.path = path.cgPath
              playView.layer.mask = maskLayer
    }
    
    
    func cofigureFileSystem() {
        
        let documentsDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].path
        do {
            
            let items = try fileManager.contentsOfDirectory(atPath: documentsDir)
            print("Count \(items.count)")
            for item in items {
                print("Found \(item)")
            }
        } catch {
            print("Not Found item")
        }
        
        
        
        if fileManager.changeCurrentDirectoryPath(documentsDir) {
            print("Current Path :  \(fileManager.currentDirectoryPath)")
        } else {
            print("Fail")
        }
        
//        let fileManager = FileManager.default
//               do {
//               //도큐멘트 파일 경로를 가져옵니다.
//               let destPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
//
//               // 접근한 경로의 디렉토리 내 파일 리스트를 불러옵니다.
//               let items = try fileManager.contentsOfDirectory(atPath: destPath)
//               print("Count \(items.count)")
//                 for item in items {
//                   print("Found \(item)")
//                 }
//               } catch {
//                 print("Not Found item")
//               }

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
    
  
    
    
    
    
}
