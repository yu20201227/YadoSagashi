//
//  AnalyticsModel.swift
//  YadoSagashi
//
//  Created by Owner on 2020/12/11.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol DoneCatchDataProtocol {
    func catchData(arrayData:Array<ShopData>, resultCount:Int)
}

class AnalyticsModel {
    
    var idoValue:Double?
    var keidoValue:Double?
    var urlString:String?
    var doneCatchProtocol:DoneCatchDataProtocol?
    var shopDataArray = [ShopData]()
    
    //viewControllerから値を受け取る(初期化）
    init(latitude:Double, longitude:Double, url:String) {
        
        idoValue = latitude
        keidoValue = longitude
        urlString = url
    }
    //json解析
    func alalizeDataWithJSON(){
        //urlエンコーディング(freewordを変換)
        let encoderUrlString:String = urlString!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        //http通信
        AF.request(encoderUrlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
    
            //取得可否確認
            print(response.debugDescription)
            
            switch response.result {
            case .success:
                do{
                    let json:JSON = try JSON(data: response.data!)
                    print(json.description)
                    var totalHitCount = json["total_hit_count"].int
                    
                    if totalHitCount! > 50 {
                        totalHitCount  = 50
                    }
                    for i in 0...totalHitCount! - 1{
                        
                        if json["rest"][i]["latitude"] != "" && json["rest"][i]["longitude"] != "" && json["rest"][i]["url"] != "" && json["rest"][i]["name"] != "" && json["rest"][i]["tel"] != "" && json["rest"][i]["image_url"]["shop_image1"] != ""{
                            
                            //階層を指定して掘り下げていく(json解析）
                            let shopData = ShopData(latitude: json["rest"][i]["latitude"].string, longitude: json["rest"][i]["longitude"].string, url: json["rest"][i]["url"].string, name:   json["rest"][i]["name"].string,
                                                    tel: json["rest"][i]["tel"].string, shop_image: json["rest"][i]["image_url"]["shop_image1"].string)
                            
                            self.shopDataArray.append(shopData)
                        }else{
                            print("something missing")
                        }
                    }
                    
                    self.doneCatchProtocol?.catchData(arrayData: self.shopDataArray, resultCount: self.shopDataArray.count)
                }catch{
                    print("error")
                }
                break
            case .failure:
                break
            }
        }
    }
}


