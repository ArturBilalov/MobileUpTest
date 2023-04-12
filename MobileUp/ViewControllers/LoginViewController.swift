//
//  LoginViewController.swift
//  MobileUp
//
//  Created by Artur Bilalov on 12.04.2023.
//

import UIKit
import WebKit


class LoginViewController: UIViewController, WKNavigationDelegate {
    
    var tokenForMyVC = ""
    
    @IBOutlet var webView: WKWebView!
//    var webView: WKWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Создание и отображение модального представления с WKWebView
        
        webView = WKWebView(frame: view.frame)
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        
        // Определяем адрес страницы авторизации
        let authURL = "https://oauth.vk.com/authorize?" +
        "client_id=51611346" +
        "redirect_uri=https://oauth.vk.com/blank.html&" +
        "scope=friends,photos&" +
        "response_type=token&" +
        "v=5.131"
        
        // Загружаем страницу авторизации
        let urlRequest = URLRequest(url: URL(string: authURL)!)
        webView.load(urlRequest)
    }
    
    
    
    // Обработчик завершения загрузки страницы
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Получаем текущий URL
        let currentURL = webView.url?.absoluteString ?? ""
        
        // Проверяем, что мы находимся на странице успешной авторизации
        if currentURL.contains("access_token") {
            guard currentURL.contains("#") else {
                // обработка ошибки
                return
            }
            
            // Разбираем полученные параметры
            let params = currentURL.components(separatedBy: "#")[1]
            let accessToken = params.components(separatedBy: "&")[0].components(separatedBy: "=")[1]
            
            // Вызываем обработчик успешной авторизации
            handleAuthSuccess(accessToken)
        } else if currentURL.contains("error") {
            // Вызываем обработчик неудачной авторизации
            handleAuthError()
        }
    }
    
    
    // Обработчик успешной авторизации
    func handleAuthSuccess(_ accessToken: String) {
        print("Access token: \(accessToken)")
        tokenForMyVC = accessToken
        showPhotosVC()
        
        // здесь можно выполнить дополнительные действия после успешной авторизации
        
    }
    
    
    func showPhotosVC() {
        
        let photosVC = CollectionViewController()
//        photosVC.accessToken = tokenForMyVC
        self.navigationController?.pushViewController(photosVC, animated: true)
        
    }
    
    // Обработчик неудачной авторизации
    func handleAuthError() {
        print("Authorization error")
        // здесь можно выполнить дополнительные действия при неудачной авторизации
    }
    
}
