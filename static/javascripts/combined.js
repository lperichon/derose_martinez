$(document).ready(function() {
    $.anchors = {};

    $('div.tour-item').each(function(){
        $.anchors[$(this).attr('title')] = true;
    });

    $(window).scroll(function(){
        var scrollOffset = $(this).scrollTop();
        for (k in $.anchors) {
            var anchor = $('div.tour-item[title="' + k + '"]');
            if (scrollOffset >= (anchor.offset().top) - 160) {
                if (scrollOffset <= ((anchor.offset().top + anchor.outerHeight(true)) - 160)) {
                    $('.side-tour-nav div.stn-middle-solid').removeClass('stn-middle-selected');
                    $('.side-tour-nav a[href="#' + k + '"]').first().parent().addClass('stn-middle-selected');
                    return;
                }
            }
        }
    });

    $('.top-right li:has(ul)').hover(function(){
        $('.top-right span#to_hide').hide("slide",{}, 500, function(){
            $(".top-right li ul").show("slide");
        });
    },function(){
        $('.top-right li ul').hide("slide", {}, 500, function(){
            $('.top-right span#to_hide').show("slide");
        });
    });
});