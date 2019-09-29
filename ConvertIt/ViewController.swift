//
//  ViewController.swift
//  ConvertIt
//
//  Created by Carter Borchetta on 9/26/19.
//  Copyright © 2019 Carter Borchetta. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var userInput: UITextField!
    @IBOutlet weak var fromUnitsLabel: UILabel!
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var formulaPicker: UIPickerView!
    @IBOutlet weak var decimalSegment: UISegmentedControl!
    @IBOutlet weak var signSegment: UISegmentedControl!
    
    
    var formulaArray = ["miles to kilometers", "kilometers to miles", "feet to meters", "yards to meters", "meters to feet", "meters to yards", "inches to cm", "cm to inches", "farenheit to celsius","celsius to farenheit", "quarts to liters", "liters to quarts"]
    var fromUnits = ""
    var toUnits = ""
    var conversionString = ""
    //MARK:- Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        formulaPicker.delegate = self
        formulaPicker.dataSource = self
        conversionString = formulaArray[formulaPicker.selectedRow(inComponent: 0)]
        userInput.becomeFirstResponder()
        signSegment.isHidden = true
    }
    
    func calculateConversion() {
        // Guard let = fancy input statement where you process the flase condition right at the front and abort the function via return
        guard let inputValue = Double(userInput.text!) else {
            if userInput.text != "" {
                showAlert(title: "Cannot Convert Value", message: "\"\(userInput.text!)\" is not a valid number.")
            }
            return
        }
        var outputValue = 0.0
        switch conversionString {
        case "miles to kilometers":
            outputValue = inputValue / 0.62137
        case "kilometers to miles":
            outputValue = inputValue * 0.62137
        case "feet to meters":
            outputValue = inputValue / 3.2808
        case "yards to meters":
            outputValue = inputValue / 1.0936
        case "meters to feet":
            outputValue = inputValue * 3.2808
        case "meters to yards":
            outputValue = inputValue * 1.0936
        case "inches to cm":
            outputValue = inputValue / 0.3937
        case "cm to inches":
            outputValue = inputValue * 0.3937
        case "farenheit to celsius":
            outputValue = (inputValue - 32) * (5/9)
        case "celsius to farenheit":
            outputValue = (inputValue * 9/5) + 32
        case "quarts to liters":
            outputValue = inputValue / 1.05669
        case "liters to quarts":
            outputValue = inputValue * 1.05669
        default:
            showAlert(title: "Unexpected Error", message: "Contact the developer and share that \"\(conversionString)\" could not be identified.")
        }
        let formatString = (decimalSegment.selectedSegmentIndex < decimalSegment.numberOfSegments - 1 ? "%.\(decimalSegment.selectedSegmentIndex+1)f":"%f" )
        let outputString = String(format: formatString, outputValue)
        resultsLabel.text = "\(inputValue) \(fromUnits) = \(outputString) \(toUnits)"
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // UIAlertController object and passing parameters to the class
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        // Create the action
        // Handler if you want some code to run once OK pressed
        alertController.addAction(action)
        // Add the UIAlertAction to the UIAlertController
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK:- IBActions
    @IBAction func userInputChanged(_ sender: UITextField) {
        resultsLabel.text = ""
        if userInput.text?.first == "-" {
            signSegment.selectedSegmentIndex = 1
        } else {
            signSegment.selectedSegmentIndex = 0
        }
    }
    
    @IBAction func decimalSelected(_ sender: UISegmentedControl) {
        calculateConversion()
    }
    
    @IBAction func signSegmentSelected(_ sender: UISegmentedControl) {
        if signSegment.selectedSegmentIndex == 0{
            userInput.text = userInput.text?.replacingOccurrences(of: "-", with: "")
        } else {
            userInput.text = "-" + userInput.text!
        }
        if userInput.text != "-" {
            calculateConversion()
            
        }
    }
    
    
    @IBAction func convertButtonPressed(_ sender: UIButton) {
        calculateConversion()
    }
}
//MARK:- PickerView Extension
extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return formulaArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // Called by the picker when it needs to get the text to display for a row
        // - row is an int of the row its working on currently
        return formulaArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Whenever a row is clicked on this function is called
        conversionString = formulaArray[row]
        
        // Will be true regardless of case if both have the word celsius
        if conversionString.lowercased().contains("celsius") {
            signSegment.isHidden = false
        } else {
            signSegment.isHidden = true
            userInput.text = userInput.text?.replacingOccurrences(of: "-", with: "")
            signSegment.selectedSegmentIndex = 0
        }
        
        let unitsArray = formulaArray[row].components(separatedBy: " to ") // This will contain the title(string) of the currently selected row and then we break it into a list
        fromUnits = unitsArray[0]
        toUnits = unitsArray[1]
        fromUnitsLabel.text = fromUnits
        
        calculateConversion()
    }
    
}
