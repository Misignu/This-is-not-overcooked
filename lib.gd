extends Node



"""
Does an screenshot
"""

# start screen capture
get_viewport().queue_screen_capture()
yield(get_tree(), "idle_frame")
yield(get_tree(), "idle_frame")

# get screen capture
var capture = get_viewport().get_screen_capture()
# save to a file
capture.save_png("user://screenshot.png")
