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
    @IBOutlet weak var viewDetails: UIView!
    
    
    
    // MARK: - Properties
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var latitude = 0.0
    var longitude = 0.0
    var foundLocation = false
    
    
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
        
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.locationManager.stopUpdatingLocation()
    }
    
    
    
    func useLocationFirstTime(latitude: Double, longitude: Double){
        if(!foundLocation){
            foundLocation = true
            
            //DEFINIR REGIAO

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
    
    
    
    func setLayout(){
        dateTodayBt.setTitle(viewModel.dateToday, for: .normal)
        temperatureNowLb.text = viewModel.temperatureNow
        descriptionWeatherNowLb.text = viewModel.descriptionWeatherNow
        sensationNowLb.text = viewModel.sensationNow
        iconTempNowImg.image = UIImage(named: viewModel.iconTempNowImg)
        
        viewWeek.isHidden = !viewModel.showWeekForecast
        viewDay.isHidden = !viewModel.showHoursForecast
    }
    
    
}











// MARK: - CLLocationManagerDelegate
extension ForecastViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        
        latitude = Double(location.coordinate.latitude)
        longitude = Double(location.coordinate.longitude)
        
        useLocationFirstTime(latitude: latitude,
                             longitude: longitude )
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if (status == .authorizedAlways || status == .authorizedWhenInUse){
            //INICIAR BUSCA DE LOCALIDADE
            locationManager.startUpdatingLocation()
        } else if (status == .denied){
            if(ServicosLocalizacao.GPSEstaAutorizado(view:self)){
                guard self.locationManager.location != nil else{
                    let alert = ServicosLocalizacao.mensagemLocalizacaoNaoEncontrada()
                    self.present(alert, animated: true) { () -> Void in }
                    return
                }
            }
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        locationManager.stopUpdatingLocation()
        let alert = ServicosLocalizacao.mensagemAppDesautorizado()
        self.present(alert, animated: true) { () -> Void in }
        
    }
    
}
