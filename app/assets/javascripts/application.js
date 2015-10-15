// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .



(function(){

    jQuery(document).ready(function($){
        startApp();
    });

    jQuery(document).on('page:change', 'page:load', startApp);

    function startApp(){
        initApp();

        setupListings();
    }

}());

// Initialize application wide functionality
function initApp(){
    
    // Fade out alerts when they are visible
    if ($(".alert").css("display") == "block"){
        setTimeout(function(){
            $(".alert").fadeOut(500);
        }, 5000);
    }

    /************************** AJAX SORTABLE HEADER (INDEX PAGES) **************************/
        
    // If .sortable-header exists
    if ($('.sortable-header').length > 0){
        // When the sortable-links are clicked, upate the hidden fields with the appropriate values and subit AJAX request to reload form
        $('.sortable-header').on('click', '.sortable-link', function(){
            var column_name     = $(this).data('column-name'); 
            var direction       = $(this).data('direction') == 'asc' ? 'desc' : 'asc'; // toggled direction

            // Update hidden fields with the column name and direction
            $('input#sort_name[type="hidden"]').val(column_name);
            $('input#sort_direction[type="hidden"]').val(direction);

            // Make sure everything is decending
            $('.sortable-link .caret').removeClass('asc');
            $('.sortable-link .caret').data('direction', 'desc');

            // Update the toggled data-direction attribute
            $(this).data('direction', direction);
            // then add the ascending class to the sortablelink
            if (direction == 'asc'){
                $(this).find('.caret').addClass('asc');
            }

            // Submit an get AJAX request with the forms paramters
            var form = $(this).parents("form");
            $.get(form.attr('action'), form.serialize(), null, "script");

            return false;
        });
    }

    // If .header-dropdown-checkbox exists
    if ($('.header-dropdown-checkbox').length > 0){
        // When the dropdown is hidden, submit an get AJAX request with the forms paramters
        $('.header-dropdown-checkbox').on('hide.bs.dropdown', function(){
            var form = $('.index-form');
            $.get(form.attr('action'), form.serialize(), null, "script");
        });
    }
    
    // AJAX for pagination
    $('.box').on('click', '.pagination a', function(){
        $.get($(this).attr('href'), null, null, "script");
        return false;
    });

    // Auto strech textarea height to fit text
    if ($("textarea").length > 0){
        $("textarea").height( $("textarea")[0].scrollHeight );      
    } 
}

function setupListings(){
    var thumbs = $('#listing-photos').slippry({
      // general elements & wrapper
      slippryWrapper: '<div class="slippry_box listing-photos" />'
    });

    jQuery(document).on('click', '.thumbs a', function (e){
        e.preventDefault();
        // console.log('data slide', jQuery(this).data('att-slide'));
        thumbs.goToSlide(jQuery(this).data('att-slide'));
        return false;
    });
}

