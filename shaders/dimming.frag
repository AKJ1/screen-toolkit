#version 440
layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;
layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    vec4 selectionRect;
    float dimOpacity;
    vec2 screenSize;
    float borderRadius;
    float outlineThickness;
};
float sdRoundedBox(vec2 p, vec2 b, float r) {
    vec2 q = abs(p) - b + vec2(r);
    return length(max(q, 0.0)) + min(max(q.x, q.y), 0.0) - r;
}
void main() {
    vec2 halfSize = selectionRect.zw * 0.5;
    vec2 center   = selectionRect.xy + halfSize;
    vec2 p        = qt_TexCoord0 * screenSize - center;
    float dist = sdRoundedBox(p, halfSize, borderRadius);
    float aa   = fwidth(dist); // 1 pixel AA based on screen-space derivative
    float insideMask  = 1.0 - smoothstep(-aa, aa, dist);
    float outlineMask = smoothstep(-aa, aa, dist)
                      * (1.0 - smoothstep(outlineThickness - aa, outlineThickness + aa, dist));
    float dimMask     = smoothstep(outlineThickness - aa, outlineThickness + aa, dist);
    vec4 clearColor   = vec4(0.0);
    vec4 outlineColor = vec4(1.0, 1.0, 1.0, qt_Opacity);
    vec4 dimColor     = vec4(0.0, 0.0, 0.0, dimOpacity * qt_Opacity);
    fragColor = insideMask  * clearColor
              + outlineMask * outlineColor
              + dimMask     * dimColor;
}
