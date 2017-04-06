//
//  InputViewController.swift
//  ToDo
//
//  Created by Mihai Cristescu on 02/04/2017.
//  Copyright © 2017 Mihai Cristescu. All rights reserved.
//

import UIKit
import CoreLocation

class InputViewController: UIViewController {

    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var dateTextField: UITextField!
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var addressTextField: UITextField!
    @IBOutlet var descriptionTextField: UITextField!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var cancelButton: UIButton!

    lazy var geocoder = CLGeocoder()
    var itemManager: ItemManager?

    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "MM/dd/yyyy"
        return df
    }()

    @IBAction func save() {

        guard let titleString = titleTextField.text, titleString.characters.count > 0 else {
            return
        }

        let date: Date?

        if let dateText = dateTextField.text, dateText.characters.count > 0 {
            date = dateFormatter.date(from: dateText)
        } else {
            date = nil
        }

        let descriptionString = descriptionTextField.text

        if let locationName = locationTextField.text, locationName.characters.count > 0 {

            if let address = addressTextField.text, address.characters.count > 0 {

                geocoder.geocodeAddressString(address) { [unowned self] (placemarks, _) -> Void in

                    let placeMark = placemarks?.first

                    let item = ToDoItem(title: titleString,
                                        itemDescription: descriptionString,
                                        timestamp: date?.timeIntervalSince1970,
                                        location: Location(name: locationName, coordinate: placeMark?.location?.coordinate))

                    DispatchQueue.main.async {
                        self.itemManager?.add(item)
                        self.dismiss(animated: true)
                    }
                }
            }
        } else {
            let item = ToDoItem(title: titleString,
                                itemDescription: descriptionString,
                                timestamp: date?.timeIntervalSince1970,
                                location: nil)

            self.itemManager?.add(item)
            dismiss(animated: true)
        }
    }

    @IBAction func cancel() {
        dismiss(animated: true)

    }
}
