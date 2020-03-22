//
//  ForecastViewController.swift
//  Tempo
//
//  Created by Kaio Dantas on 22/03/20.
//  Copyright © 2020 Kaio Dantas. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import CoreLocation

class ForecastViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var dateTodayBt: UIButton!
    @IBOutlet weak var temperatureNowLb: UILabel!
    @IBOutlet weak var descriptionWeatherNowLb: UILabel!
    @IBOutlet weak var sensationNowLb: UILabel!
    @IBOutlet weak var iconTempNowImg: UIImageView!
    @IBOutlet weak var viewDay: UIView!
    @IBOutlet weak var viewWeek: UIView!
    @IBOutlet weak var hoursStackView: UIStackView!
    @IBOutlet weak var daysCollectionView: UICollectionView!
    @IBOutlet weak var humidityLb: UILabel!
    @IBOutlet weak var pressureLb: UILabel!
    @IBOutlet weak var velocityLb: UILabel!
    @IBOutlet weak var coverSkyLb: UILabel!
    
    
    
    // MARK: - Properties
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var latitude = 0.0
    var longitude = 0.0
    var foundLocation = false
    var itemsWeatherPerDays: [Currently] = []
    
    
    // MARK: - Injection
    let viewModel = ForecastViewModel()
    
    
    
    
    
    // MARK: - ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Initialize the location manager.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        
        daysCollectionView.dataSource = self
        daysCollectionView.delegate = self
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.locationManager.stopUpdatingLocation()
    }
    
    
    //CONECTAR PELA PRIMEIRA VEZ
    func useLocationFirstTime(latitude: Double, longitude: Double){
        if(!foundLocation){
            foundLocation = true

            viewModel.connectForecast(lat: latitude, long: longitude)
            
            viewModel.updateLoadingStatus = {
                let _ = self.viewModel.isLoading ? self.loading.startAnimating() : self.loading.stopAnimating()
            }
            
            //EM CASO DE ERRO
            viewModel.showAlertClosure = {
                if let error = self.viewModel.error {
                    //ERROS DE CONEXAO E OBTENÇÃO DOS DADOS
                    print(error.localizedDescription)
                    self.showAlertMessage(message: "Ocorreu um erro ao obter a previsão. Por favor, tente novamente.")
                }
            }
            
            viewModel.showNotAvailableAlert = {
                //A API DO DARK SKY NÃO INFORMA COMO É O FORMATO DA MSG CASO NÃO TENHA NENHUMA PREVISAO, ASSIM, EU COLOQUEI UMA MSG FIXA PARA TRATAR OS CASOS
                self.showAlertMessage(message: "No momento não há nenhuma previsão do tempo para a sua localização :(")
            }
            
            viewModel.didFinishConnection = {
                self.setLayout()
            }
            
        }
    }
    
    
    
    // MARK: - SET LAYOUT
    func setLayout(){
        dateTodayBt.setTitle(viewModel.dateToday, for: .normal)
        temperatureNowLb.text = viewModel.temperatureNow
        descriptionWeatherNowLb.text = viewModel.descriptionWeatherNow
        sensationNowLb.text = viewModel.sensationNow
        iconTempNowImg.image = UIImage(named: viewModel.iconTempNowImg)
        
        //Adicionando uma animação no ícone do clima para chamar atenção do usuário
        animateWithZoomInOut(self.iconTempNowImg, duration: 0.7)
        
        humidityLb.text = viewModel.humidity
        pressureLb.text = viewModel.pressure
        velocityLb.text = viewModel.velocity
        coverSkyLb.text = viewModel.coverSky
        
        viewWeek.isHidden = !viewModel.showWeekForecast
        viewDay.isHidden = !viewModel.showHoursForecast
        
        //VIEWS DE HORÁRIOS
        
        //REMOVENDO AS VIEWS INSERIDAS ANTERIORMENTE
        let removedSubviews = hoursStackView.arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            hoursStackView.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        for v in removedSubviews {
            if v.superview != nil {
                NSLayoutConstraint.deactivate(v.constraints)
                v.removeFromSuperview()
            }
        }
        
        for viewHour in viewModel.itemsWeatherPerHour {
            hoursStackView.addArrangedSubview(viewHour)
        }
        
        
        //VIEWS DE DIAS
        itemsWeatherPerDays = viewModel.itemsWeatherPerDays
        daysCollectionView.reloadData()
       
    }
    
    
    
    
    
    func animateWithZoomInOut(_ view: UIView, duration: TimeInterval) {
        UIView.animate(withDuration: duration, animations: {() -> Void in
            view.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        }, completion: {(_ finished: Bool) -> Void in
            UIView.animate(withDuration: duration, animations: {() -> Void in
                view.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        })
    }
    
    
    
    
    
    
    func showAlertMessage(message: String){
        if ((self.view.window != nil) && (self.isViewLoaded )){
            let alert = SafeUIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel) { (UIAlertAction) -> Void in }
            alert.addAction(cancelAction)
            self.present(alert, animated: true) { () -> Void in }
        }
    }
    
    
  
    
    
    
    @IBAction func refreshForecast(_ sender: Any) {
        foundLocation = false
        useLocationFirstTime(latitude: latitude, longitude: longitude)
    }
    
}




















// MARK: - UICollectionViewDataSource
extension ForecastViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itemsWeatherPerDays.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_day", for: indexPath) as! CellDays
        
        let day = itemsWeatherPerDays[indexPath.row]
        cell = viewModel.setupDailyCollectionCell(cell: cell, day: day)

        return cell
    }
    
}

// MARK: - UICollectionViewDelegate
extension ForecastViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let day = itemsWeatherPerDays[indexPath.row]
        print(day)
//        let viewController = self.storyboard!.instantiateViewController(withIdentifier: "eventos") as! Eventos_VC
//        viewController.lat = self.lat
//        viewController.long = self.long
//        self.navigationController?.pushViewController(viewController, animated: true)
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destVC = storyboard.instantiateViewController(withIdentifier: "detailsVC") //as! DetailsVC
        
        destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        destVC.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        
        self.present(destVC, animated: true, completion: nil)
    }
}




