# Space-Time-Video-Regularity
Software for the paper "On the Space-Time Statistics of Motion Pictures" will be provided and updated here.

## Motion and space-time regularity
Software demos for motion estimation using space-time regularity are provided in the [motion_estimation_demo](/motion_estimation_demo) directory. The folder contains MATLAB scripts and functions. Two main scripts to start you off are:  
* example_scripts.m  
  - dfdfd
* generate_quiver_video.m  

	This script shows example of  how to search for certain object's motion vector based on statistical regularity and how to compute SDN coefficients (given in eq. 5 of the paper).
(1) example_scripts.m: This script shows example of  how to search for certain object's motion vector based on statistical regularity and how to compute SDN coefficients (given in eq. 5 of the paper).
(2) generate_quiver_video.m: This script image files with each frame and its block-wise motion quivers overlaid. For your information, the result images are already generated in the 'football_quiver_frames' folder.
