/*==============================================================================
 Authored by Raman Suliman
 Email: Raman.suliman1997@gmail.com
 Copyright 2022
 University of Salford

Copyright (c) 2022. All Rights Reserved.
==============================================================================*/

import UIKit

class ButtonController: UIButton
{
    //This is used to increase and decrease the x & y values of menu position.
    private var menu_new_xy = CGPoint.zero
    //Getter and setter properties to modify the menu x and y positions.
    var menu_location: CGPoint {
        get{
            return menu_new_xy
        }
        set{
            menu_new_xy = newValue
        }
    }
    
    override func menuAttachmentPoint(for configuration: UIContextMenuConfiguration) -> CGPoint {
        //Get the current coordinates
        let base_location = super.menuAttachmentPoint(for: configuration)
        //Adjust the coordinates by adding on the value defiend externally.
        return CGPoint(x: base_location.x + menu_new_xy.x, y:base_location.y + menu_new_xy.y)
    }
}
