//
//  WelcomeViewController.swift
//  MobileUp
//
//  Created by Artur Bilalov on 12.04.2023.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    init() {
        super.init(nibName: "WelcomeView", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Устанавливаем цвет навигационной панели в белый
        navigationController?.navigationBar.barTintColor = .white
        
    }
    
    @IBAction func button1Tapped(_ sender: Any) {
        let loginVC = LoginViewController()
        navigationController?.pushViewController(loginVC, animated: false)
    }
    
}
