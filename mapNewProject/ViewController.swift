//
//  ViewController.swift
//  mapProject
//
//  Created by Чистяков Василий Александрович on 12.05.2021.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    
    let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    
    let addAdress: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "push"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
        
    }()
    
    let routeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "route1"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
        
    }()
    
    let resetButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "reset1"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
        
    }()
    
    var annotationsArray = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        setConstraints()
        
        addAdress.addTarget(self, action: #selector(addAdressTapped), for: .touchUpInside)
        routeButton.addTarget(self, action: #selector(routeButtonTapped), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        
        
        
    }
    
    
    
    @objc func addAdressTapped(){
        
        allertAddAdress(title: "Добавить", placeholder: "") { [self](text) in
            setupPlacemark(adressPlace: text)
        }
        
    }
    
    @objc func routeButtonTapped(){
        
        print("1355")
               
        for index in 0...annotationsArray.count - 2 {
            
            creaateDerectionRequest(satartCooardinate: annotationsArray[index].coordinate, destinationCoardinate: annotationsArray[index + 1].coordinate)
        }
        mapView.showAnnotations(annotationsArray, animated: true)
    }
    
    
    @objc func resetButtonTapped(){
        
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
        annotationsArray = [MKPointAnnotation]()
        routeButton.isHidden = true
        resetButton.isHidden = true

        
    }
    
    private func setupPlacemark(adressPlace: String){
        
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(adressPlace) { [self] (placemarks, error) in
            if let error = error {
                print(error)
                allertError(title: "Ошибка", massege: "Cервер, недоступен . Попробуйте дабавить адрес еще раз")
                return
            }
            
            guard let placemarks = placemarks else { return }
            let placemark = placemarks.first
            
            let annotation = MKPointAnnotation()
            annotation.title = "\(adressPlace)"
            guard let placemarkLocaion = placemark?.location else { return }
            annotation.coordinate = placemarkLocaion.coordinate
            
            annotationsArray.append(annotation )
            if annotationsArray.count > 2 {
                routeButton.isHidden = false
                resetButton.isHidden = false
            }
            mapView.showAnnotations(annotationsArray, animated: true)
        }
    }
    
    
    
    private func creaateDerectionRequest(satartCooardinate: CLLocationCoordinate2D, destinationCoardinate: CLLocationCoordinate2D){
        
        let startLocation = MKPlacemark(coordinate: satartCooardinate)
        let destinationLocation = MKPlacemark(coordinate: destinationCoardinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startLocation)
        request.destination = MKMapItem(placemark: destinationLocation)
        request.transportType = .walking
        request.requestsAlternateRoutes = true
        
        let deraction = MKDirections(request: request)
        deraction.calculate { (response, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let response = response else {
                self.allertError(title: "Ошибка", massege: "Маршрут недосутпен")
                return
            }
            var minRoute = response.routes[0]
            for route in response.routes{
                minRoute = (route.distance < minRoute.distance) ? route: minRoute
            }
            self.mapView.addOverlay(minRoute.polyline)
        }
    }
}

extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .red
        return renderer
    }
}

extension ViewController{
    
    func setConstraints(){
        
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            mapView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        
        mapView.addSubview(addAdress)
        NSLayoutConstraint.activate([
            addAdress.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 50),
            addAdress.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -20),
            addAdress.heightAnchor.constraint(equalToConstant: 70),
            addAdress.widthAnchor.constraint(equalToConstant: 70)
        ])
        
        
        
        mapView.addSubview(routeButton)
        NSLayoutConstraint.activate([
            routeButton.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 20),
            routeButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -20),
            routeButton.heightAnchor.constraint(equalToConstant: 50),
            routeButton.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        mapView.addSubview(resetButton )
        NSLayoutConstraint.activate([
            resetButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -20),
            resetButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -20),
            resetButton.heightAnchor.constraint(equalToConstant: 50),
            resetButton.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
}

