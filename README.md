noccur.el
=========

Run multi-occur on project/dired files

## What is this about?

`occur-mode` is one of the awesome modes that come builtin with Emacs.

Sometimes I just want to run `multi-occur` on all (or a subdirectory) of a project I'm working on. 
Used with keyboard macros it makes it a snap to perform modifications on many buffers at once.

## Installing

It's available on [melpa](http://melpa.milkbox.net/):

    M-x package-install noccur

## Contributors

- [Damien Cassou](http://damiencassou.seasidehosting.st)
- [thdox](https://github.com/thdox)

## Usage example

The way I use it is the following:

`M-x noccur-project RET foo RET` The occur buffer's content can then be edited with `occur-edit-mode` (bound to e). 
To save changes in all modified buffer and go back to occur-mode press `C-c C-c`.
