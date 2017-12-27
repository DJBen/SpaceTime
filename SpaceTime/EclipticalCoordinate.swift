//
//  EclipticalCoordinate.swift
//  SpaceTime
//
//  Created by Sihao Lu on 12/26/17.
//  Copyright © 2017 Sihao. All rights reserved.
//

import MathUtil

public struct EclipticalCoordinate {

    public let longitude: Double
    public let latitude: Double
    public let distance: Double

    public let julianDay: JulianDay

    public init(longitude: Double, latitude: Double, distance: Double, julianDay: JulianDay) {
        self.latitude = latitude
        self.longitude = longitude
        self.julianDay = julianDay
        self.distance = distance
    }

    public init(equatorialCoordinate coord: EquatorialCoordinate, julianDay: JulianDay) {
        let eps = EclipticUtil.meanObliquityOfEcliptic(julianDay: julianDay)
        longitude = atan2(sin(coord.rightAscension) * cos(eps) + tan(coord.declination) * sin(eps), cos(coord.rightAscension))
        latitude = asin(sin(coord.declination) * cos(eps) - cos(coord.declination) * sin(eps) * sin(coord.rightAscension))
        distance = coord.distance
        self.julianDay = julianDay
    }
}

public extension EquatorialCoordinate {
    public init(eclipticalCoordinate coord: EclipticalCoordinate, julianDay: JulianDay) {
        // TODO: support precession
        precondition(julianDay == coord.julianDay, "only conversion from ecliptical to equatorial coordinate of the same equinox is supported")
        let eps = EclipticUtil.meanObliquityOfEcliptic(julianDay: julianDay)
        rightAscension = atan2(sin(coord.longitude) * cos(eps) - tan(coord.latitude) * sin(eps), cos(coord.longitude))
        declination = asin(sin(coord.latitude) * cos(eps) + cos(coord.latitude) * sin(eps) * sin(coord.longitude))
        distance = coord.distance
    }
}
