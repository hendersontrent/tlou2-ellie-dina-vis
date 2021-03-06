#-----------------------------------------
# This script sets out to merge audio
# and video files for the data vis
#
# NOTE: This script requires 
# visualiser_ellie_solo.R to have been run 
# first
#-----------------------------------------

#-------------------------------------
# Author: Trent Henderson, 2 July 2020
#-------------------------------------

#%%
from moviepy.editor import *
import os

# Load in video and audio

videoclip = VideoFileClip('/Users/trenthenderson/Documents/R/tlou2-ellie-dina-vis/data/ellie-solo-anim.mp4')
audioclip = AudioFileClip('/Users/trenthenderson/Documents/R/tlou2-ellie-dina-vis/data/through_the_valley_shorter.mp3')

# Combine into the same clip

new_audioclip = CompositeAudioClip([audioclip])
videoclip.audio = new_audioclip

# Export final mp4

videoclip.write_videofile("/Users/trenthenderson/Documents/R/tlou2-ellie-dina-vis/output/final-ellie-solo.mp4",
                            codec='libx264', audio_codec = 'aac', temp_audiofile = 'temp-audio.m4a', 
                            remove_temp = True)
