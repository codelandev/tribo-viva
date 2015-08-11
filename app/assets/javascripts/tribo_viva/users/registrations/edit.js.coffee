TriboViva.Users ?= {}
TriboViva.Users.Registrations ?= {}
TriboViva.Users.Registrations.Edit =
  init: ->

  modules: -> [TriboViva.CPFMask, TriboViva.PhoneMask]
