//
//  ViewController.swift
//  SWNetwork
//
//  Created by wangyang on 2020/12/30.
//

import UIKit

import RxSwift
import Moya

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Network.provider.rx.request(<#T##token: SWTargetType##SWTargetType#>)
        
    }


}

