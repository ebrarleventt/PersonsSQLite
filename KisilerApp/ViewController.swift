//
//  ViewController.swift
//  KisilerApp
//
//  Created by Ebrar Levent on 18.01.2024.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var kisilerTableView: UITableView!
    
    var kisilerListesi = [Kisiler]()
    
    var aramaYapiliyorMu = false
    var aramaKelimesi:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        veritabaniKopyala()
        
        kisilerTableView.delegate = self
        kisilerTableView.dataSource = self
        
        searchBar.delegate = self
        
    
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if aramaYapiliyorMu{
            kisilerListesi = KisilerDao().aramaYap(kisi_ad: aramaKelimesi!)
        }else{
            kisilerListesi = KisilerDao().tumKisileriAl()
        }
        
        kisilerTableView.reloadData()
        
    }
    
    
    
    //Asagidaki performSegue bu metodu tetikledi
    //Gecis oldugunda bunu algilayabiliyoruz
    //Asagida gonderdigimiz indexPath i de alabiliriz:
    //Veri transferi:
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let index = sender as? Int
        
        if segue.identifier == "kisilerToGuncelle"{
            let gidilecekVC = segue.destination as! KisiGuncelleViewController
            gidilecekVC.kisi = kisilerListesi[index!]
        }
        if segue.identifier == "kisilerToDetay"{
            let gidilecekVC = segue.destination as! KisiDetayViewController
            gidilecekVC.kisi = kisilerListesi[index!]
        }
        
    }

    
    
    
    
    
    func veritabaniKopyala(){
        
        let bundleYolu = Bundle.main.path(forResource: "kisiler", ofType: ".sqlite")
        
        let hedefYol = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        let fileManager = FileManager.default
        
        let kopyalanacakYer = URL(fileURLWithPath: hedefYol).appendingPathComponent("kisiler.sqlite")
        
        if fileManager.fileExists(atPath: kopyalanacakYer.path){
            print("Veritabani zaten var. Kopyalamaya gerek yok.")
        }else{
            do{
                try fileManager.copyItem(atPath: bundleYolu!, toPath: kopyalanacakYer.path)
            }catch{
                print(error)
            }
        }
}


}



extension ViewController:UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kisilerListesi.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let kisi = kisilerListesi[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "kisiCell", for: indexPath) as! KisiCellTableViewCell
        
        cell.kisiCellLabel.text = "\(kisi.kisi_ad!) - \(kisi.kisi_tel!)"
        
        return cell
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "kisilerToDetay", sender: indexPath.row)
        
    }
    
    
    
    //Sil ve guncelle icin:
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let silAction = UITableViewRowAction(style: .default, title: "Sil", handler: {
            
            //tiklanilgi zaman index bilgilerinin gelmesi lazim
            (action:UITableViewRowAction, indexPath:IndexPath) -> Void in
            
            let kisi = self.kisilerListesi[indexPath.row]
                
            KisilerDao().kisiSil(kisi_id: kisi.kisi_id!)
            
            if self.aramaYapiliyorMu{
                self.kisilerListesi = KisilerDao().aramaYap(kisi_ad: self.aramaKelimesi!)
            }else{
                self.kisilerListesi = KisilerDao().tumKisileriAl()
            }
            
            self.kisilerTableView.reloadData()
            
          
        })
        
        
        let guncelleAction = UITableViewRowAction(style: .normal, title: "Guncelle", handler: {
            
            (action:UITableViewRowAction, indexPath:IndexPath) -> Void in
            
           
            
            self.performSegue(withIdentifier: "kisilerToGuncelle", sender: indexPath.row)
            
        })
        
        return [silAction, guncelleAction]
        
        }
    
    
}



extension ViewController:UISearchBarDelegate{
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
        print("Arama Sonucu: \(searchText)")

        aramaKelimesi = searchText
        if searchText == ""{
            aramaYapiliyorMu = false
        }else{
            aramaYapiliyorMu = true
        }
        
        kisilerListesi = KisilerDao().aramaYap(kisi_ad: aramaKelimesi!)
        kisilerTableView.reloadData()
        
    }
    
    
    
}
