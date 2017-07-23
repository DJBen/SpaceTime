//
//  VectorMathTests.swift
//  VectorMathTests
//
//  Created by Nick Lockwood on 24/11/2014.
//  Copyright (c) 2014 Nick Lockwood. All rights reserved.
//

import QuartzCore
import XCTest
@testable import MathUtil

class Vector2Tests: XCTestCase {

    func testRotatedBy() {

        let a = Vector2(1, 0)
        let b = Vector2(0, 1)
        let c = a.rotated(by: Scalar.pi / 2)

        XCTAssertTrue(b ~= c)

        let d = Vector2(0.5, 1.5)
        let e = a.rotated(by: Scalar.pi / 2, around: Vector2(0, 0.5))

        XCTAssertTrue(d ~= e)
    }

    func testAngleWith() {

        let a = Vector2(1, 0)
        let b = Vector2(0, 1)
        let angle = a.angle(with: b)

        XCTAssertTrue(angle ~= Scalar.pi / 2)
    }
}

class Matrix3Tests: XCTestCase {

    func testMatrix3Multiplication() {

        let a = Matrix3(rotation: Scalar.pi / 2)
        let b = Matrix3(rotation: Scalar.pi / 4)
        let c = Matrix3(rotation: Scalar.pi / 2 + Scalar.pi / 4)
        let d = a * b

        XCTAssertTrue(c ~= d)
    }

    func testVector3Multiplication() {

        let m = Matrix3(rotation: Scalar.pi / 2)
        let a = Vector3(1, 0, 1)
        let b = Vector3(0, 1, 1)
        let c = a * m

        XCTAssertTrue(b ~= c)
    }

    func testVector2Multiplication() {

        let m = Matrix3(rotation: Scalar.pi / 2)
        let a = Vector2(1, 0)
        let b = Vector2(0, 1)
        let c = a * m

        XCTAssertTrue(b ~= c)
    }
}

class Matrix4Tests: XCTestCase {

    func testRotationAndTranslation() {
        let point = Vector4(0.0, -1.0, 0.0, 1.0)
        let euclideanTransformation = Matrix4(0.0, 1.0, 0.0, 0.0,
            -1.0, 0.0, 0.0, 0.0,
            0.0, 0.0, 0.0, 0.0,
            -1.0, 0.0, 0.0, 1.0)

        let result = euclideanTransformation * point
        let expectedResult = Vector4(0.0, 0.0, 0.0, 1.0)

        XCTAssertTrue(result ~= expectedResult)
    }

    func testTransformationMatrixMultiplication() {
        let somePoint = Vector4(2.0, 2.0, 2.0, 1.0)
        let zAxisTransformationMaxtrix90Positive = Matrix4(0.0, 1.0, 0.0, 0.0,
            -1.0, 0.0, 0.0, 0.0,
            0.0, 0.0, 0.0, 0.0,
            0.0, 0.0, 0.0, 1.0)
        let yAxisTransformationMaxtrix90Positive = Matrix4(0.0, 0.0, 1.0, 0.0,
            0.0, 1.0, 0.0, 0.0,
            -1.0, 0.0, 0.0, 0.0,
            0.0, 0.0, 0.0, 1.0)
        let xAxisTransformationMaxtrix90Positive = Matrix4(1.0, 0.0, 0.0, 0.0,
            0.0, 0.0, -1.0, 0.0,
            0.0, 1.0, 0.0, 0.0,
            0.0, 0.0, 0.0, 1.0)

        let resultPoint = (xAxisTransformationMaxtrix90Positive * (yAxisTransformationMaxtrix90Positive * (zAxisTransformationMaxtrix90Positive * somePoint)))

        let comparePoint = (xAxisTransformationMaxtrix90Positive * yAxisTransformationMaxtrix90Positive * zAxisTransformationMaxtrix90Positive) * somePoint

        XCTAssertTrue(resultPoint ~= comparePoint)
    }
}

class QuaternionTests: XCTestCase {

    func testAxisAngleConversion() {

        let aaa = Vector4(1, 0, 0, Scalar.pi / 2)
        let q = Quaternion(axisAngle: aaa)
        let aab = q.toAxisAngle()

        XCTAssertTrue(aaa ~= aab)
    }

    func testVector3Multiplication() {

        let q = Quaternion(axisAngle: Vector4(0, 0, 1, Scalar.pi / 2))
        let a = Vector3(1, 0, 1)
        let b = Vector3(0, 1, 1)
        let c = a * q

        XCTAssertTrue(b ~= c)
    }

    func testEulerConversion() {

        var quat = Quaternion(pitch: Scalar.pi / 4, yaw: 0, roll: 0)
        XCTAssertTrue(quat.toPitchYawRoll().pitch ~= Scalar.pi / 4)
        quat = Quaternion(pitch: 0, yaw: Scalar.pi / 4, roll: 0)
        XCTAssertTrue(quat.toPitchYawRoll().yaw ~= Scalar.pi / 4)
        quat = Quaternion(pitch: 0, yaw: 0, roll: Scalar.pi / 4)
        XCTAssertTrue(quat.toPitchYawRoll().roll ~= Scalar.pi / 4)

        let quat2 = Quaternion(pitch: 0.12334412, yaw: 1.3521468, roll: -0.53435323)
        let (pitch, yaw, roll) = quat2.toPitchYawRoll()
        let quat2Ref = Quaternion(pitch: pitch, yaw: yaw, roll: roll)
        XCTAssertTrue(quat2 ~= quat2Ref)
    }
}

class PerformanceTests: XCTestCase {

    func testMatrix3MultiplicationPerformance() {

        let a = Matrix3(rotation: Scalar.pi / 2)
        var b = Matrix3(translation: Vector2(1, 10))

        measure {
            for _ in 0 ..< 100000 {
                b = a * b
            }
        }
    }

    func testMatrix4MultiplicationPerformance() {

        let a = Matrix4(rotation: Vector4(1, 0, 0, Scalar.pi / 2))
        var b = Matrix4(translation: Vector3(1, 10, 24))

        measure {
            for _ in 0 ..< 100000 {
                b = a * b
            }
        }
    }
}
