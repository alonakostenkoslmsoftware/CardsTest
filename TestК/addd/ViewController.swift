//
//  ViewController.swift
//  addd
//
//  Created by Aliona Kostenko on 19.05.2021.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    var text: String = ""
    
    var cardArray: [NSManagedObject] = []
    let idCell = "cardCell"
    
    @IBOutlet weak var cardsView: UITableView!
    @IBAction func show(_ sender: Any) {
        addCard()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardsView.dataSource = self
        cardsView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)

      guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
      }

      let managedContext = appDelegate.persistentContainer.viewContext

      let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Card")

      do {
        cardArray = try managedContext.fetch(fetchRequest)
      } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
      }
    }
    
    @objc fileprivate func addCard() {
        let generateNumber = (1...16).map( {_ in Int.random(in: 1...9)} )
        let newCard = IndexPath(row: cardArray.count, section: 0)
        self.saveToData(name: generateNumber.toPrint.masked(8, reversed: true).grouping(every: 4, with: " "))
        self.cardsView.insertRows(at: [newCard], with: .fade)
    }
    
    func saveToData(name: String) {

    guard let appDelegate =
      UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext =
      appDelegate.persistentContainer.viewContext

    let entity =
      NSEntityDescription.entity(forEntityName: "Card",
                                 in: managedContext)!

    let cardID = NSManagedObject(entity: entity,
                                 insertInto: managedContext)

        cardID.setValue(name, forKeyPath: "number")

    do {
      try managedContext.save()
        cardArray.append(cardID)
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: idCell)
        let cardID = cardArray[indexPath.row]
        let cardNumber = cardID.value(forKeyPath: "number") as? String
        cell.textLabel?.text = cardNumber
        if cardNumber!.hasSuffix("9") || cardNumber!.hasSuffix("7") {
            cell.imageView?.image = UIImage(named: "MC")
        }
        else {
            cell.imageView?.image = UIImage(named: "Visa")
        }
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cardVC = UIStoryboard(name: "CardViewController", bundle: nil).instantiateViewController(withIdentifier: "CardViewController") as! CardViewController
        let cardID = cardArray[indexPath.row]
        cardVC.text = (cardID.value(forKey: "number") as? String)!
        navigationController?.pushViewController(cardVC, animated: true)
    }
}

extension Array {
    var toPrint: String  {
        var str = ""
            for element in self {
                str += "\(element) "
            }
        return str
    }
}

extension StringProtocol {
    func masked(_ n: Int = 0, reversed: Bool = false) -> String {
        let mask = String(repeating: "*", count: Swift.max(0, count-20))
        return reversed ? mask + suffix(n) : prefix(n) + mask
    }
}

extension String {
    func grouping(every groupSize: String.IndexDistance, with separator: Character) -> String {
       let cleanedUpCopy = replacingOccurrences(of: String(separator), with: "")
       return String(cleanedUpCopy.enumerated().map() {
            $0.offset % groupSize == 0 ? [separator, $0.element] : [$0.element]
       }.joined().dropFirst())
    }
}

