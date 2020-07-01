#-------------------------------------
# This script sets out to import and
# visualise TLOU Part II related
# audio files
#-------------------------------------

#-------------------------------------
# Author: Trent Henderson, 1 July 2020
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

filer <- "data/The Last of Us 2 - Ellie Take on Me Cover Song.wav"
d <- readWave(filer)

#----------------PRE PROCESSING-----------

# Extract each mono component

leftside <- d@left
rightside <- d@right

# Convert to dataframe for tidy processing and visualisation

left <- as.data.frame(leftside) %>%
  rename(amplitude = 1) %>%
  mutate(side = "Left") %>%
  mutate(samples = seq_along(amplitude))

right <- as.data.frame(rightside) %>%
  rename(amplitude = 1) %>%
  mutate(side = "Right") %>%
  mutate(samples = seq_along(amplitude))

merged <- bind_rows(left, right)

#----------------DATA VISUALISATION-------

# Read in picture of Ellie and Dina

img <- readJPEG("data/ellie-dina.jpeg")
img_crop <- readJPEG("data/rsz_ellie-dina.jpg")

#-----------------
# JUST THE FIRST
# 30 SECONDS
#-----------------

# Calculate sample rate

the_max <- max(merged$samples) # Highest sample number
the_duration <- 135 # Number of seconds of audio
smps_per_sec <- the_max / the_duration # Sample rate
frames_for_30_secs <- smps_per_sec * 30 # Samples for just first 30 seconds

left_short <- left %>%
  filter(samples <= frames_for_30_secs) %>%
  filter(row_number() %% 10 == 0) # Retain every 10th row as raw data is too large

# Integer version for animation

int_frames <- as.integer(frames_for_30_secs)
int_fps <- as.integer(smps_per_sec)

# Static chart

CairoPNG("output/ellie-dina-static.png", 600, 600)
p2 <- left_short %>%
  ggplot(aes(x = samples, y = amplitude)) +
  background_image(img_crop) +
  geom_line(colour = "#F9B8B1", alpha = 0.9) +
  theme_void()
print(p2)
dev.off()

#-----------------
# ANIMATED VERSION
#-----------------

# Produce graphic

p3 <- left_short %>%
  ggplot(aes(x = samples, y = amplitude, group = seq_along(samples))) +
  background_image(img_crop) +
  geom_line(colour = "#F9B8B1", alpha = 0.2) +
  labs(group = NULL) +
  theme(legend.position = "none") +
  theme_void() +
  transition_reveal(samples) +
  ease_aes('linear')

animate(p3, nframes = int_frames, fps = int_fps, duration = 30)
