$fn = 48;

polyhedron(points = [[25.5677651926, 27.2769943729, 4.3911292586], [24.9342164904, 23.7183610546, 4.3911292753], [27.7238814775, 26.4310576249, 4.3911292918], [24.9342164900, 23.7183610546, 4.3911292671], [25.5677651930, 27.2769943728, 4.3911292669], [23.8998490594, 25.6329673191, 4.3911292725], [24.9342164717, 23.7183610447, 4.3911292463], [23.8998490777, 25.6329673290, 4.3911292933], [22.4272510601, 23.2006332231, 4.3911292116], [23.3362460808, 20.7201229200, 4.3911292232], [24.9342164680, 23.7183610624, 4.3911292412], [22.4272510637, 23.2006332054, 4.3911292168], [25.3672199324, 18.6315088532, 4.3911290804], [24.9342164588, 23.7183610674, 4.3911292561], [23.3362460901, 20.7201229150, 4.3911292083], [23.3362461025, 20.7201229271, 4.3911291344], [21.3465451938, 16.5499286944, 4.3911291496], [25.3672199200, 18.6315088412, 4.3911291543], [21.3465451993, 16.5499286839, 4.3911292122], [24.5840865646, 11.6709360935, 4.3911290509], [25.3672199145, 18.6315088517, 4.3911290918], [21.3465452310, 16.5499287050, 4.3911291841], [18.5804443031, 12.8524534665, 4.3911292160], [24.5840865329, 11.6709360725, 4.3911290789], [19.7874759703, 9.2581792599, 4.3911291289], [24.5840865308, 11.6709360622, 4.3911291586], [18.5804443051, 12.8524534768, 4.3911291364], [19.7874759702, 9.2581792600, 4.3911291592], [21.0795807495, 7.5939731750, 4.3911292427], [24.5840865309, 11.6709360621, 4.3911291284], [19.9212221848, 17.6077216928, 4.3911292118], [23.3362460847, 20.7201229214, 4.3911292306], [22.4272510599, 23.2006332040, 4.3911292094], [23.8998491182, 25.6329673044, 4.3911292661], [22.4079335325, 27.4382254763, 4.3911292787], [22.4272510195, 23.2006332476, 4.3911292388], [22.4272510267, 23.2006332477, 4.3911292569], [22.4079335253, 27.4382254762, 4.3911292606], [17.9959637473, 24.4939627757, 4.3911293013], [17.9959637545, 24.4939628004, 4.3911292880], [16.3564483760, 22.3602790358, 4.3911292527], [22.4272510194, 23.2006332229, 4.3911292703], [15.2384631259, 26.9071096459, 4.3911292794], [16.3564483772, 22.3602790349, 4.3911292640], [17.9959637534, 24.4939628013, 4.3911292766], [15.2384631255, 26.9071096458, 4.3911292577], [12.2993224866, 24.5653565817, 4.3911292497], [16.3564483776, 22.3602790350, 4.3911292858], [24.9342165022, 23.7183610423, 4.3911292626], [29.9821641557, 24.4811073597, 4.3911292746], [27.7238814656, 26.4310576371, 4.3911293046], [29.9821641537, 24.4811073574, 4.3911292942], [32.2461009559, 27.2128558090, 4.3911292033], [27.7238814676, 26.4310576394, 4.3911292850], [36.6188910184, 22.2413021536, 4.3911291889], [32.2461009640, 27.2128558023, 4.3911292630], [29.9821641456, 24.4811073641, 4.3911292345]], triangles = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [9, 10, 11], [12, 13, 14], [15, 16, 17], [18, 19, 20], [21, 22, 23], [24, 25, 26], [27, 28, 29], [30, 31, 32], [33, 34, 35], [36, 37, 38], [39, 40, 41], [42, 43, 44], [45, 46, 47], [48, 49, 50], [51, 52, 53], [54, 55, 56]]);
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
import utilities
from numpy import array,cross
from tree import TriangleNode, parseArrayIntoTree, parseEdgeArrayIntoTree, cutTreeIntoPatches
from stl_reader import Reader
from graph2 import Graph,TreeNode,treeLength
from utilities import getMatrixArbitraryAxis
from dxf_writer import DXFWriter
from evolution import TreeWorld

# Assumes SolidPython is in site-packages or elsewhwere in sys.path
from solid import *
from solid.utils import *

SEGMENTS = 48
filename = "kitten-122.stl"
triangles = Reader.read("stl/" + filename)
# triangles = Reader.read("stl/icosahedron.stl")
g = Graph(triangles)
n = len(g.nodes)
print "There are a total of ", n, " nodes"
hFn = lambda e: g.defaultHeuristic(e)
msp = g.toMSPTree(hFn)
edge_rep = msp.makeEdgeRepresentation()

hFn = lambda e: -g.defaultHeuristic(e)
msp2 = g.toMSPTree(hFn)
edge_rep2 = msp2.makeEdgeRepresentation()

world = TreeWorld(g, [edge_rep, edge_rep2])
child1 = world.generateFittest()
print child1
tn = parseEdgeArrayIntoTree(g.nodes, child1)
print treeLength(msp,set()), "faces"
#tn = parseArrayIntoTree(g.nodes, array_rep)
tn.unfold()
v = tn.getAllChildVertices()
v2d = tn.getAllChildVertices2D()


tn.getAllChildTriangles()
kdtree = utilities.makeKDTree(tn.getAllChildTriangles())

intersects = tn.checkIntersection() # return nodes thats intersect
print len(intersects), "faces that intersects"
paths = world.paths_intersection(child1)
cutEdges = g.cutEdges(paths)
print "Edges to cut:", cutEdges
tns = cutTreeIntoPatches(tn,cutEdges)
ds = [tn.convertToDict() for tn in tns]
print "No of Patches:", len(ds)



#v_i = [ x.getTransformedVertices2D() for x in intersects ]
#v = reduce(lambda x,y: x+y, v_i)

#print [x.node for x in xs]
#print len(xs)


#array_rep = [19, 55, 115, 49, -1, 147, 55, 194, 230, 180, 14, 82, 8, 198, 157, 197, 196, 81, 254, 240, 148, 120, 26, 46, 181, 123, 210, 223, 125, 143, 52, 21, 107, 16, 212, 250, 125, 73, 196, 27, 75, 249, 167, 39, 57, 103, 166, 23, 207, 15, 3, 240, 178, 191, 33, 181, 111, 29, 184, 177, 7, 92, 118, 59, 15, 93, 129, 58, 199, 94, 97, 98, 40, 61, 143, 64, 234, 251, 75, 91, 32, 78, 186, 133, 76, 134, 90, 4, 187, 218, 51, 49, 218, 182, 106, 43, 176, 138, 121, 63, 216, 151, 36, 10, 149, 146, 47, 226, 198, 133, 66, 104, 103, 46, 162, 10, 113, 251, 25, 83, 114, 62, 11, 5, 114, 206, 120, 38, 245, 185, 159, 110, 238, 1, 189, 226, 87, 154, 142, 160, 96, 54, 44, 5, 233, 68, 74, 12, 242, 253, 54, 208, 222, 211, 33, 93, 124, 155, 127, 215, 137, 127, 168, 13, 50, 173, 19, 152, 2, 24, 230, 6, 248, 115, 195, 153, 222, 232, 170, 148, 51, 173, 52, 254, 34, 253, 171, 84, 203, 205, 153, 135, 8, 197, 128, 60, 246, 141, 4, 9, 108, 3, 140, 144, 79, 117, 221, 100, 45, 158, 214, 20, 32, 22, 175, 111, 76, 18, 182, 175, 119, 85, 190, 139, 163, 99, 151, 234, 22, 63, 8, 144, 177, 144, 76, 237, 113, 193, 239, 238, 19, 162, 26, 244, 174, 140, 235, 225, 172, 41, 249, 117, 84, 77, 18, 239]
#print array_rep
#tn = parseArrayIntoTree(g.nodes, array_rep)
#tn.unfold()
#v = tn.getAllChildVertices()

def assembly(v):
    a = polyhedron(
            points=v,
            triangles=[[x for x in range(y,y+3)] for y in range(0,len(v),3)])
    return a

def intersecting():
    a = polygon(
            points=v2d,
            paths=[[x for x in range(y,y+3)] for y in range(0,len(v),3)])
    return a

if __name__ == '__main__':
    for i,tn in enumerate(tns):
        v = tn.getAllChildVertices()
        a = assembly(v)
        scad_render_to_file(a,'unfold{0}.scad'.format(i), file_header='$fn = %s;' % SEGMENTS, include_orig_code=True)

        #a = intersecting()
        scad_render_to_file(a,'unfold.scad', file_header='$fn = %s;' % SEGMENTS, include_orig_code=True)
    
    d_writer = DXFWriter(n, ds, filename)
    d_writer.generate_file()
 
 
***********************************************/
                            
