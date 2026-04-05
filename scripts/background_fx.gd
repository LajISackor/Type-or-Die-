extends CanvasLayer
## Background FX — Animated starfield + gradient sky + danger zone.
## Part of Laji's core visual systems.
## Uses CanvasLayer to always fill the screen regardless of camera.

var drawer: Control

func _ready():
	layer = -10  # behind everything
	drawer = BackgroundDrawer.new()
	add_child(drawer)

class BackgroundDrawer extends Control:
	var stars: Array = []
	var num_stars: int = 120
	var screen_size: Vector2
	
	# Danger zone pulsing
	var danger_pulse: float = 0.0
	var danger_alpha: float = 0.15
	
	func _ready():
		# Fill the entire screen
		anchors_preset = Control.PRESET_FULL_RECT
		anchor_right = 1.0
		anchor_bottom = 1.0
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		
		screen_size = get_viewport().get_visible_rect().size
		if screen_size == Vector2.ZERO:
			screen_size = Vector2(800, 600)
		_generate_stars()
	
	func _generate_stars():
		for i in range(num_stars):
			stars.append({
				"pos": Vector2(randf() * screen_size.x, randf() * screen_size.y),
				"size": randf_range(0.5, 2.5),
				"speed": randf_range(5.0, 30.0),
				"brightness": randf_range(0.3, 1.0),
				"twinkle_speed": randf_range(1.0, 4.0),
				"twinkle_offset": randf() * TAU
			})
	
	func _process(delta):
		danger_pulse += delta * 2.0
		for star in stars:
			star["pos"].y += star["speed"] * delta
			if star["pos"].y > screen_size.y:
				star["pos"].y = -5
				star["pos"].x = randf() * screen_size.x
		queue_redraw()
	
	func _draw():
		# Background gradient — dark blue to dark purple
		var top_color = Color(0.02, 0.02, 0.08)
		var mid_color = Color(0.05, 0.03, 0.12)
		var bot_color = Color(0.08, 0.02, 0.06)
		
		# Draw gradient in strips
		var strips = 20
		for i in range(strips):
			var t = float(i) / float(strips)
			var next_t = float(i + 1) / float(strips)
			var c: Color
			if t < 0.5:
				c = top_color.lerp(mid_color, t * 2.0)
			else:
				c = mid_color.lerp(bot_color, (t - 0.5) * 2.0)
			var rect = Rect2(0, t * screen_size.y, screen_size.x, (next_t - t) * screen_size.y + 1)
			draw_rect(rect, c)
		
		# Draw stars with twinkling
		var time = Time.get_ticks_msec() / 1000.0
		for star in stars:
			var twinkle = (sin(time * star["twinkle_speed"] + star["twinkle_offset"]) + 1.0) / 2.0
			var alpha = star["brightness"] * lerp(0.3, 1.0, twinkle)
			var color = Color(0.7, 0.8, 1.0, alpha)
			var s = star["size"] * lerp(0.6, 1.0, twinkle)
			draw_circle(star["pos"], s, color)
			
			# Brighter stars get a subtle glow
			if star["size"] > 1.8:
				var glow_color = Color(0.5, 0.6, 1.0, alpha * 0.2)
				draw_circle(star["pos"], s * 3.0, glow_color)
		
		# Danger zone at the bottom — red pulsing strip
		var danger_height = 40.0
		var pulse_alpha = danger_alpha + sin(danger_pulse) * 0.08
		var danger_y = screen_size.y - danger_height
		
		# Gradient from transparent to red
		for i in range(10):
			var a = pulse_alpha * (float(i) / 10.0)
			draw_rect(Rect2(0, danger_y + i * (danger_height / 10.0), screen_size.x, danger_height / 10.0), Color(1.0, 0.1, 0.1, a))
		
		# Danger line
		var line_alpha = 0.3 + sin(danger_pulse * 1.5) * 0.15
		draw_line(Vector2(0, danger_y), Vector2(screen_size.x, danger_y), Color(1.0, 0.2, 0.2, line_alpha), 2.0)
