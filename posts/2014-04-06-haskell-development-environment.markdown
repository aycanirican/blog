---
title: Haskell Development Environment
description: Programming Haskell on OS X Mavericks using Emacs
tags: haskell, IDE, emacs
---

I thought that it's time to get advantage of new Emacs modes and
helpers for my Haskell Development Environment. After a quick google
search revealed that [Tim Dysinger's blog post] already covered how to setup
such an environment from scratch.

[Tim Dysinger's blog post]: http://tim.dysinger.net/posts/2014-02-18-haskell-with-emacs.html

# Notes for OS X Mavericks Users

- First, you have to install GHC using homebrew tool (otherwise you
  probably can't compile ghci-ng).

- One more thing you should pay attention is that Emacs doesn't set
  PATH automatically. You may prefere to set them:

```
(let ((home (getenv "HOME"))
      (my-path (concat "~/.cabal/bin:/usr/local/bin:" (getenv "PATH"))))
   (setq eshell-path-env my-path)
   (setq exec-path (append '("~/.cabal/bin" "/usr/local/bin") exec-path))
   (setenv "PATH" my-path))
```
