# Understanding Spatial Perception in Pictured Scenes 

OSF Pre-Registration: https://osf.io/28vjd

## Project Goal
Visual distance perception uses multiple sources of information to support diverse behavioral abilities including localizing objects in an environment. Based on prior work in this field, we hypothesize that human visual distance perception in pictured scenes optimally integrates visual distance cues with temporal processing differences. To that end, we aim to answer core questions about the evolution of spatial perception in natural scene images. We will use two matched tasks focusing on depth perception (discrimination, verbal report) and quantify their shared variance across a large set of images, establishing the stimulus-driven perceptual signal. We test several specific hypotheses: First, we expect that verbal reports will systematically and reliably vary across images even when the general effect of actual depth is removed. Second, these verbal reports, when subjected to a signal detection analysis, will predict performance on the matched discrimination task performed by a different group of participants on the same stimuli. The design is such that only the stimuli are common across these tasks, making the joint variance across them indicative of stimulus-driven signals. With longer stimulus durations we expect performance within each task and the relationship between tasks to strengthen. Measuring sensitivity to distance information using results from two independent paradigms will help clarify the temporal characteristics of visual scene understanding in pictures and have important implications for theories of picture and scene perception.

## Experiments
Verbal Judgment: We will present images with targets at variable distances from the SUN RGB-D database and have participants make egocentric distance estimations. Workers from Amazon’s Mechanical Turk will judge distances to a circular target with high color contrast (red and green) placed in the vertical midline of the image in either feet or meters. The target will appear in the center of the screen for each trial. Image location is adjusted accordingly such that target distance varies but target location on the screen does not. Responses will be collected in the form of typed numbers in the participants preferred units (ft, m). Response times will also be collected.

Discrimination: We will  present images with targets at variable distances from the SUN RGB-D database and have participants make distance discriminations. Specifically, workers from Amazon’s Mechanical Turk will view two different images sequentially that have high color contrast (red, green) circular targets placed in the center of the screen. Image location is adjusted accordingly such that target distance varies but target location on the screen does not. Participants must report which image’s target was closer to them if they were to imagine themselves in the scene.  Responses are collected via keypress, yielding accuracy and response times. 

## What does this repository contain?

The folder for each experiment (verbal judgement, discrimination) contains the following:
1. Analysis  
2. Counterbalancing 
3. Mechanical Turk Frontend Code

The verbal judgement folder additionally contains 'stimuli_prep', which includes scripts for the process of creating our stimuli. We emply a novel deisgn for spatial judgements using SUN RGB-D Images (https://rgbd.cs.princeton.edu/). Ground truth depth data from a kinect v2 sensor is used to place targets in the vertical midline of the image. Targets are selected such that there is an even distribution across the range of available depths (1 meter - 5 meters)

### Analysis 
Scripts for data analysis. 

### Counterbalancing
A main goal of this project is to understand how stimulus-driven cues impact spatial perception in verbal judgement and discrimination with temporal processing differences. Therefore, it is critical for stimulus order, hysteresis effects, and duration to be carefully balanced. Individual participants within any task and duration condition see a unique stimulus order. These orders are determined by a latin square and equated across the two tasks. See our OSF Pre-Registration for a more detailed explanation (https://osf.io/28vjd).

### MTurk Code
The data will be collected online through Amazon's Mechanical Turk so this folder contains basic web development files. An Apache server was used to run the experiment, and needs to be configured to allow for CORS in order for the web content to load.

- The main files for running the experiment are DepthDuration_CSS.css, DepthDuration_JS.js, and DepthDuration_HTML.html 
- The data is logged and saved as a CSV on the server in saveFile.php
- Participants receive an unique completion code via revealCode.html 
- depthDuration_source.html is adapted source code provided by Amazon Mechanical Turk for providing instructions and setting the survey link 
- depth_duration_variables.csv contains the variables that are needed for depthDuration_source.html (e.g. survey link). This method allows experimenters to publish a batch of multiple HITs (Human Intelligence Task) on Mechanical Turk

In order to maximize image variability across participants, unique trial sequences were made using SUN-RGBD images. All images in the dataset were taken with Kinectv2 sensors, so the “ground truth” distance of the targets was extracted from the depth array for each image in the SUN-RGBD dataset. The following files allow for a balanced design in terms of images, duration, and range of target distances. 
- The folder 'jsons' contains the unique trial structures for a particular duration - one for each participant. Each json file contains the duration, image path, and masking image path for each trial, for a total of 192 trials.
- Participants were given a few practice trials to acclimate themselves to the experiment. The file practice_data.json reflects the trial structure for these trials.
- Image files: example.png (sample scene from SUN-RGBD) & fixation.jpg (standard fixation image) 
- counterbalancing.csv is a file that is referenced in DepthDuration_JS.js to select the correct trial sequence (JSON file) for a given HIT 

Note: Given the sheer size of the image dataset used, image files are not currently included. All images however are available at https://rgbd.cs.princeton.edu/.

# Citations:

S. Song, S. Lichtenberg, and J. Xiao.
SUN RGB-D: A RGB-D Scene Understanding Benchmark Suite
Proceedings of 28th IEEE Conference on Computer Vision and Pattern Recognition (CVPR2015)

# Contact:
If you are interested in learning more about our work or have any questions feel free to contact us! 

Prachi Mahableshwarkar: pmahable@gwu.edu, George Washington University


Dwight Kravitz: kravitzd@gwu.edu, George Washington University 

John Philbeck: philbeck@gwu.edu, George Washington University
