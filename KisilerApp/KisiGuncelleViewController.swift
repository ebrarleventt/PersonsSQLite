//
//  KisiGuncelleViewController.swift
//  KisilerApp
//
//  Created by Ebrar Levent on 18.01.2024.
//

import UIKit

class KisiGuncelleViewController: UIViewController {
    
    
    @IBOutlet weak var kisiAdTextField: UITextField!
    
    @IBOutlet weak var kisiTelTextField: UITextField!
    
    var kisi:Kisiler?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let k = kisi{
            kisiAdTextField.text = k.kisi_ad
            kisiTelTextField.text = k.kisi_tel
        }



    }

    
    @IBAction func guncelle(_ sender: Any) {
        
        if let k = kisi, let ad = kisiAdTextField.text, let tel = kisiTelTextField.text{
            KisilerDao().kisiGuncelle(kisi_id: k.kisi_id!, kisi_ad: ad, kisi_tel: tel)
        }
        
    }
    
    

}
