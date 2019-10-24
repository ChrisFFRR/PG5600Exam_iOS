//
//  Top50AlbumsMasterViewController.swift
//  Opus
//
//  Created by Christopher Marchand on 22/10/2019.
//  Copyright © 2019 Christopher Marchand. All rights reserved.
//

import UIKit



class Top50AlbumsMasterViewController: UIViewController {
   
    
    var totalAlbums = [TopAlbum]() {
        didSet {
             print("Total albums in mvc = \(totalAlbums.count)")
            DispatchQueue.main.async {
                 self.navigationItem.title = "Top \(self.totalAlbums.count) Albums"
            }
           
        }
    }
    
    @IBOutlet var segmentedController: UISegmentedControl!
    
    private lazy var topAlbumsGridVc: Top50AlbumsViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "Top50AlbumsViewController") as! Top50AlbumsViewController
        
        self.addViewControllerAsChild(childVc: vc)
        
        return vc
    }()
    
    
    private lazy var topAlbumsListVc: Top50AlbumsListViewController = {
           let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
           let vc = storyboard.instantiateViewController(withIdentifier: "Top50AlbumsListViewController") as! Top50AlbumsListViewController
        
           vc.totalAlbums = self.totalAlbums.map({$0})
           self.addViewControllerAsChild(childVc: vc)
           
           return vc
       }()
    
    override func viewWillAppear(_ animated: Bool) {
         let topAlbums = NetworkHandler(from: "https://theaudiodb.com/api/v1/json/1/mostloved.php?format=album")

               DispatchQueue.init(label: "background").async {
               topAlbums.getTopAlbums { [weak self] result in
                          guard let result = result else {
                              print("Could not fetch Albums")
                              return
                          }
                          self?.totalAlbums = result
                      }
               }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
  
         navigationItem.title = "Loading"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Scroll to top", style: .done, target: self, action: #selector(scrollToTop(_:)))
        
         segmentedController.selectedSegmentIndex = 0
        topAlbumsGridVc.view.isHidden = false
        segmentedController.addTarget(self, action: #selector(selectionDidChange(sender:)), for: .valueChanged)
       
    }
    
   
    

    //https://www.youtube.com/watch?v=kq-lHR5ZOW0
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
    }
   
}

extension Top50AlbumsMasterViewController: AlbumDelegate {
    func didSendAlbums(_ albums: [TopAlbum]) {
        self.totalAlbums = albums.map({$0})
        print("Delegate function MVC")
        self.navigationItem.title = "Top \(self.totalAlbums.count) Albums"
        
    }
}


