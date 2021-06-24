//
//  ViewController.swift
//  UberLocationSearch
//
//  Created by Amine CHATATE on 23/06/2021.
//

import UIKit
import MapKit
import FloatingPanel
import CoreLocation

class ViewController: UIViewController {

    let mapView = MKMapView()
    let floatinPanel = FloatingPanelController()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Direction"
        view.addSubview(mapView)
        
        let searchVC = SearchViewController()
        searchVC.delegate = self
        
        floatinPanel.set(contentViewController: searchVC)
        floatinPanel.addPanel(toParent: self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = view.bounds
    }


}

extension ViewController: SearchViewControllerDelegate {
    
    func searchViewController(_ vc: SearchViewController, didSelectLocationWith coordinates: CLLocationCoordinate2D?) {
        guard let coordinates = coordinates else {
            return
        }
        floatinPanel.move(to: .tip, animated: true)
        mapView.removeAnnotations(mapView.annotations)
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates
        mapView.addAnnotation(pin)
        mapView.setRegion(MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.7, longitudeDelta: 0.7)), animated: true)
    }
    
}
