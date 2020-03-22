//
//  ForecastViewModel.swift
//  Tempo
//
//  Created by Kaio Dantas on 22/03/20.
//  Copyright © 2020 Kaio Dantas. All rights reserved.
//

import Foundation
import Alamofire

class ForecastViewModel {
    
    // MARK: - Properties
    //    private var photo: Photo? {
    //        didSet {
    //            guard let p = photo else { return }
    //            self.setupText(with: p)
    //            self.didFinishFetch?()
    //        }
    //    }
    var error: Error? {
        didSet { self.showAlertClosure?() }
    }
    var isLoading: Bool = false {
        didSet { self.updateLoadingStatus?() }
    }
    
    var titleString: String?
    var albumIdString: String?
    var photoUrl: URL?
    
    
    
    
    // MARK: - Closures for callback, since we are not using the ViewModel to the View.
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFinishFetch: (() -> ())?
    
    
    
    
    // MARK: - Constructor
    init() {
    }
    
    
    
    
    // MARK: - Network call
    func fetchPhoto(withId id: Int) {
        //        self.dataService?.requestFetchPhoto(with: id, completion: { (photo, error) in
        //            if let error = error {
        //                self.error = error
        //                self.isLoading = false
        //                return
        //            }
        //            self.error = nil
        //            self.isLoading = false
        //            self.photo = photo
        //        })
    }
    
    
    
    
    func connectForecast(lat: Double, long: Double){
        let latitude = lat
        let longitude = long
        let lang = "pt"
        let units = "auto"
        let key = APIKeys.darkSkyAPI
        
        
        self.isLoading = true
        AF.request("https://api.darksky.net/forecast/\(key)/\(latitude),\(longitude)?lang=\(lang)&units=\(units)")
            .validate()
            .responseJSON { response in
                
                self.isLoading = false
                
                if(response.error == nil){
                    //SE NAO HOUVE ERRO
                    do {
                        var forecast = try JSONDecoder().decode(Forecast.self, from: response.data!)
                        //self.adicionarItensMapa()
                        
                        print(forecast)
                        
                    } catch {
                        self.error = error
                    }
                    
                    
                } else {
                    //SE HOUVE ERRO
                    if let error = response.error {
                        self.error = error
                        self.isLoading = false
                    }
                }
                
        }
    }
    
    
    
    
    // MARK: - UI Logic
    private func setupText(with photo: String) {
        //        if let title = photo.title, let albumId = photo.albumID, let urlString = photo.url {
        //            self.titleString = "Title: \(title)"
        //            self.albumIdString = "Album ID for this photo : \(albumId)"
        //
        //            // formatting url from http to https
        //            guard let formattedUrlString = String.replaceHttpToHttps(with: urlString), let url = URL(string: formattedUrlString) else {
        //                return
        //            }
        //            self.photoUrl = url
        //        }
    }
    
    
}
