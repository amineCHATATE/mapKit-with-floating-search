//
//  SearchViewController.swift
//  UberLocationSearch
//
//  Created by Amine CHATATE on 23/06/2021.
//

import UIKit
import CoreLocation

protocol SearchViewControllerDelegate: AnyObject {
    func searchViewController(_ vc: SearchViewController, didSelectLocationWith coordinates: CLLocationCoordinate2D?)
}

class SearchViewController: UIViewController {

    var locations = [Location]()
    weak var delegate: SearchViewControllerDelegate?
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Where To?"
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        return label
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter destination"
        textField.layer.cornerRadius = 9
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        textField.leftViewMode = .always
        return textField
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .secondarySystemBackground
        
        view.addSubview(label)
        view.addSubview(textField)
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        textField.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        label.sizeToFit()
        label.frame = CGRect(x: 10, y: 10, width: label.frame.size.width, height: label.frame.size.height)
        textField.frame = CGRect(x: 10, y: 20 + label.frame.size.height, width: view.frame.size.width - 20, height: 50)
        
        let tableY: CGFloat = textField.frame.origin.y + textField.frame.size.height + 5
        tableView.frame = CGRect(x: 0, y: tableY, width: view.frame.size.width, height: view.frame.size.height - tableY)
        
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


extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let text = textField.text, !text.isEmpty {
            LocationManager.shared.findLocation(with: text) { [weak self] locations in
                DispatchQueue.main.async {
                    self?.locations = locations
                    self?.tableView.reloadData()
                }
            }
        }
        return true
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = locations[indexPath.row].title
        cell.textLabel?.numberOfLines = 0
        
        cell.contentView.backgroundColor = .secondarySystemBackground
        cell.backgroundColor = .secondarySystemBackground
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Noify map controller to show pin at selected place
        let coordinate = locations[indexPath.row].coordinates
        delegate?.searchViewController(self, didSelectLocationWith: coordinate)
    }
}
