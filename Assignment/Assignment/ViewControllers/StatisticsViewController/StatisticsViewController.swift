//
//  StatisticsViewController.swift
//  Assignment
//
//  Created by Srikanth on 05/06/21.
//

import Foundation
import UIKit
import Charts
class StatisticsViewController: UIViewController {
    //MARK:- IBOutlets
    @IBOutlet var lblCountryName: UILabel!
    @IBOutlet var pieChart: PieChartView!
    @IBOutlet var lineChart: LineChartView!
    
    //MARK:- Variables and Constants
    var countryName = ""
    var modelStatistics : ModelCountriesStatistics?
    var isFromDb = false
    var arrModelDbStatistics = [ModelCountriesStatistics]()
    
    //MARK:- UIViewController LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.uiInitalization()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    //MARK:- Initialize UI
    func uiInitalization(){
        self.lblCountryName.text = String(countryName).removingPercentEncoding
        if !isFromDb{
            self.apiCallToGetCountriesStistics()
        }else{
            self.fetchDataFromDataBase()
        }
    }
    //MARK:- Fetch Data From DataBase
    func fetchDataFromDataBase()  {
        let arrCountryExistInDb = CoreDataManager.sharedManager.fetchCountriesStatisticsByCountryName(countryName: String(countryName).removingPercentEncoding!)
        if let countryExistinDb = arrCountryExistInDb,countryExistinDb.count>0{
            countryExistinDb.forEach{self.arrModelDbStatistics.append($0.modelCountriesStatistics)}
            if self.arrModelDbStatistics.count>0{
                if let modelStatistics = self.arrModelDbStatistics.last{
                    self.assignDataToPieChart(modelStatistics)
                }
                self.lineChart = Utils.shared.initializeUiForLineChartAndAssignData(lineChart: self.lineChart, arrCountriesStastics: self.arrModelDbStatistics)
            }
        }
    }
    //MARK:- Api Call
    func apiCallToGetCountriesStistics(){
        ActivityLoader.shared().startLoading()
        ViewModelStatistics().getCountriesStatisticsList("\(UrlConstants.baseUrl)\(UrlConstants.urlGetStatistics)\(countryName)", self) { (success, response) in
            ActivityLoader.shared().stopLoading()
            if success{
                if let arrModelCountriesStatistics = response as? [ModelCountriesStatistics],arrModelCountriesStatistics.count>0{
                    for modelCountryStatistics in arrModelCountriesStatistics{
                        let recordAlreadyExist = CoreDataManager.sharedManager.checkForStatisticsEntityExists(id: modelCountryStatistics.iD ?? "0")
                        if recordAlreadyExist.0 == true{
                            let arrModelDbStatistics = recordAlreadyExist.1!
                            arrModelDbStatistics.forEach{self.arrModelDbStatistics.append($0.modelCountriesStatistics)}
                        }else{
                            CoreDataManager.sharedManager.insertStatisticsDataintoCoreData(modelCountryStatistics)
                        }
                    }
                    if let modelStatistics = arrModelCountriesStatistics.last{
                        self.assignDataToPieChart(modelStatistics)
                    }
                    self.lineChart = Utils.shared.initializeUiForLineChartAndAssignData(lineChart: self.lineChart, arrCountriesStastics: arrModelCountriesStatistics)
                }
            }else{
                if let error = response as? Error{
                    Utils.shared.showAlertMsg(Constants.error, error.localizedDescription, self)
                }
            }
        }
    }
    //MARK:- Charts
    func assignDataToPieChart(_ modelCountriesStatistics:ModelCountriesStatistics){
        if let confirmedCases = modelCountriesStatistics.confirmed,let recoveredCases = modelCountriesStatistics.recovered,let deaths = modelCountriesStatistics.deaths{
            self.pieChart = Utils.shared.initializeUiForPiChartAndAssignData(pieChart: self.pieChart, confirmedCases: confirmedCases, recoveredCases: recoveredCases, deaths: deaths)
        }
    }
    //MARK:- Button Action
    @IBAction func actionClose(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}


