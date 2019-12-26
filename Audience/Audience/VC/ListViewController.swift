//
//  IndexViewController.swift
//  Audience
//
//  Created by 이요한 on 2019/12/06.
//  Copyright © 2019 yo. All rights reserved.
//

import UIKit


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
    
    
    
    
    // MARK: - general func
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playViewBottomRadi()
        cofigureFileSystem()
        
    

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
        let fileManager = FileManager.default
        let documentsDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].path
        print(documentsDir)
        
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
//
    }
    
    
// MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        musicInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
  
    
    
    
    
}
