const std = @import("std");
const haversine_formula = @import("./haversine_formula.zig");

const allocator = std.heap.page_allocator;

const PlacePair = struct { x0: f64, y0: f64, x1: f64, y1: f64 };

pub fn main() !void {
    const start_time = std.time.milliTimestamp();

    // var file = try std.fs.cwd().openFile("data/data-10.json", .{});
    // defer file.close();
    var file_content = try std.fs.cwd().readFileAlloc(allocator, "data/data-1_000_000.json", 2_000_000_000);
    defer allocator.free(file_content);

    const end_time_read = std.time.milliTimestamp();

    // const stdout_file = std.io.getStdOut().writer();
    // var bw = std.io.bufferedWriter(stdout_file);
    // const stdout = bw.writer();
    // _ = try stdout.write(file_content);
    // try bw.flush(); // don't forget to flush!

    var i: usize = 1;
    var number_buf: [4]f64 = [_]f64{ 0, 0, 0, 0 };
    var number_buf_i: usize = 0;
    var sum: f64 = 0;
    var count: usize = 0;

    var pairs = try std.ArrayList(PlacePair).initCapacity(allocator, 10_000);
    defer pairs.deinit();

    while (i < file_content.len) : (i += 1) {
        const char = file_content[i];
        if ((file_content[i - 1] == ':' or file_content[i - 1] == ' ') and (std.ascii.isDigit(char) or char == '-')) {
            const number_start_index = i;
            i += 1;
            while (i < file_content.len) : (i += 1) {
                if (!(std.ascii.isDigit(file_content[i]) or file_content[i] == '.')) {
                    const number_slice = file_content[number_start_index..i];
                    const parsed_number = try std.fmt.parseFloat(f64, number_slice);
                    number_buf[number_buf_i] = parsed_number;
                    number_buf_i += 1;
                    if (number_buf_i == number_buf.len) {
                        number_buf_i = 0;
                        try pairs.append(PlacePair{ .x0 = number_buf[0], .y0 = number_buf[1], .x1 = number_buf[2], .y1 = number_buf[3] });
                        // sum += haversine_formula.ReferenceHaversine(number_buf[0], number_buf[1], number_buf[2], number_buf[3], haversine_formula.EARTH_RADIUS);
                        // count += 1;
                    }
                    // std.debug.print("{d} ", .{parsed_number});
                    break;
                }
            }
        }
    }

    const end_time_parse = std.time.milliTimestamp();

    for (pairs.items) |pair| {
        sum += haversine_formula.ReferenceHaversine(pair.x0, pair.y0, pair.x1, pair.y1, haversine_formula.EARTH_RADIUS);
    }
    count = pairs.items.len;
    const average = sum / @intToFloat(f64, count);

    const end_time = std.time.milliTimestamp();

    std.debug.print("Count: {d}\n", .{count});
    std.debug.print("Average: {d}\n", .{average});
    std.debug.print("Time Read: {d}\n", .{end_time_read - start_time});
    std.debug.print("Time Parse: {d}\n", .{end_time_parse - end_time_read});
    std.debug.print("Time Read+Parse: {d}\n", .{end_time_parse - start_time});
    std.debug.print("Time Calc: {d}\n", .{end_time - end_time_parse});
    std.debug.print("Time Complete: {d}\n", .{end_time - start_time});
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
