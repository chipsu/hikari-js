
class @HtplDate
    constructor: (@date) ->
        return

    format: (format) =>
        return format

class @HtplString
    format: (text) =>
        return text

class @HTemplate extends HCoreComponent

    constructor: (@template, @options) ->
        super @options
        @string = new HtplString
        @date = (date) =>
            return new HtplDate date

    render: (data = {}) =>
        _  = this
        @_data = data
        @root = $('<div>')
        @current = @root
        console.log 'Eval: ' + @template
        eval @template
        console.log 'done'
        console.log @root.html()
        return @root

    data: (key, def = null) =>
        if typeof @_data[key] != 'undefined'
            return @_data[key]
        return def

    write: (html) =>
        @current.append html
        return this

    open: (tag, attr) =>
        console.log "tag: " + tag
        element = $('<' + tag + '>')
        for key in attr
            element.attr key, value
        @current.append element
        @current = element
        return this

    close: (tag) =>
        @current = @current.parent()
        return this

###
sauce:

_.open('h1', []);
    _.write(_.string.format('%s: %s', _.data('title'), _.date(_.data('date').format('Ymd')));
_.close('h1');

###