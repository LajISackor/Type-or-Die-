extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _make_button(text: String, color: Color) -> Button:
	var btn = Button.new()
	btn.text = text
	btn.add_theme_font_size_override("font_size", 24)
	btn.custom_minimum_size = Vector2(280, 55)
	var normal_style = StyleBoxFlat.new()
	normal_style.bg_color = color
	normal_style.corner_radius_top_left = 8
	normal_style.corner_radius_top_right = 8
	normal_style.corner_radius_bottom_left = 8
	normal_style.corner_radius_bottom_right = 8
	normal_style.border_width_bottom = 2
	normal_style.border_width_top = 2
	normal_style.border_width_left = 2
	normal_style.border_width_right = 2
	normal_style.border_color = color.lightened(0.3)
	btn.add_theme_stylebox_override("normal", normal_style)
	var hover_style = StyleBoxFlat.new()
	hover_style.bg_color = color.lightened(0.2)
	hover_style.corner_radius_top_left = 8
	hover_style.corner_radius_top_right = 8
	hover_style.corner_radius_bottom_left = 8
	hover_style.corner_radius_bottom_right = 8
	hover_style.border_width_bottom = 2
	hover_style.border_width_top = 2
	hover_style.border_width_left = 2
	hover_style.border_width_right = 2
	hover_style.border_color = Color.WHITE
	btn.add_theme_stylebox_override("hover", hover_style)
	btn.add_theme_color_override("font_color", Color.WHITE)
	return btn
