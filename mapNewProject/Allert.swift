///
//  Alert .swift
//  mapProject
//
//  Created by Чистяков Василий Александрович on 12.05.2021.
//

import UIKit

extension ViewController{
    
    func allertAddAdress(title: String, placeholder: String, complitionHandler: @escaping (String) -> Void){
        
        let allertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let allertOk = UIAlertAction(title: "Ok", style: .default) { (action) in
            
            let tfText = allertController.textFields?.first
            guard let text = tfText?.text else { return }
            complitionHandler(text)
        }
        
        let allertCancel = UIAlertAction(title: "Отмена", style: .default) { (_) in
        }
        allertController.addTextField { (tf) in
            tf.placeholder = placeholder
        }
        allertController.addAction(allertOk)
        allertController.addAction(allertCancel)
        
        present(allertController, animated: true, completion: nil)
    }
    
    func allertError(title: String, massege: String){
        
        let allertController = UIAlertController(title: title, message: massege, preferredStyle: .alert)
        let allertOk = UIAlertAction(title: "ok", style: .default)
        
        allertController.addAction(allertOk)
        
        present(allertController, animated: true, completion: nil)
    }
    
    
   
    
    
}


