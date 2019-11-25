$(function()
{
	$('.sort_option').change(function() {
    var val = $('option:selected').text();
    alert(val);
});
})
