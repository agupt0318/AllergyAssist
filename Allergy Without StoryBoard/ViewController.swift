

import UIKit

var greeting = "Hello, playground"
// https://www.youtube.com/watch?v=_U6_l58Cv4E
//  ViewController.swift
//  Allergy Without StoryBoard
//
//  Created by Colin Hu on 1/2/23.
//


import Vision
import UIKit

enum AType{
    case nut
}

enum ALevel {
    case easy
    case medium
    case hard
}

class Allergy_Elements {
    //class variable
    let type : AType
    let level : ALevel
    //constructor
    init(type: AType, level: ALevel) {
        self.type = type
        self.level = level
    }
    
    //method
    public func Launch_Alert(){
        print("Allergies contained in this product!")
    }
    
    public func getType() -> AType{
        return self.type
    }
}
//data base to store suspicious elements
var allergy_elements = [Allergy_Elements(type: AType.nut, level: ALevel.medium)]
let sample_db = ["123", "0", "public"]

enum Occupation {
    case student
    case proffesional
}

class Account{
    let name : String?
    let age : Int?
    var Occupation : Occupation?
    var Allergy_Categories : [Allergy_Elements]?
    
    
    init (name : String, age : Int, Allergy_Categories: [Allergy_Elements]){
        self.name = name
        self.age = age
        self.Allergy_Categories = Allergy_Categories
    }
    
    private func insert_EI(){
        for i in 0..<5{
            self.Allergy_Categories?.append(Allergy_Elements(type: AType.nut, level: ALevel.easy))
        }
    }
}

class ViewController: UIViewController {
    var count = 0;
    
    private let label: UILabel = {
         let label = UILabel()
         label.numberOfLines = 0
         label.textAlignment = .center
         label.text = "Allergy Assist"
         
         return label
     }()
    
    private let appName: UILabel = {
         let appName = UILabel()
         appName.frame = CGRect (
            x: 100,
            y: 100,
            width: 200,
            height: 48)
         appName.numberOfLines = 0
         appName.textAlignment = .center
         appName.textColor = UIColor.black
         appName.font = UIFont.boldSystemFont(ofSize: 30)
         appName.text = "Allergy Assist"
         
         return appName
     }()
     
     private let imageView: UIImageView = {
         let imageView = UIImageView()
         imageView.image = UIImage(named: "Cover")
         imageView.contentMode = .scaleAspectFit
         return imageView
     }()
     
     override func viewDidLoad(){
        super.viewDidLoad()
        //view.addSubview(label)
        view.addSubview(appName)
        view.addSubview(imageView)
        view.backgroundColor = UIColor.white
        view.addSubview(log_in)
        view.addSubview(scan_barcode)
        view.addSubview(scan_label)
         
        start()
        
        recognizeText(image: imageView.image)
         
         DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
             self.DA(mes: self.label.text!)
         }
    }
    
    private func start(){
        log_in.frame = CGRect(x : 125, y: 475, width: 150, height: 48 )
        //sign_in.addTarget(self, action: #selector (handle_B(sender: )), for: .touchUpInside)
        view.addSubview(log_in)
        scan_barcode.frame = CGRect(x : 125, y: 575, width: 150, height: 48 )
        view.addSubview(scan_barcode)
        scan_label.frame = CGRect(x : 125, y: 675, width: 150, height: 48 )
        view.addSubview(scan_label)
    }
    
    let log_in : UIButton = {
        let si = UIButton()
        si.setTitle("Log In", for: .normal)
        si.backgroundColor = UIColor.systemGreen
        si.layer.cornerRadius = 10
        si.addTarget(self, action: #selector(LogIn), for : .touchUpInside)
        return si
    }()
    
    let scan_barcode : UIButton = {
        let sb = UIButton()
        sb.setTitle("Scan Barcode", for: .normal)
        sb.backgroundColor = UIColor.systemOrange
        sb.layer.cornerRadius = 10
        sb.addTarget(self, action: #selector(Scan_Barcode), for : .touchUpInside)
        return sb
    }()
    
    let scan_label : UIButton = {
        let sl = UIButton()
        sl.setTitle("Scan Label", for: .normal)
        sl.backgroundColor = UIColor.systemOrange
        sl.layer.cornerRadius = 10
        sl.addTarget(self, action: #selector(Scan_Label), for : .touchUpInside)
        return sl
    }()
    
    @objc func LogIn(){
        //pushing the current VC to another T(x) --->  X
        //step one : instance or object declaration
        let vc = UserAccountInfo()
        let vcRegistration = RegistrationVC()
        //B obj = new B()
        vc.view.backgroundColor = UIColor.white
        //vc.title_lb.text = sign_in.titleLabel?.text
        if vc.user.name == "" {
            vcRegistration.view.backgroundColor = UIColor.white
            self.present(vcRegistration, animated : true)
        } else {
            self.present(vc, animated : true)
        }
    }
    
    @objc func Scan_Label(){
        //pushing the current VC to another T(x) --->  X
        //step one : instance or object declaration
        let vc = ScanLabel()
        //B obj = new B()
        vc.view.backgroundColor = UIColor.white
        //vc.title_lb.text = sign_in.titleLabel?.text
        self.present(vc, animated : true)
        
    }
    
    @objc func Scan_Barcode(){
        //pushing the current VC to another T(x) --->  X
        //step one : instance or object declaration
        let vc = ScanBarcode()
        //B obj = new B()
        vc.view.backgroundColor = UIColor.white
        //vc.title_lb.text = sign_in.titleLabel?.text
        self.present(vc, animated : true)
        
    }
    
     override func viewDidLayoutSubviews(){
         super.viewDidLayoutSubviews()
         imageView.frame = CGRect (
            x: 20,
            y: view.safeAreaInsets.top+80,
            width: view.frame.size.width-40,
            height: view.frame.size.width-40)
         label.frame = CGRect(x: 20,
                          y: view.frame.size.width + view.safeAreaInsets.top-120,
                              width: view.frame.size.width-40,
                              height: 600)
     }
     
     private func recognizeText(image: UIImage?) {
         guard let cgImage = image?.cgImage else {
             fatalError("could not get image")
     }
     
     //Handler
         let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
     //Request
         let request = VNRecognizeTextRequest { [weak self] request, error in
             guard let observations = request.results as? [VNRecognizedTextObservation],
                   error == nil else {
                 return
     }
     
             let text = observations.compactMap({
                 $0.topCandidates(1).first?.string
            }).joined(separator: " ,")
     
             DispatchQueue.main.async {
         self?.label.text = text
             }
         }
     //Process the Request
            do {
                try handler.perform([request])
            }
            catch{
                label.text = ("\(error)")
            }
        }
    
    
    
    //Data Analysis
    public func DA(mes : String) -> Bool{
            //var text1 = mes
            print(mes)
        //passing the raw data in form of string
        // convert the string into array and split the substring by special symbols such as , ; space...
        // "the food contains peanut, fruit, milk" -> ["the", "food", "contains", "peanut", "fruit", "milk"]
        let res : Bool = false;
        var cnt : Int = 0
        let arr = mes.split(separator: ", ")
        print(arr)
        var percentage_arr = [String]()
        return res;
        for item in arr {
            if item.contains("%") {
                percentage_arr.append(String(item))
            }
        }
        print(percentage_arr)
        for i in 0..<arr.count {
            let lb = UILabel()
            lb.numberOfLines = -1
            let size : CGFloat = CGFloat(arr[i].count * 18 + 10)
            let x : CGFloat = 10
            let y = CGFloat(i) * 20 + 300
            lb.frame = CGRect(x: x, y: y, width: size, height: 20)
            lb.backgroundColor = UIColor.black
            lb.clipsToBounds = true
            lb.layer.cornerRadius = 3
            lb.textColor = .white
            lb.font = UIFont.boldSystemFont(ofSize: 18)
            lb.text = String(arr[i])
            view.addSubview(lb)
        }
        /*for item in mes {
            for inner in sample_db{
                if item == Character(inner){
                    cnt += 1
                }
                
            }
        }*/
    }
}

class ScanLabel : UIViewController {
    override func viewDidLoad(){
        super.viewDidLoad()
        let textView = UITextView(frame: CGRect(x: 50, y: 525, width: 300, height: 225))
        
        textView.font = UIFont.boldSystemFont(ofSize: 20)
        textView.text = IngredientList.text
        view.addSubview(textView)
        //ImportImage.borderWidth = 1
        //ImportImage.borderColor = UIColor.black.cgColor
        view.addSubview(display_imageview)
        view.addSubview(AllergyAssist)
        PhotoIcon.frame = CGRect (
           x: 80,
           y: 125,
           width: 40,
           height: 40)
        view.addSubview(PhotoIcon)
        recognizeText(image: display_imageview.image)
        
        start3()
    }
    
    let User1 : UIButton = {
        let U1 = UIButton()
        U1.setTitle("User 1", for: .normal)
        U1.backgroundColor = UIColor.systemOrange
        U1.layer.cornerRadius = 10
        //U1.addTarget(self, action: #selector(Scan_Label), for : .touchUpInside)
        return U1
    }()
    
    let display_imageview : UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor.systemGray
        iv.isUserInteractionEnabled = true
            iv.image = UIImage(named : "example2") //iv.image = UIImage(named : "sample.png")
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.black.cgColor
        return iv
    }()
    
    
    /*let ImportImage : UIButton = {
        let II = UIButton()
        //II.setTitle("Banana", for: .normal)
        II.backgroundColor = UIColor.systemGreen
        //II.layer.cornerRadius =
        //II.layer.borderColor = CGColor.systemBlue
        //II.addTarget(self, action: #selector(Scan_Label), for : .touchUpInside)
        
        return II
        
    }()*/
    
    let home_bt : UIButton = {
        let bt = UIButton()
        bt.setTitle("Home", for: .normal)
        bt.backgroundColor = UIColor.systemGray
        return bt
    }()
    
    @objc func h1(sender : UIButton){
        let vc = ViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    private func start3(){
        display_imageview.frame = CGRect(x : 50, y: 180, width: 300, height: 250 )
        view.addSubview(display_imageview)
        User1.frame = CGRect(x : 150, y: 500, width: 100, height: 50 )
        view.addSubview(display_imageview)
        AllergyAssist.frame = CGRect(x : 100, y: 50, width: 200, height: 36 )
        view.addSubview(AllergyAssist)
        ScanAnItem.frame = CGRect(x : 125, y: 120, width: 200, height: 50 )
        view.addSubview(ScanAnItem)
        ChooseUser.frame = CGRect(x : 150, y: 450, width: 100, height: 50 )
        view.addSubview(ChooseUser)
        IngredientList.frame = CGRect(x : 50, y: 525, width: 300, height: 225 )
        view.addSubview(IngredientList)
        home_bt.frame = CGRect(x: 150, y: 750, width: 100, height: 30)
        home_bt.addTarget(self, action: #selector(h1(sender: )), for: .touchUpInside)
        view.addSubview(home_bt)
        
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
        allergyAssist.textColor = UIColor.black
        allergyAssist.font = UIFont.boldSystemFont(ofSize: 24)
        allergyAssist.text = "Allergy Assist"
        allergyAssist.backgroundColor = UIColor.white
        
         
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
    
    private let IngredientList: UITextView = {
        let iList = UITextView()
        //iList.numberOfLines = 12
        //iList.textAlignment = .center
        iList.textColor = UIColor.black
        iList.font = UIFont.boldSystemFont(ofSize: 12)
        iList.text = ""
        iList.isEditable = false
        iList.isUserInteractionEnabled = true
        //chooseUser.cornerRadius = 10
        iList.backgroundColor = UIColor.white
        iList.layer.borderWidth = 1
        iList.layer.borderColor = UIColor.black.cgColor
         
         return iList
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
        SAI.textColor = UIColor.black
        SAI.font = UIFont.boldSystemFont(ofSize: 12)
        SAI.text = "Scan an item label to see if it is safe for you to eat"
        SAI.backgroundColor = UIColor.white
        
         
         return SAI
     }()
    
    private let PhotoIcon: UIImageView = {
        let photoIcon = UIImageView()
        photoIcon.image = UIImage(named: "PhotoIcon")
        photoIcon.contentMode = .scaleAspectFit
        return photoIcon
    }()
    
    private func recognizeText(image: UIImage?) {
        guard let cgImage = image?.cgImage else {
            fatalError("could not get image")
    }
    
    //Handler
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
    //Request
        let request = VNRecognizeTextRequest { [weak self] request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation],
                  error == nil else {
                return
    }
    
            let text = observations.compactMap({
                $0.topCandidates(1).first?.string
           }).joined(separator: " ,")
    
            DispatchQueue.main.async {
        self?.IngredientList.text = text
            }
        }
    //Process the Request
           do {
               try handler.perform([request])
           }
           catch{
               IngredientList.text = ("\(error)")
           }
        
       }
   
   
   
   //Data Analysis
   public func DA(mes : String) -> Bool{
           //var text1 = mes
           print(mes)
       //passing the raw data in form of string
       // convert the string into array and split the substring by special symbols such as , ; space...
       // "the food contains peanut, fruit, milk" -> ["the", "food", "contains", "peanut", "fruit", "milk"]
       let res : Bool = false;
       var cnt : Int = 0
       let arr = mes.split(separator: ", ")
       print(arr)
       var percentage_arr = [String]()
       for item in arr {
           if item.contains("%") {
               percentage_arr.append(String(item))
           }
       }
       print(percentage_arr)
       for i in 0..<arr.count {
           let lb = UILabel()
           lb.numberOfLines = -1
           let size : CGFloat = CGFloat(arr[i].count * 18 + 10)
           let x : CGFloat = 10
           let y = CGFloat(i) * 20 + 300
           lb.frame = CGRect(x: x, y: y, width: size, height: 20)
           lb.backgroundColor = UIColor.black
           lb.clipsToBounds = true
           lb.layer.cornerRadius = 3
           lb.textColor = .white
           lb.font = UIFont.boldSystemFont(ofSize: 18)
           lb.text = String(arr[i])
           view.addSubview(lb)
       }
       return res;
   }
}

class ScanBarcode : UIViewController {
    override func viewDidLoad(){
        super.viewDidLoad()
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
        allergyAssist.textColor = UIColor.black
        allergyAssist.font = UIFont.boldSystemFont(ofSize: 24)
        allergyAssist.text = "Allergy Assist"
        allergyAssist.backgroundColor = UIColor.white
        
         
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
        SAI.textColor = UIColor.black
        SAI.font = UIFont.boldSystemFont(ofSize: 12)
        SAI.text = "Scan an item barcode to see if it is safe for you to eat"
        SAI.backgroundColor = UIColor.white
        
         
         return SAI
     }()
    
    private let PhotoIcon: UIImageView = {
        let photoIcon = UIImageView()
        photoIcon.image = UIImage(named: "PhotoIcon")
        photoIcon.contentMode = .scaleAspectFit
        return photoIcon
    }()
    
}



class UserAccountInfo : UIViewController{
    let db_user = UserDefaults.standard
    let vc = RegistrationVC()
    lazy var user = vc.user
    let left_margin : CGFloat = 10;
    let top_margin : CGFloat = 10;
    lazy var container_height : CGFloat = view.frame.height / 4
    
    //user interface
    lazy var top_container : UIView = {
        let iv = UIView()
        iv.frame = CGRect(x : left_margin, y: AddUser.center.y + AddUser.frame.height * 2.2 + top_margin, width: view.frame.width - 2 * left_margin, height: container_height)
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 30
        iv.backgroundColor = UIColor.systemGray
        
        let user_profile_image_view = UIImageView()
        user_profile_image_view.image = UIImage(systemName: "Camera")
        user_profile_image_view.frame = CGRect(x : left_margin, y: top_margin, width: iv.frame.width/4, height: iv.frame.width/4)
        user_profile_image_view.clipsToBounds = true
        user_profile_image_view.backgroundColor = .white
        user_profile_image_view.layer.cornerRadius = 5
        
        let user_name = UILabel()
        user_name.frame = CGRect(x: left_margin + user_profile_image_view.center.x + user_profile_image_view.frame.width / 2, y: top_margin, width: 3 * (iv.frame.width / 4) - left_margin * 4, height: 20)
        user_name.clipsToBounds = true
        user_name.layer.cornerRadius = 5
        user_name.font = UIFont.boldSystemFont(ofSize : 18)
        user_name.backgroundColor = .white
        user_name.text = String(user.name)
        DispatchQueue.main.asyncAfter(deadline:
            DispatchTime.now() + 1) {
            user_name.text = self.user.name
        }
    
        let user_bio = UILabel()
        user_bio.frame = CGRect(x: left_margin, y: top_margin + user_profile_image_view.center.y + user_profile_image_view.frame.height / 2, width: iv.frame.width / 1.05, height: 20)
        user_bio.clipsToBounds = true
        user_bio.layer.cornerRadius = 5
        user_bio.font = UIFont.boldSystemFont(ofSize : 18)
        user_bio.backgroundColor = .white
        user_bio.text = user.email
        
        DispatchQueue.main.asyncAfter(deadline:
            DispatchTime.now() + 1) {
            user_bio.text = self.user.email
        }
        user_bio.text = user.email
        
        let user_email = UILabel()
        user_email.frame = CGRect(x: left_margin + user_profile_image_view.center.x + user_profile_image_view.frame.width / 2, y: top_margin, width: 3 * (iv.frame.width / 4) - left_margin * 4, height: 20)
        user_email.clipsToBounds = true
        user_email.layer.cornerRadius = 5
        user_email.font = UIFont.boldSystemFont(ofSize : 18)
        user_email.backgroundColor = .white
        user_email.text = user.email
        
        DispatchQueue.main.asyncAfter(deadline:
            DispatchTime.now() + 1) {
            user_bio.text = self.user.email
        }
        
        user_bio.text = user.email
        iv.addSubview(user_bio)
        iv.addSubview(user_name)
        iv.addSubview(user_profile_image_view)
        
        return iv
    }()

    lazy var middle_container : UIView = {
        let iv = UIView()
        iv.frame = CGRect(x : left_margin, y: top_container.center.y + top_container.frame.height / 2 + top_margin, width: view.frame.width - 2 * left_margin, height: container_height)
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 30
        iv.backgroundColor = UIColor.systemGray
        return iv
    }()
    
    lazy var bottom_container : UIView = {
        let iv = UIView()
        iv.frame = CGRect(x : left_margin, y: middle_container.center.y + middle_container.frame.height / 2 + top_margin, width: view.frame.width - 2 * left_margin, height: container_height)
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 30
        iv.backgroundColor = UIColor.systemGray
        
        return iv
    }()
    func setup(){
        
        
        
        view.addSubview(top_container)
        view.addSubview(middle_container)
        view.addSubview(bottom_container)
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        view.addSubview(AddUser)
        view.frame = CGRect(x : 0, y: 0, width: 400, height: 600)
        setup()
        start2()
        
    }
    lazy var AddUser : UIButton = {
        let AU = UIButton()
        AU.setTitle("Add User", for: .normal)
        AU.backgroundColor = UIColor.systemGreen
        AU.layer.cornerRadius = 10
        AU.addTarget(self, action: #selector(handle_C), for : .touchUpInside)
        AU.frame = CGRect(x : 60, y: 60, width: 125, height: 36 )
        
        return AU
        
    }()
    
    private func start2(){
        AddUser.frame = CGRect(x : 60, y: 60, width: 125, height: 36 )
        view.addSubview(AddUser)
        UserAccount.frame = CGRect(x : 0, y: 120, width: 400, height: 36 )
        view.addSubview(UserAccount)
    }
    
    private let UserAccount: UILabel = {
         let userAccount = UILabel()
         userAccount.frame = CGRect (
             x: 100,
             y: 100,
             width: 200,
             height: 48)
         userAccount.numberOfLines = 0
         userAccount.textAlignment = .center
         userAccount.textColor = UIColor.black
         userAccount.font = UIFont.boldSystemFont(ofSize: 24)
         userAccount.text = "User Account"
         userAccount.backgroundColor = UIColor.systemYellow
        
         
         return userAccount
     }()
    
    private let plusSign: UIImageView = {
        let ps = UIImageView()
        ps.image = UIImage(named: "Cover")
        ps.contentMode = .scaleAspectFit
        return ps
    }()
    
    @objc func handle_C(){
        //pushing the current VC to another T(x) --->  X
        //step one : instance or object declaration
        let vc = RegistrationVC()
        //B obj = new B()
        vc.view.backgroundColor = UIColor.white
        //vc.title_lb.text = sign_in.titleLabel?.text
        self.present(vc, animated : true)
        
    }
    
}

enum Race{
    case Asian
    case Black
    case Latino
    case White
    case Other
}

class User {
    var email : String
    var name : String
    var password : String
    var race : Race
    var allergies: [Int]
    init (email : String, name : String, password : String, race : Race, allergies : [Int]){
        self.email = email
        self.name = name
        self.password = password
        self.race = Race.Other
        self.allergies = [Int](repeating: 0, count: 14)
    }
    func updateAllergies(allergies: [Int]) {
        self.allergies = allergies
    }
}


class RegistrationVC : UIViewController {
    
    let db_user = UserDefaults.standard
    
    let email_input : UITextView = {
        let tx = UITextView()
        tx.isUserInteractionEnabled = true
        tx.layer.borderWidth = 2
        tx.layer.borderColor = UIColor.black.cgColor
        
        return tx
        
    }()
    
    let name_input : UITextView = {
        
        let tx1 = UITextView()
        tx1.isUserInteractionEnabled = true
        tx1.layer.borderWidth = 2
        tx1.layer.borderColor = UIColor.black.cgColor
        
        return tx1
        
    }()
    
    let password_input : UITextView = {
        let tx2 = UITextView()
        tx2.isUserInteractionEnabled = true
        tx2.layer.borderWidth = 2
        tx2.layer.borderColor = UIColor.black.cgColor
        
        return tx2
        
    }()
    
    var user = User(email: "sample@gmail.com", name: "", password: "123456abc", race: Race.Asian, allergies: [0,0,0,0,0,0,0,0,0,0,0,0,0])
    
    @objc func submit() {
        guard let txt = email_input.text else {return}
        guard let txt1 = name_input.text else {return}
        guard let txt2 = password_input.text else {return}
        //let sampleEmail = "asdasd"
        //email_input.text = sampleEmail
        user.email = email_input.text
        user.name =  name_input.text
        
        db_user.setValue(txt, forKey: "mess1")
        db_user.setValue(txt1, forKey: "mess2")
        db_user.setValue(txt2, forKey: "mess3")
        
        let vc = UserAccountInfo()
        vc.view.backgroundColor = UIColor.white
        vc.user = self.user
        self.present(vc, animated: true)
        
        
        //self.dismiss(animated: true)
    }
    
    @objc func test() {
        //let sampleEmail = "asdasd"
        //email_input.text = sampleEmail
        
        let vc = myAllergens()
        self.present(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(EditButton)
        view.frame = CGRect(x: 0, y: 0, width: 400, height: 600)
        /*DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
         self.work();
         }*/
        start3()
        for item in res {
            item.addTarget(self, action: #selector(SelectingRace(sender: )), for: .touchUpInside)
            view.addSubview(item)
        }
    }
    
    let races = ["Asian", "Black", "Latino", "White", "Other"]
    lazy var res = SelectRace(arr: races,
                              n: races.count,
                              c: UIColor.systemBlue,
                              s: (view.frame.width/CGFloat(races.count)) * 0.85,
                              y: 200,
                              m: 1.2)
    
    let EditButton : UIButton = {
        let EB = UIButton()
        EB.setTitle("Edit", for: .normal)
        EB.backgroundColor = UIColor.systemGreen
        EB.layer.cornerRadius = 10
        EB.addTarget(self, action: #selector(test), for : .touchUpInside)
        
        return EB
        
    }()
    
    lazy var SaveButton : UIButton = {
        let SB = UIButton()
        SB.setTitle("Save", for: .normal)
        SB.backgroundColor = UIColor.systemGreen
        SB.layer.cornerRadius = 10
        SB.addTarget(self, action: #selector(submit), for : .touchUpInside)
        
        return SB
        
    }()
    
    func SelectRace (arr : [String], n : Int, c : UIColor, s : CGFloat, y : CGFloat, m : CGFloat) -> [UIButton] {
        var res = [UIButton]()
        for i in 0..<n {
            let bt = UIButton()
            let x : CGFloat = CGFloat(i) * s * m + 10
            bt.frame = CGRect(x: x-5, y: y+100, width: s-10, height: 2 * s/3)
            bt.tag = i
            bt.setTitle(arr[i], for: .normal)
            bt.backgroundColor = c
            res.append(bt)
        }
        return res
    }
    var isPicked : [Bool] = [false,false,false,false,false]
    @objc func SelectingRace(sender : UIButton) {
        // implement algorithm to make each button work
        // check if the button is selected
        // if yes, then turn other 3s off
        // turn the currect button on
        sender.isSelected = true
        let index = sender.tag
        for i in 0..<res.count {
            if i == index {
                isPicked[i] = true
                res[i].isSelected = isPicked[i]
                res[i].backgroundColor = .green
            }else{
                isPicked[i] = false
                res[i].isSelected = isPicked[i]
                res[i].backgroundColor = .gray
            }
        }
        print(isPicked)
        print(user)
        //user["Race"] = sender.titleLabel?.text
        
    }
    
    let SetUpMyAllergenProfile : UIButton = {
        let SUMAP = UIButton()
        SUMAP.setTitle("Set Up My Allergen Profile", for: .normal)
        SUMAP.backgroundColor = UIColor.systemGreen
        SUMAP.layer.cornerRadius = 10
        SUMAP.addTarget(self, action: #selector(submit), for : .touchUpInside)
        
        return SUMAP
        
    }()
    
    private func start3(){
        EditButton.frame = CGRect(x : 125, y: 400, width: 50, height: 36 )
        view.addSubview(EditButton)
        SaveButton.frame = CGRect(x : 225, y: 400, width: 50, height: 36 )
        view.addSubview(SaveButton)
        SetUpMyAllergenProfile.frame = CGRect(x : 75, y: 575, width : 250, height : 36)
        view.addSubview(SetUpMyAllergenProfile)
        UserAccount.frame = CGRect(x : 0, y: 50, width: 400, height: 36 )
        view.addSubview(UserAccount)
        Finalize.frame = CGRect(x : 50, y: 465, width: 300, height: 72 )
        view.addSubview(Finalize)
        email_input.text = db_user.string(forKey: "mess1")
        email_input.frame = CGRect(x:45, y: 120, width: 300, height: 30)
        view.addSubview(email_input)
        name_input.text = db_user.string(forKey: "mess2")
        name_input.frame = CGRect(x:45, y: 180, width: 300, height: 30)
        view.addSubview(name_input)
        password_input.text = db_user.string(forKey: "mess3")
        password_input.frame = CGRect(x:45, y: 240, width: 300, height: 30)
        view.addSubview(password_input)
        emailAccount.frame = CGRect(x : 50, y: 96, width: 300, height: 24 )
        view.addSubview(emailAccount)
        userName.frame = CGRect(x : 50, y: 156, width: 300, height: 24 )
        view.addSubview(userName)
        passwordString.frame = CGRect(x : 50, y: 216, width: 300, height: 24 )
        view.addSubview(passwordString)
    }
    
    private let UserAccount: UILabel = {
        let userAccount = UILabel()
        userAccount.frame = CGRect (
            x: 100,
            y: 100,
            width: 200,
            height: 48)
        userAccount.numberOfLines = 0
        userAccount.textAlignment = .center
        userAccount.textColor = UIColor.black
        userAccount.font = UIFont.boldSystemFont(ofSize: 24)
        userAccount.text = "User Account"
        userAccount.backgroundColor = UIColor.systemYellow
        
        
        return userAccount
    }()
    
    private let emailAccount: UILabel = {
        let email = UILabel()
        email.frame = CGRect (
            x: 100,
            y: 100,
            width: 200,
            height: 48)
        email.numberOfLines = 0
        //email.textAlignment = .center
        email.textColor = UIColor.black
        email.font = UIFont.boldSystemFont(ofSize: 12)
        email.text = "Enter Your Email"
        email.backgroundColor = UIColor.white
        
        
        return email
    }()
    
    private let userName: UILabel = {
        let username = UILabel()
        username.frame = CGRect (
            x: 100,
            y: 100,
            width: 200,
            height: 48)
        username.numberOfLines = 0
        //email.textAlignment = .center
        username.textColor = UIColor.black
        username.font = UIFont.boldSystemFont(ofSize: 12)
        username.text = "Enter Your Name"
        username.backgroundColor = UIColor.white
        
        
        return username
    }()
    
    private let passwordString: UILabel = {
        let password = UILabel()
        password.frame = CGRect (
            x: 100,
            y: 100,
            width: 200,
            height: 48)
        password.numberOfLines = 0
        //email.textAlignment = .center
        password.textColor = UIColor.black
        password.font = UIFont.boldSystemFont(ofSize: 12)
        password.text = "Password"
        password.backgroundColor = UIColor.white
        
        
        return password
    }()
    
    
    
    private let Finalize: UILabel = {
        let finalize = UILabel()
        finalize.frame = CGRect (
            x: 100,
            y: 100,
            width: 200,
            height: 96)
        finalize.numberOfLines = 3
        finalize.textAlignment = .center
        finalize.textColor = UIColor.black
        finalize.font = UIFont.boldSystemFont(ofSize: 18)
        finalize.text = "Finalize your personalized list of ingredients that you eat, limit, and avoid based on your selections."
        finalize.backgroundColor = UIColor.white
        
        
        return finalize
    }()
    
    private let plusSign: UIImageView = {
        let ps = UIImageView()
        ps.image = UIImage(named: "Cover")
        
        ps.contentMode = .scaleAspectFit
        return ps
    }()
    
    class Add_User : UIViewController {
        
        var user_registration = ["Email" : "sample", "Name" : "N/A", "Age" : "0", "Race" : "N/A"]
        let races = ["Asian", "Black", "Latino", "White", "Other"]
        lazy var res = SelectRace(arr: races,
                                  n: races.count,
                                  c: UIColor.systemBlue,
                                  s: (view.frame.width/CGFloat(races.count)) * 0.85,
                                  y: 200,
                                  m: 1.2)
        
        override func viewDidLoad(){
            super.viewDidLoad()
            view.addSubview(EditButton)
            start3()
            
            
            for item in res {
                item.addTarget(self, action: #selector(SelectingRace(sender: )), for: .touchUpInside)
                view.addSubview(item)
            }
        }
        
        let EditButton : UIButton = {
            let EB = UIButton()
            EB.setTitle("Edit", for: .normal)
            EB.backgroundColor = UIColor.systemGreen
            EB.layer.cornerRadius = 10
            EB.addTarget(self, action: #selector(submit), for : .touchUpInside)
            
            return EB
            
        }()
        
        lazy var SaveButton : UIButton = {
            let SB = UIButton()
            SB.setTitle("Save", for: .normal)
            SB.backgroundColor = UIColor.systemGreen
            SB.layer.cornerRadius = 10
            SB.addTarget(self, action: #selector(submit), for : .touchUpInside)
            
            return SB
            
        }()
        
        func SelectRace (arr : [String], n : Int, c : UIColor, s : CGFloat, y : CGFloat, m : CGFloat) -> [UIButton] {
            var res = [UIButton]()
            for i in 0..<n {
                let bt = UIButton()
                let x : CGFloat = CGFloat(i) * s * m + 10
                bt.frame = CGRect(x: x, y: y+100, width: s, height: s)
                bt.tag = i
                bt.setTitle(arr[i], for: .normal)
                bt.backgroundColor = c
                res.append(bt)
            }
            return res
        }
        var isPicked : [Bool] = [false,false,false,false,false]
        @objc func SelectingRace(sender : UIButton) {
            // implement algorithm to make each button work
            // check if the button is selected
            // if yes, then turn other 3s off
            // turn the currect button on
            sender.isSelected = true
            let index = sender.tag
            for i in 0..<res.count {
                if i == index {
                    isPicked[i] = true
                    res[i].isSelected = isPicked[i]
                    res[i].backgroundColor = .green
                }else{
                    isPicked[i] = false
                    res[i].isSelected = isPicked[i]
                    res[i].backgroundColor = .gray
                }
            }
            print(isPicked)
            print(user_registration)
            user_registration["Race"] = sender.titleLabel?.text
            
        }
        
        let SetUpMyAllergenProfile : UIButton = {
            let SUMAP = UIButton()
            SUMAP.setTitle("Set Up My Allergen Profile", for: .normal)
            SUMAP.backgroundColor = UIColor.systemGreen
            SUMAP.layer.cornerRadius = 10
            SUMAP.addTarget(self, action: #selector(submit), for : .touchUpInside)
            
            return SUMAP
            
        }()
        
        let input_box : UITextView = {
            let tx = UITextView()
            tx.isUserInteractionEnabled = true
            tx.layer.borderWidth = 2
            tx.layer.borderColor = UIColor.black.cgColor
            
            return tx
        }()
        
        let input_box1 : UITextView = {
            let tx1 = UITextView()
            tx1.isUserInteractionEnabled = true
            tx1.layer.borderWidth = 2
            tx1.layer.borderColor = UIColor.black.cgColor
            
            return tx1
            
        }()
        
        let input_box2 : UITextView = {
            let tx2 = UITextView()
            tx2.isUserInteractionEnabled = true
            tx2.layer.borderWidth = 2
            tx2.layer.borderColor = UIColor.black.cgColor
            
            return tx2
            
        }()
        
        private func start3(){
            EditButton.frame = CGRect(x : 125, y: 400, width: 50, height: 36 )
            view.addSubview(EditButton)
            SaveButton.frame = CGRect(x : 225, y: 400, width: 50, height: 36 )
            view.addSubview(SaveButton)
            SetUpMyAllergenProfile.frame = CGRect(x : 75, y: 575, width : 250, height : 36)
            view.addSubview(SetUpMyAllergenProfile)
            UserAccount.frame = CGRect(x : 0, y: 50, width: 400, height: 36 )
            view.addSubview(UserAccount)
            Finalize.frame = CGRect(x : 50, y: 465, width: 300, height: 72 )
            view.addSubview(Finalize)
            input_box.frame = CGRect(x:45, y: 120, width: 300, height: 30)
            view.addSubview(input_box)
            input_box1.frame = CGRect(x:45, y: 180, width: 300, height: 30)
            view.addSubview(input_box1)
            input_box2.frame = CGRect(x:45, y: 240, width: 300, height: 30)
            view.addSubview(input_box2)
            emailAccount.frame = CGRect(x : 50, y: 96, width: 300, height: 24 )
            view.addSubview(emailAccount)
            userName.frame = CGRect(x : 50, y: 156, width: 300, height: 24 )
            view.addSubview(userName)
            passwordString.frame = CGRect(x : 50, y: 216, width: 300, height: 24 )
            view.addSubview(passwordString)
        }
        
        private let UserAccount: UILabel = {
            let userAccount = UILabel()
            userAccount.frame = CGRect (
                x: 100,
                y: 100,
                width: 200,
                height: 48)
            userAccount.numberOfLines = 0
            userAccount.textAlignment = .center
            userAccount.textColor = UIColor.black
            userAccount.font = UIFont.boldSystemFont(ofSize: 24)
            userAccount.text = "User Account"
            userAccount.backgroundColor = UIColor.systemYellow
            
            
            return userAccount
        }()
        
        private let emailAccount: UILabel = {
            let email = UILabel()
            email.frame = CGRect (
                x: 100,
                y: 100,
                width: 200,
                height: 48)
            email.numberOfLines = 0
            //email.textAlignment = .center
            email.textColor = UIColor.black
            email.font = UIFont.boldSystemFont(ofSize: 12)
            email.text = "Enter Your Email"
            email.backgroundColor = UIColor.white
            
            
            return email
        }()
        
        private let userName: UILabel = {
            let username = UILabel()
            username.frame = CGRect (
                x: 100,
                y: 100,
                width: 200,
                height: 48)
            username.numberOfLines = 0
            //email.textAlignment = .center
            username.textColor = UIColor.black
            username.font = UIFont.boldSystemFont(ofSize: 12)
            username.text = "Enter Your Name"
            username.backgroundColor = UIColor.white
            
            
            return username
        }()
        
        private let passwordString: UILabel = {
            let age = UILabel()
            age.frame = CGRect (
                x: 100,
                y: 100,
                width: 200,
                height: 48)
            age.numberOfLines = 0
            //email.textAlignment = .center
            age.textColor = UIColor.black
            age.font = UIFont.boldSystemFont(ofSize: 12)
            age.text = "Age"
            age.backgroundColor = UIColor.white
            
            
            return age
        }()
        
        
        
        private let Finalize: UILabel = {
            let finalize = UILabel()
            finalize.frame = CGRect (
                x: 100,
                y: 100,
                width: 200,
                height: 96)
            finalize.numberOfLines = 3
            finalize.textAlignment = .center
            finalize.textColor = UIColor.black
            finalize.font = UIFont.boldSystemFont(ofSize: 18)
            finalize.text = "Finalize your personalized list of ingredients that you eat, limit, and avoid based on your selections."
            finalize.backgroundColor = UIColor.white
            
            
            return finalize
        }()
        
        private let plusSign: UIImageView = {
            let ps = UIImageView()
            ps.image = UIImage(named: "Cover")
            
            ps.contentMode = .scaleAspectFit
            return ps
        }()
    }
    class myAllergens: UIViewController, UITableViewDataSource, UITableViewDelegate {
        var allergens: [[Any]] = [["Shellfish","+"],
                                      ["Egg",""],
                                      ["Peanut",""],
                                      ["Tree Nuts","+"],
                                      ["Dairy",""],
                                      ["Fish",""],
                                      ["Sesame",""],
                                      ["Soybean",""],
                                      ["Wheat",""],
                                      ["Additive","+"],
                                      ["Seed","+"],
                                      ["Meat","+"],
                                      ["Fruit","+"],
                                      ["Other","+"]]
        var updater: [Int] = [Int](repeating: 0, count: 14)
        let segmentItems = ["Avoid", "Limit this", "Can eat"]
        let tableView = UITableView()
        let warning = UILabel()
        lazy var saveButton: UIButton = {
            let button = UIButton()
            button.setTitle("Save", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .systemGreen
            button.layer.cornerRadius = 10
            button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
            return button
        }()
        
        override func viewDidLoad() {
            super.viewDidLoad()

            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AllergenCell")
            view.addSubview(tableView)
            tableView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: view.topAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
                tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
            ])
            
            

            warning.frame = CGRect (
                x: 100,
                y: 100,
                width: 200,
                height: 48)
            warning.numberOfLines = 0
            warning.textAlignment = .center
            warning.textColor = UIColor.black
            warning.font = UIFont.boldSystemFont(ofSize: 24)
            warning.text = "When in Doubt, Leave it Out"
            warning.backgroundColor = UIColor.systemYellow
            view.addSubview(warning)

            warning.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                warning.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
                warning.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
            view.addSubview(saveButton)
            saveButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                saveButton.bottomAnchor.constraint(equalTo: warning.topAnchor, constant: -20),
                saveButton.widthAnchor.constraint(equalToConstant: 120),
                saveButton.heightAnchor.constraint(equalToConstant: 40)
            ])
        }
        @objc func saveButtonTapped() {
                // Save the allergens to the user object and dismiss the view controller
                let vc = RegistrationVC()
                print(updater)
                vc.user.updateAllergies(allergies: updater)
                dismiss(animated: true, completion: nil)
            }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return allergens.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AllergenCell", for: indexPath)
            let allergen = allergens[indexPath.row]
            cell.textLabel?.text = allergen[0] as? String

            let control = UISegmentedControl(items: segmentItems)
            control.frame = CGRect(x: cell.frame.width - 200, y: cell.frame.minY, width: 200, height: cell.frame.height)
            control.selectedSegmentIndex = 0
            control.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .allEvents)
            cell.addSubview(control)

            control.tag = indexPath.row
            
            let dropdown = UIButton(type: .system)
            dropdown.frame = CGRect(x: cell.frame.width - 50, y: cell.frame.minY + 10, width: 30, height: 30)
            if allergen[1] as? String == "+" {
                dropdown.setImage(UIImage(named: "greenplus"), for: .normal)
                dropdown.addTarget(self, action: #selector(dropdownTapped), for: .touchUpInside)
                dropdown.isHidden = false
                cell.addSubview(dropdown)
            } else {
                dropdown.isHidden = true
            }
            cell.addSubview(dropdown)

            return cell
        }

        @objc func dropdownTapped(sender: UIButton) {
            // Code to handle the dropdown button tap
        }
            
        @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
            updater[sender.tag] = sender.selectedSegmentIndex
            
        }
        
        

        
        @objc func segmentControl(_ sender: UISegmentedControl) {
            guard let cell = sender.superview?.superview as? UITableViewCell,
                  let indexPath = tableView.indexPath(for: cell) else {
                return
            }
            var allergen = allergens[indexPath.row]
            
            
        }

    }
    
    
}
