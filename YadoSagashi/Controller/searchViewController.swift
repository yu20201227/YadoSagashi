//
//  ViewController.swift
//  YadoSagashi
//
//  Created by Owner on 2020/12/09.
//

import UIKit
import MapKit
import Lottie
import SwiftyJSON
import Alamofire

class searchViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, DoneCatchDataProtocol{
    
    
    @IBOutlet weak var textField:UITextField!
    @IBOutlet weak var mapView:MKMapView!
    
    var idoValue = Double()
    var keidoValue = Double()
    var apikey = "d88dcf59b664fa3f9b089ed353977965"
    var shopDataArray = [ShopData]()
    var totalHitCount = Int()
    var indexNumber = Int()
    
    var locationManager = CLLocationManager()
    var annotation = MKPointAnnotation()
    var animationView = AnimationView()
    
    var urlArray = [String]()
    var imageStringArray = [String]()
    var nameStringArray = [String]()
    var telArray = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        startUpdatingLocation()
        configureSubViews()
    }
    
    func startAnimation(){
        animationView = AnimationView()
        let animation = Animation.named("1.json")
        animationView.animation = animation
        animationView.frame = view.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 1.0
        animationView.play()
        view.addSubview(animationView)
    }
    
    //位置情報取得許可
    func startUpdatingLocation(){
        locationManager.requestAlwaysAuthorization()
        let status = CLAccuracyAuthorization.fullAccuracy
        
        if status == .fullAccuracy {
            locationManager.startUpdatingLocation()
        }
    }
    
    //位置情報取得性格レベル変更
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            break
        default:
            print("not useful")
        }
        switch manager.accuracyAuthorization {
        case .reducedAccuracy:
            break
        case .fullAccuracy:
            break
        default:
            print("something error")
        }
    }
    //LocationManager/MapView起動
    func configureSubViews(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
        
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.userTrackingMode = .follow
    }
    
    //LocationManager起動後、最初の位置が押された時
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        let latitude = location?.coordinate.latitude
        let longitude = location?.coordinate.longitude
        idoValue = latitude!
        keidoValue = longitude!
        //reflect on log
        print(idoValue, keidoValue)
    }
    
    @IBAction func searchButton(sender:UIButton){
        textField.resignFirstResponder()
        startAnimation()
        
        let urlString =  "https://api.gnavi.co.jp/RestSearchAPI/v3/?keyid=\(apikey)&latitude=\(idoValue)&longitude=\(keidoValue)&range=3&hit_per_page=50&freeword=\(textField.text!)"
        
        //通信
        let analyticsModel = AnalyticsModel(latitude: idoValue, longitude: keidoValue, url: urlString)
        //AnalyticsModelを起動
        analyticsModel.doneCatchProtocol = self
        analyticsModel.alalizeDataWithJSON()
    }
    
    func addAnnotation(shopData:[ShopData]){
        removeArray()
        
        for i in 0...totalHitCount - 1 {
            //幾つ情報取得できたか
            print(i)
            
            annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(shopDataArray[i].latitude!)!, CLLocationDegrees(shopDataArray[i].longitude!)!)
            
            annotation.title = shopData[i].name
            annotation.subtitle = shopData[i].tel
            
            urlArray.append(shopData[i].url!)
            imageStringArray.append(shopData[i].shop_image!)
            nameStringArray.append(shopData[i].name!)
            telArray.append(shopData[i].tel!)
            mapView.addAnnotation(annotation)
            
            
            
            
            }
        textField.resignFirstResponder()
    }
    func removeArray(){
        mapView.removeAnnotations(mapView.annotations)
        //再検索に備えて初期化
        urlArray = []
        imageStringArray = []
        nameStringArray = []
        telArray = []
    }
    
    func catchData(arrayData: Array<ShopData>, resultCount: Int) {
        
        //arrayData,resultCoutをここで使用する
        shopDataArray = arrayData
        totalHitCount = resultCount
        //情報が入ったらインディケーター不要なため
        animationView.removeFromSuperview()
        
        //shopDataArrayの中身を取り出してannotationとして設置する
        addAnnotation(shopData: shopDataArray)
    }
    //アノテーションタップ時
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        //タップされた情報をもとに詳細ページへ
        indexNumber = Int()
        
        if nameStringArray.firstIndex(of: (view.annotation?.title)!!) != nil {
            indexNumber = nameStringArray.firstIndex(of: (view.annotation?.title)!!)!
        }
        performSegue(withIdentifier: "detailVC", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let detailVC = segue.destination as! DetailInfoViewController
        detailVC.name = nameStringArray[indexNumber]
        detailVC.tel = telArray[indexNumber]
        detailVC.imageURLString = imageStringArray[indexNumber]
        detailVC.url = urlArray[indexNumber]
    }

    
}


