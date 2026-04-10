%% main.m
% Author: Abdelrhman Atta
% Date: 2026-04-10
% Brief: Master script for a Superheterodyne Receiver simulation. 
%        This script coordinates audio modulation, standard reception, 
%        and explores edge cases like image interference and frequency offsets.

clear; clc; close all;

% Initialize system settings and audio files
config;    

% Build the FDM signal by modulating multiple audio tracks
modulator; 

% Run the standard Superheterodyne receiver for all stations
receiver;

% Task 4: Demonstrate image interference by bypassing the RF filter
task_no_rf; 

% Task 5: Demonstrate the effect of Local Oscillator frequency errors
task_offset;