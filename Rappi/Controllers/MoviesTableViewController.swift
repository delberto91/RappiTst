//
//  TableViewController.swift
//  Rappi
//
//  Created by Delberto Martinez on 5/16/19.
//  Copyright © 2019 Delberto Martinez. All rights reserved.
//

import UIKit
import CoreData
class MoviesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
  
     var movieData : [MovieData] = [MovieData]()
     var filteredObjects = [MovieDataModel]()
     let searchController = UISearchController(searchResultsController: nil)
     let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
    var searchPredicate: NSPredicate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get movies
        self.getMovies(method: Categories.Popular.rawValue)
        
        //Start in segment 0
        segmentedControl.selectedSegmentIndex = 0

        self.navigationItem.title = "Movies List"
        
        //Connect delegate & dataSource
        tableView.delegate = self
        tableView.dataSource = self
        
        setupActivityIndicator()
        
    
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar"
        searchController.delegate = self as? UISearchControllerDelegate
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            // Fallback on earlier versions
        }
        definesPresentationContext = true

        //Register movie Cell
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
       
        //Validate network connection
        if Reachability.isConnectedToNetwork() {
            
        } else {
            Tools.showAlert(title: "Sin conexión a internet", message: "No cuentas con conexión a internet, no podrás obtener los datos mas recientes de las películas, pero podrás ver los últimos datos guardados.", titleForTheAction: "Aceptar", in: self)
            
        }
    }
    
    
    //fetchedResults
    lazy var fetchedhResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: MovieDataModel.self))
       fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
       
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
         frc.delegate = self
        return frc
    }()

    //MARK:- Actions
    @IBAction func clickSegmentedController(_ sender: Any) {
        if segmentedControl.selectedSegmentIndex == 0 {
            
            self.getMovies(method: Categories.Popular.rawValue)
            
        } else if segmentedControl.selectedSegmentIndex == 1 {
            
            self.getMovies(method: Categories.TopRated.rawValue)
            
        } else if segmentedControl.selectedSegmentIndex == 2 {
            self.getMovies(method: Categories.Upcomig.rawValue)
        }
    }
    

    func setupActivityIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.color = .gray
        activityIndicator.center = self.tableView.center
        
        view.addSubview(activityIndicator)
    }

    // MARK: - Table view data source

     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
 
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
       if isFiltering() {
        
        
        return filteredObjects.count
    
        }
   
        if let count = fetchedhResultController.sections?.first?.numberOfObjects {
            return count
        }
        return 0
 
    }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        
        if isFiltering() {
         
            
            cell.titleLabel.text = self.filteredObjects[indexPath.row].title
            cell.votesLabel.text =  self.filteredObjects[indexPath.row].release_date
             cell.imageMovieLabel.downloadImage(downloadURL: "\(APIManager.sharedInstance.posterURL)\(self.filteredObjects[indexPath.row].poster_path ?? "")" , completion: { (response) in
            })
            
            
        } else {
            
            if let movie = fetchedhResultController.object(at: indexPath) as? MovieDataModel {
                cell.titleLabel.text = movie.title
                cell.votesLabel.text = movie.release_date
                cell.imageMovieLabel.downloadImage(downloadURL: "\(APIManager.sharedInstance.posterURL)\(movie.poster_path ?? "")" , completion: { (response) in
                })
                
            }
        }
       
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailMovieViewController") as! DetailMovieViewController
        if let movie = fetchedhResultController.object(at: indexPath) as? MovieDataModel {
            vc.movieName = movie.title!
            vc.movieImage = movie.poster_path!
            vc.overView = movie.overview!
            
        }
        
        if isFiltering() {
            
            
            vc.movieName = self.filteredObjects[indexPath.row].title!
            vc.movieImage = self.filteredObjects[indexPath.row].poster_path!
            vc.overView  = self.filteredObjects[indexPath.row].overview!
            vc.releaseDt = self.filteredObjects[indexPath.row].release_date!
            vc.lngage = self.filteredObjects[indexPath.row].original_language!
            
            
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85.0
    }


    //get Movies info.
    func getMovies(method: String) {
        do {
            try self.fetchedhResultController.performFetch()
            print("COUNT FETCHED FIRST: \(self.fetchedhResultController.sections?[0].numberOfObjects)")
        } catch let error  {
            print("ERROR: \(error)")
        }
        let service = APIManager()
        service.getMovieInfo(method:method) { (result) in
            switch result {
            case .Success(let data):
                CoreDataStack.sharedInstance.clearData()
                CoreDataStack.sharedInstance.saveInCoreDataWith(array: data)
            case .Error(let message):
                DispatchQueue.main.async {
                      Tools.showAlert(title: "", message: message, titleForTheAction: "Aceptar", in: self)
                }
            }
        }

    }

    //MARK:- Methods for search.
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
       
        let searchText = searchText
            searchPredicate = NSPredicate(format: "title contains[cd] %@", searchText)
        filteredObjects = (self.fetchedhResultController.fetchedObjects?.filter() {
            return self.searchPredicate!.evaluate(with: $0)
            } as! [MovieDataModel]?)!
            self.tableView.reloadData()
        print(searchPredicate as Any)
        
        
    }
    //Validate if the user is searching
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
        
    }
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
}

extension MoviesTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        
        filterContentForSearchText(searchController.searchBar.text!)
        
    }
}

extension MoviesTableViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            self.tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            self.tableView.deleteRows(at: [indexPath!], with: .automatic)
        default:
            break
        }
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func deleteExisting(entityName: String, inMoc moc: NSManagedObjectContext) -> Bool {
        do {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
            try moc.execute(deleteRequest)
            return true
        } catch {
            print("ERROR: deleting existing records - \(entityName)")
            return false
        }
    }
}
