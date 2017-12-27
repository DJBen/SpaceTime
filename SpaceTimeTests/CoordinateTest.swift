//
//  CoordinateTest.swift
//  Graviton
//
//  Created by Sihao Lu on 1/6/17.
//  Copyright © 2017 Ben Lu. All rights reserved.
//

import XCTest
@testable import SpaceTime
import CoreLocation
import MathUtil

class CoordinateTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testEquatorialToCartesianConversion() {
        let sph = EquatorialCoordinate(
            rightAscension: radians(hours: 14.4966),
            declination: radians(degrees: -62.681),
            distance: 1.29)
        let converted = Vector3.init(equatorialCoordinate: sph)
        XCTAssertEqual(converted.x, -0.4700, accuracy: 1e-3)
        XCTAssertEqual(converted.y, -0.3600, accuracy: 1e-3)
        XCTAssertEqual(converted.z, -1.1461, accuracy: 1e-3)
    }

    func testNearEpochEquatorialToHorizontalConversion() {
        let sph = EquatorialCoordinate(
            rightAscension: radians(hours: 11, minutes: 3, seconds: 43),
            declination: radians(degrees: 61, minutes: 45, seconds: 3.72),
            distance: 1)
        let calendar = Calendar(identifier: .gregorian)
        let components = DateComponents(calendar: calendar, timeZone: TimeZone(abbreviation: "PST"), year: 2000, month: 1, day: 1, hour: 5)
        let date = JulianDay(date: calendar.date(from: components)!)
        let location = CLLocation(latitude: CLLocationDegrees(degrees(degrees: 37, minutes: 46, seconds: 51)), longitude: CLLocationDegrees(-degrees(degrees: 122, minutes: 24, seconds: 47)))
        let obs = ObserverLocationTime(location: location, timestamp: date)
        let horizontal = HorizontalCoordinate(equatorialCoordinate: sph, observerInfo: obs)
        XCTAssertEqual(horizontal.azimuth, radians(degrees: 351, minutes: 45, seconds: 21.84), accuracy: 1e-3)
        XCTAssertEqual(horizontal.altitude, radians(degrees: 65, minutes: 37, seconds: 8.28), accuracy: 1e-3)
    }

    func testEquatorialToHorizontalConversion() {
        // at 2017.1.6, 1:31 AM PT
        // Dubhe is at RA 11h 03m 43s, DEC +61° 45' 3.72''
        // Azm +32° 41' 21.16'', Alt 55° 55' 30.18''
        // Current location 37° 46' 51'' N, 122° 24' 47'' W
        let sph = EquatorialCoordinate(
            rightAscension: radians(hours: 11, minutes: 3, seconds: 43),
            declination: radians(degrees: 61, minutes: 45, seconds: 3.72),
            distance: 1)
        let calendar = Calendar(identifier: .gregorian)
        let components = DateComponents(calendar: calendar, timeZone: TimeZone(abbreviation: "PST"), year: 2017, month: 1, day: 6, hour: 1, minute: 31, second: 30)
        let date = JulianDay(date: calendar.date(from: components)!)
        let obs = ObserverLocationTime(location:
            CLLocation(
                latitude: CLLocationDegrees(degrees(degrees: 37, minutes: 46, seconds: 51)),
                longitude: CLLocationDegrees(-degrees(degrees: 122, minutes: 24, seconds: 47))
            ),
            timestamp: date
        )
        let horizontal = HorizontalCoordinate(equatorialCoordinate: sph, observerInfo: obs)
        XCTAssertEqual(horizontal.azimuth, radians(degrees: 32, minutes: 41, seconds: 21.16), accuracy: 5e-3)
        XCTAssertEqual(horizontal.altitude, radians(degrees: 55, minutes: 55, seconds: 30.18), accuracy: 5e-3)
    }

    func testSouthernEquatorialToHorizontalConversion() {
        // Sirius
        let sph = EquatorialCoordinate(
            rightAscension: radians(hours: 6, minutes: 45, seconds: 8),
            declination: -radians(degrees: 16, minutes: 42, seconds: 58.02),
            distance: 1)
        let calendar = Calendar(identifier: .gregorian)
        let components = DateComponents(calendar: calendar, timeZone: TimeZone(abbreviation: "PST"), year: 2017, month: 1, day: 6, hour: 2, minute: 27)
        let date = JulianDay(date: calendar.date(from: components)!)
        let obs = ObserverLocationTime(location:
            CLLocation(
                latitude: CLLocationDegrees(-33.9249),
                longitude: CLLocationDegrees(18.4241)
            ),
            timestamp: date
        )
        let horizontal = HorizontalCoordinate(equatorialCoordinate: sph, observerInfo: obs)
        XCTAssertEqual(horizontal.azimuth, radians(degrees: 180, minutes: 3, seconds: 48.13), accuracy: 5e-3)
        XCTAssertEqual(horizontal.altitude, -radians(degrees: 39, minutes: 20, seconds: 54.56), accuracy: 5e-3)
    }

    func testEclipticalToEquatorialConversion() {
        let calendar = Calendar(identifier: .gregorian)
        let components = DateComponents(calendar: calendar, timeZone: TimeZone(secondsFromGMT: 0), year: 1992, month: 4, day: 12, hour: 0)
        let julianDay = JulianDay(date: calendar.date(from: components)!)
        let moon = EclipticalCoordinate(longitude: radians(degrees: 133, minutes: 10, seconds: 2), latitude: -radians(degrees: 3, minutes: 13, seconds: 45), distance: 1, julianDay: julianDay)
        let equat = EquatorialCoordinate(eclipticalCoordinate: moon, julianDay: julianDay)
        XCTAssertEqual(equat.rightAscension, radians(hours: 8, minutes: 58, seconds: 45.2), accuracy: 1e-5)
        XCTAssertEqual(equat.declination, radians(degrees: 13, minutes: 46, seconds: 6), accuracy: 1e-5)
    }

    func testEquatorialToEclipticalConversion() {
        let pollux = EquatorialCoordinate(rightAscension: radians(hours: 7, minutes: 45, seconds: 18.946), declination: radians(degrees: 28, minutes: 1, seconds: 34.26), distance: 1)
        let eclip = EclipticalCoordinate(equatorialCoordinate: pollux, julianDay: JulianDay.J2000)
        XCTAssertEqual(eclip.longitude, radians(degrees: 113.21563), accuracy: 1e-5)
        XCTAssertEqual(eclip.latitude, radians(degrees: 6.68417), accuracy: 1e-5)
    }
}
