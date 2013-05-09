if (typeof(jQuery) != 'undefined') { (function($) {
  $(document).ready(function() {
    var title_colspan = '4';

    $.getJSON('js/faculty.json', function(data) {
      $(data).each(function(i,e) {
        var fac_li = $('<li />').append($('<a />', {href: '#'}).text(e.name));

        $(fac_li).click(function() {
          $('#publication_conatiner').show('fast');
          $('table#publications').dataTable({
            'bAutoWidth':  false,
            'bProcessing': false,
            'bDestroy':    true,
            'aaData':      e.publications,
            'aaSorting': [[ 6, "desc" ]],
            'aoColumns': [
              {'sTitle': 'Title'  },
              {'sTitle': 'Journal'},
              {'sTitle': 'Volume' },
              {'sTitle': 'Issue'  },
              {'sTitle': 'Pages'  },
              {'sTitle': 'Date'   },
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
          }).show('fast');

          $('#return').append(
            $('<a />', {href: '#', text: 'Return to faculty list'}).click(function() {
              $('table#publications').hide('fast', function() {
                $('ul#faculty_list').show('fast');
                $('#return').empty();
                $('#publication_conatiner').hide('fast');
              });
            })
          );

          $('ul#faculty_list').hide('fast');
        });

        $('ul#faculty_list').append($(fac_li));
      });
    });
  });
})(jQuery)};
