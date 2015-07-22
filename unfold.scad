$fn = 48;

rotate(a = 90) {
	polyhedron(points = [[-12.0444694219, -1.5298513995, 15.8930891847], [7.3471263876, -9.6658914803, 15.8930891529], [4.6973455988, 11.1957423909, 15.8930896472], [24.0889407089, 3.0597027289, 15.8930893951], [4.6973455095, 11.1957423795, 15.8930893886], [7.3471264769, -9.6658914689, 15.8930894116], [26.7387216808, -17.8019309007, 15.8930894034], [24.0889407108, 3.0597027264, 15.8930894034], [7.3471264750, -9.6658914664, 15.8930894034], [9.9969078812, -30.5275261078, 15.8930899995], [26.7387216525, -17.8019309681, 15.8930892120], [7.3471265033, -9.6658913991, 15.8930895947], [9.9969079400, -30.5275261003, 15.8930897497], [7.3471264445, -9.6658914065, 15.8930898444], [-9.3946880255, -22.3914870503, 15.8930899827], [43.4805361946, -5.0763371665, 15.8930889313], [24.0889407817, 3.0597027354, 15.8930892163], [26.7387216099, -17.8019309097, 15.8930895904], [21.4391600739, 23.9213369212, 15.8930897442], [4.6973455708, 11.1957425256, 15.8930889805], [24.0889406476, 3.0597025829, 15.8930898033], [2.0475656816, 32.0573776999, 15.8930893741], [4.6973454481, 11.1957426870, 15.8930892135], [21.4391601965, 23.9213367599, 15.8930895112], [2.0475657499, 32.0573777085, 15.8930893937], [-14.6942490590, 19.3317842603, 15.8930891673], [4.6973453798, 11.1957426783, 15.8930891939], [18.7893806917, 44.7829715524, 15.8930894315], [2.0475657499, 32.0573778627, 15.8930890489], [21.4391601282, 23.9213365971, 15.8930898363], [18.7893807359, 44.7829714942, 15.8930892402], [-0.6022138554, 52.9190117270, 15.8930892402], [2.0475657057, 32.0573779208, 15.8930892402], [16.1396007989, 65.6446056440, 15.8930893107], [-0.6022139310, 52.9190115469, 15.8930897515], [18.7893808115, 44.7829716743, 15.8930887290], [16.1396006408, 65.6446056239, 15.8930891460], [18.7893809695, 44.7829716943, 15.8930888936], [35.5311960988, 57.5085664708, 15.8930885340], [16.1396006808, 65.6446057994, 15.8930892406], [-3.2519944021, 73.7806457280, 15.8930901538], [-0.6022138129, 52.9190113916, 15.8930898216], [16.1396007702, 65.6446060126, 15.8930895484], [13.4898191742, 86.5062407931, 15.8930897090], [-3.2519944916, 73.7806455147, 15.8930898461], [16.1396009091, 65.6446060302, 15.8930893425], [32.8814142546, 78.3702020245, 15.8930891045], [13.4898190353, 86.5062407755, 15.8930899149], [-0.6022137758, 52.9190113963, 15.8930902518], [-3.2519944393, 73.7806457232, 15.8930897235], [-19.9938093049, 61.0550510214, 15.8930901692], [-0.6022139263, 52.9190117180, 15.8930890532], [-17.3440290403, 40.1934176401, 15.8930887682], [2.0475657765, 32.0573779299, 15.8930894273], [18.7893808069, 44.7829715670, 15.8930895324], [21.4391600131, 23.9213365824, 15.8930897355], [38.1809759438, 36.6469298830, 15.8930895802], [40.8307556124, 15.7852968630, 15.8930896744], [21.4391600697, 23.9213369207, 15.8930898142], [24.0889406517, 3.0597025834, 15.8930897333]], triangles = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [9, 10, 11], [12, 13, 14], [15, 16, 17], [18, 19, 20], [21, 22, 23], [24, 25, 26], [27, 28, 29], [30, 31, 32], [33, 34, 35], [36, 37, 38], [39, 40, 41], [42, 43, 44], [45, 46, 47], [48, 49, 50], [51, 52, 53], [54, 55, 56], [57, 58, 59]]);
}
/***********************************************
******      SolidPython code:      *************
************************************************
 
#! /usr/bin/env python
# -*- coding: UTF-8 -*-
from __future__ import division
import os
import sys
import re
import tree
from numpy import array,cross
from tree import TriangleNode,traverse,traverse_for_vertices,unfold
from stl_reader import Reader
from graph2 import Graph
from utilities import getMatrixArbitraryAxis

# Assumes SolidPython is in site-packages or elsewhwere in sys.path
from solid import *
from solid.utils import *

SEGMENTS = 48

triangles = Reader.read("stl/icosahedron.stl")
g = Graph(triangles)
msp = g.toMSPTree()
tn = traverse(msp,set())
tn.root = True
#v = traverse_for_vertices(tn)
#print reduce(lambda x,y: x+y, v)
unfold(tn)
up = array([0,0,1])
axis = tree.unitVector(cross(up, tn.normal))
m = getMatrixArbitraryAxis(axis, tree.angleBetween(up,tn.normal))
tn.unfold(m)
v = traverse_for_vertices(tn)
vertices = reduce(lambda x,y: x+y, v)
#print vertices
vertices = [y[:3] for y in vertices ]
#print vertices
def assembly():
    a = polyhedron(
            points=vertices,
            triangles=[[x for x in range(y,y+3)] for y in range(0,len(vertices),3)])
    return rotate(90)(a)

if __name__ == '__main__':
    a = assembly()
    scad_render_to_file(a,'unfold.scad', file_header='$fn = %s;' % SEGMENTS, include_orig_code=True)
 
 
***********************************************/
                            
