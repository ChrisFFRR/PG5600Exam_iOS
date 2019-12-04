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
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let favoriteNib = UINib(nibName: "FavoritesViewCell", bundle: nil)
        tableView.register(favoriteNib, forCellReuseIdentifier: "FavoritesViewCell")
        
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

        tableView.reloadData()

    
         self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source


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
        tableView.reloadData()
        
    }
    
}
