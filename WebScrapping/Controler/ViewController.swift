//
//  ViewController.swift
//  WebScrapping
//
//  Created by admin on 18/04/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import Alamofire
import Kanna

class ViewController: UICollectionViewController {
    
    let urlName = "https://www.apple.com/es/itunes/charts/songs/"
    
    var factory: SongsFactory!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadItemsInColletionView), name: NSNotification.Name("SongsUpdate"), object: nil)
        factory = SongsFactory(songsUrl: urlName)
        
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return factory.songs.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SongCell", for: indexPath) as! SongCell
        cell.labelSong.text = factory.songs[indexPath.row].title
        cell.labelAtuhor.text = factory.songs[indexPath.row].authorName
        cell.imageViewSong.downloadedFrom(link: factory.songs[indexPath.row].imageUrl)
        //print("\(indexPath.row)-- href: \(factory.songs[indexPath.row].iTunesUrl)")
        
        
        return cell
    }
    
    // abre safari
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let url = URL(string: factory.songs[indexPath.row].iTunesUrl){
            
            UIApplication.shared.open(url, options: [:]){ (success) in
                print("abrir web")
                
            }
        }
    }
    
    //@objc es para que lo pueda ejecutar el notificadorCenter
    @objc func reloadItemsInColletionView(){
        self.collectionView.reloadData()
    }
}

