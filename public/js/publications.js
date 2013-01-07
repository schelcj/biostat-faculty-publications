if (typeof(jQuery) != 'undefined') { (function($) {
  $(document).ready(function() {
    var title_colspan = '4';

    $('#faculty_list').click(function() {
      $('#faculty_member_name').empty();
      $('#publication_container:visible').hide();
      $('#faculty_container').show();
    });

    $('#faculty').dataTable({
      'bAutoWidth': false,
      'iDisplayLength': 100,
    });

    $('#faculty tbody tr td.member').each(function(i,e) {
      $(e).click(function() {
        $('#faculty_container').hide('fast', function() {
         $('#faculty_member_name').text($(e).find('a').text());
         $('#publications').empty();

          $('#publication_container').show('fast', function() {
            $('#publications').dataTable({
              'bAutoWidth':  false,
              'bProcessing': false,
              'bDestroy':    true,
              'sAjaxSource': 'json/' + $(e).attr('id') + ".json",
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
      });
    });
  });
})(jQuery)};
