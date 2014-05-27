
class @HCoreComponent

    @debug: (text) ->
        if console and console.log
            console.log text

    log: (text) =>
        if @options.debug
            HCoreComponent.debug text

    constructor: (@options, @default_options = {}) ->
        @options = $.extend(default_options, @options)
