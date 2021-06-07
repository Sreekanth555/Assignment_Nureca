//
//  HomeViewController.swift
//  Assignment
//
//  Created by Srikanth on 04/06/21.
//

import UIKit
import Charts

class HomeViewController: UIViewController {
    //MARK:- IBOutlets
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tblVwSearchCountries: UITableView!
    @IBOutlet var viewCountries: UIView!
    @IBOutlet var pieChart: PieChartView!
    @IBOutlet var lblNodata: UILabel!
    @IBOutlet var tblVwOfflineStorage: UITableView!
    //MARK:- Variables and Constants
    var arrCountryNames = [String]()
    var arrFilteredCountryNames = [String]()
    var isSearchActive = false
    var arrDbCountriesList = [CountriesList]()
    
    //MARK:- UIViewController LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.uiInitalization()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.fetchDataFromDataBase()
    }
    //MARK:- Initialize UI
    func uiInitalization(){
        searchBar.setBackgroundColor(AppColorSet.system_white_color)
        self.navigationController?.navigationBar.isHidden = true
        tblVwSearchCountries.register(UITableViewCell.self, forCellReuseIdentifier: Constants.reUseIdentifierCell)
        tblVwOfflineStorage.register(UITableViewCell.self, forCellReuseIdentifier: Constants.reUseIdentifierCell)
        self.viewCountries.isHidden = true
        self.lblNodata.isHidden = true
        self.apiCallToGetWorldStatistics()
    }
    //MARK:- Fetch Data From DataBase
    func fetchDataFromDataBase()  {
        let arrDbCountryList = CoreDataManager.sharedManager.fetchAllCountriesList()
        self.arrDbCountriesList = arrDbCountryList!
        self.tblVwOfflineStorage.reloadData()
    }
    //MARK:-  Api Calls
    func apiCallToGetCountriesList(){
        ActivityLoader.shared().startLoading()
        ViewModelHomeScreen().getCountriesList("\(UrlConstants.baseUrl)\(UrlConstants.urlGetCountriesList)", self) { (success, response) in
            ActivityLoader.shared().stopLoading()
            if success{
                if let arrModelCountriesList = response as? [ModelCountriesList]{
                    let arrSortedModelCountriesList = arrModelCountriesList.sorted { $0.country! < $1.country! }
                    for model in arrSortedModelCountriesList{
                        if let countryFlag = model.iSO2,let countryName = model.country{
                            let flag = Utils.shared.getCountryFlag(countryFlag)
                            self.arrCountryNames.append("\(flag)  \(countryName)")
                        }
                    }
                    DispatchQueue.main.async {
                        self.tblVwSearchCountries.reloadData()
                    }
                }
            }else{
                if let error = response as? Error{
                    Utils.shared.showAlertMsg(Constants.error, error.localizedDescription, self)
                }
            }
        }
    }
    func apiCallToGetWorldStatistics(){
        ActivityLoader.shared().startLoading()
        ViewModelHomeScreen().getWorldStatisticsList("\(UrlConstants.baseUrl)\(UrlConstants.urlWorldTotal)", self) { (success, response) in
            ActivityLoader.shared().stopLoading()
            if success{
                if let modelWorldStatistics = response as? ModelWorldStatistics{
                    self.assignDataToPieChart(modelWorldStatistics)
                    self.apiCallToGetCountriesList()
                }
            }else{
                if let error = response as? Error{
                    Utils.shared.showAlertMsg(Constants.error, error.localizedDescription, self)
                }
            }
        }
    }
    //MARK:- Charts
    func assignDataToPieChart(_ modelWorldStatistics:ModelWorldStatistics){
        if let confirmedCases = modelWorldStatistics.totalConfirmed,let recoveredCases = modelWorldStatistics.totalRecovered,let deaths = modelWorldStatistics.totalDeaths{
            self.pieChart = Utils.shared.initializeUiForPiChartAndAssignData(pieChart: self.pieChart, confirmedCases: confirmedCases, recoveredCases: recoveredCases, deaths: deaths)
        }
    }
}
// MARK: - TableView Delegat&DataSource Methods
extension HomeViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblVwSearchCountries{
            if isSearchActive{
                return arrFilteredCountryNames.count
            }else{
                return arrCountryNames.count
            }
        }else{
            return arrDbCountriesList.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.reUseIdentifierCell)
        if tableView == tblVwSearchCountries{
            if isSearchActive{
                cell?.textLabel?.text = arrFilteredCountryNames[indexPath.row]
            }else{
                cell?.textLabel?.text = arrCountryNames[indexPath.row]
            }
        }else{
            cell?.textLabel?.text = arrDbCountriesList[indexPath.row].countryName
        }
        cell?.selectionStyle = .none
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let statisticsViewController = self.storyboard?.instantiateViewController(withIdentifier: SBIdentifiers.statisticsViewController_SBIdentifier) as! StatisticsViewController
        if tableView == tblVwSearchCountries{            
            if isSearchActive{
                let recordAlreadyExist = CoreDataManager.sharedManager.checkForEntityExists(countryName: arrFilteredCountryNames[indexPath.row])
                if recordAlreadyExist.0 == true{
                    self.arrDbCountriesList.append(contentsOf: recordAlreadyExist.1!)
                }else{
                    CoreDataManager.sharedManager.insertCountriesListintoCoreData(arrFilteredCountryNames[indexPath.row])
                }
                statisticsViewController.countryName = String(arrFilteredCountryNames[indexPath.row].dropFirst(3)).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            }else{
                let recordAlreadyExist = CoreDataManager.sharedManager.checkForEntityExists(countryName: arrCountryNames[indexPath.row])
                if recordAlreadyExist.0 == true{
                    self.arrDbCountriesList.append(contentsOf: recordAlreadyExist.1!)
                }else{
                    CoreDataManager.sharedManager.insertCountriesListintoCoreData(arrCountryNames[indexPath.row])
                }
                statisticsViewController.countryName = String(arrCountryNames[indexPath.row].dropFirst(3)).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            }
            statisticsViewController.isFromDb = false
            self.viewCountries.isHidden = true
            self.view.endEditing(true)
        }else{
            statisticsViewController.isFromDb = true
            statisticsViewController.countryName = String((arrDbCountriesList[indexPath.row].countryName?.dropFirst(3))!).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        }
        self.navigationController?.pushViewController(statisticsViewController, animated: true)
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == tblVwOfflineStorage{
            if arrDbCountriesList.count>0{
                let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
                headerView.backgroundColor = .white
                let label = UILabel( frame: CGRect(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10))
                label.text = Constants.recentlyViewedCountries
                label.font = .boldSystemFont(ofSize: 16)
                label.textColor = .darkGray
                headerView.addSubview(label)
                
                return headerView
            }else{
                return UIView()
            }
        }else{
            return UIView()
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == tblVwOfflineStorage{
            if arrDbCountriesList.count>0{
                return 50
            }else{
                return 1
            }
        }else{
            return 1
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        1
    }
}
// MARK: -SearchBar Delegate Methods
extension HomeViewController: UISearchBarDelegate{
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.viewCountries.isHidden = false
        return true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        self.viewCountries.isHidden = true
        isSearchActive = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if (searchBar.text!.count == 0) {
            return
        }
        else {
            searchBar.endEditing(true)
            isSearchActive = true
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        arrFilteredCountryNames = arrCountryNames.filter({ (text) -> Bool in
            let temp: NSString = text as NSString
            let range = temp.range(of: searchText, options: .caseInsensitive)
            return range.location != NSNotFound
        })
        if(arrFilteredCountryNames.count == 0){
            if searchText.count == 0 {
                isSearchActive = false
            }
            else{
                self.lblNodata.isHidden = false
                isSearchActive = true
            }
        } else {
            self.lblNodata.isHidden = true
            isSearchActive = true
        }
        self.tblVwSearchCountries.reloadData()
    }
}
