//
//  ViewController.swift
//  MusicAlbumViewer
//
//  Created by Low Wai Hong on 5/28/16.
//  Copyright © 2016 Low Wai Hong. All rights reserved.
//

import UIKit

private let reuseIdentifier = "musicItem"
private let screenWidth = UIScreen.mainScreen().bounds.width

class ViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate{

    let musicAlbumMachine: MusicAlbumMachine

    @IBOutlet weak var albumCollectionView: UICollectionView!
    
    required init?(coder aDecoder: NSCoder) {
        do {
            let array = try PlistConverter.arrayFromFile("album", ofType: "plist")
            let albumCollection = try InventoryUnarchiver.inventoryFromArray(array)
            self.musicAlbumMachine = MusicAlbumMachine(inventory: albumCollection)
        } catch let error {
            fatalError("\(error)")
        }
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UICollectionView
    func setupCollectionViewCells() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        let padding: CGFloat = 10
        layout.itemSize = CGSize(width: (screenWidth / 3) - padding, height: (screenWidth / 3) - padding)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        albumCollectionView.collectionViewLayout = layout
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return musicAlbumMachine.inventory.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! musicAlbumCell
        
        let item = musicAlbumMachine.inventory[indexPath.row]
        if let bundlePath = NSBundle.mainBundle().pathForResource(item.albumName, ofType: "jpg"){
            cell.albumCover.image = UIImage(contentsOfFile: bundlePath)
        }
        
        return cell
    }
    
}

