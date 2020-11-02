//
//  ProvinceListViewController.swift
//  MindbodyProject
//
//  Created by Lynne on 10/30/20.
//

import UIKit
import MapKit

/// Displays a list of provinces.
class ProvinceListViewController: UIViewController {
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var listTableView: UITableView!
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var mapViewHeight: NSLayoutConstraint!
    private let handler = WebServiceHandler()
    private var provinceLists:[Province] = []
    private var countryCoordinates:(Double, Double)?
    
    var country:Country?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        mapViewHeight.constant = view.bounds.height / 3
    }
}

// MARK: UI
extension ProvinceListViewController {
    private func setupUI() {
        listTableView.register(UINib(nibName: "ProvinceCell", bundle: .main), forCellReuseIdentifier: "ProvinceCell")
        listTableView.dataSource = self
        listTableView.delegate = self
        self.title = "Provinces"
    }
    
    private func showEmptyAlert() {
        listTableView.isHidden = provinceLists.isEmpty
        messageLabel.isHidden = !provinceLists.isEmpty
    }
}

// MARK: Server Call
extension ProvinceListViewController {
    private func loadData() {
        startLoadingAnimation()
        guard let id = country?.id, let code = country?.code else {
            return
        }
        let group = DispatchGroup()
        group.enter()
        handler.fetchProvinceLists(country: "\(id)", callbackQueue: .main) { [weak self] (data, error) in
            group.leave()
            
            guard let data = data else {
                guard let err = error else {
                    return
                }
                self?.showError(error: err) {
                    self?.loadData()
                }
                return
            }
            self?.provinceLists = data
            self?.showEmptyAlert()
        }
        
        group.enter()
        handler.fetchCountryCordinates(country: code, callbackQueue: .main) { [weak self] (coordinates, error) in
            group.leave()
            
            guard let coordinates = coordinates else {
                guard let err = error else {
                    return
                }
                self?.showDialog(error: err)
                return
            }
            self?.countryCoordinates = coordinates
        }
        
        group.notify(queue: .main) {
            self.stopLoadingAnimation()
            self.listTableView.reloadData()
            guard let coordinates = self.countryCoordinates else {
                return
            }
            let location = CLLocation(latitude: coordinates.1, longitude: coordinates.0)
            self.mapView.centerToLocation(location)
        }
    }
}

// MARK: UITableViewDataSource
extension ProvinceListViewController:UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return provinceLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProvinceCell", for: indexPath) as! ProvinceCell
        cell.province = provinceLists[indexPath.row]
        cell.loadUI()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.mapView.searchProvince(name: provinceLists[indexPath.row].provinceName)
    }
}

// MARK: UITableViewDelegate
extension ProvinceListViewController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: MKMapView
private extension MKMapView {
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000000) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
    
    func searchProvince(name:String) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = name
        searchRequest.region = self.region
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            guard let response = response else {
                return
            }
            for item in response.mapItems {
                if let location = item.placemark.location {
                    self.centerToLocation(location)
                    break
                }
            }
        }
    }
}
