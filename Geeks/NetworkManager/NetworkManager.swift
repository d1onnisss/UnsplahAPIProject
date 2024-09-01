//
//  NetworkManager.swift
//  Geeks
//
//  Created by Alexey Lim on 12/8/24.
//

import Foundation
import FirebaseAuth
import Firebase
import FirebaseFirestore

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchPhotos(completion: @escaping ([UnsplashPhoto]) -> Void) {
        guard let url = URL(string: Constants.URLS.baseURL) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Client-ID \(Constants.Keys.accessKey)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print("Fetch photos error: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                
                if !(200...299).contains(httpResponse.statusCode) {
                    print("Request failed with status code \(httpResponse.statusCode)")
                    return
                }
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let parsedData = try JSONDecoder().decode([UnsplashPhoto].self, from: data)
                print("Fetched \(parsedData.count) photos")
                completion(parsedData)
            } catch {
                print("Decoding error: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    
    func authentication() {
        guard let url = URL(string: Constants.URLS.authenticate) else {return}
        
        var authenticationRequest = URLRequest(url: url)
        
        authenticationRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        authenticationRequest.httpMethod = "POST"
        
        let parameters: [String: Any] = [
            "client_id": Constants.Keys.accessKey,
            "client_secret": Constants.Keys.secretKey,
            "redirect_uri": "urn:ietf:wg:oauth:2.0:oob",
            "code": "SZCzA90lSAJ4L-H8zx7tD9ICDxSLwedggh1bs9qp_kg",
            "grant_type": "authorization_code"
        ]
        
        let bodyString = parameters.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
        
        authenticationRequest.httpBody = bodyString.data(using: .utf8)
        
        URLSession.shared.dataTask(with: authenticationRequest) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let data = data {
                if let jsonString = String(data: data, encoding: .utf8) {
                    print(jsonString)
                }
            }
        }.resume()
    }
    
    func register(firstName: String,
                  lastName: String,
                  email: String,
                  password: String) {
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            let dataBase = Firestore.firestore()
            dataBase.collection("users").addDocument(data: [
                "firstname" : firstName,
                "lastname" : lastName,
                "email" : email,
                "password" : password,
                "uid" : result?.user.uid
            ])
            { (error) in
                if error != nil {
                    print("failure")
                } else {
                    print("success")
                }
            }
        }
    }
    
    func auth(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { Result, error in
            if error != nil {
                print("error")
            } else {
                print("success")
            }
        }
    }
}
