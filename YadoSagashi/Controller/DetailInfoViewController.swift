//
//  DetailViewController.swift
//  YadoSagashi
//
//  Created by Owner on 2020/12/11.
//

import UIKit
import WebKit
import SDWebImage

class DetailInfoViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var webView:WKWebView!
    
    var url = String()
    var name = String()
    var imageURLString = String()
    var tel = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.sd_setImage(with: URL(string: imageURLString), completed: nil)
        let request = URLRequest(url: URL(string: url)!)
        webView.load(request)

    }
    @IBAction func callButton(sender:UIButton){
        UIApplication.shared.open(URL(string: "tel://\(tel)")!, options: [:], completionHandler: nil)
    }
    
    
    
    

}
