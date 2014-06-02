
class @HtplTest 
    run: =>
        src = '
            _.open("h1", []);
                _.write(_.string.format("%s: %s", _.data("title"), _.date(_.data("date").format("Ymd")));
            _.close("h1");
        '
        tpl = new Htpl src
        result = tpl.render
            title: 'Hello!'
            date: new Date
        console.log result
