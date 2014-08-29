Screenplay
==========

The purpose of this simple Ruby application is to set up scenario's which can be used for testing RESTful API's.

A developer may define scenarios which will be played sequentally. A scenario consists of a chain of actions.
Each action gets an input object, plays its role and returns an output object. These objects has the form of a hash or an array, or nil.
