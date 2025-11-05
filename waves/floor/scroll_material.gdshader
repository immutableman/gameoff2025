shader_type canvas_item;

// This uniform lets you control the speed from the Inspector
// vec2(1.0, 0.0) scrolls horizontally to the right.
// vec2(0.0, 1.0) scrolls vertically down.
uniform vec2 scroll_speed = vec2(0.0, 1.0);
uniform vec2 tiling = vec2(1.0, 1.0);

void fragment() {
  // Create a new UV coordinate by adding time-scaled speed to the original UV
  // 'UV' is the texture coordinate (from 0,0 to 1,1)
  // 'TIME' is a built-in variable for total time elapsed
  vec2 new_uv = UV * tiling + (scroll_speed * TIME);

  // Sample the texture at the new, moving coordinate
  // This makes the texture "slide"
  COLOR = texture(TEXTURE, new_uv);
}