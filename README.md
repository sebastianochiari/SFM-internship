# SFM-internship
Pre-degree internship @UNITN on Computer Vision > Social Force Model

Here's the Matlab code to compute the regression parameters through SFM.

### DATASETS CHEATSHEET
`real_video_trajectory/`

| Row           | Content       |
| ------------- | ------------- |
| 1             | frame         |
| 2             | pedestrian ID |
| 3             | X             |
| 4             | Y             |
| 5             | group         |

`crowded_real_video_trajectory/`

first 5 rows as `real_video_trajectory/` ones
| Row           | Content                       |
| ------------- | -------------                 |
| 6             | crowdness with `radius = 1`   |
| 7             | crowdness with `radius = 2`   |
| 8             | crowdness with `radius = 5`   |


### WORKFLOW
1. Run `multi_person.m` or `multi_person_heter.m` to compute all SFM parameters
2. Set the parameters in the Unity simulator, with input start_end (the start time and position, the end time and position of each pedestrian) and we can run the simulation.

### YUE CHEATSHEET
* `multi_person.m` regress parameters (all) from trajectory.
* `multi_person_heter.m` regress several parameters (a set) from trajectory

The parameters are contained in the matrices ThetaX. ThetaX1 contains parameters unrelevant with groups, while ThetaX2 contains group parameters (attraction and vision force). The order of the parameters are v_des, f_1, f_2, f_3, f_vis, f_att.

* `param_deal.m` deal with SFM parameters and store them
* `get_start_end.m` get the timestamp and the position of start and end

### UNITY SIMULATOR
The simulator we use (which is not included into this repository) works on **Unity v. 2017.3.0f2**. On my MacBook, I run **Unity v. 2017.3.1f1** and everything works fine. The simulator is not compatible with updated Unity versions.