//
//  EclipticUtil.swift
//  SpaceTime
//
//  Created by Sihao Lu on 12/26/17.
//  Copyright © 2017 Sihao. All rights reserved.
//

import MathUtil

public struct EclipticUtil {
    /// Medium precision mean obliquity of the ecliptic in radians.
    /// The error is 1 arcsecond over period of 2000 years and 10 arcsecond over period of 4000 years.
    public static func meanObliquityOfEcliptic(julianDay: JulianDay) -> Double {
        let t = julianDay.julianCentury
        return radians(degrees: 23, minutes: 26, seconds: 21.448) - t * radians(degrees: 0, minutes: 0, seconds: 46.815) - (t * t) * radians(degrees: 0, minutes: 0, seconds: 0.00059) + (t * t * t) * radians(degrees: 0, minutes: 0, seconds: 0.001813)
    }

    public static var currentMeanObliquityOfEcliptic: Double {
        return meanObliquityOfEcliptic(julianDay: JulianDay.now)
    }
}
