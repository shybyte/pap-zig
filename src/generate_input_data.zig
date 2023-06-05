const std = @import("std");
const haversine_formula = @import("./haversine_formula.zig");
const allocator = std.heap.page_allocator;
var rnd = std.rand.DefaultPrng.init(1234);

const PlacePair = struct { x0: f64, y0: f64, x1: f64, y1: f64 };

const N = 10;

pub fn main() !void {
    const rand = rnd.random();
    // Prints to stderr (it's a shortcut based on `std.io.getStdErr()`)
    std.debug.print("Hello world!\n", .{});
    const file = try std.fs.cwd().createFile("data/data-10.json", .{});
    defer file.close();

    const buffer = "Hello, world!\n";
    _ = buffer;

    var bw = std.io.bufferedWriter(file.writer());
    const bw_out = bw.writer();

    _ = try bw_out.write("{\"pairs\": [\n");
    var i: usize = 0;
    var sum: f64 = 0;
    while (i < N) : (i += 1) {
        _ = try bw_out.write("{");

        const place_pair = PlacePair{ .x0 = rand.float(f64), .y0 = rand.float(f64), .x1 = rand.float(f64), .y1 = rand.float(f64) };
        sum += haversine_formula.ReferenceHaversine(place_pair.x0, place_pair.y0, place_pair.x1, place_pair.y1, haversine_formula.EARTH_RADIUS);
        try bw_out.print("\"x0\": {d}, \"y0\": {d}, \"x1\": {d}, \"y1\": {d}", .{ place_pair.x0, place_pair.y0, place_pair.x1, place_pair.y1 });

        if (i < N - 1) {
            _ = try bw_out.write("},\n");
        } else {
            _ = try bw_out.write("}\n");
        }
    }
    _ = try bw_out.write("]}\n");

    // var string = std.ArrayList(u8).init(allocator);
    // try std.json.stringify(place_pair, .{}, string.writer());

    try bw.flush(); // don't forget to flush!

    // var writer = std.io.bufferedWriter(&file.writer()).writer();
    // try file.writeAll(buffer);
    // try writer.write(buffer);
    // try writer.flush();

    std.debug.print("Sum: {d}\n", .{sum});
    std.debug.print("Average: {d}\n", .{sum / N});
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
