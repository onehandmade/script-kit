// webcam_2005.shader
// "Cheap 2005 webcam" look for OBS handcam sources.
// For the obs-shaderfilter plugin: add a "User-defined shader" filter to your
// handcam source, tick "Load shader from file", and pick this file.
//
// Effects: low resolution, soft focus, color fringing, washed-out color,
// warm/green cast, blown highlights, color banding, compression blocks,
// animated grain (stronger in shadows), vignette.

uniform float res_x<
    string label = "Resolution Width (pixels)";
    string widget_type = "slider";
    float minimum = 80.0;
    float maximum = 1280.0;
    float step = 1.0;
> = 320.0;

uniform float softness<
    string label = "Softness";
    string widget_type = "slider";
    float minimum = 0.0;
    float maximum = 3.0;
    float step = 0.05;
> = 1.0;

uniform float fringe<
    string label = "Color Fringing";
    string widget_type = "slider";
    float minimum = 0.0;
    float maximum = 1.0;
    float step = 0.01;
> = 0.5;

uniform float saturation<
    string label = "Saturation";
    string widget_type = "slider";
    float minimum = 0.0;
    float maximum = 2.0;
    float step = 0.01;
> = 0.75;

uniform float contrast<
    string label = "Contrast";
    string widget_type = "slider";
    float minimum = 0.5;
    float maximum = 1.5;
    float step = 0.01;
> = 0.9;

uniform float brightness<
    string label = "Brightness";
    string widget_type = "slider";
    float minimum = -0.3;
    float maximum = 0.3;
    float step = 0.005;
> = 0.04;

uniform float blowout<
    string label = "Highlight Blowout";
    string widget_type = "slider";
    float minimum = 0.0;
    float maximum = 2.0;
    float step = 0.01;
> = 0.6;

uniform float warm_cast<
    string label = "Warm Cast (- cool, + warm)";
    string widget_type = "slider";
    float minimum = -1.0;
    float maximum = 1.0;
    float step = 0.01;
> = 0.35;

uniform float green_cast<
    string label = "Green Cast";
    string widget_type = "slider";
    float minimum = 0.0;
    float maximum = 1.0;
    float step = 0.01;
> = 0.3;

uniform float color_levels<
    string label = "Color Levels (banding)";
    string widget_type = "slider";
    float minimum = 4.0;
    float maximum = 64.0;
    float step = 1.0;
> = 24.0;

uniform float block_artifacts<
    string label = "Compression Blocks";
    string widget_type = "slider";
    float minimum = 0.0;
    float maximum = 2.0;
    float step = 0.01;
> = 0.6;

uniform float noise_amount<
    string label = "Grain";
    string widget_type = "slider";
    float minimum = 0.0;
    float maximum = 1.0;
    float step = 0.01;
> = 0.35;

uniform float noise_fps<
    string label = "Grain Speed (fps)";
    string widget_type = "slider";
    float minimum = 1.0;
    float maximum = 30.0;
    float step = 1.0;
> = 15.0;

uniform float vignette<
    string label = "Vignette";
    string widget_type = "slider";
    float minimum = 0.0;
    float maximum = 2.0;
    float step = 0.01;
> = 0.7;

float hash21(float2 p)
{
    p = frac(p * float2(123.34, 456.21));
    p += dot(p, p + 45.32);
    return frac(p.x * p.y);
}

float4 mainImage(VertData v_in) : TARGET
{
    float2 uv = v_in.uv;

    // Low-resolution grid that keeps the source aspect ratio.
    float aspect = uv_size.y / uv_size.x;
    float2 res = float2(res_x, max(1.0, floor(res_x * aspect)));
    float2 cell = floor(uv * res);
    float2 puv = (cell + 0.5) / res;
    float2 px = softness / res;

    // Soft focus: center-weighted cross blur at the low resolution.
    float4 center = image.Sample(textureSampler, puv);
    float3 c = center.rgb * 0.4;
    c += image.Sample(textureSampler, puv + float2(px.x, 0.0)).rgb * 0.15;
    c += image.Sample(textureSampler, puv - float2(px.x, 0.0)).rgb * 0.15;
    c += image.Sample(textureSampler, puv + float2(0.0, px.y)).rgb * 0.15;
    c += image.Sample(textureSampler, puv - float2(0.0, px.y)).rgb * 0.15;

    // Color fringing: red and blue channels drift sideways.
    float2 shift = float2(px.x * 1.5, 0.0);
    float r_off = image.Sample(textureSampler, puv - shift).r;
    float b_off = image.Sample(textureSampler, puv + shift).b;
    c.r = lerp(c.r, r_off, fringe);
    c.b = lerp(c.b, b_off, fringe);

    // Washed-out color.
    float luma = dot(c, float3(0.299, 0.587, 0.114));
    c = lerp(float3(luma, luma, luma), c, saturation);

    // Contrast and brightness, then blown highlights.
    c = (c - 0.5) * contrast + 0.5 + brightness;
    c += max(c - 0.7, 0.0) * blowout;

    // Cheap white balance: warm/yellow plus a slight green tint.
    c.r += warm_cast * 0.05;
    c.g += warm_cast * 0.02 + green_cast * 0.04;
    c.b -= warm_cast * 0.06;

    // Compression blocking: each 8x8 block of the low-res image gets a tiny brightness offset.
    float2 block_id = floor(cell / 8.0);
    float block_noise = hash21(block_id) - 0.5;
    c += block_noise * block_artifacts * 0.04;

    // Animated grain, stronger in dark areas.
    float frame_seed = floor(elapsed_time * noise_fps);
    float n = hash21(cell + float2(frame_seed * 17.13, frame_seed * 3.71)) - 0.5;
    float shadow_boost = saturate(1.3 - luma);
    c += n * noise_amount * 0.25 * shadow_boost;

    // Color banding.
    c = saturate(c);
    c = floor(c * color_levels + 0.5) / color_levels;

    // Vignette.
    float2 d = uv - 0.5;
    c *= saturate(1.0 - vignette * dot(d, d) * 2.0);

    return float4(saturate(c), center.a);
}
