/*
*	Copyright (C) 2010-2013 Thorsten Liebig (Thorsten.Liebig@gmx.de)
*
*	This program is free software: you can redistribute it and/or modify
*	it under the terms of the GNU Lesser General Public License as published
*	by the Free Software Foundation, either version 3 of the License, or
*	(at your option) any later version.
*
*	This program is distributed in the hope that it will be useful,
*	but WITHOUT ANY WARRANTY; without even the implied warranty of
*	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*	GNU Lesser General Public License for more details.
*
*	You should have received a copy of the GNU Lesser General Public License
*	along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#ifndef VTKINTERACTORSTYLERUBBERBAND2DPLANE_H
#define VTKINTERACTORSTYLERUBBERBAND2DPLANE_H

#include "vtkInteractorStyleRubberBand2D.h"

class vtkInteractorStyleRubberBand2DPlane : public vtkInteractorStyleRubberBand2D
{
public:
	static vtkInteractorStyleRubberBand2DPlane *New();
	vtkTypeMacro(vtkInteractorStyleRubberBand2DPlane, vtkInteractorStyle);

	virtual void OnMouseMove();

protected:
	vtkInteractorStyleRubberBand2DPlane();
};

#endif // VTKINTERACTORSTYLERUBBERBAND2DPLANE_H
