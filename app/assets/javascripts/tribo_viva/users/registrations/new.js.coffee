TriboViva.Users ?= {}
TriboViva.Users.Registrations ?= {}
TriboViva.Users.Registrations.New =
  init: ->

  modules: -> [TriboViva.CPFMask, TriboViva.PhoneMask]
