//
//  UIAlertController+Extesion.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/18/24.
//

import UIKit

extension UIAlertController {
    static func makeLocationSettingAlert() -> UIAlertController {
        let alert = UIAlertController(title: "위치 정보 이용", message: "위치 서비스를 사용할 수 없습니다.\n기기의 '설정 > 개인정보보호'에서 위치 서비스를 켜주세요", preferredStyle: .alert)
        
        let goSetting = UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            if let setting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(setting)
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(goSetting)
        alert.addAction(cancel)
        return alert
    }
}
