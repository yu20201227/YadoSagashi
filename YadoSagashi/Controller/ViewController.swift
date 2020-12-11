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

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{
    
    var textField:UITextField!
    var mapView:MKMapView!
    
    var animationView = AnimationView()
    var locationManager = CLLocationManager()
    

    override func viewDidLoad() {
        super.viewDidLoad()
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


}

