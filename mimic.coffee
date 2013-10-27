MutationObserver = window.MutationObserver or window.WebKitMutationObserver or window.MozMutationObserver

insertBefore = (referenceNode, newNode) ->
    referenceNode.parentNode.insertBefore newNode, referenceNode

insertAfter = (referenceNode, newNode) ->
    referenceNode.parentNode.insertBefore newNode, referenceNode.nextSibling

outerHTML = (node) ->
    outer = document.createElement 'div'
    outer.appendChild node
    outer.innerHTML

return unless MutationObserver?

defaults =
    placement: 'after' # after, before, `selector` (body, div.foobar, etc.)
    className: 'mimic-outer'

class Mimic

    constructor: (@options) ->
        @el = @options.el

        return @el.mimic if @el.mimic?

        @el.mimic = @

        for k, v of defaults
            if not @options[k]?
                @options[k] = v

        @insert()
        @render()
        @mimic()

        @

    insert: ->
        @mimicEl = document.createElement 'div'
        @mimicEl.className = @options.className

        if @options.placement is 'after'
            insertAfter @el, @mimicEl
        else if @options.placement is 'before'
            insertBefore @el, @mimicEl
        else
            document.querySelector(@options.placement).appendChild @mimicEl

    render: ->
        @mimicEl.innerHTML = outerHTML @el.cloneNode true

    mimic: ->
        try
            @observer ?= new MutationObserver (mutations) =>
                @render()

            @observer.observe @el,
                childList: true
                attributes: true
                characterData: true
                subtree: true

        catch e

    stop: ->
        @observer?.disconnect()

# Mimic.options = window.mimicOptions ? {}

# setTimeout ->
#   # We do this in a seperate pass to allow people to set
#   # window.mimicOptions after bringing the file in.
#   if window.mimicOptions
#     for k, v of window.mimicOptions
#       Mimic.options[k] ?= v
# , 0

# Mimic.init = ->
#   if not document.querySelectorAll?
#     # IE 7 or 8 in Quirksmode
#     return

#   elements = document.querySelectorAll (Mimic.options.selector or '.mimic')

#   for el in elements
#     el.mimic = new Mimic {el, value: (el.innerText ? el.textContent)}

# if document.documentElement?.doScroll? and document.createEventObject?
#   # IE < 9
#   _old = document.onreadystatechange
#   document.onreadystatechange = ->
#     if document.readyState is 'complete' and Mimic.options.auto isnt false
#       Mimic.init()

#     _old?.apply this, arguments
# else
#   document.addEventListener 'DOMContentLoaded', ->
#     if Mimic.options.auto isnt false
#       Mimic.init()
#   , false

window.Mimic = Mimic