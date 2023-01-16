/*==============================================================================
 Authored by Raman Suliman
 Email: Raman.suliman1997@gmail.com
 Copyright 2022
 University of Salford

Copyright (c) 2022. All Rights Reserved.
==============================================================================*/

import UIKit
import SpriteKit

class MainMenu: UIViewController
{
    private let menuSKView = SKView()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .black
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
    }
    
    @IBAction func aboutClicked(_ sender: Any)
    {
        let title = "Blood Group Information"
        let message = "The game is simple and yet significantly important to play and learn from.\n\n Humans blood is divided under 8 categories, each human must inhert one type. \nHowever, have you ever thought how blood donation and blood supplements used during surgeries are performed? \n\n A patient can only be given the blood if it is the volunteer blood type is sharing compatibility.\n\n How to play?\n It is very simple, every round there is a blood type presented on lower left corner. Your job is to fire it into the options given then click \"Next\" button to jump into next round with a new type.\n\n\n **Make Sure To Also Enjoy**"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        //Handler can be set to nil if we only want to hide the alert no code to execute.
        //style: .cancel is a predefined action to cancel the alert.
        let actionAlertThree = UIAlertAction(title: "Understood", style: .cancel)
        
        //Add button into the alert
        alert.addAction(actionAlertThree)
        
        //Show the alert, turn on animation
        present(alert, animated: true, completion: nil)
    }

    @IBAction func exitClicked(_ sender: Any)
    {
        exit(0)
    }
}
