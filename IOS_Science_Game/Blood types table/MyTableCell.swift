/*==============================================================================
 Authored by Raman Suliman
 Email: Raman.suliman1997@gmail.com
 Copyright 2022
 University of Salford

Copyright (c) 2022. All Rights Reserved.
==============================================================================*/

import UIKit

class MyTableCell: UITableViewCell
{
    @IBOutlet weak var bloodType_right_Image: UIImageView!
    @IBOutlet weak var bloodType_left_Image: UIImageView!
    
    @IBOutlet weak var tester: UIImageView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        //Set default images for each cell object created.
        bloodType_left_Image.image = UIImage(named: "default.png")
        bloodType_right_Image.image = UIImage(named: "default.png")
    }
    
    public func getLeftIamge()-> UIImage
    {
        bloodType_left_Image.setNeedsDisplay()
        return bloodType_left_Image.image!
    }
    public func getRightIamge()-> UIImage
    {
        bloodType_left_Image.setNeedsDisplay()
        bloodType_right_Image.setNeedsDisplay()
        
        return bloodType_right_Image.image!
    }
    
    public func setLeftImage(image: UIImage)
    {
        bloodType_left_Image.image = image
        bloodType_left_Image.setNeedsDisplay()
    }
    
    public func setRightImage(image: UIImage)
    {
        bloodType_right_Image.image = image
        bloodType_right_Image.setNeedsDisplay()
    }
}
