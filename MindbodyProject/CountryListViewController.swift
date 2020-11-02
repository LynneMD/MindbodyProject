//
//  CountryListViewController.swift
//  MindbodyProject
//
//  Created by Lynne on 10/30/20.
//

import UIKit

/// Displays a list of countries.
class CountryListViewController: UIViewController {
    @IBOutlet private weak var listTableView: UITableView!
    private let handler = WebServiceHandler()
    private let refreshControl = UIRefreshControl()
    private var countryLists:[Country] = []{
        didSet{
            listTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fetchCountries()
    }
}

// MARK: UI
extension CountryListViewController {
    private func setup() {
        listTableView.register(UINib(nibName: "CountryCell", bundle: .main), forCellReuseIdentifier: "CountryCell")
        listTableView.dataSource = self
        listTableView.delegate = self
        self.title = "Countries"
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshCountries(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            listTableView.refreshControl = refreshControl
        } else {
            listTableView.addSubview(refreshControl)
        }
    }
    
    @objc
    private func refreshCountries(_ sender: Any) {
        fetchCountries()
        self.refreshControl.endRefreshing()
    }
}

// MARK: Server Call
extension CountryListViewController {
    private func fetchCountries(){
        startLoadingAnimation()
        listTableView.isHidden = true
        handler.fetchCountryLists(callbackQueue: .main) { [weak self] (data, error) in
            self?.stopLoadingAnimation()
            self?.listTableView.isHidden = false
            guard let data = data else{
                guard let err = error else{
                    return
                }
                self?.showError(error: err) {
                    self?.fetchCountries()
                }
                return
            }
            self?.countryLists = data
        }
    }
}

// MARK: UITableViewDataSource
extension CountryListViewController:UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath) as! CountryCell
        cell.country = countryLists[indexPath.row]
        cell.loadUI()
        return cell
    }
    
    // Generate new url of province with the id of selected country, and push to another controller.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let story = UIStoryboard.init(name: "Main", bundle: .main)
        let goProvince = story.instantiateViewController(identifier: "ProvinceListViewController") as! ProvinceListViewController
        goProvince.country = countryLists[indexPath.row]
        navigationController?.pushViewController(goProvince, animated: true)
    }
}

// MARK: UITableViewDelegate
extension CountryListViewController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
