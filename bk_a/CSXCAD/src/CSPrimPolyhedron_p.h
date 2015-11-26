#ifndef CSPRIMPOLYHEDRON_P_H
#define CSPRIMPOLYHEDRON_P_H

#include <CGAL/Simple_cartesian.h>
#include <CGAL/Polyhedron_incremental_builder_3.h>
#include <CGAL/Polyhedron_3.h>
#include <CGAL/AABB_tree.h>
#include <CGAL/AABB_traits.h>
#include <CGAL/AABB_polyhedron_triangle_primitive.h>
#include <CGAL/AABB_polyhedron_segment_primitive.h>


typedef CGAL::Simple_cartesian<double>     Kernel;
typedef CGAL::Polyhedron_3<Kernel>         Polyhedron;
typedef Polyhedron::HalfedgeDS             HalfedgeDS;

class Polyhedron_Builder : public CGAL::Modifier_base<HalfedgeDS>
{
public:
	Polyhedron_Builder(CSPrimPolyhedron* polyhedron) {m_polyhedron=polyhedron;}
	void operator()(HalfedgeDS &hds);

protected:
	CSPrimPolyhedron* m_polyhedron;
};

typedef Kernel::Point_3                                             Point;
typedef CGAL::AABB_polyhedron_triangle_primitive<Kernel,Polyhedron> Primitive;
typedef CGAL::AABB_traits<Kernel, Primitive>                        Traits;
typedef CGAL::Simple_cartesian<double>::Ray_3                       Ray;
typedef Kernel::Segment_3                                           Segment;

struct CSPrimPolyhedronPrivate
{
	Polyhedron m_Polyhedron;
	Point m_RandPt;
	CGAL::AABB_tree<Traits> *m_PolyhedronTree;
};


#endif // CSPRIMPOLYHEDRON_P_H
