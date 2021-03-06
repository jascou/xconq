(game-module "antar-map-50km"
  (title "Antarctica Map")
  (blurb "Map of Antarctica with 50km hexes, based on RAMP DEM data from 2001.")
  (notes (
    "DRAFT VERSION"
    "" ""
    "Map developed by Matthew Skala, mskala@ansuz.sooke.bc.ca, this draft"
    "19 September 2004."
    "" ""
    "This map is based mostly on a 1-km DEM from the RAMP project. [1]  It's"
    "not actually RADARSAT data, but was compiled for the purpose of"
    "correcting RADARSAT data.  The data arrived in the form of a 144Meg"
    "gzipped ASCII text file with four columns of decimal data: latitude,"
    "longitude, and height in meters above the WGS84 and OSU91A reference"
    "geoids, for roughly 14 million points scattered about 1km apart over"
    "the entire continent surface."
    "" ""
    "I used Perl scripts to project the data points onto a Lambert"
    "azimuthal equal-area projection [2] centred on the South Pole."
    "I wanted the equal-area property because that seemed like a better"
    "trade-off for gaming than trying to go for a conformal projection or"
    "some kind of compromise between the two; this is also a very popular"
    "projection for other maps of Antarctica.  My thinking was that your"
    "navigation will be screwy anyway because of the hex grid, so there's"
    "no point worrying too much about angles, whereas you want your resource"
    "extraction and such to reflect true areas.  The output of the projection"
    "transformation was in units of Earth radii, so I multiplied by a"
    "fudge factor of 127.563 hex cells per Earth radius, to give a nominal"
    "hex size of 50km with the IUGG Earth radius value of 6378.137km. [3]"
    "" ""
    "Next I converted the x and y coordinates to hex cells using an"
    "algorithm posted to Usenet by Amit Patel. [4]  I actually got the"
    "algorithm out of the original Usenet posting and had to independently"
    "discover the bug reported by Jason Goodwin and noted on Patel's Web"
    "page, regarding behaviour with negative coordinates.  I solved it by"
    "adding offsets to force all my coordinates to be positive when they"
    "went through the algorithm.  Note that I chose my axes in such a way"
    "as to put the panhandle to the left, and the 30 degrees East meridian"
    "at the top of the map; that doesn't seem to be the usual 0=up"
    "convention of Antarctic maps, but it makes the shape fit the hexagonal"
    "map a lot better."
    "" ""
    "For each hex cell, I computed the mean and standard deviation of the"
    "OSU91 elevations for all DEM points in that cell, assigning zeroes to"
    "cells with no DEM points.  I used the OSU91 elevations because those"
    "are supposed to represent height above sea level, which seemed like it"
    "ought to have more physical significance than WGS84 for the next step:"
    "plotting the mean elevation (e) versus standard deviation of elevation"
    "(d) values on a scatterplot and looking for patterns.  My hope was that"
    "I could classify on those two variables and get some useful \"terrain"
    "category\" value which I could use to paint the map."
    "" ""
    "The classification rules were somewhat arbitrary and based on manual"
    "tweaking and examination of the scatterplot.  I can't particularly"
    "defend them scientifically nor give definitive descriptions of what"
    "the classes' physical significance on the ground actually is, but they"
    "seem to at least produce a map that looks good on my screen.  Here are"
    "the rules I used, where d is standard deviation of elevations and e is"
    "mean elevation, both in metres:"
    "" ""
    "If d=0 and e=0 (probably because of no DEM points in the cell at"
    "all, so it hits the fill-in rule) then the cell is terrain type 0 which"
    "I call \"sea\".  The terrain is very smooth and at sea level."
    "" ""
    "Else if d<20 and e<40 then the cell is terrain type 1 which I call"
    "\"ice-edge\"; these seem to be the cells right at the edges of major ice"
    "shelves, where the ice is breaking off and floating away.  The terrain"
    "is pretty smooth and very low."
    "" ""
    "Else if d<20 and e<150 then the cell is terrain type 2 which I call"
    "\"ice-shelf\"; it's smooth, and still quite low, suggesting ice"
    "floating on the ocean."
    "" ""
    "Here's where it gets tricky: if d>=220-e/20 AND d>=450-e/4, then the"
    "terrain is pretty bumpy, but how bumpy it needs to be to meet those"
    "conditions is reduced at higher elevations.  Then the cell is terrain"
    "type 5 which I call \"icy-mountains\".  This rule is somewhat ad hoc,"
    "but the basis for it seems to be that at lower elevations, just the"
    "normal basically flat glaciers have a fair bit of roughness to them,"
    "whereas at high elevations where the glaciers are generally smoother,"
    "even a little bit of bumpiness should be enough to qualify as special."
    "The cutoff boundary on the scatterplot is sort of curved, but I'm"
    "approximating it with two lines."
    "" ""
    "Else if d>e-300 the cell is terrain type 3, and all other cells are"
    "terrain type 4; respectively \"icy-lowlands\" and \"icy-highlands\"."
    "This line was also chosen by examining the scatterplot; what seems to"
    "be going on is that these two terrain types represent the bulk of the"
    "ice sheet, which is mostly smooth, but tends to be rougher in the low"
    "spots, and so what is considered to be a low spot can extend to a"
    "higher elevation when the ice is rougher."
    "" ""
    "Feature names were added by hand, based on several different maps and"
    "other resources I found on the Web. [5,6,7,8]  I got the location of the"
    "(geographic) South Pole for free from my coordinate system, but"
    "locations of other small things like islands are necessarily a bit"
    "approximate, both due to the hex grid and the difficulty of recognizing"
    "terrain features when seen through the filters of the DEM, the cell"
    "classification process, and up to 4km of ice.  You especially shouldn't"
    "trust the feature boundaries to exactly follow the theoretical under-ice"
    "coastlines.  Fortunately, that's unlikely to have much game"
    "significance even for submarines, let alone surface units."
    "" ""
    "The shape of Lake Vostok [8,9,10] is somewhat distorted because of hex-grid"
    "constraints.  After some thought I decided to make it just a feature"
    "(instead of also putting in some special cell terrain) because from"
    "the point of view of any reasonable surface unit, the terrain there"
    "is the same as that anywhere nearby.  The under-ice lake is interesting"
    "from a resources viewpoint, but not really a terrain viewpoint."
    "Elevation of \"Lake Vostok\" hexes does not match the numbers I've seen"
    "for depth of ice over the lake surface; I'm not sure whether that is"
    "because the lake surface is actually below OSU91 sea level, or if it's"
    "due to some kind of error in the position of the feature."
    "" ""
    "Note that this map is based primarily on data from 2001, and so it"
    "includes the Larsen Ice Shelf, which vanished in 2002.  The loss may"
    "have been the fault of human-induced climate change; it's still under"
    "discussion. [11]  The games I'm most interested in developing are set"
    "pre-2002 anyway."
    "" ""
    "[1] Liu, H., K. Jezek, B. Li, and Z. Zhao. 2001. Radarsat Antarctic"
    "Mapping Project digital elevation model version 2. Boulder, CO: National"
    "Snow and Ice Data Center. Digital media, online"
    "http://nsidc.org/data/nsidc-0082.html"
    "" ""
    "[2] Weisstein, Eric W. \"Lambert Azimuthal Equal-Area Projection.\" From"
    "MathWorld - A Wolfram Web Resource. Online"
    "http://mathworld.wolfram.com/LambertAzimuthalEqual-AreaProjection.html"
    "" ""
    "[3] Weisstein, Eric W. \"Earth Radius.\" From"
    "Eric Weisstein's World of Astronomy - A Wolfram Web Resource. Online"
    "http://scienceworld.wolfram.com/astronomy/EarthRadius.html"
    "" ""
    "[4] Patel, Amit, and Goodwin, Jason. Pixel Coordinates to Hexagonal"
    "Coordinates.  Usenet postings and commentary, online"
    "http://www-cs-students.stanford.edu/~amitp/Articles/GridToHex.html"
    "" ""
    "[5] abcteach. abcteach Printable Worksheet: Antarctica Map. Online"
    "http://www.abcteach.com/Themeunits/Antarctica/AntarcticaMap.htm"
    "" ""
    "[6] Voyages Jules Verne. Antarctica Map. Online"
    "http://www.vjv.com/country/arctic_&_antarctic/antarctica_cmap.html"
    "" ""
    "[7] National Geographic Society. Antarctica. Map on south-pole.com"
    "\"Antarctic Philately\" Web site, online http://www.south-pole.com/map.htm."
    "" ""
    "[8] [Russian] Arctic and Antarctic Research Institute.  Station"
    "Vostok. Online "
    "http://www.aari.nw.ru/projects/Antarctic/stations/vostok/vostok_en.html"
    "" ""
    "[9] Studinger, Michael.  Michael Studinger's Lake Vostok Home Page."
    "Online http://www.ldeo.columbia.edu/~mstuding/vostok.html"
    "" ""
    "[10] Wikipedia. \"Lake Vostok.\" Online"
    "http://en.wikipedia.org/wiki/Lake_Vostok"
    "" ""
    "[11] Dargaud, Guillaume. Antarctic Climate FAQ.  Online"
    "http://www.gdargaud.net/Antarctica/MeteoDdU.html#FAQ"
  ))
)

; (include "antar-terrain")
; (include "stdunit")

(world 800)

(area 125 111 (cell-width 50000))

(area (terrain
 (by-name
    (sea 0) (ice-edge 1) (ice-shelf 2) (icy-lowlands 3) (icy-highlands 4)
    (icy-mountains 5) (buried-lake 6))
  "125a"
  "125a"
  "125a"
  "125a"
  "125a"
  "53a2d70a"
  "50ada6d67a"
  "41ad6a7de2fd66a"
  "39ab3d3ad3fef2dfe3fd65a"
  "39a2b2db2ad2fe6fe2f2d64a"
  "38a4be4d2efefe2fe4fd64a"
  "29a2bdc3bd3b3de2fd2e4fe3fe3fd63a"
  "29a2bdcdc3dc2d4e2f6e3f2e4f2d61a"
  "27a3b10d7e2f5ef4e5f2d59a"
  "26a2b4d9ef3e4f6ef5e4fed58a"
  "24a2b2c2d12f2e6f15e2f2d56a"
  "22a4bc2de21f12ef2e2f2d55a"
  "23ab2c2de18fe3f12e2f5ed54a"
  "23a3cde13fe3fefe4f12efef3ed54a"
  "22ab3cde6f2e6fe5fe2f14e2f2e2db53a"
  "22ab2c3d3f6e5fe4fe2f15e2fe2d2cb52a"
  "21a2b3dfe2f14e4f19ef2d3cb51a"
  "22a2cd5f15e5f18e2d3cb51a"
  "22ab2d6f16ef19ed3c5db2d2a2b42a"
  "22abd2e2fe2f32ef3ed2cd2e2fefe2fd2b42a"
  "23abdef2e2f34efedfd6e2f2ef4db39a"
  "23a2bd3e2f34efe2f12e2f2d2b38a"
  "23a2b2d2e2f32ef2ef16ef3db37a"
  "24ab2d2e2f32efef6ef10e2fe2d37a"
  "24abcd2e2f56e2d36a"
  "24a3b2def55e3fdad33a"
  "25ab2cd2ef31efef22e2fd34a"
  "26a3cd35e2f22e2fda2b30a"
  "27ab2cdef29e6f22e2fd3b29a"
  "26a4bd2f30e6f22e2f2db29a"
  "27a3b2df30efe3f21efe3fd2b28a"
  "28a2b2df31efe3f22e3f3db27a"
  "29a2bdf33e5f21e3f4d26a"
  "30abdf34e5f21e4f2d26a"
  "31adf34e5f25ef2d25a"
  "32ad34e6f25efd25a"
  "33ad7ef28e3f25e2f25a"
  "33ad7ef20e2fe2f4e2f26efd24a"
  "34ad3e3df21e2fe3f30efd24a"
  "35ad2e3df21e3f2e3f27e2fdb23a"
  "36a3d2cdef21ef5ef27e2fd23a"
  "36ad4cd58ef3d21a"
  "36ad5cdef37eg17efeded20a"
  "4af30ab4d3c38e2g21efd19a"
  "4adf28a2bd4edc2d36eg21efed19a"
  "5ad2a2d24a2bcd4ed2cdef55e3d19a"
  "6ada3d22a3b3c2ded2c2d55ef3d19a"
  "7ada4d20a2b7c2dcd2f56e2d19a"
  "7a2dafdfd19ab9c2dcd2f56ed19a"
  "8a2dadfdb18ab13cde2f52efe2d18a"
  "9a2da2f2d4b5a2db5db9c2d4c2d55ed18a"
  "10a3d2f3d5b4dfd4f2d9c2d3c3defe2f48ef2d17a"
  "11adfd3f3dcb2d11f2d8cdc3d6e2f48ef2d16a"
  "12afad4fd2c2d4fe3fe3f2d4cd4c2d9ef48efd16a"
  "15af2d3f3d4fe9fd3c3d2c3d9ef47efed15a"
  "18ad9fef3d2fefefd4cd3c2d6e2fef4efef40efedb14a"
  "18a2d5fdfe2df3d2f4edc2d2c3d8efef5e3f2e2f36ef2d14a"
  "21ad3fad4fe3de2f2e4d2c2d10e2f3efe4fe3f34e2f2db13a"
  "22a3dad3fde4d2f3e7df9ef3e13f33e2fd14a"
  "26ad2f8df3e2de4d2f11e18f32ed13a"
  "27a3db7df2e2dfe3d2f11e3fe16f31ed12a"
  "30a5db3d8e3f16e2d2c3fd8f29efd12a"
  "30a4d2a3d7e4f17ed4cd4c2d6f25e3fd11a"
  "36a4df7ef18e2d12cd4f24e2f2d11a"
  "40ad27e2d13cd3f22efe2fdb10a"
  "40ad28e2d14c3f23e2fd11a"
  "41ad27e2d15c3f22e2fd11a"
  "41acd26e3d14cd2f22e2fd11a"
  "42a2df26e2d13cd4f17e2f2efd11a"
  "42a3df24ede2d13c2d3fef15ef2efd11a"
  "43a3df23e4d13cbf2d3f16efded11a"
  "44abc2f2e2d19ed16c3fad2f14efe3d11a"
  "45a3d2e3d18e2d4cd10c2b3ab3f12ef3db11a"
  "46a9d17e3d2c2d6c5badabd2f12efdb13a"
  "46a6d2b2d2ef15e2d2c2d3c3b9a4f11ed14a"
  "47a5dbab2df3ef13e2d3cbc3b10ab5f8e2d14a"
  "48a5d3a2de2f4ef11e2dc2b14ad6f4efe2d14a"
  "49a2dbdb2a3d6ef9ed3ed16abd7fe2f3d14a"
  "57a3de2fe2f8e6db15a7fde3f2d15a"
  "58a4d7f6e5db17a7f4d16a"
  "59ab4d10fe3d21a5fdb19a"
  "61a5d10f2d21ad4fd20a"
  "63a3dc2dfdef4db23af23a"
  "65adf2b5d3b48a"
  "66afd2adb2ad50a"
  "67ad57a"
  "125a"
  "125a"
  "125a"
  "125a"
  "125a"
  "125a"
  "125a"
  "125a"
  "125a"
  "125a"
  "125a"
  "125a"
  "125a"
  "125a"
  "125a"
  "125a"
  "125a"
  "125a"
  "125a"
  "125a"
  ))
(area (elevations
  (xform 20 0)
  "125a"
  "125a"
  "125a"
  "125a"
  "125a"
  "53ace70a"
  "50ahafkxywg67a"
  "41ad6aqulg2k|2O>i66a"
  "39a2boc3as:2D><m|<J74,80,?f65a"
  "39a2cmnc2a|JU67,66,UDF66,2*65,74,Ljc64a"
  "38a4c~olhpQ72,81,87,82,70,[80,89,88,78,Oyn64a"
  "29abc2d3ce3cfky2MAvL76,89,100,106,95,83,88,103,109,106,80,UOo63a"
  "29abcfdgdfdedeq>HS68,72,NP77,93,107,114,115,2*102,110,121,120,106,94,86,Uzr61a"
  "27ab2cefqplksrkp}HU67,74,2*83,71,82,95,107,117,123,119,113,117,125,130,124,118,112,89,64,J{g59a"
  "26a2c2ehr{>D>=?A@IV69,76,83,89,98,95,96,102,110,119,125,128,126,127,130,134,135,131,127,113,91,80,W=r58a"
  "24a2c2dju>BPU67,69,TS[66,[76,83,89,94,99,116,115,113,114,118,124,129,133,134,135,137,139,141,140,136,127,111,99,86,65,Dwe56a"
  "22ab3cdht>T72,2*86,91,96,87,82,90,115,124,103,99,100,109,115,126,131,128,127,128,130,134,137,141,143,2*144,2*146,142,135,125,113,100,85,68,Lxm55a"
  "23ac3duCOZ90,113,122,119,123,120,2*116,132,148,142,120,116,124,127,134,142,140,139,138,139,140,142,145,148,2*150,149,148,145,139,134,127,111,97,83,66,O;o54a"
  "23a3de<U75,96,111,129,143,148,2*143,2*141,144,150,159,146,2*133,138,141,147,150,3*149,2*148,150,152,154,153,151,149,144,137,132,129,122,105,84,69,TDy54a"
  "22ac4d<Y97,134,137,142,149,157,159,156,154,156,157,159,162,161,151,143,145,149,152,157,159,158,157,156,155,3*156,154,151,147,141,134,128,122,118,101,75,SKtfc53a"
  "22acdehox66,108,139,152,153,155,159,163,164,163,164,165,166,168,169,164,158,154,156,158,162,2*166,164,163,162,161,160,158,154,149,145,140,131,121,114,108,95,75,Gmh2dc52a"
  "21abc2huBAZ114,131,144,152,157,161,164,167,168,169,170,172,2*174,173,169,165,164,165,167,170,172,171,169,168,165,164,160,155,149,143,137,130,116,105,97,87,76,Ulfe2dc51a"
  "22a2dqFXY[92,120,135,146,154,160,164,168,170,172,173,175,176,2*178,177,174,172,171,172,174,176,175,174,173,170,168,163,157,149,141,134,125,114,100,89,78,[Fnf2edc51a"
  "22acoh;68,82,84,95,110,126,139,149,156,162,166,169,172,174,176,178,179,2*181,180,179,178,177,178,2*179,178,176,174,171,167,160,150,140,131,123,110,93,79,69,Px2feg{wbdbfm2a2b42a"
  "22abdy=65,92,100,104,2*125,135,145,152,158,163,167,169,171,174,176,178,180,182,2*183,3*182,2*183,182,180,177,174,169,163,154,141,130,121,110,95,72,T?jgfj>R[C?:~D<hcb42a"
  "23abc|V77,97,109,135,138,137,144,149,155,159,162,165,168,170,172,174,177,179,181,184,3*185,2*186,185,183,180,176,172,166,158,148,134,123,111,97,81,S{n;w>N65,76,75,68,66,[65,67,Goe2cb39a"
  "23a2cg=64,81,96,129,2*143,144,147,151,155,158,161,164,165,168,171,173,176,178,181,184,186,187,3*188,185,183,179,175,169,162,153,143,132,114,101,86,65,D?XIR64,73,84,91,89,87,85,84,83,73,UBuecb38a"
  "23abcdrF67,89,119,138,2*140,143,146,149,153,156,159,161,164,166,169,172,174,177,179,183,184,187,2*189,188,184,181,177,172,166,159,150,140,125,108,94,79,[S[64,68,76,83,92,102,107,106,103,99,98,91,80,69,R{hcb37a"
  "24acdm=M71,113,130,2*135,136,140,143,146,150,153,156,159,162,165,167,170,173,175,178,181,183,186,2*188,186,182,178,174,169,163,156,147,135,122,108,95,84,75,72,80,84,90,99,108,113,117,2*120,115,111,106,98,90,77,YFrc37a"
  "24acdr;=S105,126,128,129,131,133,136,139,143,146,150,153,157,160,163,166,169,171,174,177,180,182,185,187,186,184,180,177,172,167,160,153,143,130,120,108,99,92,86,88,95,102,114,123,124,127,130,131,129,123,118,112,104,96,82,66,J{p36a"
  "24a3ckmH81,115,120,123,125,127,129,133,136,139,143,147,151,155,159,162,165,167,170,174,177,179,182,184,186,184,182,179,175,170,165,157,148,138,129,120,111,105,101,99,101,110,122,131,135,136,138,139,138,135,129,122,115,108,96,85,71,XBvah33a"
  "25ac2dg;Y96,109,116,119,121,123,125,129,133,136,140,144,149,154,157,160,164,166,170,173,176,179,182,184,185,184,181,178,174,169,161,153,147,139,132,123,116,114,2*112,121,130,138,142,143,144,2*145,143,139,132,126,119,111,102,91,81,69,Gr34a"
  "26a3dqG67,94,107,114,115,116,119,122,127,130,134,138,143,148,152,155,159,162,166,169,172,176,179,182,185,186,184,181,178,175,169,161,156,150,144,136,127,123,122,124,129,139,143,146,148,150,151,150,149,146,141,135,129,123,116,107,96,85,71,Dkabc30a"
  "27ac2dvL75,98,108,109,108,111,115,120,125,128,133,137,143,146,150,154,157,161,165,169,172,176,180,183,2*186,184,182,179,175,170,166,161,156,149,141,133,2*132,138,144,148,151,153,2*156,155,154,152,149,144,139,133,127,119,110,100,87,67,Ci3c29a"
  "26ab3cf<66,88,98,2*102,103,110,115,118,122,126,131,136,141,144,148,151,155,160,164,168,173,176,180,184,2*187,185,183,180,177,174,171,166,159,152,144,140,139,142,147,151,155,157,160,2*161,160,159,156,151,147,142,137,131,123,113,100,88,67,~fdc29a"
  "27a3cd{65,83,92,94,96,97,102,108,112,116,120,124,130,135,138,140,144,148,152,157,162,167,173,177,181,185,2*188,186,184,182,181,179,176,169,163,154,148,2*145,149,154,158,162,165,3*166,164,161,158,153,149,146,140,134,126,115,103,91,70,=ecb28a"
  "28abcdzZ81,88,2*90,89,92,98,106,110,114,117,123,128,131,133,135,138,142,149,153,160,167,173,178,182,186,2*189,188,187,2*186,185,181,173,164,155,152,151,155,159,162,165,168,170,2*171,170,168,164,160,155,151,147,141,135,126,118,108,91,67,ydcb27a"
  "29abcwX79,81,83,84,2*81,87,93,102,108,111,115,121,124,125,127,130,133,138,146,151,158,167,174,178,183,187,189,191,190,191,2*190,188,185,177,169,161,159,161,163,166,169,171,173,174,175,2*174,171,167,162,158,152,145,139,131,122,112,94,74,Gndgk26a"
  "30abpP74,73,70,2*76,73,74,83,92,101,106,107,112,116,120,124,126,128,130,136,143,150,159,168,173,179,184,187,190,192,4*194,192,190,183,172,167,166,169,170,173,174,176,177,2*178,177,176,172,167,162,156,148,141,132,124,114,100,87,69,Q}jb26a"
  "31akD64,71,ZX68,Z[73,85,96,97,99,103,108,114,121,125,127,129,132,138,147,153,162,169,174,181,186,188,191,195,196,3*197,196,194,184,176,2*173,175,176,177,178,180,2*181,180,178,175,171,166,160,153,145,137,127,119,106,100,91,78,65,Oqc25a"
  "32auN65,TMUPHX77,88,92,95,100,103,109,117,123,126,128,131,136,142,149,157,166,171,176,182,187,191,194,197,199,200,201,202,201,196,186,181,2*179,180,2*181,183,2*184,183,180,177,173,168,163,157,150,141,132,124,115,109,101,91,82,72,Gd25a"
  "33a|TPDKN=D66,82,87,93,99,102,106,113,121,126,128,130,133,137,144,151,162,169,172,178,183,189,193,196,199,202,203,204,203,200,194,187,184,2*183,2*184,186,187,186,184,180,177,174,170,166,160,154,146,138,131,124,118,114,106,96,87,[<25a"
  "33ai=PCyG~=X68,76,88,97,101,104,111,118,124,127,129,131,134,139,147,157,166,170,174,179,185,190,194,197,200,202,2*201,200,196,191,188,3*186,187,2*188,187,184,181,178,174,170,166,162,156,150,143,137,131,125,121,116,109,98,79,Ql24a"
  "34akBM|ox}YW64,82,90,97,102,108,117,122,127,129,131,133,136,143,152,162,168,171,174,180,185,191,193,196,197,2*198,197,195,193,190,2*189,188,2*189,188,187,184,181,177,174,170,166,162,157,152,147,142,137,130,124,118,111,104,84,Zz24a"
  "35ag=;lilRTW72,84,90,97,105,114,120,125,129,131,133,135,140,148,157,165,169,171,175,179,185,189,191,3*192,194,193,192,5*190,189,187,185,183,180,177,174,170,166,161,156,152,149,145,141,135,128,119,112,105,91,[{b23a"
  "36ae2h2guKT70,79,84,91,101,111,118,124,128,131,133,135,138,144,153,160,166,169,172,175,179,184,187,4*188,2*189,3*188,2*189,187,186,184,181,179,177,174,170,165,160,155,151,147,145,142,138,131,123,115,108,95,73,Ck23a"
  "36ae2f2gh@K69,76,82,86,96,107,116,121,127,130,133,135,137,141,149,157,161,165,169,172,174,178,181,183,4*184,185,186,2*185,2*186,185,184,182,180,178,177,174,170,165,160,156,151,146,143,140,137,132,127,120,112,99,80,Qsef21a"
  "36ade2f2gmBW72,79,84,91,101,111,118,124,128,131,134,136,138,144,152,158,161,165,168,171,173,176,178,3*180,181,182,183,2*182,183,182,2*181,180,178,2*177,174,171,166,161,157,152,147,144,140,138,134,131,123,113,103,89,68,At:o20a"
  "4a{30abrn2k3gyM67,75,81,87,96,105,113,120,125,128,131,134,137,140,146,154,157,161,163,166,168,170,172,175,2*176,2*177,178,3*179,2*178,5*177,174,170,166,162,158,154,150,146,142,139,136,132,126,116,104,91,74,LET@g19a"
  "4aq?28abcl:y@>k2gwO67,75,82,90,99,106,112,119,123,127,130,134,138,141,148,154,156,159,161,164,166,167,169,170,171,2*172,2*173,174,176,175,3*174,2*176,175,173,170,166,163,159,155,152,149,145,142,138,133,128,118,107,95,80,U?UHm19a"
  "5ap2aol24a2cdhv|?>kghi~T74,83,91,100,106,110,116,121,126,130,136,137,143,151,154,155,157,160,162,164,165,166,167,168,2*167,168,169,2*171,2*170,171,172,2*173,172,169,166,163,160,156,154,151,149,145,141,136,129,121,111,101,87,68,Dwvd19a"
  "6amajon22a2bc2defjxqghjo>R72,84,90,98,105,110,115,122,128,131,136,138,149,153,154,2*155,157,160,161,163,5*164,2*165,3*167,168,169,3*170,169,166,164,161,157,155,154,152,149,144,140,132,124,116,107,95,80,W{ic19a"
  "7ahaporg20a2c3d4epn2h:TNW70,81,89,98,106,111,117,125,130,133,137,145,153,4*155,156,158,159,4*160,162,2*161,162,164,2*165,3*166,2*167,166,164,162,159,157,156,154,152,147,142,136,129,122,113,102,89,71,Ntd19a"
  "7atpa;q~c19ac5d3ef3hjD67,68,67,74,84,91,100,109,115,121,127,131,135,141,152,154,2*155,156,155,3*156,3*157,156,155,154,157,160,161,2*162,2*163,4*164,162,160,158,157,156,155,151,145,140,134,127,118,109,97,82,Y@h19a"
  "8anla}Dfb18ac6d2ef2g3h<LXZ75,87,95,103,114,121,128,132,134,137,145,149,153,154,4*155,2*154,3*153,151,150,153,155,157,3*158,160,2*161,2*162,163,162,160,159,158,157,154,149,143,138,132,124,116,105,92,74,Mod18a"
  "9ahqaCM2c2bcb5agcbceiedc7d2efig3hir>V74,89,100,110,120,128,132,133,136,140,146,151,153,2*154,3*153,151,150,3*149,147,148,150,151,153,2*154,156,158,159,2*160,161,2*162,160,159,158,156,153,147,142,136,129,121,112,100,86,66,@g18a"
  "10aihsGFhce4c3bdlup}?|vjed3e2d3eg4hltvE75,76,84,102,117,125,131,135,137,140,146,150,153,154,153,152,2*151,150,148,146,2*145,2*144,145,146,147,2*149,151,153,156,157,158,159,160,162,163,162,160,159,156,152,147,141,136,129,121,111,99,85,64,{e17a"
  "11ajHmACtj3d2cer}L69,Q67,81,ZUGwh5ed2ef2hijq|FDR65,68,81,106,117,127,134,139,143,145,152,2*155,153,151,149,148,147,145,2*143,2*142,141,140,139,142,145,146,147,149,152,154,156,157,159,161,2*163,162,161,159,156,152,146,141,135,127,119,109,97,83,Xsd16a"
  "12aSar:JS:e2demN90,87,98,92,79,90,79,88,81,71,Luf6e3gnru{C2OW64,79,92,105,117,128,139,144,147,152,156,155,153,150,148,146,144,143,140,3*139,2*137,136,134,141,2*144,146,148,151,154,156,157,159,161,163,162,161,160,158,156,152,146,140,134,126,117,107,95,80,Lq16a"
  "15a;vwLTtfem72,90,101,89,74,XSTX90,99,92,65,Fgf2eg2jhgjps{AN2Z65,71,86,95,109,124,135,142,145,150,156,155,153,151,147,144,142,140,138,136,2*134,133,132,3*133,137,140,142,143,146,149,151,154,157,159,160,161,2*160,159,157,155,151,146,139,132,123,114,104,90,72,:l15a"
  "18ahDWXDRWK66,68,G>hksT82,95,80,XAh4f4hlp|GR64,72,75,82,101,97,108,126,130,134,2*139,146,148,2*151,147,143,140,139,136,133,132,130,128,127,126,127,128,130,133,135,138,140,143,146,148,151,154,156,158,3*159,158,156,154,150,143,135,127,118,107,94,76,Swb14a"
  "18ades|2<yi|<ilvnfoL71,84,ZL>kf4ghiuz?JV65,75,86,101,112,104,116,131,128,125,129,132,123,137,140,148,145,139,133,132,133,130,129,127,124,123,121,120,122,124,126,128,131,134,137,140,143,146,149,151,153,155,156,157,159,158,155,152,145,137,129,121,110,96,78,Nth14a"
  "21am{:wast@E=;lfqL72,74,J?vghr2hnt?GIR65,71,80,88,101,109,110,114,124,122,119,108,124,2*117,118,134,140,133,126,118,123,124,122,124,122,120,118,116,117,118,120,123,126,129,132,134,138,141,144,146,148,150,152,154,155,156,155,152,146,139,131,124,112,99,84,Yudb13a"
  "22ahsnajJHoj|jicqC70,P|wkhtkmkp@WV[71,80,85,92,98,102,3*111,119,125,108,122,117,83,118,110,137,130,126,104,99,118,115,114,116,117,114,2*111,113,115,118,121,125,128,131,134,137,140,142,145,147,149,150,151,152,153,151,147,142,135,127,117,105,90,68,:c14a"
  "26anNCgbgpfjgiGN:rmpGzpwmE69,71,78,83,87,91,95,98,100,98,104,101,104,94,103,73,100,89,67,74,134,131,124,136,89,115,100,108,100,104,110,102,103,105,110,114,119,121,124,128,131,133,136,140,142,144,145,147,148,3*149,146,143,138,131,123,111,98,83,[=q13a"
  "27a2tgbejnlo2k2EwsuSHpvpK84,83,88,93,95,98,99,100,102,99,91,87,79,72,[LC?2xB97,94,79,107,U109,93,111,73,96,97,86,90,100,110,115,120,123,125,127,130,133,136,138,139,140,2*141,2*142,2*143,140,138,134,127,121,110,95,80,[Gu12a"
  "30aceqofbch{MD@?EJ<yV105,96,95,100,102,103,2*105,107,108,102,88,78,68,TOI;qi2gpB|m|vC72,M64,99,80,64,81,98,110,117,121,124,125,127,130,133,134,136,137,138,137,3*136,138,136,132,130,129,127,120,108,94,79,Uw12a"
  "30aslmq2apmuJQNFJKGI92,114,2*101,106,108,111,2*112,110,111,99,86,75,66,RKF=xmhg3f2e3dkrF73,69,U85,105,113,118,121,124,126,127,129,131,132,134,3*135,132,130,131,132,131,129,126,2*123,115,101,83,UCi11a"
  "36am2js>SPMRQP71,84,88,92,97,102,106,2*113,109,106,98,84,71,64,QGA~wskig2f3e5de=S84,99,108,114,119,122,124,126,127,128,129,130,2*131,2*130,129,126,127,129,130,127,124,121,118,105,89,66,zk11a"
  "40anDVWX[X[72,80,84,88,94,99,104,108,107,103,98,88,72,YMF>{wspmif5e6diH76,96,104,114,119,123,124,125,2*126,127,2*128,127,125,2*124,122,123,126,128,125,121,118,109,93,73,Fnc10a"
  "40ah|Q65,64,2Z64,69,74,79,83,90,96,100,2*104,100,97,90,76,ZJFB;2zvqjg3e10d>71,84,105,116,120,3*123,124,125,2*126,124,123,121,119,118,116,118,121,122,119,114,108,96,77,Mu11a"
  "41anAY[SPS[70,76,80,85,90,95,99,101,97,93,90,81,69,THD@:{vmjf3e11d=64,105,113,119,3*120,121,123,2*124,123,121,119,117,114,2*111,113,114,113,107,100,93,78,Mz11a"
  "41admGWRJHMV67,75,77,81,86,91,95,96,92,87,82,74,66,RHA<|unmh4e9delJ88,114,4*115,116,118,121,122,121,119,117,115,112,108,106,104,2*102,97,89,83,73,Lz11a"
  "42aguMTKEBGQ65,2*72,76,83,87,2*92,88,84,78,72,[PG?~xtzwgde11dg=80,73,108,107,2*105,106,111,116,2*120,117,114,112,108,106,101,97,93,89,83,74,69,65,Hu11a"
  "42a2eoLPGB@EQ65,2*68,72,78,83,88,91,87,82,75,68,WLC<wsryuhde11dfk;O86,97,98,93,101,109,115,119,117,112,109,106,103,99,93,87,80,73,WFQBw11a"
  "43agftZSKC|=R[65,66,69,74,80,89,90,84,79,73,67,VKB{uplhif3e9dcwpk;Y77,79,88,100,110,116,117,113,109,105,101,96,90,84,74,64,UEs<p11a"
  "44acdsCJEsj~NUY64,68,74,82,89,86,81,76,72,66,SG;|ulg2f4e9dlT@ad>P75,92,104,112,116,114,110,105,100,95,87,80,72,XA>wgl11a"
  "45aedhy>rel:IQW[68,77,84,88,84,79,77,73,ZM=ztni2f2ef10dcb3acuX86,102,111,116,114,110,105,99,93,85,76,67,W@iodc11a"
  "46ajfk2phdlv=MX64,72,81,87,89,84,82,78,70,VI}y2vo2fehm6d4cbaiace}85,94,107,2*116,111,105,99,92,82,71,ZREnb13a"
  "46alrhjfjbcdk;O76,68,78,87,94,93,89,84,80,69,VH=;@:ph2efh3d3c9a~V122,106,114,117,113,108,101,93,84,67,SG;q14a"
  "47alqfgkba2clDR65,75,91,97,101,98,93,89,82,72,YL2DC=yo3dcd2cb10abx86,112,98,104,106,110,104,96,87,74,UCsg14a"
  "48agqdih3ahk~O79,83,94,106,109,107,99,93,88,77,65,QMHID;lgdcb14aeR91,92,73,86,100,106,98,87,75,Q>qd14a"
  "49anlbhb2a2ok:T76,87,100,2*115,109,103,99,93,80,67,UF=u}><f16acp76,122,92,RL67,93,88,67,S|im14a"
  "57adlvBS70,84,99,116,113,110,107,106,95,83,71,Lrlfm}ob15aDr[101,108,81,Vm;N[Cpf15a"
  "58ajigw>S72,85,102,100,101,107,104,95,87,71,A4fnc17aES85,73,KCAenok16a"
  "59abjeho~O67,79,75,89,90,86,77,69,Rvhd21a68,101,91,68,Ilc19a"
  "61a2kqfhx;L65,TUV@F{eh21avM64,2@s20a"
  "63alfjefgwy2?ujidc23aB23a"
  "65afv2clfo2gb2c48a"
  "66aBo2agb2af50a"
  "67ad57a"
  "125a"
  "125a"
  "125a"
  "125a"
  "125a"
  "125a"
  "125a"
  "125a"
  "125a"
  "125a"
  "125a"
  "125a"
  "125a"
  "125a"
  "125a"
  "125a"
  "125a"
  "125a"
  "125a"
  "125a"
  ))
(area (features (
   ( 1 "continent" "Antarctica")
   ( 2 "land" "American Highland")
   ( 3 "land" "Ellsworth Land")
   ( 4 "land" "Enderby Land")
   ( 5 "land" "Graham Land")
   ( 6 "land" "Marie Byrd Land")
   ( 7 "land" "New Schwabenland")
   ( 8 "land" "Palmer Land")
   ( 9 "land" "Queen Maud Land")
   ( 10 "land" "Victoria Land")
   ( 11 "land" "Wilkes Land")
   ( 12 "island" "Alexander Island")
   ( 13 "island" "Balleny Island")
   ( 14 "island" "Berkner Island")
   ( 15 "island" "Scott Island")
   ( 16 "island" "Siple Island")
   ( 17 "island" "Roosevelt Island")
   ( 18 "island" "Ross Island")
   ( 19 "island" "Thurston Island")
   ( 20 "ice shelf" "Amary Ice Shelf")
   ( 21 "ice shelf" "Filenner Ice Shelf")
   ( 22 "ice shelf" "Fimbul Ice Shelf")
   ( 23 "ice shelf" "Getz Ice Shelf")
   ( 24 "ice shelf" "Larsen Ice Shelf")
   ( 25 "ice shelf" "Riiser-Larsen Ice Shelf")
   ( 26 "ice shelf" "Ronne Ice Shelf")
   ( 27 "ice shelf" "Ross Ice Shelf")
   ( 28 "ice shelf" "Shackleton Ice Shelf")
   ( 29 "ice shelf" "West Ice Shelf")
   ( 30 "ocean" "Atlantic Ocean")
   ( 31 "ocean" "Indian Ocean")
   ( 32 "ocean" "Pacific Ocean")
   ( 33 "sea" "Amundsen Sea")
   ( 34 "sea" "Bellingshausen Sea")
   ( 35 "sea" "Davis Sea")
   ( 36 "sea" "Ross Sea")
   ( 37 "sea" "Weddell Sea")
   ( 38 "sound" "McMurdo Sound")
   ( 39 "feature" "South Pole")
   ( 40 "lake" "Lake Vostok")
  )
  "24:46;55a"
  "24:47;54a"
  "25:47;53a"
  "26:47;52a"
  "26:48;51a"
  "27:26;2e20;50a"
  "28:22;e;6e18;49a"
  "28:13;w6;11e18;48a"
  "29:10;4w3;14e16;2?47a"
  "29:10;5w2;15e14;4?46a"
  "30:8;4wjw2j15e13;6?45a"
  "29:14w4j15e12;7?44a"
  "29:12w7j16e9;9?43a"
  "27:13w10j16e7;10?42a"
  "26:6w19j16e5;12?41a"
  "24:6w22j17e3;13?40a"
  "22:7w24j17e;15?39a"
  "23:5w27j16e16?38a"
  "23:4w29j14eu17?37a"
  "22:5w30j13e2u17?36a"
  "22:6w31j11e3u17?35a"
  "21:5w3h31j10e4u17?34a"
  "22:3w6h31j7e5u18?33a"
  "22:z2w7h32j4e9u2c2?2~10?32a"
  "22:2z8h36j2u10c3~11?31a"
  "19:4A2z8h35j13c5~9?30a"
  "18:5A3z8h34j15c4~9?29a"
  "16:7A4z7h33j2b15c4~9?28a"
  "14:10A3z8h32j3b16c2~10?27a"
  "14:10A3z8h32j3b19c10?26a"
  "13:11A5z6h31j5b19c?c8?25a"
  "12:13A4z7h30j6b19c10?24a"
  "12:14A4z5h31j7b19c?2}7?23a"
  "11:16A4z3h31j9b18c4}7?22a"
  "11:15A5z5b29j9b19c3}8?21a"
  "10:17A5z6b26j11b19c3}8?20a"
  "10:18A4z9b22j13b18c4}8?19a"
  "9:20A3z12b18j16b17c4}8?18a"
  "8:22A2z16b11j20b18c2}8?;17a"
  "8:23Az50b16c2}6?3;16a"
  "7:25A55b9c3b}6?4;15a"
  "7:26A67b4?7;14a"
  "6:27A68b11;13a"
  "6:28A67b12;12a"
  "5:30A67b12;11a"
  "5:31A3b2v61b13;10a"
  "5:31A5v63b12;9a"
  "3<2:31A6v40bD22b12;8a"
  "4<f30A{7v38b2D23b12;7a"
  "4<2f28A3{5ov38bD24b13;6a"
  "5<f2A2y24A4{5o2v61b14;5a"
  "6<fA3y22A6{4o2v61b15;4a"
  "7<fA4y20A9{o2v61b16;3a"
  "7<2fAfyfy19A10{3v60b17;2a"
  "7<>2fA2f2y18A12{2v60b17;a"
  "7<2>2fA2f6y5A8y14{2v2g11bC34b4l6b18;"
  "a7<2>5f12y5i3d13{v4g42b13l4<13;"
  "2a6<3>6f7y8i5d10{7g39b16l8<8;"
  "3a6<3>f>5f5y9i5d9{9g35b18l12<4;"
  "4a5<6>6f3y9i6d8{11g33b19l15<"
  "5a5<8>6f9i7d8{11g31b21l14<"
  "6a5<7>7f7i2m7d5{15g28b22l14<"
  "7a4<10>4f>6i3m7d2g2{16g26b24l13<"
  "8a4<10>3f>4i6m6d21g25b23l14<"
  "9a4<13>3i8m4d24g23b24l13<"
  "10a3<14>2i9m3d25g21b26l12<"
  "11a3<16>9m29g2|17b26l12<"
  "12a3<15>4m2>3m29g4|b4|10b27l11<"
  "13a3<20>3m30g12|6b27l11<"
  "14a2<24>30g13|3b29l10<"
  "15a2<23>31g14|b28l11<"
  "16a2<23>30g15|28l11<"
  "17a2<22>31g15|27l11<"
  "18a2<22>31g14|27l11<"
  "19a2<21>32g15|25l11<"
  "20a2<21>31g14|s2|23l11<"
  "21a2<21>28g16|3sB22l11<"
  "22a2<21>28g4|r12|3B21l11<"
  "23a2<21>7g2x20g2|2r11|3B19l13<"
  "24a2<20>7g3x20g2|2r6|5@4B16l14<"
  "25a2<20>6g=3x20g8|7@3B16l14<"
  "26a3<19>5g3=2x20g4|11@3B15l14<"
  "27a3<18>=5g2=3x20g|13@3B15l14<"
  "28a3<17>9=3x19g2|13@2B14l15<"
  "29a4<15>10=4x18g|14@3B11l16<"
  "30a4<14>11=5x14g18@3B7l19<"
  "31a4<13>13=5x12g19@2B6l20<"
  "32a6<10>15=6xgx2g3x2g21@2Bl23<"
  "33a6<9>17=12x25@23<"
  "34a7<7>18=2x2=2x2=x2=25@23<"
  "35a8<5>19=x10=24@23<"
  "36a10<2>31=22@24<"
  "37a11<32=20@25<"
  "38a11<32=16@28<"
  "39a11<32=13@30<"
  "40a10<33=5@37<"
  "41a10<33=@40<"
  "42a10<33=40<"
  "43a10<31=41<"
  "44a10<30=41<"
  "45a10<27=43<"
  "46a11<25=43<"
  "47a11<23=44<"
  "48a14<18=45<"
  "49a20<11=45<"
  "50a75<"
  "51a74<"
  "52a73<"
  "53a72<"
  "54a71<"
  "55a70<"
  ))
