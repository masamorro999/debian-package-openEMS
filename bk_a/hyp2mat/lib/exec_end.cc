/*
 * hyp2mat - convert hyperlynx files to matlab scripts
 * Copyright 2012 Koen De Vleeschauwer.
 *
 * This file is part of hyp2mat.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <iostream>
#include "hypfile.h"

using namespace std;
using namespace HypFile;

/*
 * Hyperlynx 'END' record. 
 * Marks end of board description.
 */

bool HypFile::Hyp::exec_end(parse_param& h)
{
  if (trace_hyp) cerr << "end" << endl;

  /* Optionally flood layers with copper */
  flood_layers_with_copper();

  return false;
}

/*
 * Hyperlynx 'KEY' record. 
 */

bool HypFile::Hyp::exec_key(parse_param& h)
{
  if (trace_hyp) cerr << "key: key = " << h.key << endl;

  return false;
}

/* not truncated */
