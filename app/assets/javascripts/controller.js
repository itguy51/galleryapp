var menuup = false;
	  var current = "";
	  function modality(uri, title){
	    $.ajax({
			url: uri,
			success: function(result) {
				$("#osx-modal-title").html(title);
				$("#osx-modal-data").html(result);
				$("#nullbox").click();
			}
		});
	  }
	  	$(document).ready(function(){
	  		$("#login").click(function(){
	  			Turbolinks.visit("/users/sign_in");
	  		});
	  		$("#back").click(function(){
	  			window.location.href = "/pages" ;
	  		});
	  		$("#logout").click(function(){
	  			window.location.href = "/users/sign_out";	
	  		});
	  		$("#new").click(function(){
	  			Turbolinks.visit('/pages/new');
	  		});
	  		$(document).mousedown(function(e){
	  			var target = e.target;
	  			if(!$(target).is('#menu') && !$(target).parents().is('#menu') && menuup){
	  				menuup = false;
	  				$("#menu").hide();
	  			}
	  		});
	  		$('.options').click(function() {
	  			current = $(this).attr("data-post");
	  			var left = (($(window).width() - 960)/2)+886;
				$("#menu").css({"top": ($(this).position().top + 35), "left": left});
				menuup = true;
				if($(this).attr("data-ismine") == "true"){
					$("#edit").show();
					$("#dele").show();
				}else{
					$("#edit").hide();
					$("#dele").hide();
				}
				$("#menu").show();
    		});
    		$('.title').click(function() {
	  			current = $(this).attr("data-post");
	  			window.location.href = "/pages/" + current;
    		});
    		$("#view").click(function(){
    			Turbolinks.visit("/pages/" + current);
    			menuup = false;
	  			$("#menu").hide();
    		});
    		$("#edit").click(function(){
    			//modality('/pages/' + current + '/edit', "Edit Page");
    			Turbolinks.visit("/pages/"  + current + "/edit");
    			menuup = false;
	  			$("#menu").hide();
    		});
    		$("#dele").click(function(){
    			var csrf_token = $('meta[name=csrf-token]').attr('content');
        		var csrf_param = $('meta[name=csrf-param]').attr('content');
        		var dat = "";
        		if (csrf_param !== undefined && csrf_token !== undefined) {
        			dat = csrf_param + '=' + csrf_token;
      			}
    			if(confirm("Are you sure?")){
    				$.ajax({
						url: '/pages/' + current,
						type: 'DELETE',
						data: dat,
						success: function(result) {
							document.location.reload(true);
						}
					});
    			}
    			menuup = false;
	  			$("#menu").hide();
    		});
	  	});