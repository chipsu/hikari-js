
class @HtplDate
    constructor: (@date) ->
        return

    format: (format) =>
        return format

class @HtplString
    format: (text) =>
        return text

class @Htpl extends HCoreComponent

    constructor: (@template, @options) ->
        super @options

    render: (data = {}) =>
        _  = this
        @root = null
        @stack = []
        eval @template
        if @stack.length
            throw new Exception 'Invalid template'
        return @root

    write: (html) =>
        if not @root
            throw new Exception 'Cannot write outside element'
        @root.html @root.html() + html

    open: (tag, attr) =>
        @stack.push
            tag: tag
            attr: attr

    close: (tag) =>
        item = @stack.pop
        element = $('<' + item.tag + '>')
        element.attr item.attr
        if @root
            element.html @root.html()
        @root = element

###
sauce:

_.open('h1', []);
    _.write(_.string.format('%s: %s', _.data('title'), _.date(_.data('date').format('Ymd')));
_.close('h1');

###