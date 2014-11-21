function get_top_five(obj) {
  var sorted = new Array;
  var params = new Array;

  Object.keys(obj).sort(function(a, b) {
    if (obj[a] > obj[b])
      return -1;

    if (obj[a] < obj[b])
      return 1;

    return 0;
  }).map(function(v, i) {
    var new_obj = new Object;
    new_obj[v] = obj[v];
    sorted.push(new_obj);
  });

  sorted.slice(0, 5).map(function(v, i) {
    var keys = Object.keys(v);
    params.push({'name': keys[0]});
  });

  return params;
}

if (typeof(jQuery) != 'undefined') { (function($) {
  $(function() {
    $.getJSON('json/faculty.json', function(data) {
      $(data).each(function(i,e) {
        $('#faculty').append($('<option />', {id: e.uniqname, text: e.realname}));
      });

      $('#faculty').select2({
        placeholder: 'Select a faculty member',
        width: 'resolve',
      });
    });

    $('#faculty').change(function() {
      var uniqname = $('select#faculty option:selected').attr('id');

      $.getJSON('json/' + uniqname + '.json', function(data) {
        var publications    = new Array;
        var publication_map = new Object;
        var co_authors      = new Object;
        var journals        = new Object;

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

          var c = isNaN(journals[article.journalTitle]) ? 0 : journals[article.journalTitle];
          c++;
          journals[article.journalTitle] = c;

          var authors = article.author.split('; ');
          for (var author in authors) {
            var count = isNaN(co_authors[authors[author]]) ? 0 : co_authors[authors[author]];
            count++;
            co_authors[authors[author]] = count;
          }
        });

        // TODO summary code goes here
        var top_co_authors = get_top_five(co_authors);
        var top_journals   = get_top_five(journals);

        console.log(top_co_authors);

        $('#pub-summary').removeClass('hide');
        $('#pub-summary #co-authors ul').empty().append($('#publication_summary_template').render(top_co_authors));
        $('#pub-summary #journals ul').empty().append($('#publication_summary_template').render(top_journals));

        $('#publications').dataTable({
          'AutoWidth':  false,
          'processing': false,
          'destroy':    true,
          'data':      publications,
          'pageLength':  25,
          'order':       [[ 1, "desc" ]],
          'columns': [
            {'title': 'Title'     },
            {'title': 'Citations' },
            {'title': 'Scopus EID'},
            {'title': 'Authors'   },
            {'title': 'Year'      },
            {'title': 'Journal'   },
            {'title': 'Volume'    },
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

              $(nTd).append($('#publication_title_template').render([{
                'author':  authors[0],
                'journal': oData[5],
                'volume':  oData[6],
                'pages':   oData[7],
                'year':    oData[4]
              }]));
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
