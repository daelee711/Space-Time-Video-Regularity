# Space-Time-Video-Regularity
Softwares for the paper "On the Space-Time Statistics of Motion Pictures" will be provided and updated here.

## Motion and space-time regularity
Software demos for motion estimation using space-time regularity are provided in the [motion_estimation_demo](/motion_estimation_demo) directory. The folder contains MATLAB scripts and functions. A sample video used for the scripts can be downloaded [here](https://utexas.box.com/shared/static/b21jy5y92oknewmcq0p0wqdgyv7qmbe6.yuv). Two main scripts to start you off are:  
* example_scripts.m  
  - Shows an example of  how to search for certain object's motion vector based on space-time regularity. 
  - Shows an example of how to compute SDN coefficients (eq. 5 of the [paper](https://arxiv.org/ftp/arxiv/papers/2101/2101.12516.pdf)) from a given displacement vector.   
* generate_quiver_video.m  
  - Generates image files with each frame and its block-wise motion quivers overlaid. An example images are pre-generated in the 'football_quiver_frames' folder.
  
## Citation
If you use this database in your research, we kindly ask you to reference our paper

>D. Lee, H. Ko, J. Kim, and A. C. Bovik, "On the Space-Time Statistics of Motion Pictures", Journal of the Optical Society of America A. 


### Contact
Please let me know if you have any inquiries or additional requests.   
Dae Yeol Lee, daelee711@utexas.edu