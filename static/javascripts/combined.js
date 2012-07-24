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

    $('.top-right li:has(ul)').hoverIntent(function(){
        $('.top-right span#to_hide').hide("slide",{}, 200, function(){
            $(".top-right li ul").show("slide");
        });
    },function(){
        $('.top-right li ul').hide("slide", {}, 200, function(){
            $('.top-right span#to_hide').show("slide");
        });
    });

    $('#horarios_lightbox_link').lightBox({
    imageLoading: '/images/lightbox-ico-loading.gif',
    imageBtnClose: '/images/lightbox-btn-close.gif',
    imageBtnPrev: '/images/lightbox-btn-prev.png',
    imageBtnNext: '/images/lightbox-btn-next.png',
    imageBlank: '/images/lightbox-blank.gif'
   });

   $("#show_message_link").click(function() {
     $("#contact_message").show();
     $("#show_message_link").hide();
   });

   contact_reason_change_action = function(){
        val = $("#Contact_contactReason option:selected").val();
        switch (val) {
            case ("-"): case("otro"):
//            $("#contact_message").show();
//            $("#show_message_link").hide();
              $("#contact_horarios_wrapper").hide();
              $("#contact_empresa_wrapper").hide();
            break;
            case ("prueba"):
//                $("#contact_message").hide();
//                $("#show_message_link").show();
                $("#contact_horarios_wrapper").show();
                $("#contact_empresa_wrapper").hide();
                break;
            case ("particulares"):
//                $("#contact_message").hide();
//                $("#show_message_link").show();
                $("#contact_horarios_wrapper").hide();
                $("#contact_empresa_wrapper").hide();
                break;
            case ("empresas"):
//                $("#contact_message").hide();
//                $("#show_message_link").show();
                $("#contact_horarios_wrapper").hide();
                $("#contact_empresa_wrapper").show();
                break;
            case ("formacion"):
//                $("#contact_message").hide();
//                $("#show_message_link").show();
                $("#contact_horarios_wrapper").show();
                $("#contact_empresa_wrapper").hide();
                break;
        }
    };

   $.urlParam = function(name){
        var results = new RegExp('[\\?&]' + name + '=([^&#]*)').exec(window.location.href);
        if(results == null) {
            return false;
        }
        return results[1];
   }

   if($.urlParam('contactReason')) {
    $('#Contact_contactReason').val($.urlParam('contactReason'));
   }

   contact_reason_change_action();
   $("#Contact_contactReason").change(contact_reason_change_action);
});