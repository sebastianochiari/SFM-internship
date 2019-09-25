# SFM-internship
Pre-degree internship @UNITN on Computer Vision > Social Force Model

Here the Matlab code to compute the regression parameters through SFM.

### YUE CHEATSHEET
* `multi_person.m` regress parameters (all) from trajectory.
* `multi_person_heter.m` regress several parameters (a set) from trajectory

The parameters are contained in the matrices ThetaX. ThetaX1 contains parameters unrelevant with groups, while ThetaX2 contains group parameters (attraction and vision force). The order of the parameters are v_des, f_1, f_2, f_3, f_vis, f_att.

* `param_deal.m` deal with SFM parameters and store them
* `get_start_end.m` get the timestamp and the position of start and end

For the simulation, set the parameters in the Unity simulator, with input start_end (the start time and position, the end time and position of each pedestrian) and we can run the simulation.