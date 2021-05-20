//
//  Test.swift
//  addd
//
//  Created by Aliona Kostenko on 19.05.2021.
//

import UIKit

class CardViewController: UIViewController {
    var text: String = ""
    @IBOutlet weak var cardLogo: UIImageView!
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var textLabel: UILabel!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        textLabel?.text = text
        if text.hasSuffix("7") || text.hasSuffix("9") {
            cardView.backgroundColor = UIColor(named: "MCColor")
            cardLogo.image = UIImage(named: "MC")
        }
        else {
            cardView.backgroundColor = UIColor(named: "VisaColor")
            cardLogo.image = UIImage(named: "Visa")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
