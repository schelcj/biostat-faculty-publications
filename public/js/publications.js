if (typeof(jQuery) != 'undefined') { (function($) {
  $(function() {
    $.getJSON('json/faculty.json', function(data) {
      $(data).each(function(i,e) {
        $('#faculty').append($('<option />', {id: e.uniqname, text: e.realname}));
      });

      $('#faculty').select2({
        placeholder: 'Select a faculty member'
      });
    });

    $('#faculty').change(function() {
      var uniqname = $('select#faculty option:selected').attr('id');

      $.getJSON('json/' + uniqname + '.json', function(data) {
        var publications    = new Array;
        var publication_map = new Object;

        $(data.publications.article).each(function(index, article) {
          publications.push([
            article.title,
            article.timescited,
            article.scopusEID,
            article.author,
            article.year,
            article.journalTitle,
            article.journalVolume,
            article.pages
          ]);

          publication_map[article.scopusEID] = {
            title:   article.title,
            cited:   article.timescited,
            author:  article.author,
            journal: article.journalTitle,
            year:    article.year,
            url:     article.pubmedURL,
            pmid:    article.pmid
          };
        });

        $('#publications').dataTable({
          'AutoWidth':  false,
          'processing': false,
          'destroy':    true,
          'data':      publications,
          'pageLength':  25,
          'order':       [[ 1, "desc" ]],
          'columns': [
            {'sTitle': 'Title'     },
            {'sTitle': 'Citations' },
            {'sTitle': 'Scopus EID'},
            {'sTitle': 'Authors'   },
            {'sTitle': 'Year'      },
            {'sTitle': 'Journal'   },
            {'sTitle': 'Volume'    },
          ],
          'columnDefs': [{
            'targets':    [ 2, 3, 4, 5, 6 ],
            'visible':    false,
            'searchable': true
            },{
            'targets': [0],
            'createdCell': function (nTd, sData, oData, iRow, iCol) {
              var authors = oData[3].split(';');

              $('<a />', {
                href:   '#',
                text:   oData[0],
                id:     'scopuseid-' + oData[2],
                class:  'publication'
                }).appendTo($(nTd).empty());

              $(nTd).append(
                  $('<div />', {class: "pub-desc"})
                  .append('<div><span class="pub-desc-title">First Author:</span> ' + authors[0] + '</div>')
                  .append('<div><span class="pub-desc-title">Journal:</span> ' + oData[5] + ' (volume: ' + oData[6] + ' pages: ' + oData[7] + ')</div>')
                  .append('<div><span class="pub-desc-title">Year:</span> ' + oData[4] + '</div>')
              );
            },
          }],
          'drawCallback': function(settings, json) {
            $('.publication').magnificPopup({
              type: 'inline',
              closeBtnInside: true,
              inline: {
                markup: $('#publication_container').html()
              },
              callbacks: {
                open: function() {
                  var eid = $(this.st.el).attr('id').slice(10);
                  this.items = [publication_map[eid]];
                  this.index = 0;
                  this.updateItemHTML();
                },
                markupParse: function(template, values, item) {
                  $(template).find('a#pmid').attr('href', item.data.url);
                  $(template).find('.pub-author').attr('title', item.data.author);
                }
              }
            });
          },
        });
      });
    });
  });
})(jQuery)};
