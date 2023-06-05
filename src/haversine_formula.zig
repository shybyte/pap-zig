const std = @import("std");

fn Square(A: f64) f64 {
    const Result: f64 = (A * A);
    return Result;
}

fn RadiansFromDegrees(Degrees: f64) f64 {
    const Result: f64 = 0.01745329251994329577 * Degrees;
    return Result;
}

pub const EARTH_RADIUS = 6372.8;

// NOTE(casey): EarthRadius is generally expected to be 6372.8
pub fn ReferenceHaversine(X0: f64, Y0: f64, X1: f64, Y1: f64, EarthRadius: f64) f64 {
    // NOTE(casey): This is not meant to be a "good" way to calculate the Haversine distance.
    // Instead, it attempts to follow, as closely as possible, the formula used in the real-world
    // question on which these homework exercises are loosely based.

    var lat1: f64 = Y0;
    var lat2: f64 = Y1;
    var lon1: f64 = X0;
    var lon2: f64 = X1;

    var dLat: f64 = RadiansFromDegrees(lat2 - lat1);
    var dLon: f64 = RadiansFromDegrees(lon2 - lon1);
    lat1 = RadiansFromDegrees(lat1);
    lat2 = RadiansFromDegrees(lat2);

    var a: f64 = Square(@sin(dLat / 2.0)) + @cos(lat1) * @cos(lat2) * Square(@sin(dLon / 2));
    var c: f64 = 2.0 * std.math.asin(@sqrt(a));

    var Result: f64 = EarthRadius * c;

    return Result;
}
