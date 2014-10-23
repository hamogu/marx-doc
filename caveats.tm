#i jdweb.tm
#d pagename Caveats for MARX \marx-version

\h1{Use of the EDSER Subpixel Algorithm with SAOTrace/Chart Rays}
\p
  One of the \href{news.html}{new features} in \marx 5 is the ability
  to use the EDSER subpixel algorithm to randomize chip coordinates.
  This algorithm works by shifting the event position from the center
  of the pixel by an amount \em{(dx,dy)} that depends upon energy and
  flight grade. However, the values of \em{(dx,dy)} in the Chandra
  CALDB form a small discrete set, not a continuous one.  As a result,
  in the absence of dither the EDSER algorithm will produce a PSF that
  consists of a number of sharp peaks.  It is the dither motion of the
  telescope that smooths this peakiness out, and as such is an
  integral part of the EDSER algorithm.
\p
  As of January 2012 no publicly released versions of \saotrace
  generate dithered rays.  However, marx 5.0 has been tested with rays
  produced by development versions of \saotrace that do incorporate
  dither.  Until such rays and the corresponding aspect solution files
  are available, non-dithered \saotrace rays will require \marx2fits
  to be used with the \tt{--pixadj=RANDOMIZE} option to avoid the
  peakiness outlined above.

\h1{Spatial Dependence of the Quantum Efficiency}

#d mkarf \tt{mkarf}
#d mkinstmap \tt{mkinstmap}
#d ardlib \tt{ardlib}

\p
The current version of \marx does not incorporate the QE uniformity
maps and bad-pixel files that give rise to spatial variation in the
QE.  Consequently, exposure maps and ARFs created by default in \ciao
will be inconsistent with MARX simulations.  For simulated
observations on ACIS-S3, this difference should be small since spatial
variations in the QE are relatively small on this CCD. However,
simulated ACIS-I observations will be effected to a greater degree due
to the larger QE variations produced by CTI effects.

\p
For users of \ciao 2.3 and higher, the tools \mkarf and \mkinstmap
include the ability to turn off the QE uniformity maps through the use
of \ardlib qualifiers.  For example, a calling sequence like: 
#v+
unix%  mkarf detsubsys="ACIS-7;uniform;bpmask=0" ......
#v-

will produce an ARF on ACIS-7 (ACIS-S3) but with bad pixel processing
disabled (\tt{bpmask=0}) and without the effects of the CALDB
non-uniformity files included.  The resulting ARF will be consistent
with a \marx simulation.  A similar call to \mkinstmap can
be used in conjunction with \mkexpmap to create exposure maps
appropriate for \marx simulations.  This technique is illustrated on
the \href{examples/ciao.html}{examples page}.

Users are refered to the
\ciao documentation for more information on \mkarf
and \mkinstmap options.

\h1{ACIS Response Functions}

\ciao includes a couple of different tools for creating ACIS response
matrices (RMFs): \mkacisrmf and \mkrmf.  The \mkacisrmf tool is
designed for the analysis of CTI corrected data, whereas \mkrmf
creates an RMF for non-CTI corrected data.  The response algorithm
implemented in \marx is based upon the calibration data used by
\mkrmf.  Hence the PHAs generated by \marx for the ACIS detector
represent non-CTI corrected values and as such are consistent with the
responses generated by \mkrmf but not with \mkacisrmf.  Consequently,
users should continue to use the \ciao's \mkrmf to create RMFs that
are consistent with their \marx simulations.  More information about
using \mkrmf in the context of a \marx simulation may be found on the
\href{examples/ciao.html}{examples page}.
\p
Alternatively, \marxrsp may be used to apply \em{any} RMF to a \marx
simulation with the caveat that the mapping from photon energy to PHA
does not vary over the detector.

#% \h1{LETG+HRC Line Widths}

#% In standard Chandra pipeline processing, the motion of the observatory
#% over the course of an observation is computed and stored in the aspect
#% solution (ASOL) file.  The tool \marxasp replicates this behavior and
#% produces an aspect solution file for a given \marx simulation. A
#% number of factors contribute to the accuracy or inaccuracy of Chandra
#% aspect reconstructions. In \marxasp, these noise terms are represented
#% empirically using the \em{sigma} parameters in \tt{marxasp.par}. The
#% default values for these noise terms have been calibrated to be
#% consistent with HETG+ACIS observations and will give erroneously
#% narrow line widths when used with LETG+HRC simulations. Users wishing
#% to simulate LETG+HRC instrument combinations should adjust these
#% values before running \marxasp.  For example, a calling sequence of the
#% form:

#% #v+
#%   unix% marxasp RA_Sigma=0.34 Dec_Sigma=0.34 Roll_Sigma=0.34 ......
#% #v-

#% will produce an ASOL file consistent with current pipeline processing
#% for LETG+HRC datasets.

#% \h1{ISIS Pileup Fitting Kernel}

#% The default parameters for the pileup fitting kernel in \isis have been
#% calibrated for point source extractions. Specifically, the values
#% correspond to a circular extraction region 4 ACIS pixels in radius.
#% Although \marx can be used to include the effects of photon
#% pileup for any arbitrary spatial and spectral source model, the
#% \isis fitting kernel may need to be adjusted for larger extraction
#% regions. In particular, the \tt{psffrac} parameter represents the
#% fraction of the Chandra PSF contained within the extraction region and
#% may need to be increased for larger regions. Note, however, that for
#% real data, larger extraction regions will include a higher fraction of
#% unpiled background photons complicating the fitting of the piled
#% source spectrum.  As such, it is recommended that this value be
#% allowed to vary during the spectral fit.  See the \isis manual for
#% more discussion of the pileup fitting kernel.

#% \h1{Chandra Aimpoint Drift}

#% \marx does not currently take into account of temporal drift in 
#% Chandra's HRMA aimpoint. Fortunately the effect of the drift is 
#% generally negligible and should not be a concern for Chandra proposers. 

#i jdweb_end.tm
