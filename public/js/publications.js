$(document).ready(function() {
  $.getJSON('json/faculty.json', function(data) {
    $.each(data, function(key, val) {
      $('<option />', {value: key, text: val.name, url: val.url}).appendTo('#faculty_selector');
    });
  });

  $('#faculty_selector').change(function() {
    $('<a />', {
      href: $(':selected', this).attr('url'),
      text: 'Google Scholar Profile'
    }).appendTo($('#google_scholar_link').empty());

    $('#publications').dataTable({
      // 'bScrollInfinite': true,
      // 'bScrollCollapse': true,
      // 'sScrollY':        '500px',
      'bAutoWidth':  false,
      'bProcessing': true,
      'bDestroy':    true,
      'sAjaxSource': 'json/' + $(this).val() + ".json",
      'aaSorting': [[ 6, "desc" ]],
      'aoColumns': [
        { 'sTitle': 'Title'     },
        { 'sTitle': 'Author'    },
        { 'sTitle': 'Journal'   },
        { 'sTitle': 'Volume'    },
        { 'sTitle': 'Number'    },
        { 'sTitle': 'Pages'     },
        { 'sTitle': 'Year'      },
        { 'sTitle': 'Publisher' }
      ],
      'aoColumnDefs': [{
        'aTargets':      ['_all'],
        'fnCreatedCell': function (nTd, sData, oData, iRow, iCol) {
            $(nTd).attr('title',sData);
        }
      }]
    });
  });
});
