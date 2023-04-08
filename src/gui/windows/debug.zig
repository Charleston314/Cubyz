const std = @import("std");
const Allocator = std.mem.Allocator;

const main = @import("root");
const graphics = main.graphics;
const draw = graphics.draw;
const Texture = graphics.Texture;
const Vec2f = main.vec.Vec2f;

const gui = @import("../gui.zig");
const GuiWindow = gui.GuiWindow;
const GuiComponent = gui.GuiComponent;

pub var window = GuiWindow {
	.contentSize = Vec2f{128, 16},
	.id = "debug",
	.isHud = false,
	.showTitleBar = false,
	.hasBackground = false,
};

fn flawedRender() !void {
	draw.setColor(0xffffffff);
	var y: f32 = 0;
	try draw.print("    fps: {d:.0} Hz{s}", .{1.0/main.lastFrameTime.load(.Monotonic), if(main.settings.vsync) @as([]const u8, " (vsync)") else ""}, 0, y, 8, .left);
	y += 8;
	try draw.print("    frameTime: {d:.1} ms", .{main.lastFrameTime.load(.Monotonic)*1000.0}, 0, y, 8, .left);
	y += 8;
	try draw.print("window size: {}×{}", .{main.Window.width, main.Window.height}, 0, y, 8, .left);
	y += 8;
	if (main.game.world != null) {
		try draw.print("Pos: {d:.1}", .{main.game.Player.getPosBlocking()}, 0, y, 8, .left);
		y += 8;
		try draw.print("Game Time: {}", .{main.game.world.?.gameTime.load(.Monotonic)}, 0, y, 8, .left);
		y += 8;
		try draw.print("Queue size: {}", .{main.threadPool.loadList.size}, 0, y, 8, .left);
		y += 8;
		// TODO: biome
		y += 8;
		// TODO: packet loss
		y += 8;
		// TODO: Protocol statistics(maybe?)
	}
}

pub fn render() Allocator.Error!void {
	flawedRender() catch |err| {
		std.log.err("Encountered error while drawing debug window: {s}", .{@errorName(err)});
	};
}