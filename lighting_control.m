%creating fuzzy inference system for a lightning control
clear all
clc
fis=mamfis("Name","Lighting_control");
%% 
%input variables environmental light, and rate of change of environmental
%light
fis = addInput(fis,[120 220],"Name","env_light");
fis = addInput(fis,[-10 10],"Name","rate_of_change");
%% 
%first input variable membership functions
fis = addMF(fis,"env_light","trapmf",[0 120 130 150 ],"Name","dark");
fis = addMF(fis,"env_light","trapmf",[130 150 190 210],"Name","medium");
fis = addMF(fis,"env_light","trapmf",[ 190 210 220 220 ],"Name","light");
%% 
%second input variable memebership functions
fis = addMF(fis,"rate_of_change","trimf",[-20 -10 0],"Name","negative_small");
fis = addMF(fis,"rate_of_change","trimf",[-10 0 10],"Name","zero");
fis = addMF(fis,"rate_of_change","trimf",[0 10 20],"Name","positive_small");
%% 
%output variable dimmer and memebership functions
fis = addOutput(fis,[0 10],"Name","dimmer");
fis = addMF(fis,"dimmer","trapmf",[0 0 2 4],"Name","very_small");
fis = addMF(fis,"dimmer","trimf",[2 4 6],"Name","small");
fis = addMF(fis,"dimmer","trimf",[4 6 8],"Name","big");
fis = addMF(fis,"dimmer","trapmf",[6 8 10 10],"Name","very_big");
%% 
%plotting the input and output memebership functions
f1=figure;
plotmf(fis,'input',1);
f2=figure;
plotmf(fis,'input',2);
f3=figure;
plotmf(fis,'output',1);
%%
%adding the rule-base for the light control system
rule1 = "env_light==dark & rate_of_change==positive_small =>dimmer=big";
rule2 = "env_light==dark & rate_of_change==zero =>dimmer=big";
rule3 = "env_light==dark & rate_of_change==negative_small =>dimmer=very_big";
rule4 = "env_light==medium & rate_of_change==positive_small =>dimmer=small";
rule5 = "env_light==medium & rate_of_change==zero =>dimmer=big";
rule6 = "env_light==medium & rate_of_change==negative_small =>dimmer=big";
rule7 = "env_light==light & rate_of_change==positive_small =>dimmer=very_small";
rule8 = "env_light==light & rate_of_change==zero =>dimmer=small";
rule9 = "env_light==light & rate_of_change==negative_small =>dimmer=big";
ruleList=[rule1 rule2 rule3 rule4 rule5 rule6 rule7 rule8 rule9];
fis = addRule(fis,ruleList);
%%
%control surface plot of the controller
gensurf(fis);

%%
%architecture of the controller
plotfis(fis);
%%
%evaluating the controller by giving crisp input values
evalfis(fis,[150 10])
