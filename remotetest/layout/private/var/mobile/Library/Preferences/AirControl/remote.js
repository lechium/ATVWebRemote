
$(document).ready(function() {
    action();
    $('#server-input').keydown(function(event) {
        if (event.keyCode == 13) {
            isIP(this)
            return false;
        }
    });
    $(document).keydown(function(e) {
        switch (e.keyCode) {
        case 37:
            $('#left').mousedown();
            return false;
        case 38:
            $('#up').mousedown();
            return false;
        case 39:
            $('#right').mousedown();
            return false;
        case 40:
            $('#down').mousedown();
            return false;
        case 13:
            $('#select').mousedown();
            return false;
        case 32:
            $('#play').mousedown();
            return false;
        case 27:
            $('#menu').mousedown();
            return false;
		case 84:
			$('#selectTextEntry').mousedown();
			return false;
        }
    });
});

function isIP(obj) {
    var ary = obj.value.split(".");
    var ip = true;
    var $remote = jQuery('#remote');
    var $input = jQuery('input');

    // for (var i in ary) { ip = (!ary[i].match(/^\d{1,3}$/) || (Number(ary[i]) > 255)) ? false : ip; }
    //ip = (ary.length != 4) ? false : ip;
    if (!ip) {
        // the value is NOT a valid IP address
        obj.style.borderBottom = "5px solid red";
        $remote.addClass('disabled');
        obj.select();
    }
    else {
        // the value IS a valid IP address
        obj.style.borderBottom = "5px solid green";
        $remote.data('server', $input.val());
        $remote.removeClass('disabled');
    }
}

function action() {
    var $remote = $('#remote');
    var $button = $remote.find('.button');
    $button.mousedown(function(event) {

        if (!$remote.hasClass('disabled')) {
            var address = location.hostname;
            var number = $(this).data('number');
            var commandAction = "/remoteCommand=";
            switch (event.which) {
            case 1:
                break;
            case 3:
                if ($(this).data('right')) {
                    number = $(this).data('right')
                }
                else {
                    number = $(this).data('number')
                }
                break;
            }
            if (number == 23) {
                number = prompt("Enter text", "");
                if (number != null) {
                    commandAction = "/enterText=";
                }
            }

            $.get("http://" + address + commandAction + number);
        }
    });
}
//function
