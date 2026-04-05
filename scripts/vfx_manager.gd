extends Node2D
## VFX Manager — Particle explosions, screen shake, combo flashes.
## Part of Laji's core visual systems.

var camera: Camera2D
var shake_intensity: float = 0.0
var shake_decay: float = 5.0

# Floating score popups
var popups: Array = []

# Explosion particles
var particles: Array = []

func _ready():
	camera = Camera2D.new()
	camera.name = "GameCamera"
	camera.position = Vector2(400, 300)
	camera.make_current()
	get_parent().add_child.call_deferred(camera)

func _process(delta):
	# Screen shake decay
	if shake_intensity > 0:
		shake_intensity = lerp(shake_intensity, 0.0, shake_decay * delta)
		if camera:
			camera.offset = Vector2(
				randf_range(-shake_intensity, shake_intensity),
				randf_range(-shake_intensity, shake_intensity)
			)
		if shake_intensity < 0.5:
			shake_intensity = 0.0
			if camera:
				camera.offset = Vector2.ZERO
	
	# Update particles
	_update_particles(delta)
	
	# Update popups
	_update_popups(delta)
	
	if particles.size() > 0 or popups.size() > 0:
		queue_redraw()

func _draw():
	# Draw particles
	for p in particles:
		var alpha = p["life"] / p["max_life"]
		var color = p["color"]
		color.a = alpha
		var size = p["size"] * alpha
		draw_circle(p["pos"], size, color)
		
		# Glow
		var glow = color
		glow.a = alpha * 0.3
		draw_circle(p["pos"], size * 2.5, glow)
	
	# Draw score popups
	for popup in popups:
		var alpha = popup["life"] / popup["max_life"]
		var font = ThemeDB.fallback_font
		var text = popup["text"]
		var pos = popup["pos"]
		var font_size = popup["size"]
		
		# Shadow
		draw_string(font, pos + Vector2(1, 1), text, HORIZONTAL_ALIGNMENT_CENTER, -1, font_size, Color(0, 0, 0, alpha * 0.5))
		# Main text
		var color = popup["color"]
		color.a = alpha
		draw_string(font, pos, text, HORIZONTAL_ALIGNMENT_CENTER, -1, font_size, color)

func _update_particles(delta):
	var to_remove = []
	for i in range(particles.size()):
		var p = particles[i]
		p["pos"] += p["vel"] * delta
		p["vel"].y += 150.0 * delta  # gravity
		p["vel"] *= 0.98  # drag
		p["life"] -= delta
		if p["life"] <= 0:
			to_remove.append(i)
	
	to_remove.reverse()
	for i in to_remove:
		particles.remove_at(i)

func _update_popups(delta):
	var to_remove = []
	for i in range(popups.size()):
		var p = popups[i]
		p["pos"].y -= 40.0 * delta  # float upward
		p["life"] -= delta
		if p["life"] <= 0:
			to_remove.append(i)
	
	to_remove.reverse()
	for i in to_remove:
		popups.remove_at(i)

# --- Public effect methods called by game_manager ---

func shake_screen(intensity: float = 8.0):
	shake_intensity = intensity

func spawn_explosion(pos: Vector2, color: Color = Color.GREEN, count: int = 16):
	## Burst of particles when a word is destroyed
	for i in range(count):
		var angle = randf() * TAU
		var speed = randf_range(80, 250)
		var p = {
			"pos": pos,
			"vel": Vector2(cos(angle) * speed, sin(angle) * speed),
			"size": randf_range(2.0, 5.0),
			"color": color,
			"life": randf_range(0.4, 0.9),
			"max_life": 0.9
		}
		particles.append(p)
	queue_redraw()

func spawn_miss_effect(pos: Vector2):
	## Red burst when a word is missed
	shake_screen(6.0)
	for i in range(10):
		var angle = randf_range(-PI, -0.2)  # mostly upward
		var speed = randf_range(40, 120)
		var p = {
			"pos": Vector2(pos.x, pos.y),
			"vel": Vector2(cos(angle) * speed, sin(angle) * speed),
			"size": randf_range(2.0, 4.0),
			"color": Color(1.0, 0.2, 0.2),
			"life": randf_range(0.3, 0.6),
			"max_life": 0.6
		}
		particles.append(p)
	queue_redraw()

func spawn_score_popup(pos: Vector2, text: String, color: Color = Color.GREEN):
	## Floating "+50" text
	var popup = {
		"pos": pos + Vector2(-20, -20),
		"text": text,
		"color": color,
		"size": 22,
		"life": 1.0,
		"max_life": 1.0
	}
	popups.append(popup)
	queue_redraw()

func spawn_level_up_effect():
	## Flash particles across the screen for level up
	var screen_w = get_viewport_rect().size.x
	for i in range(30):
		var p = {
			"pos": Vector2(randf() * screen_w, randf_range(0, 100)),
			"vel": Vector2(randf_range(-50, 50), randf_range(50, 200)),
			"size": randf_range(2.0, 6.0),
			"color": Color(1.0, 0.85, 0.2),
			"life": randf_range(0.5, 1.2),
			"max_life": 1.2
		}
		particles.append(p)
	queue_redraw()
