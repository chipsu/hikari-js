
class @HUiSlideshow extends HCoreComponent

    constructor: (@element, @options) ->
        super @options,
            debug: true           # enable console logging
            animation:
                duration: 500     # duration for open & close animations
                effect: 'slide'   # animation effect
            touch:
                enable: true      # enable touch events
                snap: 50          # snap distance
            overlay:
                enable: true      # enable overlay

    next: () =>
        @log 'Next'

    prev: () =>
        @log 'Prev'