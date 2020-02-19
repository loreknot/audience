//
//  AddVIewController.swift
//  Audience
//
//  Created by 이요한 on 2020/02/17.
//  Copyright © 2020 yo. All rights reserved.
//

import UIKit
import AVFoundation

class AddViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource {
  
  // MARK: - Outlet
  
  
  @IBOutlet var listTableView: UITableView!
  
  // MARK: - Variable
  var delegate: reloadDelegate?
  var musicIndex = [MusicData]()
  var musicSelected = [String]()

  
  let fileManager = FileManager.default
  
  
  // MARK: - Cycle
   
   override func viewDidLoad() {
     super.viewDidLoad()
    
    listTableView.delegate = self
    listTableView.dataSource = self
    
    listTableView.isEditing = true
    listTableView.setEditing(true, animated: true)
    listTableView.allowsMultipleSelectionDuringEditing = true
    
    
    loadMusicData()
  }
     
  // MARK: - Action
  
  @IBAction func tapAddButton(_ sender: Any) {
    
    
    if let index = UserDefaultManager.getMusicList() {
      let append = index + musicSelected
      UserDefaultManager.saveMusicList(append)
    } else {
      UserDefaultManager.saveMusicList(musicSelected)
    }
    
    
    self.dismiss(animated: true)
    delegate?.reloadTableView()
    
  }
  
  // MARK: - func
  
  func loadMusicData() {
    
    let documentsDir = fileManager.urls(for: .documentDirectory,
                                        in: .userDomainMask)[0].path
    
    fileManager.changeCurrentDirectoryPath(documentsDir)
    
    var image: UIImage!
    //var titleString: String!
    var artistString: String!
    var musicName: String!
    
    musicIndex.removeAll()
    
    do {
      let items = try fileManager.contentsOfDirectory(atPath: documentsDir)
      
      for item in items {
        musicName = item
        
        let url = URL(fileURLWithPath: item)
        let asset = AVAsset(url: url) as AVAsset
        
        // artwork image 얻기
        let metaArtwork = asset.commonMetadata.filter
        { $0.commonKey?.rawValue == "artwork"}
        
        if !metaArtwork.isEmpty {
          let imageData = metaArtwork[0].value
          image = UIImage(data: imageData as! Data)
        } else {
          image = UIImage(named: "noImage")
        }
        
        // artist 얻기
        let metaArtist = asset.commonMetadata.filter
        { $0.commonKey?.rawValue == "artist"}
        
        if !metaArtist.isEmpty {
          artistString = metaArtist[0].value as? String
        } else {
          artistString = "작자미상"
        }
        
        
        //          for metaDataItems in asset.commonMetadata {
        //            if metaDataItems.commonKey?.rawValue == "title" {
        //              guard let titleData = metaDataItems.value else {return}
        //              titleString = titleData as? String
        //            }
        //            if metaDataItems.commonKey?.rawValue == "artist" {
        //              guard let artistData = metaDataItems.value else {return }
        //              artistString = artistData as? String
        //
        //            }
        //          }
        
        musicIndex.append(MusicData(cover: image,
                                   title: musicName,
                                   artist: artistString,
                                   musicName: musicName))
      }
      
      
    } catch {
      print("Not Found item")
    }
    listTableView.reloadData()
    
    
    
  }
  
  
    // MARK: - TableView Delegate
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    musicIndex.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = listTableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
      
      let model = musicIndex[indexPath.row]
      
      cell.coverImage.image = model.cover
      cell.titleLabel.text = model.title?.fileName()
      cell.artistLabel.text = model.artist
    
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let data = musicIndex.map { (info) -> String in
      return info.musicName!
    }
    
    if(!musicSelected.contains(data[indexPath.row])){
      musicSelected.append(data[indexPath.row])
    }else{
      
    }
    print(musicSelected)
  }
  
  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    
    let data = musicIndex.map { (info) -> String in
      
      return info.musicName!
    }
    if let index = musicSelected.firstIndex(of: data[indexPath.row]) {
      musicSelected.remove(at: index)
      
    }
    print(musicSelected)
  }
  
  
  
  
}

 //MARK: - Protocol
 
protocol reloadDelegate {
  func reloadTableView()
}
