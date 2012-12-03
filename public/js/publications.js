if (typeof(jQuery) != 'undefined') { (function($) {
  $(document).ready(function() {
    var title_colspan = '4';

    $.getJSON('json/faculty.json', function(data) {
      $.each(data, function(key, val) {
        $('<option />', {value: val.gid, text: val.name, url: val.url}).appendTo('#faculty_selector');
      });
    });

    $('#faculty_selector').change(function() {
      $('<a />', {
        href: $(':selected', this).attr('url'),
        text: 'Google Scholar Profile',
        target: '_new'
      }).appendTo($('#google_scholar_link').empty());

      $('#publications').dataTable({
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
        ],
        'aoColumnDefs': [{
          'aTargets':      ['_all'],
          'fnCreatedCell': function (nTd, sData, oData, iRow, iCol) {
            $(nTd).attr('title', sData);

            if (iCol == 0) {
              $(nTd).attr('colspan', title_colspan);
              $('<a />', {
                href:   'http://www.ncbi.nlm.nih.gov/pubmed?term=' + sData + '[Title]',
                text:   sData,
                target: '_new'
              }).appendTo($(nTd).empty());
            }
          }
        }],
        'fnHeaderCallback': function (nHead, aData, iStart, iEnd, aiDisplay) {
          $(nHead).find('th').first().attr('colspan', title_colspan);
        }
      });
    });
  });
})(jQuery)};
