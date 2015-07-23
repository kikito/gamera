gamera.lua
==========

A camera for [LÖVE](http://love2d.org).

Initial setup
-------------

The first thing one needs to do to use gamera is to define the world size. gamera expects it to be defined as a rectangular region with left, top, width and height:

    gamera.setWorld(0,0,2000,2000)

By default gamera will use the whole screen to display graphics. You can restrict the amount of screen used with `setWindowBoundaries`:

    gamera.setWindow(0,0,800,600)

Moving the camera around
------------------------

You can move the camera around by using `setPosition`:

    gamera.setPosition(100, 200)

`setPosition` takes into account the current window boundaries and world boundaries, and tries to keep the window inside the world as much as it can. This means that if you try to look at something very close to the left border of the world, for example, the camera will not "scroll" to show empty space.

You can also zoom in and zoom out. This is done using the `setScale` method.  It's got a single parameter, which is used for both x and y. The default scale is 1.0.

    gamera.setScale(2.0)

Take notice that gamera does not limit the amount of zoom out you can make; if you zoom "out" too much, you will end up seeing the world's edges.

Drawing
-------

The camera has one method called "draw". It takes one function as a parameter, like this:

    gamera.draw(function(l,t,w,h)
      -- draw camera stuff here
    end)

Anything drawn inside the function will be scaled, rotated, translated and cut so that it appears as it should in the screen window.

Notice that the function takes 4 optional parameters. These parameters represent the area that the camera "sees". They can be used to optimize the drawing, and not draw anything outside of those borders. Those borders are always axis-aligned. This means that when the camera is rotated, the area might include elements that are not strictly visible.


Querying the camera
-------------------

* `gamera.getWorld()` returns the l,t,w,h of the world
* `gamera.getWindow()` returns the l,t,w,h of the screen window
* `gamera.getVisible()` returns the l,t,w,h of what is currently visible in the world, taking into account rotation, scale and translation. It coincides with the parameters of the callback function in `gamera.draw`. It can contain more than what is necessary due to rotation.

* `gamera.getPosition()` returns the coordinates the camera is currently "looking at", after it has been corrected so that the world boundaries are not visible, if possible.
* `gamera.getScale()` returns the current scaleX and scaleY parameters
* `gamera.getAngle()` returns the current rotation angle, in radians

Coordinate transformations
--------------------------

* `gamera.toWorld(x,y)` transforms screen coordinates into world coordinates, taking into account the window, scale, rotation and translation. Useful for mouse interaction, for example.
* `gamera.toScreen(x,y)` makes the inverse transformation; given a point in the world, it says where it lies in the screen.


Installation
============

Just copy the gamera.lua file wherever you want it. Then require it where you need it:

    local gamera = require 'gamera'

Please make sure that you read the license, too (for your convenience it's included at the beginning of the gamera.lua file).

Specs
=====

This project uses [busted](http://olivinelabs.com/busted/) for its specs. If you want to run the specs, you will have to install it first. Then just execute the following from the root folder:

    busted
