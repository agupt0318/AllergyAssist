//
//  ScanBarcode.swift
//  Allergy Without StoryBoard
//
//  Created by Owen Hu on 3/5/23.
//

import UIKit
import Vision

class ScanBarcode : UIViewController {
    override func viewDidLoad(){
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        //ImportImage.borderWidth = 1
        //ImportImage.borderColor = UIColor.black.cgColor
        view.addSubview(ImportImage)
        view.addSubview(AllergyAssist)
        PhotoIcon.frame = CGRect (
           x: 80,
           y: 125,
           width: 40,
           height: 40)
        view.addSubview(PhotoIcon)
        
        start3()
        navi()
    }
    
    let ImportImage : UIButton = {
        let II = UIButton()
        //II.setTitle("Banana", for: .normal)
        II.backgroundColor = UIColor.systemGreen
        //II.layer.cornerRadius =
        //II.layer.borderColor = CGColor.systemBlue
        //II.addTarget(self, action: #selector(Scan_Label), for : .touchUpInside)
        
        return II
        
    }()
    
    private func start3(){
        ImportImage.frame = CGRect(x : 50, y: 180, width: 300, height: 250 )
        view.addSubview(ImportImage)
        AllergyAssist.frame = CGRect(x : 100, y: 50, width: 200, height: 36 )
        view.addSubview(AllergyAssist)
        ScanAnItem.frame = CGRect(x : 125, y: 115, width: 200, height: 50 )
        view.addSubview(ScanAnItem)
        ChooseUser.frame = CGRect(x : 150, y: 450, width: 100, height: 50 )
        view.addSubview(ChooseUser)
        
    }
    
    private let AllergyAssist: UILabel = {
        let allergyAssist = UILabel()
        allergyAssist.frame = CGRect (
             x: 100,
             y: 100,
             width: 200,
             height: 48)
        allergyAssist.numberOfLines = 0
        allergyAssist.textAlignment = .center
        allergyAssist.font = UIFont.boldSystemFont(ofSize: 30)
        allergyAssist.text = "Allergy Assist"
        return allergyAssist
     }()
    
    private let ChooseUser: UILabel = {
        let chooseUser = UILabel()
        chooseUser.frame = CGRect (
            x: 100,
            y: 100,
            width: 200,
            height: 48)
        chooseUser.numberOfLines = 2
        chooseUser.textAlignment = .center
        chooseUser.textColor = UIColor.black
        chooseUser.font = UIFont.boldSystemFont(ofSize: 12)
        chooseUser.text = "Choose User To Scan"
        //chooseUser.cornerRadius = 10
        chooseUser.backgroundColor = UIColor.orange
        return chooseUser
    }()
    
    private let ScanAnItem: UILabel = {
        let SAI = UILabel()
        SAI.frame = CGRect (
             x: 100,
             y: 100,
             width: 200,
             height: 48)
        SAI.numberOfLines = 2
        SAI.textAlignment = .center
        SAI.font = UIFont.boldSystemFont(ofSize: 12)
        SAI.text = "Scan an item barcode to see if it is safe for you to eat"
        return SAI
     }()
    
    private let PhotoIcon: UIImageView = {
        let photoIcon = UIImageView()
        photoIcon.image = UIImage(named: "PhotoIcon")
        photoIcon.contentMode = .scaleAspectFit
        return photoIcon
    }()
    
//    let home_bt : UIButton = {
//         let bt = UIButton()
//         bt.setTitle("Home", for: .normal)
//         bt.backgroundColor = UIColor.systemBlue
//         return bt
//     }()
//     let sl_bt : UIButton = {
//         let bt = UIButton()
//         bt.setTitle("Scan Label", for: .normal)
//         bt.backgroundColor = UIColor.systemBlue
//         return bt
//     }()
//
//     let usercnt : UIButton = {
//         let bt = UIButton()
//         bt.setTitle("User Account", for: .normal)
//         bt.backgroundColor = UIColor.systemBlue
//         return bt
//     }()
    
    let user_bt : UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(systemName: "person"), for: .normal)
        return bt
    }()
    let sb_bt : UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(systemName: "barcode"), for: .normal)
        return bt
    }()
    let sl_bt : UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(systemName: "camera"), for: .normal)
        return bt
    }()
     
    private func navi(){
        user_bt.frame = CGRect(x: 30, y: 770, width: 100, height: 30)
        user_bt.layer.cornerRadius = 10
        user_bt.addTarget(self, action: #selector(User_Account), for: .touchUpInside)
        view.addSubview(user_bt)
        sb_bt.frame = CGRect(x: 140, y: 770, width: 120, height: 30)
        sb_bt.layer.cornerRadius = 10
        sb_bt.addTarget(self, action: #selector(Scan_Barcode), for: .touchUpInside)
        view.addSubview(sb_bt)
        sl_bt.frame = CGRect(x: 270, y: 770, width: 100, height: 30)
        sl_bt.layer.cornerRadius = 10
        sl_bt.addTarget(self, action: #selector(Scan_Label), for: .touchUpInside)
        view.addSubview(sl_bt)
    }
     
     @objc func User_Account(sender : UIButton){
         //pushing the current VC to another T(x) --->  X
         //step one : instance or object declaration
         let vc = UserAccountInfo()
         vc.modalPresentationStyle = .fullScreen
         self.present(vc, animated : true)
     }
     
    @objc func Scan_Label(sender : UIButton){
        //pushing the current VC to another T(x) --->  X
        //step one : instance or object declaration
        let vc = ScanLabel()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated : true)
    }
    
    @objc func Scan_Barcode(sender : UIButton){
        //pushing the current VC to another T(x) --->  X
        //step one : instance or object declaration
        let vc = ScanBarcode()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated : true)
    }
    
//    @objc func home(sender : UIButton){
//        let vc = ViewController()
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: true)
//    }
}
