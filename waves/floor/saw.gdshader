// Shader for rotating a 2D texture around its center
shader_type canvas_item;

// Control the rotation speed from the Inspector
uniform float rotation_speed_degrees_per_second = 90.0; // Rotate 180 degrees per second

void fragment() {
    // 1. Get the current UV coordinates (0 to 1, across the texture)
    vec2 uv = UV;

    // 2. Adjust UVs so that (0,0) is the center of the texture
    //    (Original UVs have 0,0 at top-left, 0.5,0.5 at center)
    //    This effectively moves the texture origin to the center.
    vec2 centered_uv = uv - vec2(0.5); 

    // 3. Calculate the rotation angle based on time and speed
    //    Convert degrees per second to radians per second (* PI / 180.0)
    //    Then multiply by TIME for continuous rotation
    float angle = radians(rotation_speed_degrees_per_second) * TIME;

    // 4. Apply 2D rotation matrix to the centered UV coordinates
    //    cos(angle)  -sin(angle)
    //    sin(angle)   cos(angle)
    mat2 rotation_matrix = mat2(
        vec2(cos(angle), sin(angle)),   // Column 0
        vec2(-sin(angle), cos(angle))  // Column 1
    );
    vec2 rotated_uv = rotation_matrix * centered_uv;

    // 5. Shift UVs back to original range (0 to 1) for sampling
    //    This puts the rotated texture back into the expected coordinate space
    //    where the texture sampling function expects 0,0 to be top-left.
    vec2 final_uv = rotated_uv + vec2(0.5);

    // 6. Sample the texture at the new, rotated UV coordinates
    COLOR = texture(TEXTURE, final_uv);
}