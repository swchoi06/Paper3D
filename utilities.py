import numpy as np
from numpy import matrix, linalg, cross, dot, array
from math import cos, sin, pi

def getMatrixArbitraryAxis(axis, angle):
    x,y,z = axis[:3]
    c = cos(angle)
    s = sin(angle)
    t = 1 - c
    return matrix([
        [t*x*x + c,   t*x*y - s*z, t*x*z + s*y, 0],
        [t*x*y + s*z, t*y*y + c,   t*y*z - s*x, 0],
        [t*x*z - s*y, t*y*z + s*x, t*z*z + c,   0],
        [0,           0,           0,           1]])

def angleBetween(v1,v2):
    v1_u = unitVector(v1)
    v2_u = unitVector(v2)
    angle = np.arccos(np.dot(v1_u, v2_u))
    reference = unitVector((array([0,0,1]),v1_u))
    if np.isnan(angle):
        if (v1_u == v2_u).all():
            return 0.0
        else:
            return np.pi
    #if dot(v2_u,reference) < 0:
        #return -angle
    return -angle

def getTranslationMatrix(vector):
    return matrix([
            [1,0,0,vector[0]],
            [0,1,0,vector[1]],
            [0,0,1,vector[2]],
            [0,0,0,1]])

def columnCross(v1,v2):
    return cross(v1.T[0,0:3],v2.T[0,0:3]).T

def getNormal(vertices):
    edge1 = vertices[0] - vertices[1]
    edge2 = vertices[0] - vertices[2]
    v = cross(edge1[:3], edge2[:3])
    return np.append(unitVector(v),0)

def unitVector(vector):
    norm = np.linalg.norm(vector)
    if norm == 0:
        return vector
    return vector / norm

# check if p1 -> p2 intersects pA -> pB
def checkLineIntersection(point1, point2, pointA, pointB):
   assert((len(point1) == 2) and (len(pointA) == 2))
   a,b = point1
   c,d = point2
   p,q = pointA
   r,s = pointB
   det = float((c - a) * (q - s) - (p - r) * (d - b))
   if det == 0:
       return False
   l = round(((q - s) * (p - a) + (r - p) * (q - b)) / det,5)
   g = round(((b - d) * (p - a) + (c - a) * (q - b)) / det,5)
   return (0.0 < l and l < 1.0) and (0.0 < g and g < 1.0)

#print checkLineIntersection((0,0),(1,1),(0,1),(1,0))

def planeCheck(p1,p2,p3):
    return (p1[0] - p3[0]) * (p2[1] - p3[1]) - (p2[0] - p3[0]) * (p1[1] - p3[1])

def checkPointInTriangle(point, vertices):
    b1 = planeCheck(point, vertices[0], vertices[1]) < 0
    b2 = planeCheck(point, vertices[1], vertices[2]) < 0
    b3 = planeCheck(point, vertices[2], vertices[0]) < 0
    return b1 == b2 and b1 == b3

def checkTriangleIntersection(t1,t2):
    for i in range(3):
        for j in range(3):
            if checkLineIntersection(t1[i],t1[(i+1)%3],t2[j],t2[(j+1)%3]):
                return True
    t1 = [tuple(x) for x in t1]
    t2 = [tuple(x) for x in t2]
    s1 = set(t1)
    s2 = set(t2)
    _s1 = s1 - s2
    _s2 = s2 - s1
    if len(_s1) == 0: return False
    for v in _s1:
        if checkPointInTriangle(v,t2):
            return True
    for v in _s2:
        if checkPointInTriangle(v,t1):
            return True
    return False
    

def checkTriangleIntersections(t1, triangles):
    for t in triangles:
        if checkTriangleIntersection(t1,t): return True
    return False

def findIntersectingTriangles(node, triangles):
    out = [node] if checkTriangleIntersections(node.getTransformedVertices2D(), triangles) else []
    if len(node.children) == 0:
        return out
    else:
        for child, edge in node.children:
            out.extend(findIntersectingTriangles(child, triangles))
        return out

#assert(checkTriangleIntersection([(0,0),(1,0),(0,1)],[(0,0),(0.5,0),(0,0.5)]))
#assert(checkTriangleIntersection([(0,0),(1,0),(0,1)],[(0,0),(1,0),(0,1)]))
#assert(checkTriangleIntersection([(0,0),(1,0),(0,1)],[(0,0),(1,0),(0,0.5)]))
#assert(not checkTriangleIntersection([(0,0),(1,0),(0,1)],[(0,0),(-1,0),(0,-1)]))
#assert(not checkTriangleIntersection([(0,0),(1,0),(0,1)],[(-0.1,-0.1),(-1,0),(0,-1)]))
#assert(checkTriangleIntersection([(0,0),(1,0),(0,1)],[(0.1,0.1),(0.5,0.1),(0.1,0.5)]))
#assert(not checkTriangleIntersection([(0,0),(1,0),(0,1)],[(0,1),(1,0),(1,1)]))
#assert(not checkTriangleIntersection([(0,0),(1,0),(0,1)],[(0,0),(0,1),(-1,0)]))
#assert(not checkTriangleIntersection([[-12.04447, -1.52985], [7.34713, -9.66589], [4.69735, 11.19574]],[[26.73872, -17.80193], [24.08894, 3.0597], [7.34713, -9.66589]]))
