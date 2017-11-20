//
//  SiderealTimeTest.swift
//  Graviton
//
//  Created by Sihao Lu on 1/3/17.
//  Copyright © 2017 Ben Lu. All rights reserved.
//

import XCTest
import CoreLocation
@testable import SpaceTime

class SiderealTimeTest: XCTestCase {

    var locationTime: LocationAndTime!
    var date: JulianDate {
        return locationTime.timestamp
    }

    override func setUp() {
        super.setUp()
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let components = DateComponents(calendar: calendar, timeZone: TimeZone(secondsFromGMT: 0), year: 2017, month: 1, day: 3, hour: 3, minute: 29)
        let date = JulianDate(date: calendar.date(from: components)!)
        // coordinate of my hometown
        locationTime = LocationAndTime(location: CLLocation(latitude: 32.0603, longitude: 118.7969), timestamp: date)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSiderealTime() {
        let sidTime = SiderealTime(julianDate: date)
        let localSidTime = SiderealTime(locationAndTime: locationTime)
        XCTAssertEqual(date.value, 2457756.645138889, accuracy: 1e-5)
        XCTAssertEqual(sidTime.hour, 10 + 20 / 60.0 + 47.358 / 3600.0, accuracy: 1e-3)
        let angle: Double = (18 + 15 / 60.0 + 58.614 / 3600.0) / 12 * Double.pi
        XCTAssertEqual(localSidTime.hourAngle, angle, accuracy: 1e-3)
        let sidTime2 = SiderealTime(julianDate: 2457756.845138889)
        XCTAssertEqual(sidTime2.hour, 15.15996, accuracy: 1e-3)
    }

}
