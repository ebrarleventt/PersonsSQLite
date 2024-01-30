//
//  KisiEkleViewController.swift
//  KisilerApp
//
//  Created by Ebrar Levent on 18.01.2024.
//

import UIKit

class KisiEkleViewController: UIViewController {
    

    @IBOutlet weak var kisiAdTextField: UITextField!
    
    @IBOutlet weak var kisiTelTextField: UITextField!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()


    }
    


    @IBAction func ekle(_ sender: Any) {
        
        if let ad = kisiAdTextField.text, let tel = kisiTelTextField.text{
            KisilerDao().kisiEkle(kisi_ad: ad, kisi_tel: tel )
        }
        
    }
    
   
    
    

}
