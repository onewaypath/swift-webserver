(function($) {
  $(document).ready(function() {
    // Select all links with hashes
  		$('a[href*="#"]')
  		  // Remove links that don't actually link to anything
  		  .not('[href="#"]')
  		  .not('[href="#0"]')
  		  .click(function(event) {
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
  		        }, 1000, function() {
  		          // Callback after animation
  		          // Must change focus!
  		          var $target = $(target);
  		          $target.focus();
  		          if ($target.is(":focus")) { // Checking if the target was focused
  		            return false;
  		          } else {
  		            $target.attr('tabindex','-1'); // Adding tabindex for elements not focusable
  		            $target.focus(); // Set focus again
  		          };
  		        });
  		      }
  		    }
  		  });

	  		$('a[href*=\\#]').bind('click', function(e) {
	  				e.preventDefault(); // prevent hard jump, the default behavior

            var target = $(this).attr("href");

	  				var offset = $(target).offset().top;

            if(target == '#home') {
              offset = 0
            }

            console.log(offset);

            // perform animated scrolling by getting top-position of target-element and set it as scroll target
            $('html, body').stop().animate({
                scrollTop: offset
            }, 600, function() {
                //location.hash = target; //attach the hash (#jumptarget) to the pageurl
            });

	  				return false;
	  		});

  		  $(window).scroll(function() {
  		  		var scrollDistance = $(window).scrollTop();
  		  		$('[data-identifier="page-section"]').each(function(i) {
  		  				if ($(this).position().top <= scrollDistance) {
  		  						$("nav a").removeAttr('data-active');
                    $("nav a").eq(i).attr('data-active','1');
  		  				}
  		  		});
  		  }).scroll();

  		var wid = $(window).width();

      $(window).resize(function(){
          wid = $(window).width();
          if(wid > 991) {
            $("nav div").show();
          }
          else {
            $("nav div").hide(); 
          }
      });
      
    		  $("nav button").click(function(){
            if (wid <= 991)
            {
      		    $("nav div").show("slow");		
              $(this).hide("slow");
            }
    		  });
    		  $("nav a").click(function(){
            if (wid <= 991)
            {
    		      $("nav div").hide("slow");
    		      $("nav button").show("slow");
            }
    		  });
          $("nav button").on('touchend',function(){
            if (wid <= 991)
            {
              $("nav div").show("slow"); 
              $(this).hide("slow"); 
            }
          });
          $("nav a").on('touchend',function(){
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