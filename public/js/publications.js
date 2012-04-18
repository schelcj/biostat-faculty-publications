$(document).ready(function() {
  $.getJSON('json/faculty.json', function(data) {
    $.each(data, function(key, val) {
      $('<option />', {value: key, text: val}).appendTo('#faculty_selector');
    });
  });

  $('#faculty_selector').change(function() {
    $('#publications').dataTable({
      'bProcessing': true,
      'sAjaxSource': 'json/' + $(this).val() + ".json",
      'bDestroy':    true,
      'aaSorting': [[ 6, "desc" ]],
      'aoColumns': [
        { 'sTitle': 'Title' },
        { 'sTitle': 'Author' },
        { 'sTitle': 'Journal' },
        { 'sTitle': 'Volume' },
        { 'sTitle': 'Number' },
        { 'sTitle': 'Pages' },
        { 'sTitle': 'Year' },
        { 'sTitle': 'Publisher' }
      ],
    });
  });
});
