(function ($) {
    $(document).ready(function () {
        // Select all links with hashes
        $('a[href*="#"]')
                // Remove links that don't actually link to anything
                .not('[href="#"]')
                .not('[href="#0"]')
                .click(function (event) {
                    // On-page links
                    if (
                            location.pathname.replace(/^\//, '') == this.pathname.replace(/^\//, '')
                            &&
                            location.hostname == this.hostname
                            ) {
                        // Figure out element to scroll to
                        var target = $(this.hash);
                        target = target.length ? target : $('[name=' + this.hash.slice(1) + ']');
                        // Does a scroll target exist?
                        if (target.length) {
                            // Only prevent default if animation is actually gonna happen
                            event.preventDefault();
                            $('html, body').animate({
                                scrollTop: target.offset().top
                            }, 1000, function () {
                                // Callback after animation
                                // Must change focus!
                                var $target = $(target);
                                $target.focus();
                                if ($target.is(":focus")) { // Checking if the target was focused
                                    return false;
                                } else {
                                    $target.attr('tabindex', '-1'); // Adding tabindex for elements not focusable
                                    $target.focus(); // Set focus again
                                }
                                ;
                            });
                        }
                    }
                });

       
        $(document).ready(function() {
            $('a[href*=#]').bind('click', function(e) {
                    e.preventDefault(); // prevent hard jump, the default behavior

                    var target = $(this).attr("href"); // Set the target as variable

                    // perform animated scrolling by getting top-position of target-element and set it as scroll target
                    $('html, body').stop().animate({
                            scrollTop: $(target).offset().top
                    }, 600, function() {
                            location.hash = target; //attach the hash (#jumptarget) to the pageurl
                    });

                    return false;
            });
        });

        $(window).scroll(function() {
                var scrollDistance = $(window).scrollTop();

                // Show/hide menu on scroll
                //if (scrollDistance >= 850) {
                //      $('nav').fadeIn("fast");
                //} else {
                //      $('nav').fadeOut("fast");
                //}
            
                // Assign active class to nav links while scolling
               $('[data-identifier="page-section"]').each(function (i) {
                if ($(this).position().top <= scrollDistance) {
                    $("nav a").removeAttr('data-active');
                    $("nav a").eq(i).attr('data-active', '1');
                }
            });
        }).scroll();

        var wid = $(window).width();

        $(window).resize(function () {
            wid = $(window).width();
            if (wid > 991) {
                $("nav div").show();
            }
            else {
                $("nav div").hide();
            }
        });

        $("nav button").click(function () {
            if (wid <= 991)
            {
                $("nav div").show("slow");
                $(this).hide("slow");
            }
        });

        $("#testimonials a").on('click', function (e) {
            e.preventDefault();
            $("#testimonials p").show("slow");
            $("#testimonials a").hide();
			// setTimeout(function(){
	            var maxHeight = Math.max.apply(null, $("#testimonials div div div").map(function () {
				    return $(this).height();
				}).get());
				$("#testimonials div div div").css('min-height',maxHeight);
			// },100);

        });




// var defaultHeightnew = 400;
// var textnew = $("#testimonials div div div");
// var textHeightnew = textnew[0].scrollHeight;
// textnew.css({"max-height": defaultHeightnew, "overflow": "hidden"});
// var button = $(".button");
//  $("#testimonials a").on("click", function(){
//   var newHeightnew = 0;
//   if (textnew.hasClass("active")) {
//     newHeightnew = defaultHeightnew;
//     textnew.removeClass("active");
//   } else {
//     newHeightnew = textHeightnew;
//     textnew.addClass("active");
//   }
//   textnew.animate({
//     "max-height": newHeightnew
//   }, 500);
// });

        $("#faq a").on('click', function (e) {
            e.preventDefault();
            $("#faq p").show("slow");
            $("#faq a").hide();

            setTimeout(function(){
	            var maxHeight = Math.max.apply(null, $("#faq div div div").map(function () {
				    return $(this).height();
				}).get());
				$("#faq div div div").css('min-height',maxHeight);
            },700);
        });

// var defaultHeight = 400;
// var text = $("#faq div div div");
// var textHeight = text[0].scrollHeight;
// var button = $(".button");
// text.css({"max-height": defaultHeight, "overflow": "hidden"});
//  $("#faq a").on("click", function(){
//   var newHeight = 0;
//   if (text.hasClass("active")) {
//     newHeight = defaultHeight;
//     text.removeClass("active");
//   } else {
//     newHeight = textHeight;
//     text.addClass("active");
//   }
//   text.animate({
//     "max-height": newHeight
//   }, 500);
// });

        $("nav a").click(function () {
            if (wid <= 991)
            {
                $("nav div").hide("slow");
                $("nav button").show("slow");
            }
        });
        $("nav button").on('touchend', function () {
            if (wid <= 991)
            {
                $("nav div").show("slow");
                $(this).hide("slow");
            }
        });
        $("nav a").on('touchend', function () {
            if (wid <= 991)
            {
                $("nav div").hide("slow");
                $("nav button").show("slow");
            }
        });

        /*
         $("section:nth-child(2) div a").click(function(){
         $("section:nth-child(2) div blockquote").hide();
         $("section:nth-child(2) div blockquote").eq($(this).index()).show();
         });
         $("section:nth-child(2) div a").on('touchend',function(){
         $("section:nth-child(2) div blockquote").hide();
         $("section:nth-child(2) div blockquote").eq($(this).index()).show();
         });
         var wid = $(window).width();
         if (wid <= 767)
         {
         $("section:nth-child(2) div a").click(function(){
         $("section:nth-child(2) h2 + p").hide();
         });
         $("section:nth-child(2) div a").on('touchend',function(){
         $("section:nth-child(2) h2 + p").hide();
         });
         }

         $("section:nth-child(3) dd figcaption ul li").click(function(){
         $("section:nth-child(3) dd blockquote").hide();
         $("section:nth-child(3) dd blockquote").eq($(this).index()).show();
         });

         $("section:nth-child(3) dd figcaption ul li").on('touchend',function(){
         $("section:nth-child(3) dd blockquote").hide();
         $("section:nth-child(3) dd blockquote").eq($(this).index()).show();
         });

         $("footer figcaption ul li a").click(function(){
         console.log(this);
         $("footer figcaption blockquote").toggle();
         });

         $("footer figcaption ul li a").on('touchend',function(){
         console.log(this);
         $("footer figcaption blockquote").toggle();
         });
         */

    });
})(jQuery);