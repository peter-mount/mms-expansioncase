// More information: https://danielupshaw.com/openscad-rounded-corners/
// src https://gist.github.com/groovenectar/292db1688b79efd6ce11

module roundedcube(size = [1, 1, 1], center = false, radius = 0.5) {
    // If single value, convert to [x, y, z] vector
    size = (size[0] == undef) ? [size, size, size] : size;

    translate = (center == false) ?
            [radius, radius, radius] :
                [
                    radius - (size[0] / 2),
                    radius - (size[1] / 2),
                    radius - (size[2] / 2)
                ];

    translate(v = translate)
        minkowski() {
            cube(size = [
                    size[0] - (radius * 2),
                    size[1] - (radius * 2),
                    size[2] - (radius * 2)
                ]);
            sphere(r = radius);
        }
}
