//
//  FingerpainterUITestsMain.swift
//  FingerpainterUITestsMain
//
//  Created by Morgan Davison on 7/9/18.
//  Copyright © 2018 Morgan Davison. All rights reserved.
//

import XCTest
@testable import Fingerpainter

class FingerpainterUITestsMain: XCTestCase {
    
    var app:XCUIApplication?
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        
        app = XCUIApplication()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBrushesAppear() {
        if let app = app {
            app.buttons["BrushIcon"].tap()
            XCTAssertTrue(app/*@START_MENU_TOKEN@*/.buttons["5"]/*[[".buttons[\"Brush 5\"]",".buttons[\"5\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists)
        }
    }
    
    func testOpacitiesAppear() {
        if let app = app {
            app.buttons["OpacityIcon"].tap()
            XCTAssertTrue(app.buttons["3"].exists)
        }
    }
    
    func testColorsAppear() {
        if let app = app {
            app.buttons["BrushIcon"].tap()
            app.buttons["ColorIcon"].tap()
            XCTAssertTrue(app.buttons["red"].exists)
        }
    }
    
    func testColorWheelAppears() {
        if let app = app {
            app.buttons["ColorWheelIcon"].tap()
            XCTAssertTrue(app/*@START_MENU_TOKEN@*/.otherElements["color-wheel"]/*[[".otherElements[\"Color Wheel\"]",".otherElements[\"color-wheel\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists)
            XCTAssertTrue(app.navigationBars["Fingerpainter.ColorWheelView"].buttons["Done"].exists)
        }
    }
}
