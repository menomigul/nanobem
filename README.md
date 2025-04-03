# NANOBEM

This repository contains the **NANOBEM25 MATLAB toolbox** as provided in the supplementary information of the publication:

> *U. Hohenester, ACS Photonics 2015, 2, 7, 1023–1030. DOI: [10.1021/acsphotonics.5c00254](https://doi.org/10.1021/acsphotonics.5c00254)*

---

## 📦 About

The NANOBEM25 toolbox provides a MATLAB-based implementation of the **boundary element method (BEM)** tailored for simulating optical properties of nanostructures.

In addition to core BEM functionality, this toolbox includes several **add-ons** developed for:

- **Optical tweezers simulation** — based on extensions described in  
  [ACS Photonics 2015, 2, 1023–1030](https://pubs.acs.org/doi/10.1021/acsphotonics.5c00254)

- **Optofluidic force induction (of2i)** modeling — covering the underlying physics as detailed in  
  [Phys. Rev. Applied 19, 034041 (2023)](https://doi.org/10.1103/PhysRevApplied.19.034041)

- **Interference microscopy** - extending the capabilities of the toolbox to microscopy and imaging-related tasks often encountered in nanosensing as reported in
  [ACS Photonics 2024, 11, 2745-2756](https://pubs.acs.org/doi/10.1021/acsphotonics.4c00621)


These enhancements make the toolbox suitable not only for nanoplasmonics research, but also for **optical trapping** and **particle characterization** in photonic experiments. 

---

## 📂 Getting Started

To use the NANOBEM toolbox, you must add at the beginning of each session
the main directory and all subdirectories to the Matlab path, e.g. by calling

  > addpath(genpath(NANOBEMDIR) );

Here, NANOBEMDIR is the *full* directory name of the toolbox.  

# Help pages

To set up the NANOBEM help pages, you must install them once.  
To this end, you must

  (1)  change in Matlab to the main directory of the NANOBEM toolbox, and
  (2)  run the file makehelp.
  
A detailed help of the Toolbox and a number of demo files are then 
available in the Matlab help pages which can be found on the start page 
of the help browser under Supplemental Software.

---

## 📖 Citation

If you use this toolbox in your work, please cite all of the above-mentioned papers.

---

## 📝 Copyright and License

Copyright (C) 2022-2025 Ulrich Hohenester.
This code is distributed under the terms of the **GNU General Public License**.
See the file COPYING for license details. 

NANOBEM is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version
    NANOBEM is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details
    You should have received a copy of the GNU General Public License
along with NANOBEM; if not, write to the Free Software
Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 U
