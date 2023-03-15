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
        for _ in 0..<5{
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
//         appName.frame = CGRect (
//            x: 100,
//            y: 100,
//            width: 200,
//            height: 48)
//         appName.numberOfLines = 0
         appName.textAlignment = .center
         appName.font = UIFont.boldSystemFont(ofSize: 30)
         appName.text = "Allergy Assist"
         
         return appName
     }()
     
     private let imageView: UIImageView = {
         let imageView = UIImageView()
         imageView.image = UIImage(named: "Cover")
         imageView.alignmentRectInsets
         imageView.contentMode = .scaleAspectFit
         return imageView
     }()
     
     override func viewDidLoad(){
         super.viewDidLoad()
         view.backgroundColor = UIColor.systemBackground
         // we're going to use auto-layout
         appName.translatesAutoresizingMaskIntoConstraints = false
         imageView.translatesAutoresizingMaskIntoConstraints = false
         log_in.translatesAutoresizingMaskIntoConstraints = false
         scan_barcode.translatesAutoresizingMaskIntoConstraints = false
         scan_label.translatesAutoresizingMaskIntoConstraints = false
        
         view.addSubview(appName)
         view.addSubview(imageView)
         view.addSubview(log_in)
         view.addSubview(scan_barcode)
         view.addSubview(scan_label)
        
//         start()
         let safeG = view.safeAreaLayoutGuide
         NSLayoutConstraint.activate([
            appName.topAnchor.constraint(equalTo: safeG.topAnchor,constant:75.0),
            appName.widthAnchor.constraint(equalTo: safeG.widthAnchor,constant: 0.0),
            appName.heightAnchor.constraint(equalTo: safeG.heightAnchor, multiplier: 0.05),
            imageView.topAnchor.constraint(equalTo: appName.bottomAnchor,constant:5.0),
            imageView.leftAnchor.constraint(equalTo: safeG.leftAnchor,constant: 5.0),
            imageView.widthAnchor.constraint(equalTo: safeG.widthAnchor,constant: -10.0),
            imageView.heightAnchor.constraint(equalTo: safeG.widthAnchor, multiplier: 0.75),
            log_in.topAnchor.constraint(equalTo: imageView.bottomAnchor,constant:15.0),
            log_in.widthAnchor.constraint(equalTo: safeG.widthAnchor,multiplier: 0.5),
            log_in.centerXAnchor.constraint(equalTo: safeG.centerXAnchor),
            log_in.heightAnchor.constraint(equalTo: safeG.heightAnchor, multiplier: 0.05),
            scan_barcode.topAnchor.constraint(equalTo: log_in.bottomAnchor,constant:15.0),
            scan_barcode.widthAnchor.constraint(equalTo: safeG.widthAnchor,multiplier: 0.5),
            scan_barcode.centerXAnchor.constraint(equalTo: safeG.centerXAnchor),
            scan_barcode.heightAnchor.constraint(equalTo: safeG.heightAnchor, multiplier: 0.05),
            scan_label.topAnchor.constraint(equalTo: scan_barcode.bottomAnchor,constant:15.0),
            scan_label.widthAnchor.constraint(equalTo: safeG.widthAnchor,multiplier: 0.5),
            scan_label.centerXAnchor.constraint(equalTo: safeG.centerXAnchor),
            scan_label.heightAnchor.constraint(equalTo: safeG.heightAnchor, multiplier: 0.05),
         ])
        
         recognizeText(image: imageView.image)
         
         DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
             self.DA(mes: self.label.text!)
         }
    }
    
    private func start(){
        log_in.frame = CGRect(x : 100, y: 475, width: 200, height: 48 )
        view.addSubview(log_in)
        scan_barcode.frame = CGRect(x : 100, y: 575, width: 200, height: 48 )
        view.addSubview(scan_barcode)
        scan_label.frame = CGRect(x : 100, y: 675, width: 200, height: 48 )
        view.addSubview(scan_label)
    }
    
    let log_in : UIButton = {
        let si = UIButton()
        si.setTitle("Users", for: .normal)
        si.setImage(UIImage(systemName: "person"), for: .normal)
        si.backgroundColor = UIColor.systemGreen
        si.layer.cornerRadius = 10
        si.addTarget(self, action: #selector(UserSetting), for : .touchUpInside)
        return si
    }()
    
    let scan_barcode : UIButton = {
        let sb = UIButton()
        sb.setTitle("Scan Barcode", for: .normal)
        sb.setImage(UIImage(systemName: "barcode"), for: .normal)
        sb.backgroundColor = UIColor.systemOrange
        sb.layer.cornerRadius = 10
        sb.addTarget(self, action: #selector(Scan_Barcode), for : .touchUpInside)
        return sb
    }()
    
    let scan_label : UIButton = {
        let sl = UIButton()
        sl.setTitle("Scan Label", for: .normal)
        sl.setImage(UIImage(systemName: "camera"), for: .normal)
        sl.backgroundColor = UIColor.systemOrange
        sl.layer.cornerRadius = 10
        sl.addTarget(self, action: #selector(Scan_Label), for : .touchUpInside)
        return sl
    }()
    
    @objc func UserSetting(sender : UIButton){
        //pushing the current VC to another T(x) --->  X
        //step one : instance or object declaration
//        let tabBarVC = UITabBarController()
//        let vc1 = UINavigationController(rootViewController: UserAccountInfo())
//        let vc2 = UINavigationController(rootViewController: ScanLabel())
//        let vc3 = UINavigationController(rootViewController: ScanBarcode())
//        vc1.tabBarItem = UITabBarItem(title: "User", image : UIImage(systemName: "person"), tag: 0)
//        vc2.tabBarItem = UITabBarItem(title: "Scan Label", image : UIImage(systemName: "camera"), tag: 0)
//        vc3.tabBarItem = UITabBarItem(title: "Scan Barcode", image : UIImage(systemName: "barcode"), tag: 0)
//        tabBarVC.setViewControllers([vc1,vc2,vc3],animated: false)
//        tabBarVC.modalPresentationStyle = .fullScreen
//        self.present(tabBarVC, animated: true)
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
    
//     override func viewDidLayoutSubviews(){
//         super.viewDidLayoutSubviews()
//         imageView.frame = CGRect (
//            x: 20,
//            y: view.safeAreaInsets.top+80,
//            width: view.frame.size.width-40,
//            height: view.frame.size.width-40)
//         appName.frame = CGRect(x: 20,
//                          y: view.safeAreaInsets.top,
//                              width: view.frame.size.width-40,
//                              height: 100)
//     }
     
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
    init (email : String, name : String, password : String, race : Race){
        self.email = email
        self.name = name
        self.password = password
        self.race = Race.Other
    }
}

class RegistrationVC : UIViewController {
    let db_user = UserDefaults.standard
    var dict = UserDefaults.standard.dictionary(forKey: "UserDB")
    let email_input : UITextView = {
        let tx = UITextView()
        tx.isUserInteractionEnabled = true
        tx.layer.borderWidth = 2
        tx.layer.borderColor = UIColor.systemBlue.cgColor
        return tx
    }()
    
    let name_input : UITextView = {
        let tx1 = UITextView()
        tx1.isUserInteractionEnabled = true
        tx1.layer.borderWidth = 2
        tx1.layer.borderColor = UIColor.systemBlue.cgColor
        return tx1
    }()
    
    let password_input : UITextView = {
        let tx2 = UITextView()
        tx2.isUserInteractionEnabled = true
        tx2.layer.borderWidth = 2
        tx2.layer.borderColor = UIColor.systemBlue.cgColor
        return tx2
    }()
    
    var user = User(email: "sample@gmail.com", name: "Joe", password: "123456abc", race: Race.Asian)
    
    @objc func submit() {
        guard let txt = email_input.text else {return}
        guard let txt1 = name_input.text else {return}
        guard let txt2 = password_input.text else {return}
        //let sampleEmail = "asdasd"
        //email_input.text = sampleEmail
        user.email = txt
        user.name =  txt1
        user.password = txt2
        var myAvoid = ["Shellfish","Egg","Peanut","Tree Nut","Dairy","Fish","Sesame","Soybean","Wheat","Additive","Seed","Meat","Fruit"]
        var myLimit:[String] = []
        
        if var dt = UserDefaults.standard.dictionary(forKey: "UserDB"){
            if let arr = dt[user.name] as? [[String]]{
                myAvoid = arr[1]
                myLimit = arr[2]
            } else {}
            dt[txt1]=[[txt, txt2], myAvoid, myLimit]
            db_user.setValue(dt, forKey: "UserDB")
        } else {
            let dt = [txt1:[[txt,txt2],myAvoid, myLimit]]
            db_user.setValue(dt, forKey: "UserDB")
        }
//        dict[txt]=["name","password"]
//        db_user.setValue(dict, forKey: "UserDB")
//        db_user.setValue(txt, forKey: "mess1")
//        db_user.setValue(txt1, forKey: "mess2")
//        db_user.setValue(txt2, forKey: "mess3")
//        print(user.name,user.email,myAvoid,myLimit)
        let vc = UserAccountInfo()
        vc.user = self.user
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @objc func setAllergyProfile() {
        guard let txt = email_input.text else {return}
        guard let txt1 = name_input.text else {return}
        guard let txt2 = password_input.text else {return}
        user.email = txt
        user.name =  txt1
        user.password = txt2
        
        let vc = myAllergens()
        vc.user = self.user
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
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
        navi()
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
        SUMAP.addTarget(self, action: #selector(setAllergyProfile), for : .touchUpInside)
        return SUMAP
    }()
    
    private func start3(){
//        EditButton.frame = CGRect(x : 125, y: 400, width: 50, height: 36 )
//        view.addSubview(EditButton)
        SaveButton.frame = CGRect(x : 300, y: 60, width: 80, height: 30 )
        view.addSubview(SaveButton)
        SetUpMyAllergenProfile.frame = CGRect(x : 75, y: 575, width : 250, height : 36)
        view.addSubview(SetUpMyAllergenProfile)
        UserAccount.frame = CGRect(x : 0, y: 60, width: 300, height: 30 )
        view.addSubview(UserAccount)
        Finalize.frame = CGRect(x : 50, y: 465, width: 300, height: 72 )
        view.addSubview(Finalize)
//        email_input.text = db_user.string(forKey: "mess1")
        email_input.text = user.email
        email_input.frame = CGRect(x:45, y: 120, width: 300, height: 30)
        view.addSubview(email_input)
//        name_input.text = db_user.string(forKey: "mess2")
        name_input.text = user.name
        name_input.frame = CGRect(x:45, y: 180, width: 300, height: 30)
        view.addSubview(name_input)
//        password_input.text = db_user.string(forKey: "mess3")
        password_input.text = user.password
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
//        userAccount.numberOfLines = 0
        userAccount.textAlignment = .center
//        userAccount.textColor = UIColor.black
        userAccount.font = UIFont.boldSystemFont(ofSize: 25)
        userAccount.text = "User Profile"
//        userAccount.backgroundColor = UIColor.systemYellow
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
        email.font = UIFont.boldSystemFont(ofSize: 12)
        email.text = "Enter Your Email"
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
        username.font = UIFont.boldSystemFont(ofSize: 12)
        username.text = "Enter Your Name"
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
        password.font = UIFont.boldSystemFont(ofSize: 12)
        password.text = "Password"
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
        finalize.font = UIFont.boldSystemFont(ofSize: 18)
        finalize.text = "Finalize your personalized list of ingredients that you eat, limit, and avoid based on your selections."
        return finalize
    }()
    
    class ReadingTheLabel  : UIViewController{
        override func viewDidLoad(){
            super.viewDidLoad()
            title_lb.frame = CGRect(x : 10, y: 60, width : 120, height: 48)
            title_lb.textAlignment =  .center
            view.addSubview(title_lb)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2){
                self.start()
            }
        }
        let title_lb = UILabel()
        var display_bars = [UIButton]()
        var data_from_main : Int = 0
        var data_string_from_main : [String]?
        
        func iterate(n : Int, arr : [String])-> [UIButton]{
            var res = [UIButton]()
            //design the pattern
            let w : CGFloat = view.frame.width - 20
            let size : CGFloat = 24
            for i in 0..<n{
                let bt = UIButton()
                let length : CGFloat = CGFloat(arr[i].count) * size * 1.2
                bt.setTitle(arr[i], for: .normal)
                let x : CGFloat = 10
                let y : CGFloat = CGFloat(i) * size * 1.2 + 60 //f(x) = ax + b
                bt.frame = CGRect(x : x, y: y, width: w, height: size)
                bt.setTitleColor(UIColor.black, for: .normal)
                bt.backgroundColor = UIColor.systemGray
                res.append(bt)
            }
            return res
        }
        func start(){
            display_bars = iterate(n : data_from_main, arr : data_string_from_main!)
            for item in display_bars {
                view.addSubview(item)
            }
        }
    }
    
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
}
