#-------------------------------------
# This script sets out to import and
# visualise TLOU Part II related
# audio files
#-------------------------------------

#-------------------------------------
# Author: Trent Henderson, 2 July 2020
#-------------------------------------

library(tidyverse)
library(tuneR)
library(jpeg)
library(gganimate)
library(Cairo)
library(jpeg)
library(ggpubr)

# Turn off scientific notation

options(scipen = 999)

# Create an output folder if none exists

if(!dir.exists('output')) dir.create('output')

#----------------DATA LOADS---------------

# Read in audio

filer <- "data/through_the_valley.wav"
d <- readWave(filer)

#----------------PRE PROCESSING-----------

# Extract mono component

leftside <- d@left

# Convert to dataframe for tidy processing and visualisation

left <- as.data.frame(leftside) %>%
  rename(amplitude = 1) %>%
  mutate(side = "Left") %>%
  mutate(samples = seq_along(amplitude))

#----------------DATA VISUALISATION-------

# Read in picture of Ellie

img <- readJPEG("data/ellie-solo.jpeg")

#-----------------
# FROM 6 TO 36
# SECONDS
#-----------------

# Calculate sample rate

the_max <- max(left$samples) # Highest sample number
the_duration <- 180 # Number of seconds of audio
smps_per_sec <- the_max / the_duration # Sample rate
frames_for_6_secs <- smps_per_sec * 6 # Samples for just first 6 seconds
frames_for_36_secs <- smps_per_sec * 36 # Samples for just first 36 seconds

left_short <- left %>%
  filter(samples >= frames_for_6_secs & samples <= frames_for_36_secs) %>%
  filter(row_number() %% 100 == 0) # Retain every 100th row as raw data is too large

# Integer version for animation

int_frames <- as.integer((frames_for_36_secs - frames_for_6_secs))
int_fps <- as.integer(smps_per_sec)

# Produce graphic

p <- left_short %>%
  ggplot(aes(x = samples, y = amplitude)) +
  background_image(img) +
  geom_line(colour = "#D4F1F4", alpha = 0.9) +
  theme_void() +
  transition_reveal(samples) +
  ease_aes('linear')

animate(p, duration = 30,
        width = 1000, height = 600)
