MATLAB knot theory functions
--------------------------------
Some functions used for calculating the alexander polynomial of a knot
given its DT (Dowker Thistlethwaite) code.

Function realiseDT.m is an implementation of the algorithm described by
Dowker and Thistlethwaite in ‘Classifying knot projections’ and is used
to determine information about handedness of each crossing.

Created as part of my third year project at university
--------------------------------

The functions can be used in MATLAB by passing a valid DT code to them in the usual MATLAB way eg

realise_DT([4 6 2])
