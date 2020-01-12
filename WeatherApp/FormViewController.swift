//
//  FormViewController.swift
//  WeatherApp
//
//  Created by Khairul Rijal on 12/01/20.
//  Copyright © 2020 Khairul Rijal. All rights reserved.
//

import UIKit

class FormViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var postalCodeField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showAlert(with message: String) {
        let alert = UIAlertController(title: "Perhatian", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        self.show(alert, sender: nil)
    }
    
    @IBAction func sendTap(_ sender: Any) {
        guard nameField.text!.count > 0  else {
            showAlert(with: "Harap Isi Nama Anda")
            return
        }
        
        guard postalCodeField.text!.count == 5 else {
            showAlert(with: "Harap Isi Kode POS, 5 Angka")
            return
        }
        
        loadingForecast()
    }
    
    @IBAction func _selectedPostalCode(_  unwindSegue: UIStoryboardSegue) {
        guard let source = unwindSegue.source as? SearchViewController else {
            return
        }
        
        guard let indexPath = source.tableView.indexPathForSelectedRow else {
            return
        }
        
        postalCodeField.text = source.mapItems[indexPath.row].placemark.postalCode
    }
    
    func loadingForecast() {
        provider.request(APIService.forecast5(self.postalCodeField.text!)) { (result) in
            switch result {
            case .success(let response):
                print(response)
                
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .secondsSince1970
                    let result = try decoder.decode(Response.self, from: response.data)
                    
                    self.performSegue(withIdentifier: "toDetail", sender: result)
                    
                    print(result)
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
            if let destiantion = segue.destination as? DetailWeatherViewController {
                if let result = sender as? Response {
                    destiantion.response = result
                    destiantion.name = self.nameField.text
                }
            }
        }
    }
}

