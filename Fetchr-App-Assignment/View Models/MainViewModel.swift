//
//  MainViewModel.swift
//  Fetchr-App-Assignment
//
//  Created by Hashaam Siddiq on 8/7/17.
//  Copyright © 2017 Hashaam. All rights reserved.
//

import Foundation
import Alamofire

enum ViewModelState {
    case success, failure(Error?)
}

class MainViewModel {
    
    let updateViewHandler: (ViewModelState) -> Void
    
    init(updateViewHandler: @escaping (ViewModelState) -> Void) {
        self.updateViewHandler = updateViewHandler
        getToken()
    }
    
    var request: DataRequest?
    
    var accessToken: String? {
        didSet {
            if searchPending {
                search()
            }
        }
    }
    
    var searchPending = false
    
    var statuses: [ParseStatus]?
    
    var searchString = ""
    
    func getToken() {
        
        if let token = Core.token {
            accessToken = token
            return
        }
        
        let key = CONSUMER_KEY
        let secret = CONSUMER_SECRET
        
        let urlEncodedKey = key.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let urlEncodedSecret = secret.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        
        let joined = "\(urlEncodedKey):\(urlEncodedSecret)"
        let base64EncodedString = Data(joined.utf8).base64EncodedString()
        
        let parameters: [String: Any] = [
            "grant_type": "client_credentials"
        ]
        
        let headers: [String: String] = [
            "Authorization": "Basic \(base64EncodedString)"
        ]
        
        request = Alamofire.request(TOKEN_URL, method: .post, parameters: parameters, headers: headers).validate().responseJSON { [weak self] response in
            
            guard let strongSelf = self else { return }
            
            switch response.result {
                
            case .success(let value):
                let resultData = value as? [String: Any] ?? [:]
                let accessToken = resultData["access_token"] as? String ?? ""
                Core.token = accessToken
                
                strongSelf.accessToken = accessToken
                
            case .failure(let error):
                print(error.localizedDescription)
                
            }
            
        }
        
    }
    
    func search() {
        
        let dateFormatter = DateFormatterManager.shared.formatter
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: Date())
        
        print("\(dateString) searching...")
        
        var tmpSearchString = searchString
        guard tmpSearchString.characters.count > 3 else { return }
        
        guard let accessToken = accessToken else {
            searchPending = true
            return;
        }
        
        tmpSearchString = tmpSearchString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        
        let parameters: [String: Any] = [
            "q": searchString
        ]
        
        let headers: [String: String] = [
            "Authorization": "Bearer \(accessToken)"
        ]
        
        request = Alamofire.request(SEARCH_URL, parameters: parameters, headers: headers).validate().responseJSON(completionHandler: { [weak self] response in
            
            guard let strongSelf = self else { return }
            
            switch response.result {
                
            case .success(let value):
                let resultData = value as? [String: Any] ?? [:]
                let statusesData = resultData["statuses"] as? [[String: Any]] ?? [[:]]
                
                let statuses = statusesData.flatMap { status in
                    ParseStatus(data: status)
                }
                
                DispatchQueue.main.async {
                    strongSelf.statuses = statuses
                    strongSelf.updateViewHandler(.success)
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    strongSelf.updateViewHandler(.failure(error))
                }
                
            }
            
        })
        
    }
    
    var statusesCount: Int {
        return statuses?.count ?? 0
    }
    
    func statusAt(_ index: Int) -> ParseStatus? {
        
        return statuses?[index]
        
    }
    
}
