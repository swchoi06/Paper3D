$fn = 48;

polyhedron(points = [[-209.6627341125, -403.4339045920, 95.2417408827], [-178.4248530781, -386.0241189832, 95.2417407217], [-232.2128535210, -347.8298231951, 95.2417409080], [-172.3742590702, -415.3313283596, 95.2417421101], [-178.4248530562, -386.0241190225, 95.2417407585], [-209.6627341344, -403.4339045527, 95.2417408459], [-178.4248529701, -386.0241190047, 95.2417414223], [-172.3742591563, -415.3313283774, 95.2417414463], [-115.3795959416, -364.7253253037, 95.2417414257], [-268.9695701568, -374.6395431426, 95.2417406705], [-209.6627339464, -403.4339045246, 95.2417405497], [-232.2128536870, -347.8298232624, 95.2417412409]], triangles = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [9, 10, 11]]);
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

triangles = Reader.read("stl/rhino-quarter.stl")
g = Graph(triangles)
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
    #scad_render_to_file(a,'unfold.scad', file_header='$fn = %s;' % SEGMENTS, include_orig_code=True)
    #d = DXFWriter(v2d) 
    #d.generate_file()
 
 
***********************************************/
                            
