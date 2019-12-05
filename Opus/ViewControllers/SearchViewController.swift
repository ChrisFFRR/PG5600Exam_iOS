//
//  SearchViewController.swift
//  Opus
//
//
//  https://www.raywenderlich.com/4363809-uisearchcontroller-tutorial-getting-started
//

import UIKit

class SearchViewController: UIViewController, UISearchResultsUpdating, UICollectionViewDelegate, UICollectionViewDataSource {
   
    
   
    @IBOutlet weak var searchContainer: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var collectionViewFlowLayout: UICollectionViewFlowLayout!
     let noResultLabel = UILabel(frame: CGRect(x:0,y: 0,width: 200, height: 30))
    

    let searchController = UISearchController(searchResultsController: nil)
    var filteredAlbums: [TopAlbum] = []
    var albums: [TopAlbum] = []
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let topAlbums =  NetworkHandler(from: "https://theaudiodb.com/api/v1/json/1/mostloved.php?format=album")
        topAlbums.getTopAlbums {[weak self] result in
            guard let result = result else {
                print("Could not fetch Albums")
                return
            }
            self?.albums += result
        }
        
       
       
    
        //register topalbum cell
               let topAlbumNib = UINib(nibName: "TopAlbumCell", bundle: nil)
               collectionView.register(topAlbumNib, forCellWithReuseIdentifier: "TopAlbumCell")
        
        
        searchController.searchBar.sizeToFit()
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Artist"
        definesPresentationContext = true
        extendedLayoutIncludesOpaqueBars = true
        searchController.searchBar.barStyle = .black
        searchContainer.addSubview(searchController.searchBar)
       
        
        
    
        
      
    }
    
    override func viewWillLayoutSubviews() {
           if collectionViewFlowLayout == nil {

               let lineSpacing: CGFloat = 20
               let interItemSpacing: CGFloat = 10
               let width = collectionView.frame.width / 2
               collectionViewFlowLayout = UICollectionViewFlowLayout()
               collectionViewFlowLayout.itemSize = CGSize(width: CGFloat(width), height: CGFloat(230)) //230
               collectionViewFlowLayout.scrollDirection = .vertical
               collectionViewFlowLayout.minimumLineSpacing = lineSpacing
               collectionViewFlowLayout.minimumInteritemSpacing = interItemSpacing
               collectionViewFlowLayout.sectionInset.top = CGFloat(15)

               collectionView.setCollectionViewLayout(collectionViewFlowLayout, animated: true)
           }
       }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredAlbums.count
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopAlbumCell", for: indexPath) as! TopAlbumCell
        
        let albumDetail = filteredAlbums[indexPath.row]
        
        cell.contentView.layer.masksToBounds = true
        cell.layer.cornerRadius = 10
        cell.albumArtist.text = albumDetail.strArtist
        cell.albumTitle.text = albumDetail.strAlbum
        
        Utils.convertStrToUIImage(albumDetail.strAlbumThumb) { uiImage in
            cell.albumImage.image = uiImage
        }
        
        return cell
        }
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
           let albumDetailVC = storyboard.instantiateViewController(withIdentifier: "AlbumDetailViewController") as? AlbumDetailViewController
           
           let albumDetailData = filteredAlbums[indexPath.row]
           
           Utils.setUpAndShowModal(album: albumDetailData, albumDetailVC, senderVC: self)
           
       }
    
    
    func filterContextOnSearch(_ input: String) {
        
        filteredAlbums = albums.filter { (album: TopAlbum) -> Bool in
            return album.strArtist.lowercased().contains(input.lowercased())
        }
        if(!isSearchBarEmpty && !filteredAlbums.isEmpty) {
            noResultLabel.removeFromSuperview()

                }
        
        collectionView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContextOnSearch(searchBar.text!)
        
           if(!isSearchBarEmpty && filteredAlbums.isEmpty) {
            print(self.view.center.y)
            print(self.view.center.x)
            print(self.view.center)
            noResultLabel.center.x = self.view.center.x
            noResultLabel.center.y = self.view.center.y / 2
            noResultLabel.textAlignment = .center
           
               noResultLabel.text = "Nothing to show"
               noResultLabel.textColor = .white
               self.collectionView.addSubview(noResultLabel);
           }
    
       }
}
