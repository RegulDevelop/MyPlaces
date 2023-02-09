//
//  MainViewController.swift
//  MyPlaces
//
//  Created by Anton Tyurin on 09.02.2023.
//

import UIKit

class MainViewController: UITableViewController {
    
    let places = Place.getPlaces()

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return places.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // dlya raboty s classom CustomTableViewCell podpisyvaem cell k CustomTableViewCell dlya raboty s outletami classa
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        cell.nameLabel.text = places[indexPath.row].name
        cell.locationLabel.text = places[indexPath.row].location
        cell.typeLabel.text = places[indexPath.row].type
        cell.imageOfPlace.image = UIImage(named: places[indexPath.row].image)
        // skruglyaem kartinku, vysotu stroki delem na 2
        cell.imageOfPlace.layer.cornerRadius = cell.imageOfPlace.frame.size.height / 2
        // obrezka izobrajeniya po granicam imageView
        cell.imageOfPlace.clipsToBounds = true

        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
