
class @HTemplateTest 
    run: =>
        console.log 'test'
        src = '
            console.log(_);
            _.open("h1", {"id":"header"});
                _.write(
                    _.string.format("%s: %s",
                        _.data("title"),
                        _.date(_.data("date")).format("Ymd")
                    )
                );
            _.close("h1");
        '
        tpl = new HTemplate src
        result = tpl.render
            title: 'Hello!'
            date: new Date
        console.log result

$ ->
    console.log 'run tests...'
    test = new HTemplateTest
    test.run()
