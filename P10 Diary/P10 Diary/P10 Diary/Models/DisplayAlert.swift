//
//  DisplayAlert.swift
//  P10 Diary
//
//  Created by Tom Bastable on 03/12/2019.
//  Copyright © 2019 Tom Bastable. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

func displayAlertWith(error: Error){
    
    let title: String
    let subTitle: String
    let buttonTitle: String
    
    switch error {
        
    case DiaryError.insufficientEntryData:
        title = "Uh Oh."
        subTitle = "Please ensure all fields are filled out and you have chosen at least one Photo."
        buttonTitle = "OK"
    case DiaryError.invalidText:
    title = "Uh Oh."
    subTitle = "Ivalid Characters in Entry Fields"
    buttonTitle = "OK"
    case DiaryError.errorDisplayingEntry:
       title = "Uh Oh."
       subTitle = "Error Displaying Diary Entry"
       buttonTitle = "OK"
    case DiaryError.errorDisplayingImages:
    title = "Uh Oh."
    subTitle = "Error Displaying Entry Images"
    buttonTitle = "OK"
    default:
        title = "Error"
        subTitle = "\(error)"
        buttonTitle = "OK"
    }
    
    let alert = UIAlertController(title: title, message: subTitle, preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: nil))
    
    self.present(alert, animated: true)
    
}

}
