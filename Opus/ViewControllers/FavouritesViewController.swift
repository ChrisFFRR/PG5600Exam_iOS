//
//  FavouritesViewController.swift
//  Opus
//
//  Created  on 03/12/2019.
//  Copyright © 2019  All rights reserved.
//

import UIKit
import CoreData

class FavouritesViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    //kontroller for database
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
   
    
    var allFavorites: [FavouriteTrack] = []
    var reccomendedArtist: [Reccomended] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let favoriteNib = UINib(nibName: "FavoritesViewCell", bundle: nil)
        tableView.register(favoriteNib, forCellReuseIdentifier: "FavoritesViewCell")
        
        //Udemy course iOS12 bootcamp
        //her henter vi entitiet fra database og sorterer etter artist (a-å)
        let fetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "FavouriteTrack")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "artist", ascending: true)]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: AppDelegate.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
            } catch {
            print(error.localizedDescription)
        }
        
        allFavorites = fetchedResultsController.fetchedObjects as! [FavouriteTrack]
        print("Entries in coreData",allFavorites.count)
        
        getSimilarArtists(to: allFavorites)

        tableView.reloadData()

    
         self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allFavorites.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesViewCell", for: indexPath) as? FavoritesViewCell else {
            fatalError("unable to dequeue FavoritesViewCell")
        }
        let favourite = allFavorites[indexPath.row]

        cell.artistName.text = favourite.artist
        cell.trackTitle.text = favourite.trackTitle
        cell.trackDuration.text = favourite.trackDuration

        return cell
    }


   

   
   
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            //Sletter valgt favoritt track fra database
            let favoriteToDelete = fetchedResultsController.object(at: indexPath) as! FavouriteTrack
            AppDelegate.context.delete(favoriteToDelete)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
          
            tableView.reloadData()
            
            let alertDeleted = UIAlertController(title: "Tired of the song?!", message: "Song deleted", preferredStyle: .alert)
                   present(alertDeleted, animated: true) {
                       DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                           alertDeleted.dismiss(animated: true, completion: nil)
                       }
                   }
        }
    }

    //funksjon som lytter til forandringer i core data database samt oppdaterer tableview deretter.
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        print("Change in db")
        allFavorites = fetchedResultsController.fetchedObjects as! [FavouriteTrack]
        getSimilarArtists(to: allFavorites)
        tableView.reloadData()
        
    }
    
    func getSimilarArtists(to artists: [FavouriteTrack]) {
        // API key limited to 300 request an hour
        var url = "https://tastedive.com/api/similar?type=music&limit=10&k=350796-OPUSexam-HCD3DNWH&q="
       
        let likedArtist = artists.map({$0.artist!})
 
        let uniqueArtists = Array(Set(likedArtist)).joined(separator: ",")
        let parameters = uniqueArtists.replacingOccurrences(of: ",", with: "%2C").replacingOccurrences(of: " ", with: "+")
       
        url.append(parameters)
        print(url)
        
        let reccomended = NetworkHandler(from: url)
        reccomended.getReccomended{ result in
        guard let result = result else {
            print("could not find reccomended")
            return
        }
            self.reccomendedArtist = result.results
        }
        
        //resets the url with no artist query
        //https://stackoverflow.com/a/39185097
        if let index = url.range(of: "q=")?.upperBound {
            let substring = url[..<index]
            url = String(substring)
        }
    }
}

