
/******************************************************************************
* MODULE     : ns_utilities.mm
* DESCRIPTION: Utilities for Aqua
* COPYRIGHT  : (C) 2007  Massimiliano Gubinelli
*******************************************************************************
* This software falls under the GNU general public license version 3 or later.
* It comes WITHOUT ANY WARRANTY WHATSOEVER. For details, see the file LICENSE
* in the root directory or <http://www.gnu.org/licenses/gpl-3.0.html>.
******************************************************************************/

#include "ns_utilities.h"
#include "dictionary.hpp"
#include "converter.hpp"
#include "analyze.hpp"

#define SCREEN_PIXEL (PIXEL)

coord4 from_nsrect (NSRect rect)
{
  SI c1, c2, c3, c4;
  c1 = rect.origin.x*SCREEN_PIXEL;
  c2 = rect.origin.y*SCREEN_PIXEL;
  c3 = (rect.origin.x+rect.size.width+SCREEN_PIXEL-1)*SCREEN_PIXEL;
  c4 = (rect.origin.y+rect.size.height+SCREEN_PIXEL-1)*SCREEN_PIXEL;
  return coord4 (c1, c2, c3, c4);
}

NSRect to_nsrect(coord4 p)
{
	float c = 1.0/SCREEN_PIXEL;
	return NSMakeRect (p.x1*c, -p.x4*c,
                     (p.x3-p.x1+SCREEN_PIXEL-1)*c, (p.x4-p.x2+SCREEN_PIXEL-1)*c);
}

NSPoint to_nspoint (coord2 p)
{
	float c = 1.0/SCREEN_PIXEL;
	return NSMakePoint (p.x1*c,-p.x2*c);
}

NSSize to_nssize (coord2 p)
{
	float c = 1.0/SCREEN_PIXEL;
	return NSMakeSize (p.x1*c,p.x2*c);
}

coord2 from_nspoint (NSPoint pt)
{
	SI c1, c2;
	c1 = pt.x*SCREEN_PIXEL;
	c2 = -pt.y*SCREEN_PIXEL;
	return coord2 (c1,c2)	;
}

coord2 from_nssize (NSSize s)
{
	SI c1, c2;
	c1 = s.width*SCREEN_PIXEL;
	c2 = s.height*SCREEN_PIXEL;
	return coord2 (c1,c2)	;
}

NSString *to_nsstring (string s)
{
	c_string p = c_string (s);
	NSString *nss = [NSString stringWithCString:p encoding:NSUTF8StringEncoding];
	return nss;
}

string from_nsstring(NSString *s)
{
	const char *cstr = [s cStringUsingEncoding:NSUTF8StringEncoding];
	return utf8_to_cork(string((char*)cstr));
}


NSString *to_nsstring_utf8(string s)
{
  s = cork_to_utf8 (s);
  c_string p = c_string (s);
  NSString *nss = [NSString stringWithCString:p encoding:NSUTF8StringEncoding];
  return nss;
}

string
ns_translate (string s) {
  string out_lan= get_output_language ();
  return tm_var_encode (translate (s, "english", out_lan));
}


tm_ostream&
operator << (tm_ostream& out, NSRect rect) {
  return out << "(" << rect.origin.x << "," << rect.origin.y << ","
  << rect.size.width << "," << rect.size.height << ")";
}

tm_ostream&
operator << (tm_ostream& out, NSSize size) {
  return out << "("  << size.width << "," << size.height << ")";
}

