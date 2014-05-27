
next_id = 0

#
# A swipe menu for touch devices
#
class @HUiTouchMenu extends HCoreComponent

    @init: () ->
        @debug 'init'
        $('[data-touchmenu]').each (index, item) ->
            item = $(item)
            target = $(item.data 'touchmenu')
            if target.length
                menu = target.data 'touchmenu-instance'
                if not menu
                    options = target.data 'touchmenu-options'
                    if options and options.position == 'auto'
                        pos = item.offset().left + item.outerWidth()
                        options.position = if pos < $(window).innerWidth() then 'left' else 'right'
                    menu = new HUiTouchMenu target, options
                    item.data 'touchmenu', '#' + menu.id
        $('body').on 'click', '[data-touchmenu]', (event) ->
            id = $(this).data 'touchmenu'
            menu = $(id).data 'touchmenu-instance'
            if menu
                event.preventDefault()
                menu.toggle()
            else
                @debug 'no touchmenu instance set for: ' + id

    constructor: (@element, @options) ->
        super @options,
            debug: true           # enable console logging
            body: true            # attach to and push with body
            position: 'left'      # menu slidein position
            clone: true           # clone menu element
            animation:
                duration: 500     # duration for open & close animations
            stack:
                enable: true      # enable submenu navigation
                parallax: 20      # amount to push parent menus
                offset: 0         # final offset to previous menu
                direction: 'auto' # stack slidein direction (auto = opposite of menu direction)
            touch:
                enable: true      # enable touch events
                snap: 50          # snap distance
            overlay:
                enable: true      # enable body overlay
        @body = $('body')
        @stack = []
        if @options.clone
            @element = @element.clone()
            @id = @element.data 'touchmenu-id'
            if not @id
                @id = '__touchmenu-' + (++next_id)
            @element.attr 'id', @id
        @element.data 'touchmenu-instance', this
        @element.addClass 'touchmenu'
        @element.appendTo @body
        @element.trigger 'touchmenu-init', this
        @log 'ctor'
        @log @options
        switch @options.position
            when 'left', 'right'
                @_size = =>
                    return @element.outerWidth true
            when 'top', 'bottom'
                @_size = =>
                    return @element.outerHeight true
            else
                throw 'invalid position: ' + @options.position
        @overlay = $('<div>')
        @overlay.css
            position: 'fixed'
            top: 0
            left: 0
            right: 0
            bottom: 0
            backgroundColor: 'rgba(0,0,0,.5)'
            zIndex: 9000
        @overlay.hide()
        @overlay.appendTo @body
        @overlay.on 'click', @close
        $(window).on 'resize', @reset
        @element.on 'click', (event) =>
            target = $(event.target)
            li = target.closest 'li'
            ul = li.find '> ul'
            if ul.length
                event.preventDefault()
                ul.css
                    backgroundColor: '#666'
                    position: 'fixed'
                    left: @size()
                    top: 0
                    bottom: 0
                    width: @size()
                    zIndex: 9000 + @stack.length
                @stack.push ul
                ul.show()
                ul.animate
                    left: '0px'
                @element.animate
                    left: '-=' + 20 + 'px'
        @reset()

    reset: () =>
        @log 'reset'
        @overlay.fadeOut()
        @element.find('ul ul').hide()
        @stack = []
        @element.show()
        css =
            position: 'fixed'
            zIndex: 9001
        switch @options.position
            when 'left', 'right'
                css.top = 0
                css.bottom = 0
            when 'top', 'bottom'
                css.left = 0
                css.right = 0
        css[@options.position] = -@size()
        @element.css css
        @element.fadeOut()
        if @options.body
            css =
                position: 'relative'
                overflow: 'auto'
            css[@options.position] = 0
            @body.css css

    # progress 0.0 to 1.0
    progress: () =>
        return Math.abs(@offset()) / @size()

    # offset (left, right, top or bottom)
    offset: () =>
        return parseInt(@element.css @options.position)

    # size (width or height)
    size: () =>
        return @_size()

    toggle: () =>
        @log 'toggle'
        @open()

    open: () =>
        @log 'open'
        @reset
        @element.show()
        @overlay.fadeIn()
        css = {}
        options =
            complete: =>
                @log 'complete'
        if @options.body
            @element.css
                position: 'absolute'
            switch @options.position
                when 'left', 'right'
                    css.top = 0
                    css.height = $(window).innerHeight()
                when 'top', 'bottom'
                    css.left = 0
                    css.width = $(window).innerWidth()
            @element.css @options.position, '-' + @size() + 'px'
            @body.css
                position: 'absolute'
                overflow: 'hidden'
                width: '100%'
            css[@options.position] = '+=' + @size()
            @body.animate css, options
        else
            css[@options.position] = 0
            @element.animate css, options

    close: () =>
        @log 'close'
        css = {}
        options =
            complete: =>
                @element.hide()
                @reset()
        if @options.body
            css[@options.position] = 0
            @body.animate css, options
        else
            css[@options.position] = -@size()
            @element.animate css, options

    is_open: () =>
        return not @is_closed()

    is_closed: () =>
        return @progress() == 0

$ ->
    HUiTouchMenu.init()
