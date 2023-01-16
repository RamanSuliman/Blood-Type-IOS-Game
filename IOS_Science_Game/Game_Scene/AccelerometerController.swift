/*==============================================================================
 Authored by Raman Suliman
 Email: Raman.suliman1997@gmail.com
 Copyright 2022
 University of Salford

Copyright (c) 2022. All Rights Reserved.
==============================================================================*/

import CoreMotion

class AccelerometerController
{
    private let motionManager = CMMotionManager()
    private var mainScene: MainScene
    
    init(mainScene: MainScene)
    {
        self.mainScene = mainScene
        initAccelerometer()
    }
    
    private func initAccelerometer()
    {
        //Make sure the hardware is avaliable
        if motionManager.isAccelerometerAvailable
        {
            motionManager.accelerometerUpdateInterval = 1.0 / 60.0
            //Start the hardware.
            motionManager.startAccelerometerUpdates()
            //Begin taking sensor feed.
            getFeedFromSensor()
        }
    }

    private func getFeedFromSensor()
    {
        //Configure a timer to fetch the data
        let timer = Timer(fire: Date(), interval: (1.0 / 60.0), repeats: true, block: {(timer) in
            if self.mainScene.typeOfInput == "Accelerometer"
            {
                //Get the feed from the sensor.
                if let data = self.motionManager.accelerometerData
                {
                    //Send the x-axis sensor feed to rotate the jet object accordingly.
                    self.mainScene.updateJet_Rotation(increaseX_axisBy: data.acceleration.x)
                }
            }
        })
        //motionManager.stopAccelerometerUpdates()
        //Add timer to current application run loop
        RunLoop.current.add(timer, forMode: .default)
    }
}
