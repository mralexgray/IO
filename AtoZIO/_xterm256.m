/**
 * Optimized Code For Quantizing Colors to xterm256
 *
 * These functions are equivalent to the ones found in xterm256.py but
 * orders of a magnitude faster and should compile quickly (fractions
 * of a second) on most systems with very little risk of
 * complications.
 *
 * Color quantization is very complex.  This works by treating RGB
 * values as 3D euclidean space and brute-force searching for the
 * nearest neighbor.
 */

//#import "_IO.h"

//@end

  //  rgb_t res;
  //  if (xcolor < 16) res = BASIC16[xcolor];
  //  else if (16 <= xcolor && xcolor <= 231) {
  //    xcolor -= 16;
  //    res.r = CUBE_STEPS[(xcolor / 36) % 6];
  //    res.g = CUBE_STEPS[(xcolor / 6) % 6];
  //    res.b = CUBE_STEPS[xcolor % 6];
  //  } else if (232 <= xcolor && xcolor <= 255) res.r = res.g = res.b = 8 + (xcolor - 232) * 0x0A;
  //  return res;

//}

//int xterm_to_rgb(int xcolor) {
//
//  // This function provides a quick and dirty way to serialize an rgb_t struct to an int which can be decoded by our Python code using ctypes.
//
//  rgb res = xterm_to_rgb(xcolor);  return (res.r << 16) | (res.g << 8) | (res.b << 0);
//}


