//
//  Top50AlbumsMasterViewController.swift
//  Opus
//
//  Created by Christopher Marchand on 22/10/2019.
//  Copyright © 2019 Christopher Marchand. All rights reserved.
//

import UIKit

class Top50AlbumsMasterViewController: UIViewController {
    
    var totalAlbums: [TopAlbum] = []
    
    @IBOutlet var segmentedController: UISegmentedControl!
    
    private lazy var topAlbumsGridVc: Top50AlbumsViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "Top50AlbumsViewController") as! Top50AlbumsViewController
        self.totalAlbums = vc.topAlbumList
        
        self.addViewControllerAsChild(childVc: vc)
        
        return vc
    }()
    
    private lazy var topAlbumsListVc: Top50AlbumsListViewController = {
           let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
           let vc = storyboard.instantiateViewController(withIdentifier: "Top50AlbumsListViewController") as! Top50AlbumsListViewController
          
           self.addViewControllerAsChild(childVc: vc)
        
           return vc
       }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Scroll to top", style: .plain, target: self, action: #selector(scrollToTop(_:)))
        
        segmentedController.addTarget(self, action: #selector(selectionDidChange(sender:)), for: .valueChanged)
        segmentedController.selectedSegmentIndex = 0
        
        print(self.topAlbumsGridVc.topAlbumList)
        
            
          
    }
    

    
    @objc func selectionDidChange(sender: UISegmentedControl) {
        topAlbumsGridVc.view.isHidden = !(segmentedController.selectedSegmentIndex == 0)
        topAlbumsListVc.view.isHidden = (segmentedController.selectedSegmentIndex == 0)
    }
    
    private func addViewControllerAsChild(childVc: UIViewController) {
        addChild(childVc)
        
        
        view.addSubview(childVc.view)
        
        childVc.view.frame = view.bounds
        childVc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
        childVc.didMove(toParent: self)
    }
    
    @objc func scrollToTop(_ sender: Any) {
        topAlbumsGridVc.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        print("click");
    }
   
}
